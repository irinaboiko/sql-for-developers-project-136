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
	updated_at TIMESTAMP NOT NULL,
	deleted_at TIMESTAMP
);

CREATE TABLE lessons(
	id serial PRIMARY KEY,
	course_id integer REFERENCES courses(id),
	name VARCHAR(255) NOT NULL,
	content TEXT NOT NULL,
	video_url TEXT NOT NULL,
	position INTEGER,
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL,
	deleted_at TIMESTAMP
);

CREATE TABLE modules(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(255) NOT NULL,
	description TEXT NOT NULL,
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL,
	deleted_at TIMESTAMP
);

CREATE TABLE programs(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(255) NOT NULL,
	price INTEGER NOT NULL,
	program_type VARCHAR(255) NOT NULL,
	created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE course_modules(
	course_id BIGINT REFERENCES courses(id),
	module_id BIGINT REFERENCES modules(id)
);

CREATE TABLE program_modules(
	program_id BIGINT REFERENCES programs(id),
	module_id BIGINT REFERENCES modules(id)
);

CREATE TABLE teaching_groups(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	slug VARCHAR(255) UNIQUE,
	created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE users(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	teaching_group_id BIGINT REFERENCES teaching_groups(id),
	name VARCHAR(255) NOT NULL,
	email VARCHAR(255) UNIQUE NOT NULL,
	password_hash TEXT NOT NULL,
	role user_role NOT NULL,
	created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  deleted_at TIMESTAMP
);

CREATE TABLE enrollments(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	user_id BIGINT REFERENCES users(id),
	program_id BIGINT REFERENCES programs(id),
	status enrollment_status NOT NULL,
	created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE payments(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	enrollment_id BIGINT REFERENCES enrollments(id),
	amount NUMERIC NOT NULL,
	status payment_status NOT NULL,
	paid_at TIMESTAMP NOT NULL,
	created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE program_completions(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	user_id BIGINT REFERENCES users(id),
	program_id BIGINT REFERENCES programs(id),
	status program_completion_status NOT NULL,
	started_at TIMESTAMP NOT NULL,
	completed_at TIMESTAMP,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE certificates(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	user_id BIGINT REFERENCES users(id),
  program_id BIGINT REFERENCES programs(id),
  url TEXT NOT NULL,
  issued_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE quizzes(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	lesson_id BIGINT REFERENCES lessons(id),
	name VARCHAR(255) NOT NULL,
	content JSONB NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE exercises(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	lesson_id BIGINT REFERENCES lessons(id),
	name VARCHAR(255) NOT NULL,
	url TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE discussions(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	user_id BIGINT REFERENCES users(id),
	lesson_id BIGINT REFERENCES lessons(id),
	text JSONB NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE blogs(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	user_id BIGINT REFERENCES users(id),
	name VARCHAR(255) NOT NULL,
	content TEXT  NOT NULL,
	status blog_status NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);
