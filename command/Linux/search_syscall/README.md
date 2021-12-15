# システムコール番号の確認
```
echo '#include<sys/syscall.h>' | cpp -dM - | grep '#define __NR_'
```
