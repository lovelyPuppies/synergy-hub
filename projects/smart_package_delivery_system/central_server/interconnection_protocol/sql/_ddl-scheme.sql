-- MariaDB Script
-- Author: Wbfw109
-- Created: 
-- Description: 📰
-- DB Version: MariaDB 11.6.2


CREATE DATABASE IF NOT EXISTS smart_pkg_db;
USE smart_pkg_db;

-- * Cardinality
--    users     : addresses     ==    1 : N
--    pkg_rooms : lockers       ==    1 : N
--    pkgs      : lockers       ==    1 : 1

--
-- 🌀 Independent Tables
--
CREATE TABLE IF NOT EXISTS whitelist_clients (
    id                  INT AUTO_INCREMENT PRIMARY KEY          COMMENT '클라이언트 고유 식별자',
    node_id             INT NOT NULL                            COMMENT '클라이언트 노드의 타입별 식별 ID',
    node_type           ENUM('CLIENT_ADDRESS_RECOGNIZER', 'CLIENT_USER', 'CLIENT_DELIVERY_ROBOT', 'CLIENT_ELEVATOR') NOT NULL
                                                                COMMENT '클라이언트 노드의 타입',
    node_name           VARCHAR(255) NOT NULL                   COMMENT '클라이언트 노드의 이름',
    -- node_alias VARCHAR(255) DEFAULT NULL                        COMMENT '사용자가 지정한 별칭 (중복 가능)',
    is_active           BOOLEAN DEFAULT TRUE                    COMMENT '활성화 여부 (TRUE=허용, FALSE=차단)',
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP     COMMENT '등록 시각',
    -- updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    --                                                             COMMENT '마지막 업데이트 시각',
    -- hmac_key            VARCHAR(64) DEFAULT NULL                COMMENT 'HMAC 검증용 보안 키 (선택 사항)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS users (
    id                  INT AUTO_INCREMENT PRIMARY KEY    COMMENT '사용자 고유 식별자',
    name                VARCHAR(255) NOT NULL             COMMENT '사용자 이름',
    is_deleted          BOOLEAN DEFAULT FALSE             COMMENT 'SOFT DELETE (TRUE = 삭제됨)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- Apartment Package Room
CREATE TABLE IF NOT EXISTS pkg_rooms (
    id                  INT AUTO_INCREMENT PRIMARY KEY    COMMENT '택배 저장소 고유 식별자',
    name                VARCHAR(255)                      COMMENT '택배 저장소 이름',
    is_deleted          BOOLEAN DEFAULT FALSE             COMMENT 'SOFT DELETE (TRUE = 삭제됨)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


--
-- 🌀 Dependent Tables
--

CREATE TABLE IF NOT EXISTS lockers (
    id                  INT AUTO_INCREMENT PRIMARY KEY    COMMENT '택배 보관함 고유 식별자',
    pkg_room_id         INT                               COMMENT '택배 저장소의 외래키 (pkg_rooms.id 참조)',
    -- TODO: password_hash VARCHAR(72)                        COMMENT 'bcrypt 해시 저장 (최대 72자)',
    is_deleted          BOOLEAN DEFAULT FALSE             COMMENT 'SOFT DELETE (TRUE = 삭제됨)',
    FOREIGN KEY (pkg_room_id) REFERENCES pkg_rooms(id) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS pkgs (
    id                  INT AUTO_INCREMENT PRIMARY KEY    COMMENT '택배 고유 식별자',
    name                VARCHAR(255) NOT NULL             COMMENT '택배 물품 이름',
    receiver_id         INT                               COMMENT '수령자 id',
    pkg_room_id         INT                               COMMENT '저장소 ID (pkg_rooms.id 참조)',
    locker_id           INT UNIQUE                        COMMENT '택배 보관함 안에 pkg 가 있다면, NOT NULL',
    -- phone_num        VARCHAR(20)                       COMMENT '수령자 연락처. 월패드로 정보 전달 예정',
    delivery_status     ENUM('PENDING', 'IN_TRANSIT', 'DELIVERED') NOT NULL DEFAULT 'PENDING'
                                                          COMMENT '배송 상태',
    -- delivery_date       DATE                              COMMENT '🧪 배송 예정일',
    delivery_image_path VARCHAR(255)                      COMMENT '배송 완료 후 이미지 경로 (URL 또는 파일 경로)',
    is_deleted          BOOLEAN DEFAULT FALSE             COMMENT 'SOFT DELETE (TRUE = 삭제됨)',
    FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE NO ACTION,
    FOREIGN KEY (pkg_room_id) REFERENCES pkg_rooms(id) ON DELETE NO ACTION,
    FOREIGN KEY (locker_id) REFERENCES lockers(id) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



CREATE TABLE IF NOT EXISTS addresses (
    id                  INT AUTO_INCREMENT PRIMARY KEY    COMMENT '주소 고유 식별자',
    user_id             INT                               COMMENT '사용자의 외래키 (user.id 참조)',
    -- city          VARCHAR(100)                            COMMENT '🧪 도시 이름',
    -- district      VARCHAR(100)                            COMMENT '🧪 구/군 이름',
    sub_address         VARCHAR(255)                      COMMENT '상세 주소 (예: XX동, XX호)',
    -- created_at    DATETIME DEFAULT CURRENT_TIMESTAMP 
    --                                                       COMMENT '🧪 주소 생성 시각 (기본값: 현재 시각)',
    -- updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP 
    --             ON UPDATE CURRENT_TIMESTAMP               COMMENT '🧪 주소 업데이트 시각 (수정 시 자동 갱신)'
    is_deleted          BOOLEAN DEFAULT FALSE             COMMENT 'SOFT DELETE (TRUE = 삭제됨)',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


