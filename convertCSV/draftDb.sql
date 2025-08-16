-- People (one row per person)
CREATE TABLE contacts (
  contact_id      	BIGINT PRIMARY KEY AUTO_INCREMENT,
  tel             	VARCHAR(255),
  fullname        	VARCHAR(255) NULL,
  contact_status  	ENUM('lead','customer') NOT NULL DEFAULT 'lead',
  register_date   	DATETIME NULL,                  -- optional cache of first registration time
  has_deposited   	TINYINT(1) NOT NULL DEFAULT 0,  -- optional cache
  last_deposit_at  	DATE NULL, -- optional cache
  last_call_at		DATETIME NULL,
  last_call_status	ENUM('no_answer','connected_declined','callback','wrong_number','blocked','success') NULL,
  -- call_note         TEXT, -- stored in call_logs 
  line    			VARCHAR(255) NULL,
  create_at      	DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_at      	DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE call_logs (
  call_id          BIGINT PRIMARY KEY AUTO_INCREMENT,
  contact_id       BIGINT NOT NULL,
  -- which phone/handle did we dial (optional but very useful)
  point_id         BIGINT NULL,                            -- FK to contact_points
  staff_id         VARCHAR(20) NULL,                       -- who made the call
  call_status      ENUM(
                     'no_answer',          -- rung, not picked
                     'connected_declined', -- spoke, not interested
                     'interested_callback',           -- asked to call later
                     'wrong_number',
                     'blocked',
                     'success'             -- converted / achieved goal
                   ) NOT NULL,
  call_note        TEXT NULL,
  call_started_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  call_ended_at    DATETIME NULL,                          -- set if you track it
  next_action_at   DATETIME NULL,                          -- schedule follow-up

  FOREIGN KEY (contact_id) REFERENCES contacts(contact_id) ON DELETE CASCADE,
  FOREIGN KEY (point_id)   REFERENCES contact_points(point_id),
  FOREIGN KEY (staff_id)   REFERENCES staff(staff_id)

  -- INDEX idx_call_logs_contact_time (contact_id, call_started_at),
  -- INDEX idx_call_logs_staff_time   (staff_id, call_started_at),
  -- INDEX idx_call_logs_status_time  (call_status, call_started_at)
);

-- Platform types (category)
CREATE TABLE platform_types ( 
  type_id   TINYINT PRIMARY KEY,  -- Phai ra quy dinh bang du lieu 
  type_name VARCHAR(50) NOT NULL UNIQUE          -- 'forum','streaming','marketplace', ...
) ENGINE=InnoDB;

-- Platforms (specific sites/apps)
CREATE TABLE platforms (
  platform_id   BIGINT PRIMARY KEY,
  type_id       TINYINT NOT NULL,
  platform_name VARCHAR(255) NOT NULL UNIQUE,
  FOREIGN KEY (type_id) REFERENCES platform_types(type_id)
) ENGINE=InnoDB;

-- Contact channels (phone, email, telegram, ...)
CREATE TABLE contact_channels (
  channel_code  VARCHAR(20) PRIMARY KEY,         -- e.g. 'ph','em','tg','zl','vb','fb','wa','wc','ds'
  channel_name  VARCHAR(50)  NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Ways to reach a contact (one row per phone/email/handle)
CREATE TABLE contact_points (
  point_id      BIGINT PRIMARY KEY AUTO_INCREMENT,
  contact_id    BIGINT NOT NULL,
  channel_code  VARCHAR(20) NOT NULL,
  value_raw     VARCHAR(255) NOT NULL,
  value_norm    VARCHAR(255) NOT NULL,           -- normalize in the app; 
  is_primary    TINYINT(1) NOT NULL DEFAULT 1,
  verify_at  	DATETIME NULL,
  create_at    	DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (contact_id)   REFERENCES contacts(contact_id)      ON DELETE CASCADE,
  FOREIGN KEY (channel_code) REFERENCES contact_channels(channel_code),

  UNIQUE KEY uq_contact_point (channel_code, value_norm),
  KEY idx_contact_points_1 (contact_id, channel_code),
  KEY idx_contact_points_2 (channel_code, value_norm)
) ENGINE=InnoDB;

-- A person’s account on a given platform
CREATE TABLE usernames (
  username_id    BIGINT PRIMARY KEY AUTO_INCREMENT,
  contact_id     BIGINT NOT NULL,
  platform_id    BIGINT NOT NULL,
  username       VARCHAR(50) NOT NULL,
  register_date  DATETIME NULL,                   -- per-platform registration time (optional)
  has_deposited  TINYINT(1) NOT NULL DEFAULT 0,  -- optional cache for analytics
  last_deposit   DATE NULL,
  vip_level      TINYINT NULL,

  FOREIGN KEY (contact_id)  REFERENCES contacts(contact_id)  ON DELETE CASCADE,
  FOREIGN KEY (platform_id) REFERENCES platforms(platform_id),

  UNIQUE KEY uq_platform_username (platform_id, username),  -- per-platform uniqueness
  UNIQUE KEY uq_contact_platform  (contact_id, platform_id),-- at most one account per contact per platform
  KEY idx_usernames_contact (contact_id)
) ENGINE=InnoDB;

-- Registration log (1 username can have many registration events)
CREATE TABLE registrations (
  register_id   BIGINT PRIMARY KEY AUTO_INCREMENT,
  username_id   BIGINT NOT NULL,
  registered_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (contact_id)  REFERENCES contacts(contact_id)   ON DELETE CASCADE,
  FOREIGN KEY (username_id) REFERENCES usernames(username_id) ON DELETE CASCADE,

  KEY idx_reg_contact (contact_id, registered_at),
  KEY idx_reg_username (username_id, registered_at)
) ENGINE=InnoDB;

/* ------------------------------------------------------------------------- 

-- Forum-specific profile (1:1 with a forum username)
CREATE TABLE forum_profiles (
  username_id  BIGINT PRIMARY KEY,
  posts_count  INT NOT NULL DEFAULT 0,
  reputation   INT NOT NULL DEFAULT 0,
  last_post_at DATETIME NULL,
  FOREIGN KEY (username_id) REFERENCES usernames(username_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Streaming-specific profile (1:1 with a streaming username)
CREATE TABLE streaming_profiles (
  username_id    BIGINT PRIMARY KEY,
  watch_streak   INT NOT NULL DEFAULT 0,
  hours_watched  DECIMAL(10,2) NOT NULL DEFAULT 0,
  last_stream_at DATETIME NULL,
  FOREIGN KEY (username_id) REFERENCES usernames(username_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- customer detail once they register (optional - maybe not needed)
CREATE TABLE customer (
  contact_id      BIGINT PRIMARY KEY,
  customer_no     BIGINT UNIQUE,
  registered_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (contact_id) REFERENCES contacts(contact_id)
);

/*
Many phones & channels: every number/handle is a row in contact_points (no more Tel1/Tel2/Tel3 columns).

Many platforms: every platform account is a row in usernames.

Global dedupe: UNIQUE (channel_id, value_norm) guarantees the same phone/email/handle can’t be attached to two different people.

Per‑platform rules: UNIQUE (platform_id, username) prevents duplicate handles on the same platform; UNIQUE (contact_id, platform_id) caps to 1 handle per person per platform. 
*/


INSERT INTO contact_channels (channel_id, channel_name) VALUES
  (1,'Telephone'),
  (2,'Email'),
  (3,'Telegram'),
  (4,'Zalo'),
  (5,'Viber'),
  (6,'Facebook'),
  (7,'WhatsApp'),
  (8,'WeChat'),
  (9,'Discord');
  
