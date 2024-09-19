CREATE TABLE lessons(
	id BIGINT PRIMARY KEY UNIQUE NOT NULL,
	course_id BIGINT REFERENCES courses(id) NOT NULL,
	name VARCHAR(255) NOT NULL,
	content TEXT NOT NULL,
	video_url TEXT NOT NULL,
	position INTEGER NOT NULL,
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL,
	deleted_at TIMESTAMP NOT NULL
);

CREATE TABLE courses(
	id BIGINT PRIMARY KEY UNIQUE NOT NULL,
	name VARCHAR(255) NOT NULL,
	description TEXT NOT NULL,
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL,
	deleted_at TIMESTAMP NOT NULL
);

CREATE TABLE modules(
	id BIGINT PRIMARY KEY UNIQUE NOT NULL,
	name VARCHAR(255) NOT NULL,
	description TEXT NOT NULL,
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL,
	deleted_at TIMESTAMP NOT NULL
);

CREATE TABLE programs(
	id BIGINT PRIMARY KEY UNIQUE NOT NULL,
	name VARCHAR(255) NOT NULL,
	price INTEGER NOT NULL,
	program_type VARCHAR(255) NOT NULL,
	created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE course_modules(
	course_id BIGINT REFERENCES courses(id) ON DELETE SET NULL,
	module_id BIGINT REFERENCES modules(id) ON DELETE SET NULL
);

CREATE TABLE program_modules(
	program_id BIGINT REFERENCES programs(id) ON DELETE SET NULL,
	module_id BIGINT REFERENCES modules(id) ON DELETE SET NULL
);

CREATE TYPE user_role AS ENUM('student', 'teacher', 'admin');

CREATE TABLE users(
	id BIGINT PRIMARY KEY UNIQUE NOT NULL,
	teaching_group_id BIGINT REFERENCES teaching_groups(id) ON DELETE SET NULL,
	name VARCHAR(255) NOT NULL,
	email VARCHAR(255) UNIQUE NOT NULL,
	password_hash TEXT NOT NULL,
	role user_role NOT NULL,
	created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL,
  deleted_at TIMESTAMP NOT NULL
);

CREATE TABLE teaching_groups(
	id BIGINT PRIMARY KEY UNIQUE NOT NULL,
	slug VARCHAR(255) UNIQUE,
	created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TYPE enrollment_status AS ENUM('active', 'pending', 'cancelled', 'completed');

CREATE TABLE enrollments(
	id BIGINT PRIMARY KEY UNIQUE NOT NULL,
	user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
	program_id BIGINT REFERENCES programs(id) ON DELETE SET NULL,
	status enrollment_status NOT NULL,
	created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TYPE payment_status AS ENUM('pending', 'paid', 'failed', 'refunded');

CREATE TABLE payments(
	id BIGINT PRIMARY KEY UNIQUE NOT NULL,
	enrollment_id BIGINT REFERENCES enrollments(id) ON DELETE SET NULL,
	amount NUMERIC NOT NULL,
	status payment_status NOT NULL,
	paid_at TIMESTAMP NOT NULL,
	created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TYPE program_completion_status AS ENUM('active', 'completed', 'pending', 'cancelled');

CREATE TABLE program_completions(
	id BIGINT PRIMARY KEY UNIQUE NOT NULL,
	user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
	program_id BIGINT REFERENCES programs(id) ON DELETE SET NULL,
	status program_completion_status NOT NULL,
	started_at TIMESTAMP NOT NULL,
	completed_at TIMESTAMP,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE certificates(
	id BIGINT PRIMARY KEY UNIQUE NOT NULL,
	user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
  program_id BIGINT REFERENCES programs(id) ON DELETE SET NULL,
  url TEXT NOT NULL,
  issued_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE quizzes(
	id BIGINT PRIMARY KEY UNIQUE NOT NULL,
	lesson_id BIGINT REFERENCES lessons(id) ON DELETE SET NULL,
	name VARCHAR(255) NOT NULL,
	content JSONB NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE exercises(
	id BIGINT PRIMARY KEY UNIQUE NOT NULL,
	lesson_id BIGINT REFERENCES lessons(id) ON DELETE SET NULL,
	name VARCHAR(255) NOT NULL,
	url TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE discussions(
	id BIGINT PRIMARY KEY UNIQUE NOT NULL,
	user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
	lesson_id BIGINT REFERENCES lessons(id) ON DELETE SET NULL,
	text JSONB NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TYPE blog_status AS ENUM('created', 'in moderation', 'published', 'archived');

CREATE TABLE blog(
	id BIGINT PRIMARY KEY UNIQUE NOT NULL,
	user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
	name VARCHAR(255) NOT NULL,
	content TEXT  NOT NULL,
	status blog_status NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);
