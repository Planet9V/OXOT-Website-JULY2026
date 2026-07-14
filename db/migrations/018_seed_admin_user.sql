-- 018_seed_admin_user.sql
-- Seed the dev/demo admin DIRECTLY via db:migrate, because the Railway pre-deploy
-- 'seed:admin' step is not executing (only db:migrate runs there). scrypt hash of
-- 'OxotDev!2026' in salt:hash form, matching src/lib/auth.ts verifyPassword().
-- Idempotent: ON CONFLICT (email) DO UPDATE. Login: admin@oxot.local / OxotDev!2026
INSERT INTO admin_users (email, password_hash)
VALUES ('admin@oxot.local', '77e1d4a9473fdadde5ef44b760615eb0:0ddaf56ae0566e1c7ca68d55cf0ff6049fbc1aa3fb768c73930aeb9d793698e5f2bbf1985ce92295317f53135b9dbcc53b6beb74bf01b3d6d2c9eaecc527944a')
ON CONFLICT (email) DO UPDATE SET password_hash = EXCLUDED.password_hash;
