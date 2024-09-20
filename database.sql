CREATE type user_role as ENUM('student', 'teacher', 'admin');
CREATE type enrollment_status as ENUM('active', 'pending', 'cancelled', 'completed');
CREATE type payment_status as ENUM('pending', 'paid', 'failed', 'refunded');
CREATE type program_completion_status as ENUM('active', 'completed', 'pending', 'cancelled');
CREATE type blog_status as ENUM('created', 'in moderation', 'published', 'archived');

CREATE TABLE courses(
	id serial PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	description TEXT NOT NULL,
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP,
	deleted_at TIMESTAMP
);

CREATE TABLE lessons(
	id serial PRIMARY KEY,
	course_id integer REFERENCES courses(id),
	name VARCHAR(255) NOT NULL,
	content TEXT NOT NULL,
	video_url TEXT,
	position INTEGER,
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP,
	deleted_at TIMESTAMP
);

CREATE TABLE modules(
	id serial PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	description TEXT NOT NULL,
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP,
	deleted_at TIMESTAMP
);

CREATE TABLE programs(
	id serial PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	price INTEGER NOT NULL,
	program_type VARCHAR(255) NOT NULL,
	created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP
);

CREATE TABLE course_modules(
	course_id BIGINT REFERENCES courses(id),
	module_id BIGINT REFERENCES modules(id),
	PRIMARY KEY (course_id, module_id)
);

CREATE TABLE program_modules(
	program_id BIGINT REFERENCES programs(id),
	module_id BIGINT REFERENCES modules(id),
	PRIMARY KEY (program_id, module_id)
);

CREATE TABLE teaching_groups(
	id serial PRIMARY KEY,
	slug VARCHAR(255) UNIQUE,
	created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP
);

CREATE TABLE users(
	id serial PRIMARY KEY,
	teaching_group_id integer REFERENCES teaching_groups(id),
	name VARCHAR(255) NOT NULL,
	email VARCHAR(255) UNIQUE NOT NULL,
	password_hash TEXT NOT NULL,
	role user_role NOT NULL,
	created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP,
  deleted_at TIMESTAMP
);

CREATE TABLE enrollments(
	id serial PRIMARY KEY,
	user_id integer REFERENCES users(id),
	program_id integer REFERENCES programs(id),
	status enrollment_status NOT NULL,
	created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP
);

CREATE TABLE payments(
	id serial PRIMARY KEY,
	enrollment_id integer REFERENCES enrollments(id),
	amount NUMERIC NOT NULL,
	status payment_status NOT NULL,
	paid_at TIMESTAMP,
	created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP
);

CREATE TABLE program_completions(
	id serial PRIMARY KEY,
	user_id integer REFERENCES users(id),
	program_id integer REFERENCES programs(id),
	status program_completion_status NOT NULL,
	started_at TIMESTAMP NOT NULL,
	completed_at TIMESTAMP,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP
);

CREATE TABLE certificates(
	id serial PRIMARY KEY,
	user_id integer REFERENCES users(id),
  program_id integer REFERENCES programs(id),
  url TEXT,
  issued_at TIMESTAMP,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP
);

CREATE TABLE quizzes(
	id serial PRIMARY KEY,
	lesson_id integer REFERENCES lessons(id),
	name VARCHAR(255) NOT NULL,
	content JSONB NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP
);

CREATE TABLE exercises(
	id serial PRIMARY KEY,
	lesson_id integer REFERENCES lessons(id),
	name VARCHAR(255) NOT NULL,
	url TEXT,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP
);

CREATE TABLE discussions(
	id serial PRIMARY KEY,
	user_id integer REFERENCES users(id),
	lesson_id integer REFERENCES lessons(id),
	text JSONB NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP
);

CREATE TABLE blogs(
	id serial PRIMARY KEY,
	user_id integer REFERENCES users(id),
	name VARCHAR(255) NOT NULL,
	content TEXT NOT NULL,
	status blog_status NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP
);
