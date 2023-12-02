create table specialization (
    specialization_id   serial          PRIMARY KEY,
    specialization_name varchar(100)    NOT NULL
);

create table area (
    area_id     serial          PRIMARY KEY,
    area_name   varchar(100)    NOT NULL
);

create table job_seeker (
    job_seeker_id       serial          PRIMARY KEY,
    job_seeker_name     varchar(150)    NOT NULL,
    job_seeker_age      integer         CHECK (job_seeker_age > 16 AND job_seeker_age < 100),
    job_seeker_email    varchar(100)    NOT NULL UNIQUE,
    area_id             integer         NOT NULL REFERENCES area(area_id)
);

create table resume (
    resume_id           serial          PRIMARY KEY,
    resume_title        varchar(100)    NOT NULL,
    job_seeker_id       integer         NOT NULL REFERENCES job_seeker(job_seeker_id),
    compensation_from   integer,
    compensation_to     integer,
    area_id             integer         NOT NULL REFERENCES area(area_id),
    specialization_id   integer         NOT NULL REFERENCES specialization(specialization_id),
    publication_time    timestamp       NOT NULL default CURRENT_TIMESTAMP
);

create table employer (
    employer_id     serial          PRIMARY KEY,
    employer_name   varchar(150)    NOT NULL,
    employer_email  varchar(100)    NOT NULL UNIQUE,
    area_id         integer         NOT NULL REFERENCES area(area_id)
);

create table vacancy (
    vacancy_id          serial          PRIMARY KEY,
    vacancy_title       varchar(100)    NOT NULL,
    employer_id         integer         NOT NULL REFERENCES employer(employer_id),
    description         text,
    compensation_from   integer,
    compensation_to     integer,
    area_id             integer         NOT NULL REFERENCES area(area_id),
    specialization_id   integer         NOT NULL REFERENCES specialization(specialization_id),
    publication_time    timestamp       NOT NULL default CURRENT_TIMESTAMP
);

create table response (
    resume_id       integer     NOT NULL REFERENCES resume(resume_id),
    vacancy_id      integer     NOT NULL REFERENCES vacancy(vacancy_id),
    response_time   timestamp   NOT NULL default CURRENT_TIMESTAMP,
    primary key (resume_id, vacancy_id)
);
