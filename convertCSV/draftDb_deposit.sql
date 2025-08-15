-- One row per successful deposit on a specific platform username
CREATE TABLE deposits (
  deposit_id     BIGINT PRIMARY KEY AUTO_INCREMENT,
  deposit_code	 VARCHAR(255), 
  username_id    BIGINT NOT NULL, -- which account on which platform
  staff_id		 BIGINT, 
  amount         DECIMAL(12,2) NOT NULL,
  currency       CHAR(3) NOT NULL DEFAULT 'USD',     -- keep anyway, future-proof
  deposited_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  -- Optional status if you ingest pending/failed: only count 'success'
  transaction_status         ENUM('success','failed','pending') NOT NULL DEFAULT 'success',

  FOREIGN KEY (username_id) REFERENCES usernames(username_id),
  INDEX (username_id, deposited_at),
  INDEX (status, deposited_at)
);

CREATE TABLE withdrawals (
  withdraw_id     BIGINT PRIMARY KEY AUTO_INCREMENT,
  withdraw_code	 VARCHAR(255), 
  username_id    BIGINT NOT NULL, -- which account on which platform
  staff_id		 BIGINT, 
  amount         DECIMAL(12,2) NOT NULL,
  currency       CHAR(3) NOT NULL DEFAULT 'USD',     -- keep anyway, future-proof
  withdraw_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  -- Optional status if you ingest pending/failed: only count 'success'
  transaction_status         ENUM('success','failed','pending') NOT NULL DEFAULT 'success',

  FOREIGN KEY (username_id) REFERENCES usernames(username_id),
  INDEX (username_id, deposited_at),
  INDEX (status, deposited_at)
);
/* 
	
*/

