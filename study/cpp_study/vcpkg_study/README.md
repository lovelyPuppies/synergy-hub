- 목표
  1. 크로스 컴파일
  2. 크로스 컴파일 (+ 외부 라이브러리 사용)
  3. 크로스 컴파일된 실행파일 디버깅

```bash
#!/usr/bin/env fish

# ⚙️ Adjust your environment variable for cmake
./setup_dev_env.fish

❯ ls $VCPKG_ROOT/installed/x64-linux/debug/lib
libcrypto.a  libfmtd.a  libmariadb.a@  libmariadbclient.a  libmariadbcpp.a@  libmariadbcpp-static.a  libssl.a  libz.a  pkgconfig/

```
