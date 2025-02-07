-- MariaDB Script
-- Author: Wbfw109
-- Created: 
-- Description: 📰
-- DB Version: MariaDB 11.6.2


USE smart_parcel;

-- 🌀 1. 기본 데이터 삽입
-- 👤 사용자 2명 추가
INSERT INTO
  users (id, name)
VALUES
  (1, '사용자A'),
  (2, '사용자B');

-- 🏠 각 사용자의 주소 추가
INSERT INTO
  addresses (user_id, sub_address)
VALUES
  (1, '101동 101호'),
  (2, '102동 202호');

-- 🏬 창고 추가
INSERT INTO
  storages (id, name)
VALUES
  (1, '강남 창고'),
  (2, '서초 창고');

-- 🔒 보관함 추가 (강남 창고 2개, 서초 창고 2개)
INSERT INTO
  lockers (storage_id)
VALUES
  (1),
  (1),
  (2),
  (2);

-- ➡️ SELECT * FROM addresses WHERE is_deleted = FALSE;
-- ➡️ SELECT * FROM users WHERE is_deleted = FALSE;
-- ➡️ SELECT * FROM storages WHERE is_deleted = FALSE;
-- ➡️ SELECT * FROM lockers WHERE is_deleted = FALSE;
--
--
--
-- 🌀 2. [택배기사] Parcel 등록 및 보관함에 저장
-- storage_id = 1 (강남 창고)에 택배 2개 등록
INSERT INTO
  parcels (recipient_id, name, storage_id)
VALUES
  (1, '노트북', 1),
  (1, '책', 1);

-- 📦 빈 보관함을 찾아 최신 택배를 할당
-- 📍 UPDATE multiple rows with different values in one query 📅 2025-02-07 01:20:05
UPDATE parcels p
JOIN (
  SELECT
    p.id AS parcel_id,
    l.id AS locker_id
  FROM
    (
      SELECT
        id,
        ROW_NUMBER() OVER () AS rownum
      FROM
        parcels
      WHERE
        storage_id = 1
        AND is_deleted = FALSE
        AND delivery_status = 'pending'
        AND locker_id IS NULL
      ORDER BY
        id ASC
      LIMIT
        10 -- ⚙️ 한번에 최대 10개 업데이트 (설정 가능)
    ) p
    JOIN (
      SELECT
        id,
        ROW_NUMBER() OVER () AS rownum
      FROM
        lockers
      WHERE
        storage_id = 1
        AND is_deleted = FALSE
        AND id NOT IN(
          SELECT
            locker_id
          FROM
            parcels
          WHERE
            storage_id = 1
            AND locker_id IS NOT NULL
            AND is_deleted = FALSE
        )
      ORDER BY
        id ASC
      LIMIT
        10 -- ⚙️ 보관함도 한번에 최대 10개 가져옴
    ) l ON p.rownum = l.rownum -- ❗ 1:1 매칭
) temp ON p.id = temp.parcel_id
SET
  p.locker_id = temp.locker_id;

-- ➡️ SELECT * FROM parcels WHERE is_deleted = FALSE AND storage_id = 1;
-- ➡️ SELECT * FROM lockers WHERE is_deleted = FALSE AND storage_id = 1;
--
--
--
-- 🌀 3. [사용자] 자신의 택배 찾고 보관함에서 꺼냄
-- user_id = 1 인 사용자가 본인의 택배 ID 찾기
SELECT
  id
FROM
  parcels
WHERE
  storage_id = 1
  AND is_deleted = FALSE
  AND recipient_id = 1
  AND delivery_status = 'pending';

-- 🔓 보관함에서 parcel_id 제거, 🚛 택배 상태를 "배송 중"으로 변경 (택배 꺼내기)
UPDATE parcels
SET
  locker_id = NULL,
  delivery_status = 'in_transit'
WHERE
  storage_id = 1
  AND is_deleted = FALSE
  AND recipient_id = 1
  AND delivery_status = 'pending'
LIMIT
  1;

-- ➡️ SELECT * FROM parcels WHERE is_deleted = FALSE AND storage_id = 1;
--
--
-- 🌀 4. [자동 배송 로봇] 배송 완료 후 업데이트
-- 📸 배송이 완료된 택배의 사진을 업로드하고 상태 변경
UPDATE parcels
SET
  delivery_image_path = '/images/delivery_1.jpg',
  delivery_status = 'delivered'
WHERE
  recipient_id = 1
  AND delivery_status = 'in_transit'
  AND is_deleted = FALSE
  AND storage_id = 1;

-- ➡️ SELECT * FROM parcels WHERE is_deleted = FALSE AND storage_id = 1;
