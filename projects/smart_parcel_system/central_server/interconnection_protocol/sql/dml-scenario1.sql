USE smart_parcel;

-- 🚀 1. 기본 데이터 삽입
-- 🏠 사용자 (Users) 2명 생성
INSERT INTO
  users (id)
VALUES
  (1),
  (2);

-- 🏠 각 사용자 별 주소 생성
INSERT INTO
  addresses (user_id, sub_address)
VALUES
  (1, '101동 101호'),
  (2, '102동 202호');

-- 📦 스토리지 (Storage) 2개 생성
INSERT INTO
  storages (id, name)
VALUES
  (1, '강남 창고'),
  (2, '서초 창고');

-- 🔒 각 스토리지 별 보관함 (Locker) 2개씩 생성
INSERT INTO
  lockers (storage_id, parcel_id)
VALUES
  (1, NULL),
  (1, NULL), -- 강남 창고의 보관함 2개
  (2, NULL),
  (2, NULL);

-- 서초 창고의 보관함 2개
-- 🚀 2. [택배기사] Parcel 등록 및 보관함에 저장
-- 🚛 storage_id = 1 (강남 창고)에 택배 등록
INSERT INTO
  parcels (recipient_id)
VALUES
  (1);

-- 가장 먼저 빈 locker 찾기
UPDATE lockers
SET
  parcel_id = (
    SELECT
      MAX(id)
    FROM
      parcels
  )
WHERE
  storage_id = 1
  AND parcel_id IS NULL
LIMIT
  1;

-- 🚀 3. [사용자] 자신의 택배 찾고 보관함에서 꺼냄
-- 🔍 user_id = 1 인 사용자가 본인의 택배 ID 찾기
SELECT
  id
FROM
  parcels
WHERE
  recipient_id = 1;

-- 🔓 lockers 에서 parcel_id 제거 (택배 꺼내기)
UPDATE lockers
SET
  parcel_id = NULL
WHERE
  parcel_id = (
    SELECT
      id
    FROM
      parcels
    WHERE
      recipient_id = 1
    ORDER BY
      id DESC
    LIMIT
      1
  );

-- 🚛 택배 상태를 "in_transit" (배송 중)으로 변경
UPDATE parcels
SET
  delivery_status = 'in_transit'
WHERE
  recipient_id = 1;

-- 🚀 4. [자동 배송 로봇] 배송 완료 후 업데이트
-- 📸 배송이 완료된 택배의 사진을 업로드하고 상태 변경
UPDATE parcels
SET
  delivery_image_path = '/images/delivery_1.jpg',
  delivery_status = 'delivered'
WHERE
  recipient_id = 1;