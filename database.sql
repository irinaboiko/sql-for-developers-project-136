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

