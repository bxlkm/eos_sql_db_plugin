USE eos;

ALTER TABLE tokens CHANGE amount amount double(64,4) DEFAULT NULL;
ALTER TABLE accounts_keys CHANGE COLUMN public_key public_key varchar(64) DEFAULT NULL;

ALTER TABLE `actions` ADD COLUMN `eosto` varchar(12) GENERATED ALWAYS AS (`data` ->> '$.to');
ALTER TABLE `actions` ADD COLUMN `eosfrom` varchar(12) GENERATED ALWAYS AS (`data` ->> '$.from');
ALTER TABLE `actions` ADD COLUMN `receiver` varchar(12) GENERATED ALWAYS AS (`data` ->> '$.receiver');
ALTER TABLE `actions` ADD COLUMN `payer` varchar(12) GENERATED ALWAYS AS (`data` ->> '$.payer');

CREATE INDEX `idx_actions_eosto` ON `actions`(`eosto`);
CREATE INDEX `idx_actions_eosfrom` ON `actions`(`eosfrom`);
CREATE INDEX `idx_actions_receiver` ON `actions`(`receiver`);
CREATE INDEX `idx_actions_payer` ON `actions`(`payer`);
