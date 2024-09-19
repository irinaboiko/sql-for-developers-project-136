-- Таблица уроков
CREATE TABLE lessons(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	course_id BIGINT REFERENCES courses(id) NOT NULL,
	name VARCHAR(255) NOT NULL,
	content TEXT NOT NULL,
	video_link TEXT NOT NULL,
	position INTEGER NOT NULL,
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL,
	related_course_url TEXT,
	is_deleted BOOLEAN DEFAULT FALSE
);

-- Таблица курсов
CREATE TABLE courses(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(255) NOT NULL,
	description TEXT NOT NULL,
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL,
	is_deleted BOOLEAN DEFAULT FALSE
);

-- Таблица модулей
CREATE TABLE modules(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(255) NOT NULL,
	description TEXT NOT NULL,
	created_at TIMESTAMP NOT NULL,
	updated_at TIMESTAMP NOT NULL
);

-- Таблица программ обучения
CREATE TABLE programs(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(255) NOT NULL,
	cost INTEGER NOT NULL,
	type VARCHAR(255) NOT NULL,
	created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

-- Таблица для связи курсов и модулей (многие-ко-многим)
CREATE TABLE course_modules(
	course_id BIGINT REFERENCES courses(id) ON DELETE SET NULL,
	module_id BIGINT REFERENCES modules(id) ON DELETE SET NULL,
	PRIMARY KEY(course_id, module_id)
);

-- Таблица для связи программ и модулей (многие-ко-многим)
CREATE TABLE program_modules(
	program_id BIGINT REFERENCES programs(id) ON DELETE SET NULL,
	module_id BIGINT REFERENCES modules(id) ON DELETE SET NULL,
	PRIMARY KEY(program_id, module_id)
);

-- Таблица пользователей
CREATE TYPE user_role AS ENUM('student', 'teacher', 'admin');

CREATE TABLE users(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	teaching_group_id BIGINT REFERENCES teaching_groups(id) ON DELETE SET NULL,
	username VARCHAR(255) NOT NULL,
	email VARCHAR(255) UNIQUE NOT NULL,
	password TEXT NOT NULL,
	teaching_group_link TEXT NOT NULL,
	role user_role NOT NULL,
	created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

-- Таблица учебной группы пользователя
CREATE TABLE teaching_groups(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	slug VARCHAR(255) UNIQUE,
	created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

-- Таблица подписок
CREATE TYPE enrollment_status AS ENUM('active', 'pending', 'cancelled', 'completed');

CREATE TABLE enrollments(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
	program_id BIGINT REFERENCES programs(id) ON DELETE SET NULL,
	status enrollment_status NOT NULL,
	created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);



-- Таблица для оплат
CREATE TYPE payment_status AS ENUM('pending', 'paid', 'failed', 'refunded');

CREATE TABLE payments(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	enrollment_id BIGINT REFERENCES enrollments(id) ON DELETE SET NULL,
	amount NUMERIC NOT NULL,
	status payment_status NOT NULL,
	paid_at TIMESTAMP NOT NULL,
	created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

-- Таблица отслеживания прогресса прохождения программы
CREATE TYPE program_completion_status AS ENUM('active', 'completed', 'pending', 'cancelled');

CREATE TABLE program_completions(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
	program_id BIGINT REFERENCES programs(id) ON DELETE SET NULL,
	status program_completion_status NOT NULL,
	start_date TIMESTAMP NOT NULL,
	end_date TIMESTAMP,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

-- Таблица сертификатов
CREATE TABLE certificates(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
  program_id BIGINT REFERENCES programs(id) ON DELETE SET NULL,
  certificate_url TEXT NOT NULL,
  issued_at TIMESTAMP NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

-- Таблица для тестов
CREATE TABLE quizzes(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	lesson_id BIGINT REFERENCES lessons(id) ON DELETE SET NULL,
	name VARCHAR(255) NOT NULL,
	content JSONB NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

-- Таблица для практических заданий
CREATE TABLE exercises(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	lesson_id BIGINT REFERENCES lessons(id) ON DELETE SET NULL,
	name VARCHAR(255) NOT NULL,
	url TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

-- Таблица обсуждений
CREATE TABLE discussions(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	lesson_id BIGINT REFERENCES lessons(id) ON DELETE SET NULL,
	content JSONB NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

-- Таблица блога
CREATE TYPE blog_status AS ENUM('created', 'in moderation', 'published', 'archived');

CREATE TABLE blog(
	id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	user_id BIGINT REFERENCES users(id) ON DELETE SET NULL,
	title VARCHAR(255) NOT NULL,
	content TEXT  NOT NULL,
	status blog_status NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);
