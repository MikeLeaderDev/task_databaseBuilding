-- One row per person
CREATE TABLE contacts ( -- "person" level info will record contactsid and their tel, also record their status as lead or customer 
  contact_id      BIGINT PRIMARY KEY AUTO_INCREMENT,
  tel			  VARCHAR(200),
  fullname		  VARCHAR(200), 
  contact_status  ENUM('lead','customer') NOT NULL DEFAULT 'lead',
  note			  TEXT,
  created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Catalog of channels (telephone, email, telegram, zalo, etc.)
CREATE TABLE contact_channels ( -- will store contact channels id and name 
  channel_code    TINYINT PRIMARY KEY,
  channel_name    VARCHAR(32) NOT NULL UNIQUE,   -- e.g., 'phone','email','telegram','zalo','viber','facebook','whatsapp','wechat','discord'
);

-- Each row = one way to reach a contact on a channel (replaces Tel1/Tel2/Tel3, EM/ZL/VB/…)
CREATE TABLE contact_points (
  point_id        BIGINT PRIMARY KEY AUTO_INCREMENT,
  contact_id      BIGINT NOT NULL,
  channel_code    TINYINT NOT NULL,
  value_raw       VARCHAR(255) NOT NULL,  -- as entered by user 
  value_norm      VARCHAR(255) NULL, -- application level handle this when posting
  is_primary      BOOLEAN NOT NULL DEFAULT 0,
  verified_at     DATETIME NULL,
  created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  contact_note	  TEXT,

  FOREIGN KEY (contact_id)  REFERENCES contacts(contact_id),
  FOREIGN KEY (channel_id)  REFERENCES contact_channels(channel_id),

  INDEX (contact_id, channel_id),
  INDEX (channel_id, value_norm),

  -- Prevent duplicate ownership of the same identifier across the whole system
  UNIQUE (channel_id, value_norm)
);

-- Platforms on which a user can register a username/account
CREATE TABLE platforms (
  platform_id     SMALLINT PRIMARY KEY,
  platform_name   VARCHAR(100) NOT NULL UNIQUE
);

-- A person’s account/handle on a given platform
CREATE TABLE usernames (
  username_id     BIGINT PRIMARY KEY AUTO_INCREMENT,
  contact_id      BIGINT NOT NULL,
  platform_id     SMALLINT NOT NULL,
  username        VARCHAR(50) NOT NULL,
  register_date   DATE NULL,
  vip_level       TINYINT NULL,

  FOREIGN KEY (contact_id)  REFERENCES contacts(contact_id),
  FOREIGN KEY (platform_id) REFERENCES platforms(platform_id),

  -- One handle may exist on multiple platforms, but must be unique per platform
  UNIQUE (platform_id, username),

  -- A person can have at most one account per platform (remove if you allow multiples)
  UNIQUE (contact_id, platform_id)
);

-- customer detail once they register (optional - maybe not needed)
CREATE TABLE customers (
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
  
