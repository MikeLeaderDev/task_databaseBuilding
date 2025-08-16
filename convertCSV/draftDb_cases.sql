-- Who handles cases
-- Lookup: Positions
CREATE TABLE staff_departments (
  dept_code		  VARCHAR(20) PRIMARY KEY, -- TLS, CRM, DEV 
  dept_name		  VARCHAR(100) NOT NULL UNIQUE
) ;

-- Lookup: Levels (e.g., L1..L7, Junior/Mid/Senior)
CREATE TABLE staff_levels (
  level_code   	VARCHAR(20) PRIMARY KEY, -- MNG, LEA, EXC
  level_name 	VARCHAR(50) NOT NULL UNIQUE
) ;

-- Staff
CREATE TABLE staff (
  staff_id     VARCHAR(20) PRIMARY KEY ,
  dept_code    VARCHAR(20) NOT NULL,
  level_code   VARCHAR(20) NOT NULL,
  full_name    VARCHAR(200) NOT NULL,
  email        VARCHAR(255) NOT NULL UNIQUE,
  join_date    DATE NULL,
  create_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT fk_staff_departments
    FOREIGN KEY (dept_code) REFERENCES staff_departments(dept_code)
      ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT fk_staff_level
    FOREIGN KEY (level_code) REFERENCES staff_levels(level_code)
      ON DELETE RESTRICT ON UPDATE RESTRICT
) ;

-- Core case record: always tied to the person
CREATE TABLE cases (
  case_id       BIGINT PRIMARY KEY AUTO_INCREMENT,
  username_id   BIGINT NULL,                     -- the specific platform account
  contact_id    BIGINT NOT NULL,                 -- anchor to the person
  case_subject  VARCHAR(255) NOT NULL,
  case_description   TEXT,
  case_status   ENUM('pending','done','transferred','closed') NOT NULL DEFAULT 'open', 
  priority      ENUM('low','normal','urgent') NOT NULL DEFAULT 'normal',
  create_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (contact_id) REFERENCES contacts(contact_id) ON DELETE CASCADE,
  FOREIGN KEY (username_id) REFERENCES usernames(username_id),

  INDEX (contact_id),
  INDEX (username_id),
  INDEX (status, priority, created_at)
);

-- Assignment (many staff can collaborate; keep history)
CREATE TABLE case_assignments (
  case_id     BIGINT NOT NULL,
  staff_id    VARCHAR(20) NOT NULL,
  assign_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  case_note   TEXT, 
  PRIMARY KEY (case_id, staff_id),
  FOREIGN KEY (case_id) REFERENCES cases(case_id) ON DELETE CASCADE,
  FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

