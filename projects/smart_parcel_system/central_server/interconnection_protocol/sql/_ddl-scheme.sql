-- MariaDB Script
-- Author: Wbfw109
-- Created: 
-- Description: 📰
-- DB Version: MariaDB 11.6.2


CREATE DATABASE IF NOT EXISTS smart_parcel;
USE smart_parcel;
--
-- 🌀 Independent Tables
--


CREATE TABLE IF NOT EXISTS users (
    id                  INT AUTO_INCREMENT PRIMARY KEY    COMMENT '사용자 고유 식별자',
    name                VARCHAR(255) NOT NULL             COMMENT '사용자 이름',
    is_deleted          BOOLEAN DEFAULT FALSE             COMMENT 'SOFT DELETE (TRUE = 삭제됨)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



CREATE TABLE IF NOT EXISTS storages (
    id                  INT AUTO_INCREMENT PRIMARY KEY    COMMENT '택배 저장소 고유 식별자',
    name                VARCHAR(255)                      COMMENT '택배 저장소 이름',
    is_deleted          BOOLEAN DEFAULT FALSE             COMMENT 'SOFT DELETE (TRUE = 삭제됨)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


--
-- 🌀 Dependent Tables
--

CREATE TABLE IF NOT EXISTS lockers (
    id                  INT AUTO_INCREMENT PRIMARY KEY    COMMENT '택배 보관함 고유 식별자',
    storage_id          INT                               COMMENT '택배 저장소의 외래키 (storages.id 참조)',
    is_deleted          BOOLEAN DEFAULT FALSE             COMMENT 'SOFT DELETE (TRUE = 삭제됨)',
    FOREIGN KEY (storage_id) REFERENCES storages(id) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS parcels (
    id                  INT AUTO_INCREMENT PRIMARY KEY    COMMENT '택배 고유 식별자',
    name                VARCHAR(255) NOT NULL             COMMENT '택배 물품 이름',
    recipient_id        INT                               COMMENT '수령자 id',
    storage_id          INT                               COMMENT '저장소 ID (storages.id 참조)',
    locker_id           INT UNIQUE                        COMMENT '택배 보관함 안에 parcel 이 있다면, NOT NULL',
    -- phone_number        VARCHAR(20)                       COMMENT '수령자 연락처. 월패드로 정보 전달 예정',
    delivery_status     ENUM('pending', 'in_transit', 'delivered') NOT NULL DEFAULT 'pending'
                                                          COMMENT '배송 상태 (pending, in_transit, delivered)',
    -- delivery_date       DATE                              COMMENT '🧪 배송 예정일',
    delivery_image_path VARCHAR(255)                      COMMENT '배송 완료 후 이미지 경로 (URL 또는 파일 경로)',
    is_deleted          BOOLEAN DEFAULT FALSE             COMMENT 'SOFT DELETE (TRUE = 삭제됨)',
    FOREIGN KEY (recipient_id) REFERENCES users(id) ON DELETE NO ACTION,
    FOREIGN KEY (storage_id) REFERENCES storages(id) ON DELETE NO ACTION,
    FOREIGN KEY (locker_id) REFERENCES lockers(id) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



CREATE TABLE IF NOT EXISTS addresses (
    id            INT AUTO_INCREMENT PRIMARY KEY          COMMENT '주소 고유 식별자',
    user_id       INT                                     COMMENT '사용자의 외래키 (user.id 참조)',
    -- city          VARCHAR(100)                            COMMENT '🧪 도시 이름',
    -- district      VARCHAR(100)                            COMMENT '🧪 구/군 이름',
    sub_address   VARCHAR(255)                            COMMENT '상세 주소 (예: XX동, XX호)',
    -- created_at    DATETIME DEFAULT CURRENT_TIMESTAMP 
    --                                                       COMMENT '🧪 주소 생성 시각 (기본값: 현재 시각)',
    -- updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP 
    --             ON UPDATE CURRENT_TIMESTAMP               COMMENT '🧪 주소 업데이트 시각 (수정 시 자동 갱신)'
    is_deleted    BOOLEAN DEFAULT FALSE                   COMMENT 'SOFT DELETE (TRUE = 삭제됨)',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


