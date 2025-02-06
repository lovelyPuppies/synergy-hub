-- MariaDB DDL Script
-- Author: Wbfw109
-- Created: 
-- Description: 📰
-- DB Version: MariaDB 11.6.2

CREATE TABLE parcels (
    id                  INT AUTO_INCREMENT PRIMARY KEY    COMMENT '택배 고유 식별자',
    parcel_name         VARCHAR(255) NOT NULL             COMMENT '택배 물품 이름',
    recipient_name      VARCHAR(255)                      COMMENT '🧪 수령자 이름',
    phone_number        VARCHAR(20)                       COMMENT '수령자 연락처. 월패드로 정보 전달 예정',
    delivery_status     ENUM('pending', 'in_transit', 'delivered') NOT NULL DEFAULT 'pending'
                                                          COMMENT '배송 상태 (pending, in_transit, delivered)',
    delivery_date       DATE                              COMMENT '🧪 배송 예정일',
    address_id          INT                               COMMENT '배송지 주소의 외래키 (addresses.id 참조)',
    delivery_image_path VARCHAR(255)                      COMMENT '배송 완료 후 이미지 경로 (URL 또는 파일 경로)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE addresses (
    id            INT AUTO_INCREMENT PRIMARY KEY          COMMENT '주소 고유 식별자',
    city          VARCHAR(100)                            COMMENT '🧪 도시 이름',
    district      VARCHAR(100)                            COMMENT '🧪 구/군 이름',
    sub_address   VARCHAR(255)                            COMMENT '상세 주소 (예: XX동, XX호)',
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP 
                                                          COMMENT '🧪 주소 생성 시각 (기본값: 현재 시각)',
    updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP 
                ON UPDATE CURRENT_TIMESTAMP               COMMENT '🧪 주소 업데이트 시각 (수정 시 자동 갱신)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


----- DB.. .proto에 따라 추가해야함.. parcel..