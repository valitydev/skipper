CREATE SCHEMA IF NOT EXISTS skipper;

CREATE TYPE skipper.chargeback_category AS ENUM ('FRAUD', 'DISPUTE', 'AUTHORISATION', 'PROCESSING_ERROR');

CREATE TABLE skipper.chargeback (
    id                       BIGSERIAL                      NOT NULL,
    invoice_id               CHARACTER VARYING              NOT NULL,
    payment_id               CHARACTER VARYING              NOT NULL,
    pretension_date          TIMESTAMP WITHOUT TIME ZONE    NOT NULL,
    operation_date           TIMESTAMP WITHOUT TIME ZONE    NOT NULL,
    amount                   BIGINT                         NOT NULL,
    currency                 VARCHAR(3)                     NOT NULL,
    shop_id                  CHARACTER VARYING              NOT NULL,
    chargeback_category      skipper.chargeback_category    NOT NULL,
    reason_code              CHARACTER VARYING              NULL,
    rrn                      CHARACTER VARYING              NULL,
    masked_pan               CHARACTER VARYING              NULL,
    shop_url                 CHARACTER VARYING              NULL,
    party_email              CHARACTER VARYING              NULL,
    contact_email            CHARACTER VARYING              NULL,

    CONSTRAINT chargeback_id_PK PRIMARY KEY (id)
);

CREATE INDEX chargeback_invoice_payment_idx ON skipper.chargeback (invoice_id, payment_id);
CREATE INDEX chargeback_pretension_date_idx ON skipper.chargeback (pretension_date);
CREATE INDEX chargeback_shop_idx            ON skipper.chargeback (shop_id);

CREATE TYPE skipper.chargeback_stage AS ENUM ('CHARGEBACK', 'PRE_ARBITRATION', 'ARBITRATION');
CREATE TYPE skipper.chargeback_status AS ENUM ('PENDING', 'ACCEPTED', 'REJECTED', 'CANCELLED');

CREATE TABLE skipper.chargeback_state (
    id                       BIGSERIAL                      NOT NULL,
    chargeback_id            BIGINT                         NOT NULL,
    invoice_id               CHARACTER VARYING              NOT NULL,
    payment_id               CHARACTER VARYING              NOT NULL,
    stage                    skipper.chargeback_stage       NOT NULL,
    status                   skipper.chargeback_status      NOT NULL,
    created_at               TIMESTAMP WITHOUT TIME ZONE    NOT NULL,
    date_of_decision         TIMESTAMP WITHOUT TIME ZONE    NULL,

    CONSTRAINT chargeback_state_id_PK PRIMARY KEY (chargeback_id, id),
    FOREIGN KEY (chargeback_id) REFERENCES skipper.chargeback (id)
);

CREATE INDEX chargeback_state_invoice_payment_idx  ON skipper.chargeback_state (invoice_id, payment_id, id);
CREATE INDEX chargeback_state_created_and_invoice_id_idx  ON skipper.chargeback_state (created_at, invoice_id);


CREATE TABLE skipper.chargeback_hold_state (
    id                       BIGSERIAL                      NOT NULL,
    chargeback_id            BIGINT                         NOT NULL,
    invoice_id               CHARACTER VARYING              NOT NULL,
    payment_id               CHARACTER VARYING              NOT NULL,
    created_at               TIMESTAMP WITHOUT TIME ZONE    NOT NULL,
    will_hold_from_merchant  BOOLEAN                        NOT NULL,
    was_hold_from_merchant   BOOLEAN                        NOT NULL,
    hold_from_us             BOOLEAN                        NOT NULL,

    CONSTRAINT chargeback_hold_state_id_PK PRIMARY KEY (chargeback_id, id),
    FOREIGN KEY (chargeback_id) REFERENCES skipper.chargeback (id)
);

CREATE INDEX chargeback_hold_state_created_idx ON skipper.chargeback_hold_state (created_at, chargeback_id);
CREATE INDEX chargeback_hold_state_created_and_invoice_idx ON skipper.chargeback_hold_state (created_at, invoice_id, payment_id);

