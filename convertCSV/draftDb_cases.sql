-- Who handles cases
-- Lookup: Positions
CREATE TABLE staff_positions (
  position_code VARCHAR(20) PRIMARY KEY, -- TLS, CRM, DEV 
  position_name VARCHAR(100) NOT NULL UNIQUE
) ;

-- Lookup: Levels (e.g., L1..L7, Junior/Mid/Senior)
CREATE TABLE staff_levels (
  level_code   	VARCHAR(20) PRIMARY KEY, -- MNG, LEA, EXC
  level_name 	VARCHAR(100) NOT NULL UNIQUE
) ;

-- Staff
CREATE TABLE staff (
  staff_id     BIGINT PRIMARY KEY AUTO_INCREMENT,
  position_code  VARCHAR(20) NOT NULL,
  level_code     VARCHAR(20) NOT NULL,
  full_name    VARCHAR(200) NOT NULL,
  email        VARCHAR(255) NOT NULL UNIQUE,
  hired_at     DATE NULL,
  created_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT fk_staff_position
    FOREIGN KEY (position_id) REFERENCES staff_positions(position_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_staff_level
    FOREIGN KEY (level_id) REFERENCES staff_levels(level_id)
      ON DELETE RESTRICT ON UPDATE RESTRICT
) ;

-- Core case record: always tied to the person
CREATE TABLE cases (
  case_id       BIGINT PRIMARY KEY AUTO_INCREMENT,
  contact_id    BIGINT NOT NULL,                 -- anchor to the person
  username_id   BIGINT NULL,                     -- optional: the specific platform account
  source_chan   TINYINT NULL,                    -- optional: channel_id from contact_channels (where it came in)
  case_subject  VARCHAR(200) NOT NULL,
  case_description   TEXT,
  case_status   ENUM('pending','done','transfered','closed') NOT NULL DEFAULT 'open',
  priority      ENUM('low','normal','urgent') NOT NULL DEFAULT 'normal',
  created_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (contact_id) REFERENCES contacts(contact_id) ON DELETE CASCADE,
  FOREIGN KEY (username_id) REFERENCES usernames(username_id),
  FOREIGN KEY (source_chan) REFERENCES contact_channels(channel_id),

  INDEX (contact_id),
  INDEX (username_id),
  INDEX (status, priority, created_at)
);

-- Assignment (many staff can collaborate; keep history)
CREATE TABLE case_assignments (
  case_id     BIGINT NOT NULL,
  staff_id    BIGINT NOT NULL,
  assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (case_id, staff_id),
  FOREIGN KEY (case_id) REFERENCES cases(case_id) ON DELETE CASCADE,
  FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

