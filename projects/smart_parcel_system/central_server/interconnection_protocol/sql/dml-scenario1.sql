USE smart_parcel;

-- 🌀 1. 기본 데이터 삽입
-- 👤 사용자 2명 추가
INSERT INTO users (id, name) VALUES (1, '사용자A'), (2, '사용자B');
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
INSERT INTO lockers (storage_id) VALUES (1), (1), (2), (2);


-- ➡️ SELECT * from addresses; SELECT * from users;
-- ➡️ SELECT * from storages; SELECT * from lockers;
--
--
--
-- 🌀 2. [택배기사] Parcel 등록 및 보관함에 저장
-- storage_id = 1 (강남 창고)에 택배 2개 등록
INSERT INTO parcels (recipient_id, name) VALUES (1, '노트북'), (1, '책');

-- 📦 빈 보관함을 찾아 최신 택배를 할당
UPDATE parcels p
JOIN (
    SELECT id FROM lockers
    WHERE storage_id = 1
    AND id NOT IN (SELECT locker_id FROM parcels WHERE locker_id IS NOT NULL)
    ORDER BY id ASC
    LIMIT 2
) l
SET p.locker_id = l.id
WHERE p.delivery_status = 'pending' AND p.locker_id IS NULL
LIMIT 2;

-- ➡️ SELECT * FROM parcels; SELECT * FROM lockers;
--
--
--
-- 🌀 3. [사용자] 자신의 택배 찾고 보관함에서 꺼냄
-- user_id = 1 인 사용자가 본인의 택배 ID 찾기
SELECT id FROM parcels WHERE recipient_id = 1 AND delivery_status = 'pending';

-- 🔓 보관함에서 parcel_id 제거 (택배 꺼내기)
UPDATE parcels
SET locker_id = NULL, delivery_status = 'in_transit'
WHERE recipient_id = 1 AND delivery_status = 'pending'
LIMIT 1;

-- 🚛 택배 상태를 "in_transit" (배송 중)으로 변경
UPDATE parcels
SET delivery_status = 'in_transit'
WHERE recipient_id = 1 AND locker_id IS NULL;
--
--
--
-- 🌀 4. [자동 배송 로봇] 배송 완료 후 업데이트
-- 📸 배송이 완료된 택배의 사진을 업로드하고 상태 변경
UPDATE parcels
SET delivery_image_path = '/images/delivery_1.jpg',
    delivery_status = 'delivered'
WHERE recipient_id = 1 AND delivery_status = 'in_transit';