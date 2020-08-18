
_usertests:     file format elf32-i386


Disassembly of section .text:

00001000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "iput test\n");
    1006:	a1 58 75 00 00       	mov    0x7558,%eax
    100b:	c7 44 24 04 ae 55 00 	movl   $0x55ae,0x4(%esp)
    1012:	00 
    1013:	89 04 24             	mov    %eax,(%esp)
    1016:	e8 5f 41 00 00       	call   517a <printf>

  if(mkdir("iputdir") < 0){
    101b:	c7 04 24 b9 55 00 00 	movl   $0x55b9,(%esp)
    1022:	e8 2b 40 00 00       	call   5052 <mkdir>
    1027:	85 c0                	test   %eax,%eax
    1029:	79 1a                	jns    1045 <iputtest+0x45>
    printf(stdout, "mkdir failed\n");
    102b:	a1 58 75 00 00       	mov    0x7558,%eax
    1030:	c7 44 24 04 c1 55 00 	movl   $0x55c1,0x4(%esp)
    1037:	00 
    1038:	89 04 24             	mov    %eax,(%esp)
    103b:	e8 3a 41 00 00       	call   517a <printf>
    exit();
    1040:	e8 a5 3f 00 00       	call   4fea <exit>
  }
  if(chdir("iputdir") < 0){
    1045:	c7 04 24 b9 55 00 00 	movl   $0x55b9,(%esp)
    104c:	e8 09 40 00 00       	call   505a <chdir>
    1051:	85 c0                	test   %eax,%eax
    1053:	79 1a                	jns    106f <iputtest+0x6f>
    printf(stdout, "chdir iputdir failed\n");
    1055:	a1 58 75 00 00       	mov    0x7558,%eax
    105a:	c7 44 24 04 cf 55 00 	movl   $0x55cf,0x4(%esp)
    1061:	00 
    1062:	89 04 24             	mov    %eax,(%esp)
    1065:	e8 10 41 00 00       	call   517a <printf>
    exit();
    106a:	e8 7b 3f 00 00       	call   4fea <exit>
  }
  if(unlink("../iputdir") < 0){
    106f:	c7 04 24 e5 55 00 00 	movl   $0x55e5,(%esp)
    1076:	e8 bf 3f 00 00       	call   503a <unlink>
    107b:	85 c0                	test   %eax,%eax
    107d:	79 1a                	jns    1099 <iputtest+0x99>
    printf(stdout, "unlink ../iputdir failed\n");
    107f:	a1 58 75 00 00       	mov    0x7558,%eax
    1084:	c7 44 24 04 f0 55 00 	movl   $0x55f0,0x4(%esp)
    108b:	00 
    108c:	89 04 24             	mov    %eax,(%esp)
    108f:	e8 e6 40 00 00       	call   517a <printf>
    exit();
    1094:	e8 51 3f 00 00       	call   4fea <exit>
  }
  if(chdir("/") < 0){
    1099:	c7 04 24 0a 56 00 00 	movl   $0x560a,(%esp)
    10a0:	e8 b5 3f 00 00       	call   505a <chdir>
    10a5:	85 c0                	test   %eax,%eax
    10a7:	79 1a                	jns    10c3 <iputtest+0xc3>
    printf(stdout, "chdir / failed\n");
    10a9:	a1 58 75 00 00       	mov    0x7558,%eax
    10ae:	c7 44 24 04 0c 56 00 	movl   $0x560c,0x4(%esp)
    10b5:	00 
    10b6:	89 04 24             	mov    %eax,(%esp)
    10b9:	e8 bc 40 00 00       	call   517a <printf>
    exit();
    10be:	e8 27 3f 00 00       	call   4fea <exit>
  }
  printf(stdout, "iput test ok\n");
    10c3:	a1 58 75 00 00       	mov    0x7558,%eax
    10c8:	c7 44 24 04 1c 56 00 	movl   $0x561c,0x4(%esp)
    10cf:	00 
    10d0:	89 04 24             	mov    %eax,(%esp)
    10d3:	e8 a2 40 00 00       	call   517a <printf>
}
    10d8:	c9                   	leave  
    10d9:	c3                   	ret    

000010da <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
    10da:	55                   	push   %ebp
    10db:	89 e5                	mov    %esp,%ebp
    10dd:	83 ec 28             	sub    $0x28,%esp
  int pid;

  printf(stdout, "exitiput test\n");
    10e0:	a1 58 75 00 00       	mov    0x7558,%eax
    10e5:	c7 44 24 04 2a 56 00 	movl   $0x562a,0x4(%esp)
    10ec:	00 
    10ed:	89 04 24             	mov    %eax,(%esp)
    10f0:	e8 85 40 00 00       	call   517a <printf>

  pid = fork();
    10f5:	e8 e8 3e 00 00       	call   4fe2 <fork>
    10fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
    10fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1101:	79 1a                	jns    111d <exitiputtest+0x43>
    printf(stdout, "fork failed\n");
    1103:	a1 58 75 00 00       	mov    0x7558,%eax
    1108:	c7 44 24 04 39 56 00 	movl   $0x5639,0x4(%esp)
    110f:	00 
    1110:	89 04 24             	mov    %eax,(%esp)
    1113:	e8 62 40 00 00       	call   517a <printf>
    exit();
    1118:	e8 cd 3e 00 00       	call   4fea <exit>
  }
  if(pid == 0){
    111d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1121:	0f 85 83 00 00 00    	jne    11aa <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    1127:	c7 04 24 b9 55 00 00 	movl   $0x55b9,(%esp)
    112e:	e8 1f 3f 00 00       	call   5052 <mkdir>
    1133:	85 c0                	test   %eax,%eax
    1135:	79 1a                	jns    1151 <exitiputtest+0x77>
      printf(stdout, "mkdir failed\n");
    1137:	a1 58 75 00 00       	mov    0x7558,%eax
    113c:	c7 44 24 04 c1 55 00 	movl   $0x55c1,0x4(%esp)
    1143:	00 
    1144:	89 04 24             	mov    %eax,(%esp)
    1147:	e8 2e 40 00 00       	call   517a <printf>
      exit();
    114c:	e8 99 3e 00 00       	call   4fea <exit>
    }
    if(chdir("iputdir") < 0){
    1151:	c7 04 24 b9 55 00 00 	movl   $0x55b9,(%esp)
    1158:	e8 fd 3e 00 00       	call   505a <chdir>
    115d:	85 c0                	test   %eax,%eax
    115f:	79 1a                	jns    117b <exitiputtest+0xa1>
      printf(stdout, "child chdir failed\n");
    1161:	a1 58 75 00 00       	mov    0x7558,%eax
    1166:	c7 44 24 04 46 56 00 	movl   $0x5646,0x4(%esp)
    116d:	00 
    116e:	89 04 24             	mov    %eax,(%esp)
    1171:	e8 04 40 00 00       	call   517a <printf>
      exit();
    1176:	e8 6f 3e 00 00       	call   4fea <exit>
    }
    if(unlink("../iputdir") < 0){
    117b:	c7 04 24 e5 55 00 00 	movl   $0x55e5,(%esp)
    1182:	e8 b3 3e 00 00       	call   503a <unlink>
    1187:	85 c0                	test   %eax,%eax
    1189:	79 1a                	jns    11a5 <exitiputtest+0xcb>
      printf(stdout, "unlink ../iputdir failed\n");
    118b:	a1 58 75 00 00       	mov    0x7558,%eax
    1190:	c7 44 24 04 f0 55 00 	movl   $0x55f0,0x4(%esp)
    1197:	00 
    1198:	89 04 24             	mov    %eax,(%esp)
    119b:	e8 da 3f 00 00       	call   517a <printf>
      exit();
    11a0:	e8 45 3e 00 00       	call   4fea <exit>
    }
    exit();
    11a5:	e8 40 3e 00 00       	call   4fea <exit>
  }
  wait();
    11aa:	e8 43 3e 00 00       	call   4ff2 <wait>
  printf(stdout, "exitiput test ok\n");
    11af:	a1 58 75 00 00       	mov    0x7558,%eax
    11b4:	c7 44 24 04 5a 56 00 	movl   $0x565a,0x4(%esp)
    11bb:	00 
    11bc:	89 04 24             	mov    %eax,(%esp)
    11bf:	e8 b6 3f 00 00       	call   517a <printf>
}
    11c4:	c9                   	leave  
    11c5:	c3                   	ret    

000011c6 <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
    11c6:	55                   	push   %ebp
    11c7:	89 e5                	mov    %esp,%ebp
    11c9:	83 ec 28             	sub    $0x28,%esp
  int pid;

  printf(stdout, "openiput test\n");
    11cc:	a1 58 75 00 00       	mov    0x7558,%eax
    11d1:	c7 44 24 04 6c 56 00 	movl   $0x566c,0x4(%esp)
    11d8:	00 
    11d9:	89 04 24             	mov    %eax,(%esp)
    11dc:	e8 99 3f 00 00       	call   517a <printf>
  if(mkdir("oidir") < 0){
    11e1:	c7 04 24 7b 56 00 00 	movl   $0x567b,(%esp)
    11e8:	e8 65 3e 00 00       	call   5052 <mkdir>
    11ed:	85 c0                	test   %eax,%eax
    11ef:	79 1a                	jns    120b <openiputtest+0x45>
    printf(stdout, "mkdir oidir failed\n");
    11f1:	a1 58 75 00 00       	mov    0x7558,%eax
    11f6:	c7 44 24 04 81 56 00 	movl   $0x5681,0x4(%esp)
    11fd:	00 
    11fe:	89 04 24             	mov    %eax,(%esp)
    1201:	e8 74 3f 00 00       	call   517a <printf>
    exit();
    1206:	e8 df 3d 00 00       	call   4fea <exit>
  }
  pid = fork();
    120b:	e8 d2 3d 00 00       	call   4fe2 <fork>
    1210:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
    1213:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1217:	79 1a                	jns    1233 <openiputtest+0x6d>
    printf(stdout, "fork failed\n");
    1219:	a1 58 75 00 00       	mov    0x7558,%eax
    121e:	c7 44 24 04 39 56 00 	movl   $0x5639,0x4(%esp)
    1225:	00 
    1226:	89 04 24             	mov    %eax,(%esp)
    1229:	e8 4c 3f 00 00       	call   517a <printf>
    exit();
    122e:	e8 b7 3d 00 00       	call   4fea <exit>
  }
  if(pid == 0){
    1233:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1237:	75 3c                	jne    1275 <openiputtest+0xaf>
    int fd = open("oidir", O_RDWR);
    1239:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    1240:	00 
    1241:	c7 04 24 7b 56 00 00 	movl   $0x567b,(%esp)
    1248:	e8 dd 3d 00 00       	call   502a <open>
    124d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0){
    1250:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1254:	78 1a                	js     1270 <openiputtest+0xaa>
      printf(stdout, "open directory for write succeeded\n");
    1256:	a1 58 75 00 00       	mov    0x7558,%eax
    125b:	c7 44 24 04 98 56 00 	movl   $0x5698,0x4(%esp)
    1262:	00 
    1263:	89 04 24             	mov    %eax,(%esp)
    1266:	e8 0f 3f 00 00       	call   517a <printf>
      exit();
    126b:	e8 7a 3d 00 00       	call   4fea <exit>
    }
    exit();
    1270:	e8 75 3d 00 00       	call   4fea <exit>
  }
  sleep(1);
    1275:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    127c:	e8 f9 3d 00 00       	call   507a <sleep>
  if(unlink("oidir") != 0){
    1281:	c7 04 24 7b 56 00 00 	movl   $0x567b,(%esp)
    1288:	e8 ad 3d 00 00       	call   503a <unlink>
    128d:	85 c0                	test   %eax,%eax
    128f:	74 1a                	je     12ab <openiputtest+0xe5>
    printf(stdout, "unlink failed\n");
    1291:	a1 58 75 00 00       	mov    0x7558,%eax
    1296:	c7 44 24 04 bc 56 00 	movl   $0x56bc,0x4(%esp)
    129d:	00 
    129e:	89 04 24             	mov    %eax,(%esp)
    12a1:	e8 d4 3e 00 00       	call   517a <printf>
    exit();
    12a6:	e8 3f 3d 00 00       	call   4fea <exit>
  }
  wait();
    12ab:	e8 42 3d 00 00       	call   4ff2 <wait>
  printf(stdout, "openiput test ok\n");
    12b0:	a1 58 75 00 00       	mov    0x7558,%eax
    12b5:	c7 44 24 04 cb 56 00 	movl   $0x56cb,0x4(%esp)
    12bc:	00 
    12bd:	89 04 24             	mov    %eax,(%esp)
    12c0:	e8 b5 3e 00 00       	call   517a <printf>
}
    12c5:	c9                   	leave  
    12c6:	c3                   	ret    

000012c7 <opentest>:

// simple file system tests

void
opentest(void)
{
    12c7:	55                   	push   %ebp
    12c8:	89 e5                	mov    %esp,%ebp
    12ca:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(stdout, "open test\n");
    12cd:	a1 58 75 00 00       	mov    0x7558,%eax
    12d2:	c7 44 24 04 dd 56 00 	movl   $0x56dd,0x4(%esp)
    12d9:	00 
    12da:	89 04 24             	mov    %eax,(%esp)
    12dd:	e8 98 3e 00 00       	call   517a <printf>
  fd = open("echo", 0);
    12e2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    12e9:	00 
    12ea:	c7 04 24 98 55 00 00 	movl   $0x5598,(%esp)
    12f1:	e8 34 3d 00 00       	call   502a <open>
    12f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    12f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12fd:	79 1a                	jns    1319 <opentest+0x52>
    printf(stdout, "open echo failed!\n");
    12ff:	a1 58 75 00 00       	mov    0x7558,%eax
    1304:	c7 44 24 04 e8 56 00 	movl   $0x56e8,0x4(%esp)
    130b:	00 
    130c:	89 04 24             	mov    %eax,(%esp)
    130f:	e8 66 3e 00 00       	call   517a <printf>
    exit();
    1314:	e8 d1 3c 00 00       	call   4fea <exit>
  }
  close(fd);
    1319:	8b 45 f4             	mov    -0xc(%ebp),%eax
    131c:	89 04 24             	mov    %eax,(%esp)
    131f:	e8 ee 3c 00 00       	call   5012 <close>
  fd = open("doesnotexist", 0);
    1324:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    132b:	00 
    132c:	c7 04 24 fb 56 00 00 	movl   $0x56fb,(%esp)
    1333:	e8 f2 3c 00 00       	call   502a <open>
    1338:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    133b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    133f:	78 1a                	js     135b <opentest+0x94>
    printf(stdout, "open doesnotexist succeeded!\n");
    1341:	a1 58 75 00 00       	mov    0x7558,%eax
    1346:	c7 44 24 04 08 57 00 	movl   $0x5708,0x4(%esp)
    134d:	00 
    134e:	89 04 24             	mov    %eax,(%esp)
    1351:	e8 24 3e 00 00       	call   517a <printf>
    exit();
    1356:	e8 8f 3c 00 00       	call   4fea <exit>
  }
  printf(stdout, "open test ok\n");
    135b:	a1 58 75 00 00       	mov    0x7558,%eax
    1360:	c7 44 24 04 26 57 00 	movl   $0x5726,0x4(%esp)
    1367:	00 
    1368:	89 04 24             	mov    %eax,(%esp)
    136b:	e8 0a 3e 00 00       	call   517a <printf>
}
    1370:	c9                   	leave  
    1371:	c3                   	ret    

00001372 <writetest>:

void
writetest(void)
{
    1372:	55                   	push   %ebp
    1373:	89 e5                	mov    %esp,%ebp
    1375:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
    1378:	a1 58 75 00 00       	mov    0x7558,%eax
    137d:	c7 44 24 04 34 57 00 	movl   $0x5734,0x4(%esp)
    1384:	00 
    1385:	89 04 24             	mov    %eax,(%esp)
    1388:	e8 ed 3d 00 00       	call   517a <printf>
  fd = open("small", O_CREATE|O_RDWR);
    138d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1394:	00 
    1395:	c7 04 24 45 57 00 00 	movl   $0x5745,(%esp)
    139c:	e8 89 3c 00 00       	call   502a <open>
    13a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
    13a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13a8:	78 21                	js     13cb <writetest+0x59>
    printf(stdout, "creat small succeeded; ok\n");
    13aa:	a1 58 75 00 00       	mov    0x7558,%eax
    13af:	c7 44 24 04 4b 57 00 	movl   $0x574b,0x4(%esp)
    13b6:	00 
    13b7:	89 04 24             	mov    %eax,(%esp)
    13ba:	e8 bb 3d 00 00       	call   517a <printf>
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
    13bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    13c6:	e9 a0 00 00 00       	jmp    146b <writetest+0xf9>
    printf(stdout, "error: creat small failed!\n");
    13cb:	a1 58 75 00 00       	mov    0x7558,%eax
    13d0:	c7 44 24 04 66 57 00 	movl   $0x5766,0x4(%esp)
    13d7:	00 
    13d8:	89 04 24             	mov    %eax,(%esp)
    13db:	e8 9a 3d 00 00       	call   517a <printf>
    exit();
    13e0:	e8 05 3c 00 00       	call   4fea <exit>
    if(write(fd, "aaaaaaaaaa", 10) != 10){
    13e5:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    13ec:	00 
    13ed:	c7 44 24 04 82 57 00 	movl   $0x5782,0x4(%esp)
    13f4:	00 
    13f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13f8:	89 04 24             	mov    %eax,(%esp)
    13fb:	e8 0a 3c 00 00       	call   500a <write>
    1400:	83 f8 0a             	cmp    $0xa,%eax
    1403:	74 21                	je     1426 <writetest+0xb4>
      printf(stdout, "error: write aa %d new file failed\n", i);
    1405:	a1 58 75 00 00       	mov    0x7558,%eax
    140a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    140d:	89 54 24 08          	mov    %edx,0x8(%esp)
    1411:	c7 44 24 04 90 57 00 	movl   $0x5790,0x4(%esp)
    1418:	00 
    1419:	89 04 24             	mov    %eax,(%esp)
    141c:	e8 59 3d 00 00       	call   517a <printf>
      exit();
    1421:	e8 c4 3b 00 00       	call   4fea <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
    1426:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    142d:	00 
    142e:	c7 44 24 04 b4 57 00 	movl   $0x57b4,0x4(%esp)
    1435:	00 
    1436:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1439:	89 04 24             	mov    %eax,(%esp)
    143c:	e8 c9 3b 00 00       	call   500a <write>
    1441:	83 f8 0a             	cmp    $0xa,%eax
    1444:	74 21                	je     1467 <writetest+0xf5>
      printf(stdout, "error: write bb %d new file failed\n", i);
    1446:	a1 58 75 00 00       	mov    0x7558,%eax
    144b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    144e:	89 54 24 08          	mov    %edx,0x8(%esp)
    1452:	c7 44 24 04 c0 57 00 	movl   $0x57c0,0x4(%esp)
    1459:	00 
    145a:	89 04 24             	mov    %eax,(%esp)
    145d:	e8 18 3d 00 00       	call   517a <printf>
      exit();
    1462:	e8 83 3b 00 00       	call   4fea <exit>
  for(i = 0; i < 100; i++){
    1467:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    146b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    146f:	0f 8e 70 ff ff ff    	jle    13e5 <writetest+0x73>
    }
  }
  printf(stdout, "writes ok\n");
    1475:	a1 58 75 00 00       	mov    0x7558,%eax
    147a:	c7 44 24 04 e4 57 00 	movl   $0x57e4,0x4(%esp)
    1481:	00 
    1482:	89 04 24             	mov    %eax,(%esp)
    1485:	e8 f0 3c 00 00       	call   517a <printf>
  close(fd);
    148a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    148d:	89 04 24             	mov    %eax,(%esp)
    1490:	e8 7d 3b 00 00       	call   5012 <close>
  fd = open("small", O_RDONLY);
    1495:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    149c:	00 
    149d:	c7 04 24 45 57 00 00 	movl   $0x5745,(%esp)
    14a4:	e8 81 3b 00 00       	call   502a <open>
    14a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
    14ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    14b0:	78 3e                	js     14f0 <writetest+0x17e>
    printf(stdout, "open small succeeded ok\n");
    14b2:	a1 58 75 00 00       	mov    0x7558,%eax
    14b7:	c7 44 24 04 ef 57 00 	movl   $0x57ef,0x4(%esp)
    14be:	00 
    14bf:	89 04 24             	mov    %eax,(%esp)
    14c2:	e8 b3 3c 00 00       	call   517a <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
    14c7:	c7 44 24 08 d0 07 00 	movl   $0x7d0,0x8(%esp)
    14ce:	00 
    14cf:	c7 44 24 04 40 9d 00 	movl   $0x9d40,0x4(%esp)
    14d6:	00 
    14d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    14da:	89 04 24             	mov    %eax,(%esp)
    14dd:	e8 20 3b 00 00       	call   5002 <read>
    14e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(i == 2000){
    14e5:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
    14ec:	75 4e                	jne    153c <writetest+0x1ca>
    14ee:	eb 1a                	jmp    150a <writetest+0x198>
    printf(stdout, "error: open small failed!\n");
    14f0:	a1 58 75 00 00       	mov    0x7558,%eax
    14f5:	c7 44 24 04 08 58 00 	movl   $0x5808,0x4(%esp)
    14fc:	00 
    14fd:	89 04 24             	mov    %eax,(%esp)
    1500:	e8 75 3c 00 00       	call   517a <printf>
    exit();
    1505:	e8 e0 3a 00 00       	call   4fea <exit>
    printf(stdout, "read succeeded ok\n");
    150a:	a1 58 75 00 00       	mov    0x7558,%eax
    150f:	c7 44 24 04 23 58 00 	movl   $0x5823,0x4(%esp)
    1516:	00 
    1517:	89 04 24             	mov    %eax,(%esp)
    151a:	e8 5b 3c 00 00       	call   517a <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
    151f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1522:	89 04 24             	mov    %eax,(%esp)
    1525:	e8 e8 3a 00 00       	call   5012 <close>

  if(unlink("small") < 0){
    152a:	c7 04 24 45 57 00 00 	movl   $0x5745,(%esp)
    1531:	e8 04 3b 00 00       	call   503a <unlink>
    1536:	85 c0                	test   %eax,%eax
    1538:	79 36                	jns    1570 <writetest+0x1fe>
    153a:	eb 1a                	jmp    1556 <writetest+0x1e4>
    printf(stdout, "read failed\n");
    153c:	a1 58 75 00 00       	mov    0x7558,%eax
    1541:	c7 44 24 04 36 58 00 	movl   $0x5836,0x4(%esp)
    1548:	00 
    1549:	89 04 24             	mov    %eax,(%esp)
    154c:	e8 29 3c 00 00       	call   517a <printf>
    exit();
    1551:	e8 94 3a 00 00       	call   4fea <exit>
    printf(stdout, "unlink small failed\n");
    1556:	a1 58 75 00 00       	mov    0x7558,%eax
    155b:	c7 44 24 04 43 58 00 	movl   $0x5843,0x4(%esp)
    1562:	00 
    1563:	89 04 24             	mov    %eax,(%esp)
    1566:	e8 0f 3c 00 00       	call   517a <printf>
    exit();
    156b:	e8 7a 3a 00 00       	call   4fea <exit>
  }
  printf(stdout, "small file test ok\n");
    1570:	a1 58 75 00 00       	mov    0x7558,%eax
    1575:	c7 44 24 04 58 58 00 	movl   $0x5858,0x4(%esp)
    157c:	00 
    157d:	89 04 24             	mov    %eax,(%esp)
    1580:	e8 f5 3b 00 00       	call   517a <printf>
}
    1585:	c9                   	leave  
    1586:	c3                   	ret    

00001587 <writetest1>:

void
writetest1(void)
{
    1587:	55                   	push   %ebp
    1588:	89 e5                	mov    %esp,%ebp
    158a:	83 ec 28             	sub    $0x28,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
    158d:	a1 58 75 00 00       	mov    0x7558,%eax
    1592:	c7 44 24 04 6c 58 00 	movl   $0x586c,0x4(%esp)
    1599:	00 
    159a:	89 04 24             	mov    %eax,(%esp)
    159d:	e8 d8 3b 00 00       	call   517a <printf>

  fd = open("big", O_CREATE|O_RDWR);
    15a2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    15a9:	00 
    15aa:	c7 04 24 7c 58 00 00 	movl   $0x587c,(%esp)
    15b1:	e8 74 3a 00 00       	call   502a <open>
    15b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    15b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    15bd:	79 1a                	jns    15d9 <writetest1+0x52>
    printf(stdout, "error: creat big failed!\n");
    15bf:	a1 58 75 00 00       	mov    0x7558,%eax
    15c4:	c7 44 24 04 80 58 00 	movl   $0x5880,0x4(%esp)
    15cb:	00 
    15cc:	89 04 24             	mov    %eax,(%esp)
    15cf:	e8 a6 3b 00 00       	call   517a <printf>
    exit();
    15d4:	e8 11 3a 00 00       	call   4fea <exit>
  }

  for(i = 0; i < MAXFILE; i++){
    15d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    15e0:	eb 51                	jmp    1633 <writetest1+0xac>
    ((int*)buf)[0] = i;
    15e2:	b8 40 9d 00 00       	mov    $0x9d40,%eax
    15e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
    15ea:	89 10                	mov    %edx,(%eax)
    if(write(fd, buf, 512) != 512){
    15ec:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    15f3:	00 
    15f4:	c7 44 24 04 40 9d 00 	movl   $0x9d40,0x4(%esp)
    15fb:	00 
    15fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    15ff:	89 04 24             	mov    %eax,(%esp)
    1602:	e8 03 3a 00 00       	call   500a <write>
    1607:	3d 00 02 00 00       	cmp    $0x200,%eax
    160c:	74 21                	je     162f <writetest1+0xa8>
      printf(stdout, "error: write big file failed\n", i);
    160e:	a1 58 75 00 00       	mov    0x7558,%eax
    1613:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1616:	89 54 24 08          	mov    %edx,0x8(%esp)
    161a:	c7 44 24 04 9a 58 00 	movl   $0x589a,0x4(%esp)
    1621:	00 
    1622:	89 04 24             	mov    %eax,(%esp)
    1625:	e8 50 3b 00 00       	call   517a <printf>
      exit();
    162a:	e8 bb 39 00 00       	call   4fea <exit>
  for(i = 0; i < MAXFILE; i++){
    162f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1633:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1636:	3d 8b 00 00 00       	cmp    $0x8b,%eax
    163b:	76 a5                	jbe    15e2 <writetest1+0x5b>
    }
  }

  close(fd);
    163d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1640:	89 04 24             	mov    %eax,(%esp)
    1643:	e8 ca 39 00 00       	call   5012 <close>

  fd = open("big", O_RDONLY);
    1648:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    164f:	00 
    1650:	c7 04 24 7c 58 00 00 	movl   $0x587c,(%esp)
    1657:	e8 ce 39 00 00       	call   502a <open>
    165c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    165f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1663:	79 1a                	jns    167f <writetest1+0xf8>
    printf(stdout, "error: open big failed!\n");
    1665:	a1 58 75 00 00       	mov    0x7558,%eax
    166a:	c7 44 24 04 b8 58 00 	movl   $0x58b8,0x4(%esp)
    1671:	00 
    1672:	89 04 24             	mov    %eax,(%esp)
    1675:	e8 00 3b 00 00       	call   517a <printf>
    exit();
    167a:	e8 6b 39 00 00       	call   4fea <exit>
  }

  n = 0;
    167f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    i = read(fd, buf, 512);
    1686:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    168d:	00 
    168e:	c7 44 24 04 40 9d 00 	movl   $0x9d40,0x4(%esp)
    1695:	00 
    1696:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1699:	89 04 24             	mov    %eax,(%esp)
    169c:	e8 61 39 00 00       	call   5002 <read>
    16a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(i == 0){
    16a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    16a8:	75 4c                	jne    16f6 <writetest1+0x16f>
      if(n == MAXFILE - 1){
    16aa:	81 7d f0 8b 00 00 00 	cmpl   $0x8b,-0x10(%ebp)
    16b1:	75 21                	jne    16d4 <writetest1+0x14d>
        printf(stdout, "read only %d blocks from big", n);
    16b3:	a1 58 75 00 00       	mov    0x7558,%eax
    16b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
    16bb:	89 54 24 08          	mov    %edx,0x8(%esp)
    16bf:	c7 44 24 04 d1 58 00 	movl   $0x58d1,0x4(%esp)
    16c6:	00 
    16c7:	89 04 24             	mov    %eax,(%esp)
    16ca:	e8 ab 3a 00 00       	call   517a <printf>
        exit();
    16cf:	e8 16 39 00 00       	call   4fea <exit>
      }
      break;
    16d4:	90                   	nop
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
  }
  close(fd);
    16d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    16d8:	89 04 24             	mov    %eax,(%esp)
    16db:	e8 32 39 00 00       	call   5012 <close>
  if(unlink("big") < 0){
    16e0:	c7 04 24 7c 58 00 00 	movl   $0x587c,(%esp)
    16e7:	e8 4e 39 00 00       	call   503a <unlink>
    16ec:	85 c0                	test   %eax,%eax
    16ee:	0f 89 87 00 00 00    	jns    177b <writetest1+0x1f4>
    16f4:	eb 6b                	jmp    1761 <writetest1+0x1da>
    } else if(i != 512){
    16f6:	81 7d f4 00 02 00 00 	cmpl   $0x200,-0xc(%ebp)
    16fd:	74 21                	je     1720 <writetest1+0x199>
      printf(stdout, "read failed %d\n", i);
    16ff:	a1 58 75 00 00       	mov    0x7558,%eax
    1704:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1707:	89 54 24 08          	mov    %edx,0x8(%esp)
    170b:	c7 44 24 04 ee 58 00 	movl   $0x58ee,0x4(%esp)
    1712:	00 
    1713:	89 04 24             	mov    %eax,(%esp)
    1716:	e8 5f 3a 00 00       	call   517a <printf>
      exit();
    171b:	e8 ca 38 00 00       	call   4fea <exit>
    if(((int*)buf)[0] != n){
    1720:	b8 40 9d 00 00       	mov    $0x9d40,%eax
    1725:	8b 00                	mov    (%eax),%eax
    1727:	3b 45 f0             	cmp    -0x10(%ebp),%eax
    172a:	74 2c                	je     1758 <writetest1+0x1d1>
             n, ((int*)buf)[0]);
    172c:	b8 40 9d 00 00       	mov    $0x9d40,%eax
      printf(stdout, "read content of block %d is %d\n",
    1731:	8b 10                	mov    (%eax),%edx
    1733:	a1 58 75 00 00       	mov    0x7558,%eax
    1738:	89 54 24 0c          	mov    %edx,0xc(%esp)
    173c:	8b 55 f0             	mov    -0x10(%ebp),%edx
    173f:	89 54 24 08          	mov    %edx,0x8(%esp)
    1743:	c7 44 24 04 00 59 00 	movl   $0x5900,0x4(%esp)
    174a:	00 
    174b:	89 04 24             	mov    %eax,(%esp)
    174e:	e8 27 3a 00 00       	call   517a <printf>
      exit();
    1753:	e8 92 38 00 00       	call   4fea <exit>
    n++;
    1758:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  }
    175c:	e9 25 ff ff ff       	jmp    1686 <writetest1+0xff>
    printf(stdout, "unlink big failed\n");
    1761:	a1 58 75 00 00       	mov    0x7558,%eax
    1766:	c7 44 24 04 20 59 00 	movl   $0x5920,0x4(%esp)
    176d:	00 
    176e:	89 04 24             	mov    %eax,(%esp)
    1771:	e8 04 3a 00 00       	call   517a <printf>
    exit();
    1776:	e8 6f 38 00 00       	call   4fea <exit>
  }
  printf(stdout, "big files ok\n");
    177b:	a1 58 75 00 00       	mov    0x7558,%eax
    1780:	c7 44 24 04 33 59 00 	movl   $0x5933,0x4(%esp)
    1787:	00 
    1788:	89 04 24             	mov    %eax,(%esp)
    178b:	e8 ea 39 00 00       	call   517a <printf>
}
    1790:	c9                   	leave  
    1791:	c3                   	ret    

00001792 <createtest>:

void
createtest(void)
{
    1792:	55                   	push   %ebp
    1793:	89 e5                	mov    %esp,%ebp
    1795:	83 ec 28             	sub    $0x28,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
    1798:	a1 58 75 00 00       	mov    0x7558,%eax
    179d:	c7 44 24 04 44 59 00 	movl   $0x5944,0x4(%esp)
    17a4:	00 
    17a5:	89 04 24             	mov    %eax,(%esp)
    17a8:	e8 cd 39 00 00       	call   517a <printf>

  name[0] = 'a';
    17ad:	c6 05 40 bd 00 00 61 	movb   $0x61,0xbd40
  name[2] = '\0';
    17b4:	c6 05 42 bd 00 00 00 	movb   $0x0,0xbd42
  for(i = 0; i < 52; i++){
    17bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    17c2:	eb 31                	jmp    17f5 <createtest+0x63>
    name[1] = '0' + i;
    17c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c7:	83 c0 30             	add    $0x30,%eax
    17ca:	a2 41 bd 00 00       	mov    %al,0xbd41
    fd = open(name, O_CREATE|O_RDWR);
    17cf:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    17d6:	00 
    17d7:	c7 04 24 40 bd 00 00 	movl   $0xbd40,(%esp)
    17de:	e8 47 38 00 00       	call   502a <open>
    17e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(fd);
    17e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17e9:	89 04 24             	mov    %eax,(%esp)
    17ec:	e8 21 38 00 00       	call   5012 <close>
  for(i = 0; i < 52; i++){
    17f1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    17f5:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
    17f9:	7e c9                	jle    17c4 <createtest+0x32>
  }
  name[0] = 'a';
    17fb:	c6 05 40 bd 00 00 61 	movb   $0x61,0xbd40
  name[2] = '\0';
    1802:	c6 05 42 bd 00 00 00 	movb   $0x0,0xbd42
  for(i = 0; i < 52; i++){
    1809:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1810:	eb 1b                	jmp    182d <createtest+0x9b>
    name[1] = '0' + i;
    1812:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1815:	83 c0 30             	add    $0x30,%eax
    1818:	a2 41 bd 00 00       	mov    %al,0xbd41
    unlink(name);
    181d:	c7 04 24 40 bd 00 00 	movl   $0xbd40,(%esp)
    1824:	e8 11 38 00 00       	call   503a <unlink>
  for(i = 0; i < 52; i++){
    1829:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    182d:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
    1831:	7e df                	jle    1812 <createtest+0x80>
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
    1833:	a1 58 75 00 00       	mov    0x7558,%eax
    1838:	c7 44 24 04 6c 59 00 	movl   $0x596c,0x4(%esp)
    183f:	00 
    1840:	89 04 24             	mov    %eax,(%esp)
    1843:	e8 32 39 00 00       	call   517a <printf>
}
    1848:	c9                   	leave  
    1849:	c3                   	ret    

0000184a <dirtest>:

void dirtest(void)
{
    184a:	55                   	push   %ebp
    184b:	89 e5                	mov    %esp,%ebp
    184d:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "mkdir test\n");
    1850:	a1 58 75 00 00       	mov    0x7558,%eax
    1855:	c7 44 24 04 92 59 00 	movl   $0x5992,0x4(%esp)
    185c:	00 
    185d:	89 04 24             	mov    %eax,(%esp)
    1860:	e8 15 39 00 00       	call   517a <printf>

  if(mkdir("dir0") < 0){
    1865:	c7 04 24 9e 59 00 00 	movl   $0x599e,(%esp)
    186c:	e8 e1 37 00 00       	call   5052 <mkdir>
    1871:	85 c0                	test   %eax,%eax
    1873:	79 1a                	jns    188f <dirtest+0x45>
    printf(stdout, "mkdir failed\n");
    1875:	a1 58 75 00 00       	mov    0x7558,%eax
    187a:	c7 44 24 04 c1 55 00 	movl   $0x55c1,0x4(%esp)
    1881:	00 
    1882:	89 04 24             	mov    %eax,(%esp)
    1885:	e8 f0 38 00 00       	call   517a <printf>
    exit();
    188a:	e8 5b 37 00 00       	call   4fea <exit>
  }

  if(chdir("dir0") < 0){
    188f:	c7 04 24 9e 59 00 00 	movl   $0x599e,(%esp)
    1896:	e8 bf 37 00 00       	call   505a <chdir>
    189b:	85 c0                	test   %eax,%eax
    189d:	79 1a                	jns    18b9 <dirtest+0x6f>
    printf(stdout, "chdir dir0 failed\n");
    189f:	a1 58 75 00 00       	mov    0x7558,%eax
    18a4:	c7 44 24 04 a3 59 00 	movl   $0x59a3,0x4(%esp)
    18ab:	00 
    18ac:	89 04 24             	mov    %eax,(%esp)
    18af:	e8 c6 38 00 00       	call   517a <printf>
    exit();
    18b4:	e8 31 37 00 00       	call   4fea <exit>
  }

  if(chdir("..") < 0){
    18b9:	c7 04 24 b6 59 00 00 	movl   $0x59b6,(%esp)
    18c0:	e8 95 37 00 00       	call   505a <chdir>
    18c5:	85 c0                	test   %eax,%eax
    18c7:	79 1a                	jns    18e3 <dirtest+0x99>
    printf(stdout, "chdir .. failed\n");
    18c9:	a1 58 75 00 00       	mov    0x7558,%eax
    18ce:	c7 44 24 04 b9 59 00 	movl   $0x59b9,0x4(%esp)
    18d5:	00 
    18d6:	89 04 24             	mov    %eax,(%esp)
    18d9:	e8 9c 38 00 00       	call   517a <printf>
    exit();
    18de:	e8 07 37 00 00       	call   4fea <exit>
  }

  if(unlink("dir0") < 0){
    18e3:	c7 04 24 9e 59 00 00 	movl   $0x599e,(%esp)
    18ea:	e8 4b 37 00 00       	call   503a <unlink>
    18ef:	85 c0                	test   %eax,%eax
    18f1:	79 1a                	jns    190d <dirtest+0xc3>
    printf(stdout, "unlink dir0 failed\n");
    18f3:	a1 58 75 00 00       	mov    0x7558,%eax
    18f8:	c7 44 24 04 ca 59 00 	movl   $0x59ca,0x4(%esp)
    18ff:	00 
    1900:	89 04 24             	mov    %eax,(%esp)
    1903:	e8 72 38 00 00       	call   517a <printf>
    exit();
    1908:	e8 dd 36 00 00       	call   4fea <exit>
  }
  printf(stdout, "mkdir test ok\n");
    190d:	a1 58 75 00 00       	mov    0x7558,%eax
    1912:	c7 44 24 04 de 59 00 	movl   $0x59de,0x4(%esp)
    1919:	00 
    191a:	89 04 24             	mov    %eax,(%esp)
    191d:	e8 58 38 00 00       	call   517a <printf>
}
    1922:	c9                   	leave  
    1923:	c3                   	ret    

00001924 <exectest>:

void
exectest(void)
{
    1924:	55                   	push   %ebp
    1925:	89 e5                	mov    %esp,%ebp
    1927:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "exec test\n");
    192a:	a1 58 75 00 00       	mov    0x7558,%eax
    192f:	c7 44 24 04 ed 59 00 	movl   $0x59ed,0x4(%esp)
    1936:	00 
    1937:	89 04 24             	mov    %eax,(%esp)
    193a:	e8 3b 38 00 00       	call   517a <printf>
  if(exec("echo", echoargv) < 0){
    193f:	c7 44 24 04 44 75 00 	movl   $0x7544,0x4(%esp)
    1946:	00 
    1947:	c7 04 24 98 55 00 00 	movl   $0x5598,(%esp)
    194e:	e8 cf 36 00 00       	call   5022 <exec>
    1953:	85 c0                	test   %eax,%eax
    1955:	79 1a                	jns    1971 <exectest+0x4d>
    printf(stdout, "exec echo failed\n");
    1957:	a1 58 75 00 00       	mov    0x7558,%eax
    195c:	c7 44 24 04 f8 59 00 	movl   $0x59f8,0x4(%esp)
    1963:	00 
    1964:	89 04 24             	mov    %eax,(%esp)
    1967:	e8 0e 38 00 00       	call   517a <printf>
    exit();
    196c:	e8 79 36 00 00       	call   4fea <exit>
  }
}
    1971:	c9                   	leave  
    1972:	c3                   	ret    

00001973 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
    1973:	55                   	push   %ebp
    1974:	89 e5                	mov    %esp,%ebp
    1976:	83 ec 38             	sub    $0x38,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
    1979:	8d 45 d8             	lea    -0x28(%ebp),%eax
    197c:	89 04 24             	mov    %eax,(%esp)
    197f:	e8 76 36 00 00       	call   4ffa <pipe>
    1984:	85 c0                	test   %eax,%eax
    1986:	74 19                	je     19a1 <pipe1+0x2e>
    printf(1, "pipe() failed\n");
    1988:	c7 44 24 04 0a 5a 00 	movl   $0x5a0a,0x4(%esp)
    198f:	00 
    1990:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1997:	e8 de 37 00 00       	call   517a <printf>
    exit();
    199c:	e8 49 36 00 00       	call   4fea <exit>
  }
  pid = fork();
    19a1:	e8 3c 36 00 00       	call   4fe2 <fork>
    19a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  seq = 0;
    19a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(pid == 0){
    19b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    19b4:	0f 85 88 00 00 00    	jne    1a42 <pipe1+0xcf>
    close(fds[0]);
    19ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
    19bd:	89 04 24             	mov    %eax,(%esp)
    19c0:	e8 4d 36 00 00       	call   5012 <close>
    for(n = 0; n < 5; n++){
    19c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    19cc:	eb 69                	jmp    1a37 <pipe1+0xc4>
      for(i = 0; i < 1033; i++)
    19ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    19d5:	eb 18                	jmp    19ef <pipe1+0x7c>
        buf[i] = seq++;
    19d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19da:	8d 50 01             	lea    0x1(%eax),%edx
    19dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
    19e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
    19e3:	81 c2 40 9d 00 00    	add    $0x9d40,%edx
    19e9:	88 02                	mov    %al,(%edx)
      for(i = 0; i < 1033; i++)
    19eb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    19ef:	81 7d f0 08 04 00 00 	cmpl   $0x408,-0x10(%ebp)
    19f6:	7e df                	jle    19d7 <pipe1+0x64>
      if(write(fds[1], buf, 1033) != 1033){
    19f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
    19fb:	c7 44 24 08 09 04 00 	movl   $0x409,0x8(%esp)
    1a02:	00 
    1a03:	c7 44 24 04 40 9d 00 	movl   $0x9d40,0x4(%esp)
    1a0a:	00 
    1a0b:	89 04 24             	mov    %eax,(%esp)
    1a0e:	e8 f7 35 00 00       	call   500a <write>
    1a13:	3d 09 04 00 00       	cmp    $0x409,%eax
    1a18:	74 19                	je     1a33 <pipe1+0xc0>
        printf(1, "pipe1 oops 1\n");
    1a1a:	c7 44 24 04 19 5a 00 	movl   $0x5a19,0x4(%esp)
    1a21:	00 
    1a22:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a29:	e8 4c 37 00 00       	call   517a <printf>
        exit();
    1a2e:	e8 b7 35 00 00       	call   4fea <exit>
    for(n = 0; n < 5; n++){
    1a33:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    1a37:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
    1a3b:	7e 91                	jle    19ce <pipe1+0x5b>
      }
    }
    exit();
    1a3d:	e8 a8 35 00 00       	call   4fea <exit>
  } else if(pid > 0){
    1a42:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    1a46:	0f 8e f9 00 00 00    	jle    1b45 <pipe1+0x1d2>
    close(fds[1]);
    1a4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1a4f:	89 04 24             	mov    %eax,(%esp)
    1a52:	e8 bb 35 00 00       	call   5012 <close>
    total = 0;
    1a57:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cc = 1;
    1a5e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
    1a65:	eb 68                	jmp    1acf <pipe1+0x15c>
      for(i = 0; i < n; i++){
    1a67:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1a6e:	eb 3d                	jmp    1aad <pipe1+0x13a>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a73:	05 40 9d 00 00       	add    $0x9d40,%eax
    1a78:	0f b6 00             	movzbl (%eax),%eax
    1a7b:	0f be c8             	movsbl %al,%ecx
    1a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a81:	8d 50 01             	lea    0x1(%eax),%edx
    1a84:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1a87:	31 c8                	xor    %ecx,%eax
    1a89:	0f b6 c0             	movzbl %al,%eax
    1a8c:	85 c0                	test   %eax,%eax
    1a8e:	74 19                	je     1aa9 <pipe1+0x136>
          printf(1, "pipe1 oops 2\n");
    1a90:	c7 44 24 04 27 5a 00 	movl   $0x5a27,0x4(%esp)
    1a97:	00 
    1a98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a9f:	e8 d6 36 00 00       	call   517a <printf>
    1aa4:	e9 b5 00 00 00       	jmp    1b5e <pipe1+0x1eb>
      for(i = 0; i < n; i++){
    1aa9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ab0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1ab3:	7c bb                	jl     1a70 <pipe1+0xfd>
          return;
        }
      }
      total += n;
    1ab5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1ab8:	01 45 e4             	add    %eax,-0x1c(%ebp)
      cc = cc * 2;
    1abb:	d1 65 e8             	shll   -0x18(%ebp)
      if(cc > sizeof(buf))
    1abe:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1ac1:	3d 00 20 00 00       	cmp    $0x2000,%eax
    1ac6:	76 07                	jbe    1acf <pipe1+0x15c>
        cc = sizeof(buf);
    1ac8:	c7 45 e8 00 20 00 00 	movl   $0x2000,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
    1acf:	8b 45 d8             	mov    -0x28(%ebp),%eax
    1ad2:	8b 55 e8             	mov    -0x18(%ebp),%edx
    1ad5:	89 54 24 08          	mov    %edx,0x8(%esp)
    1ad9:	c7 44 24 04 40 9d 00 	movl   $0x9d40,0x4(%esp)
    1ae0:	00 
    1ae1:	89 04 24             	mov    %eax,(%esp)
    1ae4:	e8 19 35 00 00       	call   5002 <read>
    1ae9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1aec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1af0:	0f 8f 71 ff ff ff    	jg     1a67 <pipe1+0xf4>
    }
    if(total != 5 * 1033){
    1af6:	81 7d e4 2d 14 00 00 	cmpl   $0x142d,-0x1c(%ebp)
    1afd:	74 20                	je     1b1f <pipe1+0x1ac>
      printf(1, "pipe1 oops 3 total %d\n", total);
    1aff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1b02:	89 44 24 08          	mov    %eax,0x8(%esp)
    1b06:	c7 44 24 04 35 5a 00 	movl   $0x5a35,0x4(%esp)
    1b0d:	00 
    1b0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b15:	e8 60 36 00 00       	call   517a <printf>
      exit();
    1b1a:	e8 cb 34 00 00       	call   4fea <exit>
    }
    close(fds[0]);
    1b1f:	8b 45 d8             	mov    -0x28(%ebp),%eax
    1b22:	89 04 24             	mov    %eax,(%esp)
    1b25:	e8 e8 34 00 00       	call   5012 <close>
    wait();
    1b2a:	e8 c3 34 00 00       	call   4ff2 <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
    1b2f:	c7 44 24 04 5b 5a 00 	movl   $0x5a5b,0x4(%esp)
    1b36:	00 
    1b37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b3e:	e8 37 36 00 00       	call   517a <printf>
    1b43:	eb 19                	jmp    1b5e <pipe1+0x1eb>
    printf(1, "fork() failed\n");
    1b45:	c7 44 24 04 4c 5a 00 	movl   $0x5a4c,0x4(%esp)
    1b4c:	00 
    1b4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b54:	e8 21 36 00 00       	call   517a <printf>
    exit();
    1b59:	e8 8c 34 00 00       	call   4fea <exit>
}
    1b5e:	c9                   	leave  
    1b5f:	c3                   	ret    

00001b60 <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
    1b60:	55                   	push   %ebp
    1b61:	89 e5                	mov    %esp,%ebp
    1b63:	83 ec 38             	sub    $0x38,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
    1b66:	c7 44 24 04 65 5a 00 	movl   $0x5a65,0x4(%esp)
    1b6d:	00 
    1b6e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b75:	e8 00 36 00 00       	call   517a <printf>
  pid1 = fork();
    1b7a:	e8 63 34 00 00       	call   4fe2 <fork>
    1b7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid1 == 0)
    1b82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1b86:	75 02                	jne    1b8a <preempt+0x2a>
    for(;;)
      ;
    1b88:	eb fe                	jmp    1b88 <preempt+0x28>

  pid2 = fork();
    1b8a:	e8 53 34 00 00       	call   4fe2 <fork>
    1b8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid2 == 0)
    1b92:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1b96:	75 02                	jne    1b9a <preempt+0x3a>
    for(;;)
      ;
    1b98:	eb fe                	jmp    1b98 <preempt+0x38>

  pipe(pfds);
    1b9a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    1b9d:	89 04 24             	mov    %eax,(%esp)
    1ba0:	e8 55 34 00 00       	call   4ffa <pipe>
  pid3 = fork();
    1ba5:	e8 38 34 00 00       	call   4fe2 <fork>
    1baa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid3 == 0){
    1bad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1bb1:	75 4c                	jne    1bff <preempt+0x9f>
    close(pfds[0]);
    1bb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1bb6:	89 04 24             	mov    %eax,(%esp)
    1bb9:	e8 54 34 00 00       	call   5012 <close>
    if(write(pfds[1], "x", 1) != 1)
    1bbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1bc1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1bc8:	00 
    1bc9:	c7 44 24 04 6f 5a 00 	movl   $0x5a6f,0x4(%esp)
    1bd0:	00 
    1bd1:	89 04 24             	mov    %eax,(%esp)
    1bd4:	e8 31 34 00 00       	call   500a <write>
    1bd9:	83 f8 01             	cmp    $0x1,%eax
    1bdc:	74 14                	je     1bf2 <preempt+0x92>
      printf(1, "preempt write error");
    1bde:	c7 44 24 04 71 5a 00 	movl   $0x5a71,0x4(%esp)
    1be5:	00 
    1be6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1bed:	e8 88 35 00 00       	call   517a <printf>
    close(pfds[1]);
    1bf2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1bf5:	89 04 24             	mov    %eax,(%esp)
    1bf8:	e8 15 34 00 00       	call   5012 <close>
    for(;;)
      ;
    1bfd:	eb fe                	jmp    1bfd <preempt+0x9d>
  }

  close(pfds[1]);
    1bff:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1c02:	89 04 24             	mov    %eax,(%esp)
    1c05:	e8 08 34 00 00       	call   5012 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    1c0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1c0d:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1c14:	00 
    1c15:	c7 44 24 04 40 9d 00 	movl   $0x9d40,0x4(%esp)
    1c1c:	00 
    1c1d:	89 04 24             	mov    %eax,(%esp)
    1c20:	e8 dd 33 00 00       	call   5002 <read>
    1c25:	83 f8 01             	cmp    $0x1,%eax
    1c28:	74 16                	je     1c40 <preempt+0xe0>
    printf(1, "preempt read error");
    1c2a:	c7 44 24 04 85 5a 00 	movl   $0x5a85,0x4(%esp)
    1c31:	00 
    1c32:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c39:	e8 3c 35 00 00       	call   517a <printf>
    1c3e:	eb 77                	jmp    1cb7 <preempt+0x157>
    return;
  }
  close(pfds[0]);
    1c40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1c43:	89 04 24             	mov    %eax,(%esp)
    1c46:	e8 c7 33 00 00       	call   5012 <close>
  printf(1, "kill... ");
    1c4b:	c7 44 24 04 98 5a 00 	movl   $0x5a98,0x4(%esp)
    1c52:	00 
    1c53:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c5a:	e8 1b 35 00 00       	call   517a <printf>
  kill(pid1);
    1c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c62:	89 04 24             	mov    %eax,(%esp)
    1c65:	e8 b0 33 00 00       	call   501a <kill>
  kill(pid2);
    1c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c6d:	89 04 24             	mov    %eax,(%esp)
    1c70:	e8 a5 33 00 00       	call   501a <kill>
  kill(pid3);
    1c75:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1c78:	89 04 24             	mov    %eax,(%esp)
    1c7b:	e8 9a 33 00 00       	call   501a <kill>
  printf(1, "wait... ");
    1c80:	c7 44 24 04 a1 5a 00 	movl   $0x5aa1,0x4(%esp)
    1c87:	00 
    1c88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c8f:	e8 e6 34 00 00       	call   517a <printf>
  wait();
    1c94:	e8 59 33 00 00       	call   4ff2 <wait>
  wait();
    1c99:	e8 54 33 00 00       	call   4ff2 <wait>
  wait();
    1c9e:	e8 4f 33 00 00       	call   4ff2 <wait>
  printf(1, "preempt ok\n");
    1ca3:	c7 44 24 04 aa 5a 00 	movl   $0x5aaa,0x4(%esp)
    1caa:	00 
    1cab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cb2:	e8 c3 34 00 00       	call   517a <printf>
}
    1cb7:	c9                   	leave  
    1cb8:	c3                   	ret    

00001cb9 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
    1cb9:	55                   	push   %ebp
    1cba:	89 e5                	mov    %esp,%ebp
    1cbc:	83 ec 28             	sub    $0x28,%esp
  int i, pid;

  for(i = 0; i < 100; i++){
    1cbf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1cc6:	eb 53                	jmp    1d1b <exitwait+0x62>
    pid = fork();
    1cc8:	e8 15 33 00 00       	call   4fe2 <fork>
    1ccd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0){
    1cd0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1cd4:	79 16                	jns    1cec <exitwait+0x33>
      printf(1, "fork failed\n");
    1cd6:	c7 44 24 04 39 56 00 	movl   $0x5639,0x4(%esp)
    1cdd:	00 
    1cde:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ce5:	e8 90 34 00 00       	call   517a <printf>
      return;
    1cea:	eb 49                	jmp    1d35 <exitwait+0x7c>
    }
    if(pid){
    1cec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1cf0:	74 20                	je     1d12 <exitwait+0x59>
      if(wait() != pid){
    1cf2:	e8 fb 32 00 00       	call   4ff2 <wait>
    1cf7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
    1cfa:	74 1b                	je     1d17 <exitwait+0x5e>
        printf(1, "wait wrong pid\n");
    1cfc:	c7 44 24 04 b6 5a 00 	movl   $0x5ab6,0x4(%esp)
    1d03:	00 
    1d04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d0b:	e8 6a 34 00 00       	call   517a <printf>
        return;
    1d10:	eb 23                	jmp    1d35 <exitwait+0x7c>
      }
    } else {
      exit();
    1d12:	e8 d3 32 00 00       	call   4fea <exit>
  for(i = 0; i < 100; i++){
    1d17:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1d1b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    1d1f:	7e a7                	jle    1cc8 <exitwait+0xf>
    }
  }
  printf(1, "exitwait ok\n");
    1d21:	c7 44 24 04 c6 5a 00 	movl   $0x5ac6,0x4(%esp)
    1d28:	00 
    1d29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d30:	e8 45 34 00 00       	call   517a <printf>
}
    1d35:	c9                   	leave  
    1d36:	c3                   	ret    

00001d37 <mem>:

void
mem(void)
{
    1d37:	55                   	push   %ebp
    1d38:	89 e5                	mov    %esp,%ebp
    1d3a:	83 ec 28             	sub    $0x28,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
    1d3d:	c7 44 24 04 d3 5a 00 	movl   $0x5ad3,0x4(%esp)
    1d44:	00 
    1d45:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d4c:	e8 29 34 00 00       	call   517a <printf>
  ppid = getpid();
    1d51:	e8 14 33 00 00       	call   506a <getpid>
    1d56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((pid = fork()) == 0){
    1d59:	e8 84 32 00 00       	call   4fe2 <fork>
    1d5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1d61:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d65:	0f 85 aa 00 00 00    	jne    1e15 <mem+0xde>
    m1 = 0;
    1d6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
    1d72:	eb 0e                	jmp    1d82 <mem+0x4b>
      *(char**)m2 = m1;
    1d74:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1d77:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1d7a:	89 10                	mov    %edx,(%eax)
      m1 = m2;
    1d7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
    1d82:	c7 04 24 11 27 00 00 	movl   $0x2711,(%esp)
    1d89:	e8 d8 36 00 00       	call   5466 <malloc>
    1d8e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    1d91:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1d95:	75 dd                	jne    1d74 <mem+0x3d>
    }
    while(m1){
    1d97:	eb 19                	jmp    1db2 <mem+0x7b>
      m2 = *(char**)m1;
    1d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d9c:	8b 00                	mov    (%eax),%eax
    1d9e:	89 45 e8             	mov    %eax,-0x18(%ebp)
      free(m1);
    1da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1da4:	89 04 24             	mov    %eax,(%esp)
    1da7:	e8 81 35 00 00       	call   532d <free>
      m1 = m2;
    1dac:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1daf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while(m1){
    1db2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1db6:	75 e1                	jne    1d99 <mem+0x62>
    }
    m1 = malloc(1024*20);
    1db8:	c7 04 24 00 50 00 00 	movl   $0x5000,(%esp)
    1dbf:	e8 a2 36 00 00       	call   5466 <malloc>
    1dc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(m1 == 0){
    1dc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1dcb:	75 24                	jne    1df1 <mem+0xba>
      printf(1, "couldn't allocate mem?!!\n");
    1dcd:	c7 44 24 04 dd 5a 00 	movl   $0x5add,0x4(%esp)
    1dd4:	00 
    1dd5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ddc:	e8 99 33 00 00       	call   517a <printf>
      kill(ppid);
    1de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1de4:	89 04 24             	mov    %eax,(%esp)
    1de7:	e8 2e 32 00 00       	call   501a <kill>
      exit();
    1dec:	e8 f9 31 00 00       	call   4fea <exit>
    }
    free(m1);
    1df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1df4:	89 04 24             	mov    %eax,(%esp)
    1df7:	e8 31 35 00 00       	call   532d <free>
    printf(1, "mem ok\n");
    1dfc:	c7 44 24 04 f7 5a 00 	movl   $0x5af7,0x4(%esp)
    1e03:	00 
    1e04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e0b:	e8 6a 33 00 00       	call   517a <printf>
    exit();
    1e10:	e8 d5 31 00 00       	call   4fea <exit>
  } else {
    wait();
    1e15:	e8 d8 31 00 00       	call   4ff2 <wait>
  }
}
    1e1a:	c9                   	leave  
    1e1b:	c3                   	ret    

00001e1c <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
    1e1c:	55                   	push   %ebp
    1e1d:	89 e5                	mov    %esp,%ebp
    1e1f:	83 ec 48             	sub    $0x48,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
    1e22:	c7 44 24 04 ff 5a 00 	movl   $0x5aff,0x4(%esp)
    1e29:	00 
    1e2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e31:	e8 44 33 00 00       	call   517a <printf>

  unlink("sharedfd");
    1e36:	c7 04 24 0e 5b 00 00 	movl   $0x5b0e,(%esp)
    1e3d:	e8 f8 31 00 00       	call   503a <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    1e42:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1e49:	00 
    1e4a:	c7 04 24 0e 5b 00 00 	movl   $0x5b0e,(%esp)
    1e51:	e8 d4 31 00 00       	call   502a <open>
    1e56:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
    1e59:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1e5d:	79 19                	jns    1e78 <sharedfd+0x5c>
    printf(1, "fstests: cannot open sharedfd for writing");
    1e5f:	c7 44 24 04 18 5b 00 	movl   $0x5b18,0x4(%esp)
    1e66:	00 
    1e67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e6e:	e8 07 33 00 00       	call   517a <printf>
    return;
    1e73:	e9 a0 01 00 00       	jmp    2018 <sharedfd+0x1fc>
  }
  pid = fork();
    1e78:	e8 65 31 00 00       	call   4fe2 <fork>
    1e7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
    1e80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    1e84:	75 07                	jne    1e8d <sharedfd+0x71>
    1e86:	b8 63 00 00 00       	mov    $0x63,%eax
    1e8b:	eb 05                	jmp    1e92 <sharedfd+0x76>
    1e8d:	b8 70 00 00 00       	mov    $0x70,%eax
    1e92:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1e99:	00 
    1e9a:	89 44 24 04          	mov    %eax,0x4(%esp)
    1e9e:	8d 45 d6             	lea    -0x2a(%ebp),%eax
    1ea1:	89 04 24             	mov    %eax,(%esp)
    1ea4:	e8 94 2f 00 00       	call   4e3d <memset>
  for(i = 0; i < 1000; i++){
    1ea9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1eb0:	eb 39                	jmp    1eeb <sharedfd+0xcf>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    1eb2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1eb9:	00 
    1eba:	8d 45 d6             	lea    -0x2a(%ebp),%eax
    1ebd:	89 44 24 04          	mov    %eax,0x4(%esp)
    1ec1:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1ec4:	89 04 24             	mov    %eax,(%esp)
    1ec7:	e8 3e 31 00 00       	call   500a <write>
    1ecc:	83 f8 0a             	cmp    $0xa,%eax
    1ecf:	74 16                	je     1ee7 <sharedfd+0xcb>
      printf(1, "fstests: write sharedfd failed\n");
    1ed1:	c7 44 24 04 44 5b 00 	movl   $0x5b44,0x4(%esp)
    1ed8:	00 
    1ed9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ee0:	e8 95 32 00 00       	call   517a <printf>
      break;
    1ee5:	eb 0d                	jmp    1ef4 <sharedfd+0xd8>
  for(i = 0; i < 1000; i++){
    1ee7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1eeb:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    1ef2:	7e be                	jle    1eb2 <sharedfd+0x96>
    }
  }
  if(pid == 0)
    1ef4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    1ef8:	75 05                	jne    1eff <sharedfd+0xe3>
    exit();
    1efa:	e8 eb 30 00 00       	call   4fea <exit>
  else
    wait();
    1eff:	e8 ee 30 00 00       	call   4ff2 <wait>
  close(fd);
    1f04:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1f07:	89 04 24             	mov    %eax,(%esp)
    1f0a:	e8 03 31 00 00       	call   5012 <close>
  fd = open("sharedfd", 0);
    1f0f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1f16:	00 
    1f17:	c7 04 24 0e 5b 00 00 	movl   $0x5b0e,(%esp)
    1f1e:	e8 07 31 00 00       	call   502a <open>
    1f23:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
    1f26:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1f2a:	79 19                	jns    1f45 <sharedfd+0x129>
    printf(1, "fstests: cannot open sharedfd for reading\n");
    1f2c:	c7 44 24 04 64 5b 00 	movl   $0x5b64,0x4(%esp)
    1f33:	00 
    1f34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f3b:	e8 3a 32 00 00       	call   517a <printf>
    return;
    1f40:	e9 d3 00 00 00       	jmp    2018 <sharedfd+0x1fc>
  }
  nc = np = 0;
    1f45:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    1f4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1f4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1f52:	eb 3b                	jmp    1f8f <sharedfd+0x173>
    for(i = 0; i < sizeof(buf); i++){
    1f54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1f5b:	eb 2a                	jmp    1f87 <sharedfd+0x16b>
      if(buf[i] == 'c')
    1f5d:	8d 55 d6             	lea    -0x2a(%ebp),%edx
    1f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f63:	01 d0                	add    %edx,%eax
    1f65:	0f b6 00             	movzbl (%eax),%eax
    1f68:	3c 63                	cmp    $0x63,%al
    1f6a:	75 04                	jne    1f70 <sharedfd+0x154>
        nc++;
    1f6c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(buf[i] == 'p')
    1f70:	8d 55 d6             	lea    -0x2a(%ebp),%edx
    1f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f76:	01 d0                	add    %edx,%eax
    1f78:	0f b6 00             	movzbl (%eax),%eax
    1f7b:	3c 70                	cmp    $0x70,%al
    1f7d:	75 04                	jne    1f83 <sharedfd+0x167>
        np++;
    1f7f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
    for(i = 0; i < sizeof(buf); i++){
    1f83:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1f8a:	83 f8 09             	cmp    $0x9,%eax
    1f8d:	76 ce                	jbe    1f5d <sharedfd+0x141>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1f8f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1f96:	00 
    1f97:	8d 45 d6             	lea    -0x2a(%ebp),%eax
    1f9a:	89 44 24 04          	mov    %eax,0x4(%esp)
    1f9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1fa1:	89 04 24             	mov    %eax,(%esp)
    1fa4:	e8 59 30 00 00       	call   5002 <read>
    1fa9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    1fac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    1fb0:	7f a2                	jg     1f54 <sharedfd+0x138>
    }
  }
  close(fd);
    1fb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1fb5:	89 04 24             	mov    %eax,(%esp)
    1fb8:	e8 55 30 00 00       	call   5012 <close>
  unlink("sharedfd");
    1fbd:	c7 04 24 0e 5b 00 00 	movl   $0x5b0e,(%esp)
    1fc4:	e8 71 30 00 00       	call   503a <unlink>
  if(nc == 10000 && np == 10000){
    1fc9:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
    1fd0:	75 1f                	jne    1ff1 <sharedfd+0x1d5>
    1fd2:	81 7d ec 10 27 00 00 	cmpl   $0x2710,-0x14(%ebp)
    1fd9:	75 16                	jne    1ff1 <sharedfd+0x1d5>
    printf(1, "sharedfd ok\n");
    1fdb:	c7 44 24 04 8f 5b 00 	movl   $0x5b8f,0x4(%esp)
    1fe2:	00 
    1fe3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fea:	e8 8b 31 00 00       	call   517a <printf>
    1fef:	eb 27                	jmp    2018 <sharedfd+0x1fc>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    1ff1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1ff4:	89 44 24 0c          	mov    %eax,0xc(%esp)
    1ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ffb:	89 44 24 08          	mov    %eax,0x8(%esp)
    1fff:	c7 44 24 04 9c 5b 00 	movl   $0x5b9c,0x4(%esp)
    2006:	00 
    2007:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    200e:	e8 67 31 00 00       	call   517a <printf>
    exit();
    2013:	e8 d2 2f 00 00       	call   4fea <exit>
  }
}
    2018:	c9                   	leave  
    2019:	c3                   	ret    

0000201a <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    201a:	55                   	push   %ebp
    201b:	89 e5                	mov    %esp,%ebp
    201d:	83 ec 48             	sub    $0x48,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    2020:	c7 45 c8 b1 5b 00 00 	movl   $0x5bb1,-0x38(%ebp)
    2027:	c7 45 cc b4 5b 00 00 	movl   $0x5bb4,-0x34(%ebp)
    202e:	c7 45 d0 b7 5b 00 00 	movl   $0x5bb7,-0x30(%ebp)
    2035:	c7 45 d4 ba 5b 00 00 	movl   $0x5bba,-0x2c(%ebp)
  char *fname;

  printf(1, "fourfiles test\n");
    203c:	c7 44 24 04 bd 5b 00 	movl   $0x5bbd,0x4(%esp)
    2043:	00 
    2044:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    204b:	e8 2a 31 00 00       	call   517a <printf>

  for(pi = 0; pi < 4; pi++){
    2050:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    2057:	e9 fc 00 00 00       	jmp    2158 <fourfiles+0x13e>
    fname = names[pi];
    205c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    205f:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    2063:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    unlink(fname);
    2066:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    2069:	89 04 24             	mov    %eax,(%esp)
    206c:	e8 c9 2f 00 00       	call   503a <unlink>

    pid = fork();
    2071:	e8 6c 2f 00 00       	call   4fe2 <fork>
    2076:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if(pid < 0){
    2079:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    207d:	79 19                	jns    2098 <fourfiles+0x7e>
      printf(1, "fork failed\n");
    207f:	c7 44 24 04 39 56 00 	movl   $0x5639,0x4(%esp)
    2086:	00 
    2087:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    208e:	e8 e7 30 00 00       	call   517a <printf>
      exit();
    2093:	e8 52 2f 00 00       	call   4fea <exit>
    }

    if(pid == 0){
    2098:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    209c:	0f 85 b2 00 00 00    	jne    2154 <fourfiles+0x13a>
      fd = open(fname, O_CREATE | O_RDWR);
    20a2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    20a9:	00 
    20aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    20ad:	89 04 24             	mov    %eax,(%esp)
    20b0:	e8 75 2f 00 00       	call   502a <open>
    20b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
      if(fd < 0){
    20b8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
    20bc:	79 19                	jns    20d7 <fourfiles+0xbd>
        printf(1, "create failed\n");
    20be:	c7 44 24 04 cd 5b 00 	movl   $0x5bcd,0x4(%esp)
    20c5:	00 
    20c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20cd:	e8 a8 30 00 00       	call   517a <printf>
        exit();
    20d2:	e8 13 2f 00 00       	call   4fea <exit>
      }

      memset(buf, '0'+pi, 512);
    20d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
    20da:	83 c0 30             	add    $0x30,%eax
    20dd:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    20e4:	00 
    20e5:	89 44 24 04          	mov    %eax,0x4(%esp)
    20e9:	c7 04 24 40 9d 00 00 	movl   $0x9d40,(%esp)
    20f0:	e8 48 2d 00 00       	call   4e3d <memset>
      for(i = 0; i < 12; i++){
    20f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    20fc:	eb 4b                	jmp    2149 <fourfiles+0x12f>
        if((n = write(fd, buf, 500)) != 500){
    20fe:	c7 44 24 08 f4 01 00 	movl   $0x1f4,0x8(%esp)
    2105:	00 
    2106:	c7 44 24 04 40 9d 00 	movl   $0x9d40,0x4(%esp)
    210d:	00 
    210e:	8b 45 dc             	mov    -0x24(%ebp),%eax
    2111:	89 04 24             	mov    %eax,(%esp)
    2114:	e8 f1 2e 00 00       	call   500a <write>
    2119:	89 45 d8             	mov    %eax,-0x28(%ebp)
    211c:	81 7d d8 f4 01 00 00 	cmpl   $0x1f4,-0x28(%ebp)
    2123:	74 20                	je     2145 <fourfiles+0x12b>
          printf(1, "write failed %d\n", n);
    2125:	8b 45 d8             	mov    -0x28(%ebp),%eax
    2128:	89 44 24 08          	mov    %eax,0x8(%esp)
    212c:	c7 44 24 04 dc 5b 00 	movl   $0x5bdc,0x4(%esp)
    2133:	00 
    2134:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    213b:	e8 3a 30 00 00       	call   517a <printf>
          exit();
    2140:	e8 a5 2e 00 00       	call   4fea <exit>
      for(i = 0; i < 12; i++){
    2145:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2149:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
    214d:	7e af                	jle    20fe <fourfiles+0xe4>
        }
      }
      exit();
    214f:	e8 96 2e 00 00       	call   4fea <exit>
  for(pi = 0; pi < 4; pi++){
    2154:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    2158:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    215c:	0f 8e fa fe ff ff    	jle    205c <fourfiles+0x42>
    }
  }

  for(pi = 0; pi < 4; pi++){
    2162:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    2169:	eb 09                	jmp    2174 <fourfiles+0x15a>
    wait();
    216b:	e8 82 2e 00 00       	call   4ff2 <wait>
  for(pi = 0; pi < 4; pi++){
    2170:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
    2174:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
    2178:	7e f1                	jle    216b <fourfiles+0x151>
  }

  for(i = 0; i < 2; i++){
    217a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2181:	e9 dc 00 00 00       	jmp    2262 <fourfiles+0x248>
    fname = names[i];
    2186:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2189:	8b 44 85 c8          	mov    -0x38(%ebp,%eax,4),%eax
    218d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    fd = open(fname, 0);
    2190:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2197:	00 
    2198:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    219b:	89 04 24             	mov    %eax,(%esp)
    219e:	e8 87 2e 00 00       	call   502a <open>
    21a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
    total = 0;
    21a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    21ad:	eb 4c                	jmp    21fb <fourfiles+0x1e1>
      for(j = 0; j < n; j++){
    21af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    21b6:	eb 35                	jmp    21ed <fourfiles+0x1d3>
        if(buf[j] != '0'+i){
    21b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    21bb:	05 40 9d 00 00       	add    $0x9d40,%eax
    21c0:	0f b6 00             	movzbl (%eax),%eax
    21c3:	0f be c0             	movsbl %al,%eax
    21c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
    21c9:	83 c2 30             	add    $0x30,%edx
    21cc:	39 d0                	cmp    %edx,%eax
    21ce:	74 19                	je     21e9 <fourfiles+0x1cf>
          printf(1, "wrong char\n");
    21d0:	c7 44 24 04 ed 5b 00 	movl   $0x5bed,0x4(%esp)
    21d7:	00 
    21d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21df:	e8 96 2f 00 00       	call   517a <printf>
          exit();
    21e4:	e8 01 2e 00 00       	call   4fea <exit>
      for(j = 0; j < n; j++){
    21e9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    21ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
    21f0:	3b 45 d8             	cmp    -0x28(%ebp),%eax
    21f3:	7c c3                	jl     21b8 <fourfiles+0x19e>
        }
      }
      total += n;
    21f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
    21f8:	01 45 ec             	add    %eax,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    21fb:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    2202:	00 
    2203:	c7 44 24 04 40 9d 00 	movl   $0x9d40,0x4(%esp)
    220a:	00 
    220b:	8b 45 dc             	mov    -0x24(%ebp),%eax
    220e:	89 04 24             	mov    %eax,(%esp)
    2211:	e8 ec 2d 00 00       	call   5002 <read>
    2216:	89 45 d8             	mov    %eax,-0x28(%ebp)
    2219:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
    221d:	7f 90                	jg     21af <fourfiles+0x195>
    }
    close(fd);
    221f:	8b 45 dc             	mov    -0x24(%ebp),%eax
    2222:	89 04 24             	mov    %eax,(%esp)
    2225:	e8 e8 2d 00 00       	call   5012 <close>
    if(total != 12*500){
    222a:	81 7d ec 70 17 00 00 	cmpl   $0x1770,-0x14(%ebp)
    2231:	74 20                	je     2253 <fourfiles+0x239>
      printf(1, "wrong length %d\n", total);
    2233:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2236:	89 44 24 08          	mov    %eax,0x8(%esp)
    223a:	c7 44 24 04 f9 5b 00 	movl   $0x5bf9,0x4(%esp)
    2241:	00 
    2242:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2249:	e8 2c 2f 00 00       	call   517a <printf>
      exit();
    224e:	e8 97 2d 00 00       	call   4fea <exit>
    }
    unlink(fname);
    2253:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    2256:	89 04 24             	mov    %eax,(%esp)
    2259:	e8 dc 2d 00 00       	call   503a <unlink>
  for(i = 0; i < 2; i++){
    225e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2262:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
    2266:	0f 8e 1a ff ff ff    	jle    2186 <fourfiles+0x16c>
  }

  printf(1, "fourfiles ok\n");
    226c:	c7 44 24 04 0a 5c 00 	movl   $0x5c0a,0x4(%esp)
    2273:	00 
    2274:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    227b:	e8 fa 2e 00 00       	call   517a <printf>
}
    2280:	c9                   	leave  
    2281:	c3                   	ret    

00002282 <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    2282:	55                   	push   %ebp
    2283:	89 e5                	mov    %esp,%ebp
    2285:	83 ec 48             	sub    $0x48,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    2288:	c7 44 24 04 18 5c 00 	movl   $0x5c18,0x4(%esp)
    228f:	00 
    2290:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2297:	e8 de 2e 00 00       	call   517a <printf>

  for(pi = 0; pi < 4; pi++){
    229c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    22a3:	e9 f4 00 00 00       	jmp    239c <createdelete+0x11a>
    pid = fork();
    22a8:	e8 35 2d 00 00       	call   4fe2 <fork>
    22ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    22b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    22b4:	79 19                	jns    22cf <createdelete+0x4d>
      printf(1, "fork failed\n");
    22b6:	c7 44 24 04 39 56 00 	movl   $0x5639,0x4(%esp)
    22bd:	00 
    22be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22c5:	e8 b0 2e 00 00       	call   517a <printf>
      exit();
    22ca:	e8 1b 2d 00 00       	call   4fea <exit>
    }

    if(pid == 0){
    22cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    22d3:	0f 85 bf 00 00 00    	jne    2398 <createdelete+0x116>
      name[0] = 'p' + pi;
    22d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    22dc:	83 c0 70             	add    $0x70,%eax
    22df:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[2] = '\0';
    22e2:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
      for(i = 0; i < N; i++){
    22e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    22ed:	e9 97 00 00 00       	jmp    2389 <createdelete+0x107>
        name[1] = '0' + i;
    22f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    22f5:	83 c0 30             	add    $0x30,%eax
    22f8:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    22fb:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2302:	00 
    2303:	8d 45 c8             	lea    -0x38(%ebp),%eax
    2306:	89 04 24             	mov    %eax,(%esp)
    2309:	e8 1c 2d 00 00       	call   502a <open>
    230e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if(fd < 0){
    2311:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2315:	79 19                	jns    2330 <createdelete+0xae>
          printf(1, "create failed\n");
    2317:	c7 44 24 04 cd 5b 00 	movl   $0x5bcd,0x4(%esp)
    231e:	00 
    231f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2326:	e8 4f 2e 00 00       	call   517a <printf>
          exit();
    232b:	e8 ba 2c 00 00       	call   4fea <exit>
        }
        close(fd);
    2330:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2333:	89 04 24             	mov    %eax,(%esp)
    2336:	e8 d7 2c 00 00       	call   5012 <close>
        if(i > 0 && (i % 2 ) == 0){
    233b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    233f:	7e 44                	jle    2385 <createdelete+0x103>
    2341:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2344:	83 e0 01             	and    $0x1,%eax
    2347:	85 c0                	test   %eax,%eax
    2349:	75 3a                	jne    2385 <createdelete+0x103>
          name[1] = '0' + (i / 2);
    234b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    234e:	89 c2                	mov    %eax,%edx
    2350:	c1 ea 1f             	shr    $0x1f,%edx
    2353:	01 d0                	add    %edx,%eax
    2355:	d1 f8                	sar    %eax
    2357:	83 c0 30             	add    $0x30,%eax
    235a:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    235d:	8d 45 c8             	lea    -0x38(%ebp),%eax
    2360:	89 04 24             	mov    %eax,(%esp)
    2363:	e8 d2 2c 00 00       	call   503a <unlink>
    2368:	85 c0                	test   %eax,%eax
    236a:	79 19                	jns    2385 <createdelete+0x103>
            printf(1, "unlink failed\n");
    236c:	c7 44 24 04 bc 56 00 	movl   $0x56bc,0x4(%esp)
    2373:	00 
    2374:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    237b:	e8 fa 2d 00 00       	call   517a <printf>
            exit();
    2380:	e8 65 2c 00 00       	call   4fea <exit>
      for(i = 0; i < N; i++){
    2385:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2389:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    238d:	0f 8e 5f ff ff ff    	jle    22f2 <createdelete+0x70>
          }
        }
      }
      exit();
    2393:	e8 52 2c 00 00       	call   4fea <exit>
  for(pi = 0; pi < 4; pi++){
    2398:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    239c:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    23a0:	0f 8e 02 ff ff ff    	jle    22a8 <createdelete+0x26>
    }
  }

  for(pi = 0; pi < 4; pi++){
    23a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    23ad:	eb 09                	jmp    23b8 <createdelete+0x136>
    wait();
    23af:	e8 3e 2c 00 00       	call   4ff2 <wait>
  for(pi = 0; pi < 4; pi++){
    23b4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    23b8:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    23bc:	7e f1                	jle    23af <createdelete+0x12d>
  }

  name[0] = name[1] = name[2] = 0;
    23be:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    23c2:	0f b6 45 ca          	movzbl -0x36(%ebp),%eax
    23c6:	88 45 c9             	mov    %al,-0x37(%ebp)
    23c9:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
    23cd:	88 45 c8             	mov    %al,-0x38(%ebp)
  for(i = 0; i < N; i++){
    23d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    23d7:	e9 bb 00 00 00       	jmp    2497 <createdelete+0x215>
    for(pi = 0; pi < 4; pi++){
    23dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    23e3:	e9 a1 00 00 00       	jmp    2489 <createdelete+0x207>
      name[0] = 'p' + pi;
    23e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    23eb:	83 c0 70             	add    $0x70,%eax
    23ee:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    23f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    23f4:	83 c0 30             	add    $0x30,%eax
    23f7:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    23fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2401:	00 
    2402:	8d 45 c8             	lea    -0x38(%ebp),%eax
    2405:	89 04 24             	mov    %eax,(%esp)
    2408:	e8 1d 2c 00 00       	call   502a <open>
    240d:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((i == 0 || i >= N/2) && fd < 0){
    2410:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2414:	74 06                	je     241c <createdelete+0x19a>
    2416:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    241a:	7e 26                	jle    2442 <createdelete+0x1c0>
    241c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2420:	79 20                	jns    2442 <createdelete+0x1c0>
        printf(1, "oops createdelete %s didn't exist\n", name);
    2422:	8d 45 c8             	lea    -0x38(%ebp),%eax
    2425:	89 44 24 08          	mov    %eax,0x8(%esp)
    2429:	c7 44 24 04 2c 5c 00 	movl   $0x5c2c,0x4(%esp)
    2430:	00 
    2431:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2438:	e8 3d 2d 00 00       	call   517a <printf>
        exit();
    243d:	e8 a8 2b 00 00       	call   4fea <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    2442:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2446:	7e 2c                	jle    2474 <createdelete+0x1f2>
    2448:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    244c:	7f 26                	jg     2474 <createdelete+0x1f2>
    244e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2452:	78 20                	js     2474 <createdelete+0x1f2>
        printf(1, "oops createdelete %s did exist\n", name);
    2454:	8d 45 c8             	lea    -0x38(%ebp),%eax
    2457:	89 44 24 08          	mov    %eax,0x8(%esp)
    245b:	c7 44 24 04 50 5c 00 	movl   $0x5c50,0x4(%esp)
    2462:	00 
    2463:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    246a:	e8 0b 2d 00 00       	call   517a <printf>
        exit();
    246f:	e8 76 2b 00 00       	call   4fea <exit>
      }
      if(fd >= 0)
    2474:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2478:	78 0b                	js     2485 <createdelete+0x203>
        close(fd);
    247a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    247d:	89 04 24             	mov    %eax,(%esp)
    2480:	e8 8d 2b 00 00       	call   5012 <close>
    for(pi = 0; pi < 4; pi++){
    2485:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    2489:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    248d:	0f 8e 55 ff ff ff    	jle    23e8 <createdelete+0x166>
  for(i = 0; i < N; i++){
    2493:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2497:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    249b:	0f 8e 3b ff ff ff    	jle    23dc <createdelete+0x15a>
    }
  }

  for(i = 0; i < N; i++){
    24a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    24a8:	eb 34                	jmp    24de <createdelete+0x25c>
    for(pi = 0; pi < 4; pi++){
    24aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    24b1:	eb 21                	jmp    24d4 <createdelete+0x252>
      name[0] = 'p' + i;
    24b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    24b6:	83 c0 70             	add    $0x70,%eax
    24b9:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    24bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    24bf:	83 c0 30             	add    $0x30,%eax
    24c2:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    24c5:	8d 45 c8             	lea    -0x38(%ebp),%eax
    24c8:	89 04 24             	mov    %eax,(%esp)
    24cb:	e8 6a 2b 00 00       	call   503a <unlink>
    for(pi = 0; pi < 4; pi++){
    24d0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    24d4:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    24d8:	7e d9                	jle    24b3 <createdelete+0x231>
  for(i = 0; i < N; i++){
    24da:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    24de:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    24e2:	7e c6                	jle    24aa <createdelete+0x228>
    }
  }

  printf(1, "createdelete ok\n");
    24e4:	c7 44 24 04 70 5c 00 	movl   $0x5c70,0x4(%esp)
    24eb:	00 
    24ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24f3:	e8 82 2c 00 00       	call   517a <printf>
}
    24f8:	c9                   	leave  
    24f9:	c3                   	ret    

000024fa <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    24fa:	55                   	push   %ebp
    24fb:	89 e5                	mov    %esp,%ebp
    24fd:	83 ec 28             	sub    $0x28,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    2500:	c7 44 24 04 81 5c 00 	movl   $0x5c81,0x4(%esp)
    2507:	00 
    2508:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    250f:	e8 66 2c 00 00       	call   517a <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    2514:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    251b:	00 
    251c:	c7 04 24 92 5c 00 00 	movl   $0x5c92,(%esp)
    2523:	e8 02 2b 00 00       	call   502a <open>
    2528:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    252b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    252f:	79 19                	jns    254a <unlinkread+0x50>
    printf(1, "create unlinkread failed\n");
    2531:	c7 44 24 04 9d 5c 00 	movl   $0x5c9d,0x4(%esp)
    2538:	00 
    2539:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2540:	e8 35 2c 00 00       	call   517a <printf>
    exit();
    2545:	e8 a0 2a 00 00       	call   4fea <exit>
  }
  write(fd, "hello", 5);
    254a:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    2551:	00 
    2552:	c7 44 24 04 b7 5c 00 	movl   $0x5cb7,0x4(%esp)
    2559:	00 
    255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    255d:	89 04 24             	mov    %eax,(%esp)
    2560:	e8 a5 2a 00 00       	call   500a <write>
  close(fd);
    2565:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2568:	89 04 24             	mov    %eax,(%esp)
    256b:	e8 a2 2a 00 00       	call   5012 <close>

  fd = open("unlinkread", O_RDWR);
    2570:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    2577:	00 
    2578:	c7 04 24 92 5c 00 00 	movl   $0x5c92,(%esp)
    257f:	e8 a6 2a 00 00       	call   502a <open>
    2584:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2587:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    258b:	79 19                	jns    25a6 <unlinkread+0xac>
    printf(1, "open unlinkread failed\n");
    258d:	c7 44 24 04 bd 5c 00 	movl   $0x5cbd,0x4(%esp)
    2594:	00 
    2595:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    259c:	e8 d9 2b 00 00       	call   517a <printf>
    exit();
    25a1:	e8 44 2a 00 00       	call   4fea <exit>
  }
  if(unlink("unlinkread") != 0){
    25a6:	c7 04 24 92 5c 00 00 	movl   $0x5c92,(%esp)
    25ad:	e8 88 2a 00 00       	call   503a <unlink>
    25b2:	85 c0                	test   %eax,%eax
    25b4:	74 19                	je     25cf <unlinkread+0xd5>
    printf(1, "unlink unlinkread failed\n");
    25b6:	c7 44 24 04 d5 5c 00 	movl   $0x5cd5,0x4(%esp)
    25bd:	00 
    25be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25c5:	e8 b0 2b 00 00       	call   517a <printf>
    exit();
    25ca:	e8 1b 2a 00 00       	call   4fea <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    25cf:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    25d6:	00 
    25d7:	c7 04 24 92 5c 00 00 	movl   $0x5c92,(%esp)
    25de:	e8 47 2a 00 00       	call   502a <open>
    25e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  write(fd1, "yyy", 3);
    25e6:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
    25ed:	00 
    25ee:	c7 44 24 04 ef 5c 00 	movl   $0x5cef,0x4(%esp)
    25f5:	00 
    25f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    25f9:	89 04 24             	mov    %eax,(%esp)
    25fc:	e8 09 2a 00 00       	call   500a <write>
  close(fd1);
    2601:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2604:	89 04 24             	mov    %eax,(%esp)
    2607:	e8 06 2a 00 00       	call   5012 <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    260c:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    2613:	00 
    2614:	c7 44 24 04 40 9d 00 	movl   $0x9d40,0x4(%esp)
    261b:	00 
    261c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    261f:	89 04 24             	mov    %eax,(%esp)
    2622:	e8 db 29 00 00       	call   5002 <read>
    2627:	83 f8 05             	cmp    $0x5,%eax
    262a:	74 19                	je     2645 <unlinkread+0x14b>
    printf(1, "unlinkread read failed");
    262c:	c7 44 24 04 f3 5c 00 	movl   $0x5cf3,0x4(%esp)
    2633:	00 
    2634:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    263b:	e8 3a 2b 00 00       	call   517a <printf>
    exit();
    2640:	e8 a5 29 00 00       	call   4fea <exit>
  }
  if(buf[0] != 'h'){
    2645:	0f b6 05 40 9d 00 00 	movzbl 0x9d40,%eax
    264c:	3c 68                	cmp    $0x68,%al
    264e:	74 19                	je     2669 <unlinkread+0x16f>
    printf(1, "unlinkread wrong data\n");
    2650:	c7 44 24 04 0a 5d 00 	movl   $0x5d0a,0x4(%esp)
    2657:	00 
    2658:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    265f:	e8 16 2b 00 00       	call   517a <printf>
    exit();
    2664:	e8 81 29 00 00       	call   4fea <exit>
  }
  if(write(fd, buf, 10) != 10){
    2669:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    2670:	00 
    2671:	c7 44 24 04 40 9d 00 	movl   $0x9d40,0x4(%esp)
    2678:	00 
    2679:	8b 45 f4             	mov    -0xc(%ebp),%eax
    267c:	89 04 24             	mov    %eax,(%esp)
    267f:	e8 86 29 00 00       	call   500a <write>
    2684:	83 f8 0a             	cmp    $0xa,%eax
    2687:	74 19                	je     26a2 <unlinkread+0x1a8>
    printf(1, "unlinkread write failed\n");
    2689:	c7 44 24 04 21 5d 00 	movl   $0x5d21,0x4(%esp)
    2690:	00 
    2691:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2698:	e8 dd 2a 00 00       	call   517a <printf>
    exit();
    269d:	e8 48 29 00 00       	call   4fea <exit>
  }
  close(fd);
    26a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    26a5:	89 04 24             	mov    %eax,(%esp)
    26a8:	e8 65 29 00 00       	call   5012 <close>
  unlink("unlinkread");
    26ad:	c7 04 24 92 5c 00 00 	movl   $0x5c92,(%esp)
    26b4:	e8 81 29 00 00       	call   503a <unlink>
  printf(1, "unlinkread ok\n");
    26b9:	c7 44 24 04 3a 5d 00 	movl   $0x5d3a,0x4(%esp)
    26c0:	00 
    26c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26c8:	e8 ad 2a 00 00       	call   517a <printf>
}
    26cd:	c9                   	leave  
    26ce:	c3                   	ret    

000026cf <linktest>:

void
linktest(void)
{
    26cf:	55                   	push   %ebp
    26d0:	89 e5                	mov    %esp,%ebp
    26d2:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(1, "linktest\n");
    26d5:	c7 44 24 04 49 5d 00 	movl   $0x5d49,0x4(%esp)
    26dc:	00 
    26dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26e4:	e8 91 2a 00 00       	call   517a <printf>

  unlink("lf1");
    26e9:	c7 04 24 53 5d 00 00 	movl   $0x5d53,(%esp)
    26f0:	e8 45 29 00 00       	call   503a <unlink>
  unlink("lf2");
    26f5:	c7 04 24 57 5d 00 00 	movl   $0x5d57,(%esp)
    26fc:	e8 39 29 00 00       	call   503a <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    2701:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2708:	00 
    2709:	c7 04 24 53 5d 00 00 	movl   $0x5d53,(%esp)
    2710:	e8 15 29 00 00       	call   502a <open>
    2715:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2718:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    271c:	79 19                	jns    2737 <linktest+0x68>
    printf(1, "create lf1 failed\n");
    271e:	c7 44 24 04 5b 5d 00 	movl   $0x5d5b,0x4(%esp)
    2725:	00 
    2726:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    272d:	e8 48 2a 00 00       	call   517a <printf>
    exit();
    2732:	e8 b3 28 00 00       	call   4fea <exit>
  }
  if(write(fd, "hello", 5) != 5){
    2737:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    273e:	00 
    273f:	c7 44 24 04 b7 5c 00 	movl   $0x5cb7,0x4(%esp)
    2746:	00 
    2747:	8b 45 f4             	mov    -0xc(%ebp),%eax
    274a:	89 04 24             	mov    %eax,(%esp)
    274d:	e8 b8 28 00 00       	call   500a <write>
    2752:	83 f8 05             	cmp    $0x5,%eax
    2755:	74 19                	je     2770 <linktest+0xa1>
    printf(1, "write lf1 failed\n");
    2757:	c7 44 24 04 6e 5d 00 	movl   $0x5d6e,0x4(%esp)
    275e:	00 
    275f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2766:	e8 0f 2a 00 00       	call   517a <printf>
    exit();
    276b:	e8 7a 28 00 00       	call   4fea <exit>
  }
  close(fd);
    2770:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2773:	89 04 24             	mov    %eax,(%esp)
    2776:	e8 97 28 00 00       	call   5012 <close>

  if(link("lf1", "lf2") < 0){
    277b:	c7 44 24 04 57 5d 00 	movl   $0x5d57,0x4(%esp)
    2782:	00 
    2783:	c7 04 24 53 5d 00 00 	movl   $0x5d53,(%esp)
    278a:	e8 bb 28 00 00       	call   504a <link>
    278f:	85 c0                	test   %eax,%eax
    2791:	79 19                	jns    27ac <linktest+0xdd>
    printf(1, "link lf1 lf2 failed\n");
    2793:	c7 44 24 04 80 5d 00 	movl   $0x5d80,0x4(%esp)
    279a:	00 
    279b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27a2:	e8 d3 29 00 00       	call   517a <printf>
    exit();
    27a7:	e8 3e 28 00 00       	call   4fea <exit>
  }
  unlink("lf1");
    27ac:	c7 04 24 53 5d 00 00 	movl   $0x5d53,(%esp)
    27b3:	e8 82 28 00 00       	call   503a <unlink>

  if(open("lf1", 0) >= 0){
    27b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    27bf:	00 
    27c0:	c7 04 24 53 5d 00 00 	movl   $0x5d53,(%esp)
    27c7:	e8 5e 28 00 00       	call   502a <open>
    27cc:	85 c0                	test   %eax,%eax
    27ce:	78 19                	js     27e9 <linktest+0x11a>
    printf(1, "unlinked lf1 but it is still there!\n");
    27d0:	c7 44 24 04 98 5d 00 	movl   $0x5d98,0x4(%esp)
    27d7:	00 
    27d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27df:	e8 96 29 00 00       	call   517a <printf>
    exit();
    27e4:	e8 01 28 00 00       	call   4fea <exit>
  }

  fd = open("lf2", 0);
    27e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    27f0:	00 
    27f1:	c7 04 24 57 5d 00 00 	movl   $0x5d57,(%esp)
    27f8:	e8 2d 28 00 00       	call   502a <open>
    27fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2800:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2804:	79 19                	jns    281f <linktest+0x150>
    printf(1, "open lf2 failed\n");
    2806:	c7 44 24 04 bd 5d 00 	movl   $0x5dbd,0x4(%esp)
    280d:	00 
    280e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2815:	e8 60 29 00 00       	call   517a <printf>
    exit();
    281a:	e8 cb 27 00 00       	call   4fea <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    281f:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    2826:	00 
    2827:	c7 44 24 04 40 9d 00 	movl   $0x9d40,0x4(%esp)
    282e:	00 
    282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2832:	89 04 24             	mov    %eax,(%esp)
    2835:	e8 c8 27 00 00       	call   5002 <read>
    283a:	83 f8 05             	cmp    $0x5,%eax
    283d:	74 19                	je     2858 <linktest+0x189>
    printf(1, "read lf2 failed\n");
    283f:	c7 44 24 04 ce 5d 00 	movl   $0x5dce,0x4(%esp)
    2846:	00 
    2847:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    284e:	e8 27 29 00 00       	call   517a <printf>
    exit();
    2853:	e8 92 27 00 00       	call   4fea <exit>
  }
  close(fd);
    2858:	8b 45 f4             	mov    -0xc(%ebp),%eax
    285b:	89 04 24             	mov    %eax,(%esp)
    285e:	e8 af 27 00 00       	call   5012 <close>

  if(link("lf2", "lf2") >= 0){
    2863:	c7 44 24 04 57 5d 00 	movl   $0x5d57,0x4(%esp)
    286a:	00 
    286b:	c7 04 24 57 5d 00 00 	movl   $0x5d57,(%esp)
    2872:	e8 d3 27 00 00       	call   504a <link>
    2877:	85 c0                	test   %eax,%eax
    2879:	78 19                	js     2894 <linktest+0x1c5>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    287b:	c7 44 24 04 df 5d 00 	movl   $0x5ddf,0x4(%esp)
    2882:	00 
    2883:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    288a:	e8 eb 28 00 00       	call   517a <printf>
    exit();
    288f:	e8 56 27 00 00       	call   4fea <exit>
  }

  unlink("lf2");
    2894:	c7 04 24 57 5d 00 00 	movl   $0x5d57,(%esp)
    289b:	e8 9a 27 00 00       	call   503a <unlink>
  if(link("lf2", "lf1") >= 0){
    28a0:	c7 44 24 04 53 5d 00 	movl   $0x5d53,0x4(%esp)
    28a7:	00 
    28a8:	c7 04 24 57 5d 00 00 	movl   $0x5d57,(%esp)
    28af:	e8 96 27 00 00       	call   504a <link>
    28b4:	85 c0                	test   %eax,%eax
    28b6:	78 19                	js     28d1 <linktest+0x202>
    printf(1, "link non-existant succeeded! oops\n");
    28b8:	c7 44 24 04 00 5e 00 	movl   $0x5e00,0x4(%esp)
    28bf:	00 
    28c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28c7:	e8 ae 28 00 00       	call   517a <printf>
    exit();
    28cc:	e8 19 27 00 00       	call   4fea <exit>
  }

  if(link(".", "lf1") >= 0){
    28d1:	c7 44 24 04 53 5d 00 	movl   $0x5d53,0x4(%esp)
    28d8:	00 
    28d9:	c7 04 24 23 5e 00 00 	movl   $0x5e23,(%esp)
    28e0:	e8 65 27 00 00       	call   504a <link>
    28e5:	85 c0                	test   %eax,%eax
    28e7:	78 19                	js     2902 <linktest+0x233>
    printf(1, "link . lf1 succeeded! oops\n");
    28e9:	c7 44 24 04 25 5e 00 	movl   $0x5e25,0x4(%esp)
    28f0:	00 
    28f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28f8:	e8 7d 28 00 00       	call   517a <printf>
    exit();
    28fd:	e8 e8 26 00 00       	call   4fea <exit>
  }

  printf(1, "linktest ok\n");
    2902:	c7 44 24 04 41 5e 00 	movl   $0x5e41,0x4(%esp)
    2909:	00 
    290a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2911:	e8 64 28 00 00       	call   517a <printf>
}
    2916:	c9                   	leave  
    2917:	c3                   	ret    

00002918 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    2918:	55                   	push   %ebp
    2919:	89 e5                	mov    %esp,%ebp
    291b:	83 ec 68             	sub    $0x68,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    291e:	c7 44 24 04 4e 5e 00 	movl   $0x5e4e,0x4(%esp)
    2925:	00 
    2926:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    292d:	e8 48 28 00 00       	call   517a <printf>
  file[0] = 'C';
    2932:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    2936:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    293a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2941:	e9 f7 00 00 00       	jmp    2a3d <concreate+0x125>
    file[1] = '0' + i;
    2946:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2949:	83 c0 30             	add    $0x30,%eax
    294c:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    294f:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    2952:	89 04 24             	mov    %eax,(%esp)
    2955:	e8 e0 26 00 00       	call   503a <unlink>
    pid = fork();
    295a:	e8 83 26 00 00       	call   4fe2 <fork>
    295f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid && (i % 3) == 1){
    2962:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2966:	74 3a                	je     29a2 <concreate+0x8a>
    2968:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    296b:	ba 56 55 55 55       	mov    $0x55555556,%edx
    2970:	89 c8                	mov    %ecx,%eax
    2972:	f7 ea                	imul   %edx
    2974:	89 c8                	mov    %ecx,%eax
    2976:	c1 f8 1f             	sar    $0x1f,%eax
    2979:	29 c2                	sub    %eax,%edx
    297b:	89 d0                	mov    %edx,%eax
    297d:	01 c0                	add    %eax,%eax
    297f:	01 d0                	add    %edx,%eax
    2981:	29 c1                	sub    %eax,%ecx
    2983:	89 ca                	mov    %ecx,%edx
    2985:	83 fa 01             	cmp    $0x1,%edx
    2988:	75 18                	jne    29a2 <concreate+0x8a>
      link("C0", file);
    298a:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    298d:	89 44 24 04          	mov    %eax,0x4(%esp)
    2991:	c7 04 24 5e 5e 00 00 	movl   $0x5e5e,(%esp)
    2998:	e8 ad 26 00 00       	call   504a <link>
    299d:	e9 87 00 00 00       	jmp    2a29 <concreate+0x111>
    } else if(pid == 0 && (i % 5) == 1){
    29a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    29a6:	75 3a                	jne    29e2 <concreate+0xca>
    29a8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    29ab:	ba 67 66 66 66       	mov    $0x66666667,%edx
    29b0:	89 c8                	mov    %ecx,%eax
    29b2:	f7 ea                	imul   %edx
    29b4:	d1 fa                	sar    %edx
    29b6:	89 c8                	mov    %ecx,%eax
    29b8:	c1 f8 1f             	sar    $0x1f,%eax
    29bb:	29 c2                	sub    %eax,%edx
    29bd:	89 d0                	mov    %edx,%eax
    29bf:	c1 e0 02             	shl    $0x2,%eax
    29c2:	01 d0                	add    %edx,%eax
    29c4:	29 c1                	sub    %eax,%ecx
    29c6:	89 ca                	mov    %ecx,%edx
    29c8:	83 fa 01             	cmp    $0x1,%edx
    29cb:	75 15                	jne    29e2 <concreate+0xca>
      link("C0", file);
    29cd:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    29d0:	89 44 24 04          	mov    %eax,0x4(%esp)
    29d4:	c7 04 24 5e 5e 00 00 	movl   $0x5e5e,(%esp)
    29db:	e8 6a 26 00 00       	call   504a <link>
    29e0:	eb 47                	jmp    2a29 <concreate+0x111>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    29e2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    29e9:	00 
    29ea:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    29ed:	89 04 24             	mov    %eax,(%esp)
    29f0:	e8 35 26 00 00       	call   502a <open>
    29f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(fd < 0){
    29f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    29fc:	79 20                	jns    2a1e <concreate+0x106>
        printf(1, "concreate create %s failed\n", file);
    29fe:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    2a01:	89 44 24 08          	mov    %eax,0x8(%esp)
    2a05:	c7 44 24 04 61 5e 00 	movl   $0x5e61,0x4(%esp)
    2a0c:	00 
    2a0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a14:	e8 61 27 00 00       	call   517a <printf>
        exit();
    2a19:	e8 cc 25 00 00       	call   4fea <exit>
      }
      close(fd);
    2a1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2a21:	89 04 24             	mov    %eax,(%esp)
    2a24:	e8 e9 25 00 00       	call   5012 <close>
    }
    if(pid == 0)
    2a29:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2a2d:	75 05                	jne    2a34 <concreate+0x11c>
      exit();
    2a2f:	e8 b6 25 00 00       	call   4fea <exit>
    else
      wait();
    2a34:	e8 b9 25 00 00       	call   4ff2 <wait>
  for(i = 0; i < 40; i++){
    2a39:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2a3d:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    2a41:	0f 8e ff fe ff ff    	jle    2946 <concreate+0x2e>
  }

  memset(fa, 0, sizeof(fa));
    2a47:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
    2a4e:	00 
    2a4f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2a56:	00 
    2a57:	8d 45 bd             	lea    -0x43(%ebp),%eax
    2a5a:	89 04 24             	mov    %eax,(%esp)
    2a5d:	e8 db 23 00 00       	call   4e3d <memset>
  fd = open(".", 0);
    2a62:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2a69:	00 
    2a6a:	c7 04 24 23 5e 00 00 	movl   $0x5e23,(%esp)
    2a71:	e8 b4 25 00 00       	call   502a <open>
    2a76:	89 45 e8             	mov    %eax,-0x18(%ebp)
  n = 0;
    2a79:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    2a80:	e9 a1 00 00 00       	jmp    2b26 <concreate+0x20e>
    if(de.inum == 0)
    2a85:	0f b7 45 ac          	movzwl -0x54(%ebp),%eax
    2a89:	66 85 c0             	test   %ax,%ax
    2a8c:	75 05                	jne    2a93 <concreate+0x17b>
      continue;
    2a8e:	e9 93 00 00 00       	jmp    2b26 <concreate+0x20e>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    2a93:	0f b6 45 ae          	movzbl -0x52(%ebp),%eax
    2a97:	3c 43                	cmp    $0x43,%al
    2a99:	0f 85 87 00 00 00    	jne    2b26 <concreate+0x20e>
    2a9f:	0f b6 45 b0          	movzbl -0x50(%ebp),%eax
    2aa3:	84 c0                	test   %al,%al
    2aa5:	75 7f                	jne    2b26 <concreate+0x20e>
      i = de.name[1] - '0';
    2aa7:	0f b6 45 af          	movzbl -0x51(%ebp),%eax
    2aab:	0f be c0             	movsbl %al,%eax
    2aae:	83 e8 30             	sub    $0x30,%eax
    2ab1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(i < 0 || i >= sizeof(fa)){
    2ab4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2ab8:	78 08                	js     2ac2 <concreate+0x1aa>
    2aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2abd:	83 f8 27             	cmp    $0x27,%eax
    2ac0:	76 23                	jbe    2ae5 <concreate+0x1cd>
        printf(1, "concreate weird file %s\n", de.name);
    2ac2:	8d 45 ac             	lea    -0x54(%ebp),%eax
    2ac5:	83 c0 02             	add    $0x2,%eax
    2ac8:	89 44 24 08          	mov    %eax,0x8(%esp)
    2acc:	c7 44 24 04 7d 5e 00 	movl   $0x5e7d,0x4(%esp)
    2ad3:	00 
    2ad4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2adb:	e8 9a 26 00 00       	call   517a <printf>
        exit();
    2ae0:	e8 05 25 00 00       	call   4fea <exit>
      }
      if(fa[i]){
    2ae5:	8d 55 bd             	lea    -0x43(%ebp),%edx
    2ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2aeb:	01 d0                	add    %edx,%eax
    2aed:	0f b6 00             	movzbl (%eax),%eax
    2af0:	84 c0                	test   %al,%al
    2af2:	74 23                	je     2b17 <concreate+0x1ff>
        printf(1, "concreate duplicate file %s\n", de.name);
    2af4:	8d 45 ac             	lea    -0x54(%ebp),%eax
    2af7:	83 c0 02             	add    $0x2,%eax
    2afa:	89 44 24 08          	mov    %eax,0x8(%esp)
    2afe:	c7 44 24 04 96 5e 00 	movl   $0x5e96,0x4(%esp)
    2b05:	00 
    2b06:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b0d:	e8 68 26 00 00       	call   517a <printf>
        exit();
    2b12:	e8 d3 24 00 00       	call   4fea <exit>
      }
      fa[i] = 1;
    2b17:	8d 55 bd             	lea    -0x43(%ebp),%edx
    2b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2b1d:	01 d0                	add    %edx,%eax
    2b1f:	c6 00 01             	movb   $0x1,(%eax)
      n++;
    2b22:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    2b26:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    2b2d:	00 
    2b2e:	8d 45 ac             	lea    -0x54(%ebp),%eax
    2b31:	89 44 24 04          	mov    %eax,0x4(%esp)
    2b35:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2b38:	89 04 24             	mov    %eax,(%esp)
    2b3b:	e8 c2 24 00 00       	call   5002 <read>
    2b40:	85 c0                	test   %eax,%eax
    2b42:	0f 8f 3d ff ff ff    	jg     2a85 <concreate+0x16d>
    }
  }
  close(fd);
    2b48:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2b4b:	89 04 24             	mov    %eax,(%esp)
    2b4e:	e8 bf 24 00 00       	call   5012 <close>

  if(n != 40){
    2b53:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    2b57:	74 19                	je     2b72 <concreate+0x25a>
    printf(1, "concreate not enough files in directory listing\n");
    2b59:	c7 44 24 04 b4 5e 00 	movl   $0x5eb4,0x4(%esp)
    2b60:	00 
    2b61:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b68:	e8 0d 26 00 00       	call   517a <printf>
    exit();
    2b6d:	e8 78 24 00 00       	call   4fea <exit>
  }

  for(i = 0; i < 40; i++){
    2b72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2b79:	e9 2d 01 00 00       	jmp    2cab <concreate+0x393>
    file[1] = '0' + i;
    2b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2b81:	83 c0 30             	add    $0x30,%eax
    2b84:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    2b87:	e8 56 24 00 00       	call   4fe2 <fork>
    2b8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    2b8f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2b93:	79 19                	jns    2bae <concreate+0x296>
      printf(1, "fork failed\n");
    2b95:	c7 44 24 04 39 56 00 	movl   $0x5639,0x4(%esp)
    2b9c:	00 
    2b9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ba4:	e8 d1 25 00 00       	call   517a <printf>
      exit();
    2ba9:	e8 3c 24 00 00       	call   4fea <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    2bae:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    2bb1:	ba 56 55 55 55       	mov    $0x55555556,%edx
    2bb6:	89 c8                	mov    %ecx,%eax
    2bb8:	f7 ea                	imul   %edx
    2bba:	89 c8                	mov    %ecx,%eax
    2bbc:	c1 f8 1f             	sar    $0x1f,%eax
    2bbf:	29 c2                	sub    %eax,%edx
    2bc1:	89 d0                	mov    %edx,%eax
    2bc3:	01 c0                	add    %eax,%eax
    2bc5:	01 d0                	add    %edx,%eax
    2bc7:	29 c1                	sub    %eax,%ecx
    2bc9:	89 ca                	mov    %ecx,%edx
    2bcb:	85 d2                	test   %edx,%edx
    2bcd:	75 06                	jne    2bd5 <concreate+0x2bd>
    2bcf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2bd3:	74 28                	je     2bfd <concreate+0x2e5>
       ((i % 3) == 1 && pid != 0)){
    2bd5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    2bd8:	ba 56 55 55 55       	mov    $0x55555556,%edx
    2bdd:	89 c8                	mov    %ecx,%eax
    2bdf:	f7 ea                	imul   %edx
    2be1:	89 c8                	mov    %ecx,%eax
    2be3:	c1 f8 1f             	sar    $0x1f,%eax
    2be6:	29 c2                	sub    %eax,%edx
    2be8:	89 d0                	mov    %edx,%eax
    2bea:	01 c0                	add    %eax,%eax
    2bec:	01 d0                	add    %edx,%eax
    2bee:	29 c1                	sub    %eax,%ecx
    2bf0:	89 ca                	mov    %ecx,%edx
    if(((i % 3) == 0 && pid == 0) ||
    2bf2:	83 fa 01             	cmp    $0x1,%edx
    2bf5:	75 74                	jne    2c6b <concreate+0x353>
       ((i % 3) == 1 && pid != 0)){
    2bf7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2bfb:	74 6e                	je     2c6b <concreate+0x353>
      close(open(file, 0));
    2bfd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2c04:	00 
    2c05:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    2c08:	89 04 24             	mov    %eax,(%esp)
    2c0b:	e8 1a 24 00 00       	call   502a <open>
    2c10:	89 04 24             	mov    %eax,(%esp)
    2c13:	e8 fa 23 00 00       	call   5012 <close>
      close(open(file, 0));
    2c18:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2c1f:	00 
    2c20:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    2c23:	89 04 24             	mov    %eax,(%esp)
    2c26:	e8 ff 23 00 00       	call   502a <open>
    2c2b:	89 04 24             	mov    %eax,(%esp)
    2c2e:	e8 df 23 00 00       	call   5012 <close>
      close(open(file, 0));
    2c33:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2c3a:	00 
    2c3b:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    2c3e:	89 04 24             	mov    %eax,(%esp)
    2c41:	e8 e4 23 00 00       	call   502a <open>
    2c46:	89 04 24             	mov    %eax,(%esp)
    2c49:	e8 c4 23 00 00       	call   5012 <close>
      close(open(file, 0));
    2c4e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2c55:	00 
    2c56:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    2c59:	89 04 24             	mov    %eax,(%esp)
    2c5c:	e8 c9 23 00 00       	call   502a <open>
    2c61:	89 04 24             	mov    %eax,(%esp)
    2c64:	e8 a9 23 00 00       	call   5012 <close>
    2c69:	eb 2c                	jmp    2c97 <concreate+0x37f>
    } else {
      unlink(file);
    2c6b:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    2c6e:	89 04 24             	mov    %eax,(%esp)
    2c71:	e8 c4 23 00 00       	call   503a <unlink>
      unlink(file);
    2c76:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    2c79:	89 04 24             	mov    %eax,(%esp)
    2c7c:	e8 b9 23 00 00       	call   503a <unlink>
      unlink(file);
    2c81:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    2c84:	89 04 24             	mov    %eax,(%esp)
    2c87:	e8 ae 23 00 00       	call   503a <unlink>
      unlink(file);
    2c8c:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    2c8f:	89 04 24             	mov    %eax,(%esp)
    2c92:	e8 a3 23 00 00       	call   503a <unlink>
    }
    if(pid == 0)
    2c97:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2c9b:	75 05                	jne    2ca2 <concreate+0x38a>
      exit();
    2c9d:	e8 48 23 00 00       	call   4fea <exit>
    else
      wait();
    2ca2:	e8 4b 23 00 00       	call   4ff2 <wait>
  for(i = 0; i < 40; i++){
    2ca7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2cab:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    2caf:	0f 8e c9 fe ff ff    	jle    2b7e <concreate+0x266>
  }

  printf(1, "concreate ok\n");
    2cb5:	c7 44 24 04 e5 5e 00 	movl   $0x5ee5,0x4(%esp)
    2cbc:	00 
    2cbd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cc4:	e8 b1 24 00 00       	call   517a <printf>
}
    2cc9:	c9                   	leave  
    2cca:	c3                   	ret    

00002ccb <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    2ccb:	55                   	push   %ebp
    2ccc:	89 e5                	mov    %esp,%ebp
    2cce:	83 ec 28             	sub    $0x28,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    2cd1:	c7 44 24 04 f3 5e 00 	movl   $0x5ef3,0x4(%esp)
    2cd8:	00 
    2cd9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ce0:	e8 95 24 00 00       	call   517a <printf>

  unlink("x");
    2ce5:	c7 04 24 6f 5a 00 00 	movl   $0x5a6f,(%esp)
    2cec:	e8 49 23 00 00       	call   503a <unlink>
  pid = fork();
    2cf1:	e8 ec 22 00 00       	call   4fe2 <fork>
    2cf6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid < 0){
    2cf9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2cfd:	79 19                	jns    2d18 <linkunlink+0x4d>
    printf(1, "fork failed\n");
    2cff:	c7 44 24 04 39 56 00 	movl   $0x5639,0x4(%esp)
    2d06:	00 
    2d07:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d0e:	e8 67 24 00 00       	call   517a <printf>
    exit();
    2d13:	e8 d2 22 00 00       	call   4fea <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    2d18:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2d1c:	74 07                	je     2d25 <linkunlink+0x5a>
    2d1e:	b8 01 00 00 00       	mov    $0x1,%eax
    2d23:	eb 05                	jmp    2d2a <linkunlink+0x5f>
    2d25:	b8 61 00 00 00       	mov    $0x61,%eax
    2d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 100; i++){
    2d2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2d34:	e9 8e 00 00 00       	jmp    2dc7 <linkunlink+0xfc>
    x = x * 1103515245 + 12345;
    2d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2d3c:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
    2d42:	05 39 30 00 00       	add    $0x3039,%eax
    2d47:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((x % 3) == 0){
    2d4a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    2d4d:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    2d52:	89 c8                	mov    %ecx,%eax
    2d54:	f7 e2                	mul    %edx
    2d56:	d1 ea                	shr    %edx
    2d58:	89 d0                	mov    %edx,%eax
    2d5a:	01 c0                	add    %eax,%eax
    2d5c:	01 d0                	add    %edx,%eax
    2d5e:	29 c1                	sub    %eax,%ecx
    2d60:	89 ca                	mov    %ecx,%edx
    2d62:	85 d2                	test   %edx,%edx
    2d64:	75 1e                	jne    2d84 <linkunlink+0xb9>
      close(open("x", O_RDWR | O_CREATE));
    2d66:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2d6d:	00 
    2d6e:	c7 04 24 6f 5a 00 00 	movl   $0x5a6f,(%esp)
    2d75:	e8 b0 22 00 00       	call   502a <open>
    2d7a:	89 04 24             	mov    %eax,(%esp)
    2d7d:	e8 90 22 00 00       	call   5012 <close>
    2d82:	eb 3f                	jmp    2dc3 <linkunlink+0xf8>
    } else if((x % 3) == 1){
    2d84:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    2d87:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    2d8c:	89 c8                	mov    %ecx,%eax
    2d8e:	f7 e2                	mul    %edx
    2d90:	d1 ea                	shr    %edx
    2d92:	89 d0                	mov    %edx,%eax
    2d94:	01 c0                	add    %eax,%eax
    2d96:	01 d0                	add    %edx,%eax
    2d98:	29 c1                	sub    %eax,%ecx
    2d9a:	89 ca                	mov    %ecx,%edx
    2d9c:	83 fa 01             	cmp    $0x1,%edx
    2d9f:	75 16                	jne    2db7 <linkunlink+0xec>
      link("cat", "x");
    2da1:	c7 44 24 04 6f 5a 00 	movl   $0x5a6f,0x4(%esp)
    2da8:	00 
    2da9:	c7 04 24 04 5f 00 00 	movl   $0x5f04,(%esp)
    2db0:	e8 95 22 00 00       	call   504a <link>
    2db5:	eb 0c                	jmp    2dc3 <linkunlink+0xf8>
    } else {
      unlink("x");
    2db7:	c7 04 24 6f 5a 00 00 	movl   $0x5a6f,(%esp)
    2dbe:	e8 77 22 00 00       	call   503a <unlink>
  for(i = 0; i < 100; i++){
    2dc3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2dc7:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    2dcb:	0f 8e 68 ff ff ff    	jle    2d39 <linkunlink+0x6e>
    }
  }

  if(pid)
    2dd1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2dd5:	74 07                	je     2dde <linkunlink+0x113>
    wait();
    2dd7:	e8 16 22 00 00       	call   4ff2 <wait>
    2ddc:	eb 05                	jmp    2de3 <linkunlink+0x118>
  else
    exit();
    2dde:	e8 07 22 00 00       	call   4fea <exit>

  printf(1, "linkunlink ok\n");
    2de3:	c7 44 24 04 08 5f 00 	movl   $0x5f08,0x4(%esp)
    2dea:	00 
    2deb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2df2:	e8 83 23 00 00       	call   517a <printf>
}
    2df7:	c9                   	leave  
    2df8:	c3                   	ret    

00002df9 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    2df9:	55                   	push   %ebp
    2dfa:	89 e5                	mov    %esp,%ebp
    2dfc:	83 ec 38             	sub    $0x38,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    2dff:	c7 44 24 04 17 5f 00 	movl   $0x5f17,0x4(%esp)
    2e06:	00 
    2e07:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e0e:	e8 67 23 00 00       	call   517a <printf>
  unlink("bd");
    2e13:	c7 04 24 24 5f 00 00 	movl   $0x5f24,(%esp)
    2e1a:	e8 1b 22 00 00       	call   503a <unlink>

  fd = open("bd", O_CREATE);
    2e1f:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2e26:	00 
    2e27:	c7 04 24 24 5f 00 00 	movl   $0x5f24,(%esp)
    2e2e:	e8 f7 21 00 00       	call   502a <open>
    2e33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    2e36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2e3a:	79 19                	jns    2e55 <bigdir+0x5c>
    printf(1, "bigdir create failed\n");
    2e3c:	c7 44 24 04 27 5f 00 	movl   $0x5f27,0x4(%esp)
    2e43:	00 
    2e44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e4b:	e8 2a 23 00 00       	call   517a <printf>
    exit();
    2e50:	e8 95 21 00 00       	call   4fea <exit>
  }
  close(fd);
    2e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2e58:	89 04 24             	mov    %eax,(%esp)
    2e5b:	e8 b2 21 00 00       	call   5012 <close>

  for(i = 0; i < 500; i++){
    2e60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2e67:	eb 64                	jmp    2ecd <bigdir+0xd4>
    name[0] = 'x';
    2e69:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    2e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2e70:	8d 50 3f             	lea    0x3f(%eax),%edx
    2e73:	85 c0                	test   %eax,%eax
    2e75:	0f 48 c2             	cmovs  %edx,%eax
    2e78:	c1 f8 06             	sar    $0x6,%eax
    2e7b:	83 c0 30             	add    $0x30,%eax
    2e7e:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    2e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2e84:	99                   	cltd   
    2e85:	c1 ea 1a             	shr    $0x1a,%edx
    2e88:	01 d0                	add    %edx,%eax
    2e8a:	83 e0 3f             	and    $0x3f,%eax
    2e8d:	29 d0                	sub    %edx,%eax
    2e8f:	83 c0 30             	add    $0x30,%eax
    2e92:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    2e95:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(link("bd", name) != 0){
    2e99:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    2e9c:	89 44 24 04          	mov    %eax,0x4(%esp)
    2ea0:	c7 04 24 24 5f 00 00 	movl   $0x5f24,(%esp)
    2ea7:	e8 9e 21 00 00       	call   504a <link>
    2eac:	85 c0                	test   %eax,%eax
    2eae:	74 19                	je     2ec9 <bigdir+0xd0>
      printf(1, "bigdir link failed\n");
    2eb0:	c7 44 24 04 3d 5f 00 	movl   $0x5f3d,0x4(%esp)
    2eb7:	00 
    2eb8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ebf:	e8 b6 22 00 00       	call   517a <printf>
      exit();
    2ec4:	e8 21 21 00 00       	call   4fea <exit>
  for(i = 0; i < 500; i++){
    2ec9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2ecd:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    2ed4:	7e 93                	jle    2e69 <bigdir+0x70>
    }
  }

  unlink("bd");
    2ed6:	c7 04 24 24 5f 00 00 	movl   $0x5f24,(%esp)
    2edd:	e8 58 21 00 00       	call   503a <unlink>
  for(i = 0; i < 500; i++){
    2ee2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2ee9:	eb 5c                	jmp    2f47 <bigdir+0x14e>
    name[0] = 'x';
    2eeb:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    2eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2ef2:	8d 50 3f             	lea    0x3f(%eax),%edx
    2ef5:	85 c0                	test   %eax,%eax
    2ef7:	0f 48 c2             	cmovs  %edx,%eax
    2efa:	c1 f8 06             	sar    $0x6,%eax
    2efd:	83 c0 30             	add    $0x30,%eax
    2f00:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    2f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2f06:	99                   	cltd   
    2f07:	c1 ea 1a             	shr    $0x1a,%edx
    2f0a:	01 d0                	add    %edx,%eax
    2f0c:	83 e0 3f             	and    $0x3f,%eax
    2f0f:	29 d0                	sub    %edx,%eax
    2f11:	83 c0 30             	add    $0x30,%eax
    2f14:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    2f17:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(unlink(name) != 0){
    2f1b:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    2f1e:	89 04 24             	mov    %eax,(%esp)
    2f21:	e8 14 21 00 00       	call   503a <unlink>
    2f26:	85 c0                	test   %eax,%eax
    2f28:	74 19                	je     2f43 <bigdir+0x14a>
      printf(1, "bigdir unlink failed");
    2f2a:	c7 44 24 04 51 5f 00 	movl   $0x5f51,0x4(%esp)
    2f31:	00 
    2f32:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f39:	e8 3c 22 00 00       	call   517a <printf>
      exit();
    2f3e:	e8 a7 20 00 00       	call   4fea <exit>
  for(i = 0; i < 500; i++){
    2f43:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    2f47:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    2f4e:	7e 9b                	jle    2eeb <bigdir+0xf2>
    }
  }

  printf(1, "bigdir ok\n");
    2f50:	c7 44 24 04 66 5f 00 	movl   $0x5f66,0x4(%esp)
    2f57:	00 
    2f58:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f5f:	e8 16 22 00 00       	call   517a <printf>
}
    2f64:	c9                   	leave  
    2f65:	c3                   	ret    

00002f66 <subdir>:

void
subdir(void)
{
    2f66:	55                   	push   %ebp
    2f67:	89 e5                	mov    %esp,%ebp
    2f69:	83 ec 28             	sub    $0x28,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    2f6c:	c7 44 24 04 71 5f 00 	movl   $0x5f71,0x4(%esp)
    2f73:	00 
    2f74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2f7b:	e8 fa 21 00 00       	call   517a <printf>

  unlink("ff");
    2f80:	c7 04 24 7e 5f 00 00 	movl   $0x5f7e,(%esp)
    2f87:	e8 ae 20 00 00       	call   503a <unlink>
  if(mkdir("dd") != 0){
    2f8c:	c7 04 24 81 5f 00 00 	movl   $0x5f81,(%esp)
    2f93:	e8 ba 20 00 00       	call   5052 <mkdir>
    2f98:	85 c0                	test   %eax,%eax
    2f9a:	74 19                	je     2fb5 <subdir+0x4f>
    printf(1, "subdir mkdir dd failed\n");
    2f9c:	c7 44 24 04 84 5f 00 	movl   $0x5f84,0x4(%esp)
    2fa3:	00 
    2fa4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2fab:	e8 ca 21 00 00       	call   517a <printf>
    exit();
    2fb0:	e8 35 20 00 00       	call   4fea <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    2fb5:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2fbc:	00 
    2fbd:	c7 04 24 9c 5f 00 00 	movl   $0x5f9c,(%esp)
    2fc4:	e8 61 20 00 00       	call   502a <open>
    2fc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2fcc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2fd0:	79 19                	jns    2feb <subdir+0x85>
    printf(1, "create dd/ff failed\n");
    2fd2:	c7 44 24 04 a2 5f 00 	movl   $0x5fa2,0x4(%esp)
    2fd9:	00 
    2fda:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2fe1:	e8 94 21 00 00       	call   517a <printf>
    exit();
    2fe6:	e8 ff 1f 00 00       	call   4fea <exit>
  }
  write(fd, "ff", 2);
    2feb:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    2ff2:	00 
    2ff3:	c7 44 24 04 7e 5f 00 	movl   $0x5f7e,0x4(%esp)
    2ffa:	00 
    2ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2ffe:	89 04 24             	mov    %eax,(%esp)
    3001:	e8 04 20 00 00       	call   500a <write>
  close(fd);
    3006:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3009:	89 04 24             	mov    %eax,(%esp)
    300c:	e8 01 20 00 00       	call   5012 <close>

  if(unlink("dd") >= 0){
    3011:	c7 04 24 81 5f 00 00 	movl   $0x5f81,(%esp)
    3018:	e8 1d 20 00 00       	call   503a <unlink>
    301d:	85 c0                	test   %eax,%eax
    301f:	78 19                	js     303a <subdir+0xd4>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    3021:	c7 44 24 04 b8 5f 00 	movl   $0x5fb8,0x4(%esp)
    3028:	00 
    3029:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3030:	e8 45 21 00 00       	call   517a <printf>
    exit();
    3035:	e8 b0 1f 00 00       	call   4fea <exit>
  }

  if(mkdir("/dd/dd") != 0){
    303a:	c7 04 24 de 5f 00 00 	movl   $0x5fde,(%esp)
    3041:	e8 0c 20 00 00       	call   5052 <mkdir>
    3046:	85 c0                	test   %eax,%eax
    3048:	74 19                	je     3063 <subdir+0xfd>
    printf(1, "subdir mkdir dd/dd failed\n");
    304a:	c7 44 24 04 e5 5f 00 	movl   $0x5fe5,0x4(%esp)
    3051:	00 
    3052:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3059:	e8 1c 21 00 00       	call   517a <printf>
    exit();
    305e:	e8 87 1f 00 00       	call   4fea <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3063:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    306a:	00 
    306b:	c7 04 24 00 60 00 00 	movl   $0x6000,(%esp)
    3072:	e8 b3 1f 00 00       	call   502a <open>
    3077:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    307a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    307e:	79 19                	jns    3099 <subdir+0x133>
    printf(1, "create dd/dd/ff failed\n");
    3080:	c7 44 24 04 09 60 00 	movl   $0x6009,0x4(%esp)
    3087:	00 
    3088:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    308f:	e8 e6 20 00 00       	call   517a <printf>
    exit();
    3094:	e8 51 1f 00 00       	call   4fea <exit>
  }
  write(fd, "FF", 2);
    3099:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    30a0:	00 
    30a1:	c7 44 24 04 21 60 00 	movl   $0x6021,0x4(%esp)
    30a8:	00 
    30a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    30ac:	89 04 24             	mov    %eax,(%esp)
    30af:	e8 56 1f 00 00       	call   500a <write>
  close(fd);
    30b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    30b7:	89 04 24             	mov    %eax,(%esp)
    30ba:	e8 53 1f 00 00       	call   5012 <close>

  fd = open("dd/dd/../ff", 0);
    30bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    30c6:	00 
    30c7:	c7 04 24 24 60 00 00 	movl   $0x6024,(%esp)
    30ce:	e8 57 1f 00 00       	call   502a <open>
    30d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    30d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    30da:	79 19                	jns    30f5 <subdir+0x18f>
    printf(1, "open dd/dd/../ff failed\n");
    30dc:	c7 44 24 04 30 60 00 	movl   $0x6030,0x4(%esp)
    30e3:	00 
    30e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30eb:	e8 8a 20 00 00       	call   517a <printf>
    exit();
    30f0:	e8 f5 1e 00 00       	call   4fea <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    30f5:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    30fc:	00 
    30fd:	c7 44 24 04 40 9d 00 	movl   $0x9d40,0x4(%esp)
    3104:	00 
    3105:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3108:	89 04 24             	mov    %eax,(%esp)
    310b:	e8 f2 1e 00 00       	call   5002 <read>
    3110:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(cc != 2 || buf[0] != 'f'){
    3113:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
    3117:	75 0b                	jne    3124 <subdir+0x1be>
    3119:	0f b6 05 40 9d 00 00 	movzbl 0x9d40,%eax
    3120:	3c 66                	cmp    $0x66,%al
    3122:	74 19                	je     313d <subdir+0x1d7>
    printf(1, "dd/dd/../ff wrong content\n");
    3124:	c7 44 24 04 49 60 00 	movl   $0x6049,0x4(%esp)
    312b:	00 
    312c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3133:	e8 42 20 00 00       	call   517a <printf>
    exit();
    3138:	e8 ad 1e 00 00       	call   4fea <exit>
  }
  close(fd);
    313d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3140:	89 04 24             	mov    %eax,(%esp)
    3143:	e8 ca 1e 00 00       	call   5012 <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3148:	c7 44 24 04 64 60 00 	movl   $0x6064,0x4(%esp)
    314f:	00 
    3150:	c7 04 24 00 60 00 00 	movl   $0x6000,(%esp)
    3157:	e8 ee 1e 00 00       	call   504a <link>
    315c:	85 c0                	test   %eax,%eax
    315e:	74 19                	je     3179 <subdir+0x213>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    3160:	c7 44 24 04 70 60 00 	movl   $0x6070,0x4(%esp)
    3167:	00 
    3168:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    316f:	e8 06 20 00 00       	call   517a <printf>
    exit();
    3174:	e8 71 1e 00 00       	call   4fea <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    3179:	c7 04 24 00 60 00 00 	movl   $0x6000,(%esp)
    3180:	e8 b5 1e 00 00       	call   503a <unlink>
    3185:	85 c0                	test   %eax,%eax
    3187:	74 19                	je     31a2 <subdir+0x23c>
    printf(1, "unlink dd/dd/ff failed\n");
    3189:	c7 44 24 04 91 60 00 	movl   $0x6091,0x4(%esp)
    3190:	00 
    3191:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3198:	e8 dd 1f 00 00       	call   517a <printf>
    exit();
    319d:	e8 48 1e 00 00       	call   4fea <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    31a2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    31a9:	00 
    31aa:	c7 04 24 00 60 00 00 	movl   $0x6000,(%esp)
    31b1:	e8 74 1e 00 00       	call   502a <open>
    31b6:	85 c0                	test   %eax,%eax
    31b8:	78 19                	js     31d3 <subdir+0x26d>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    31ba:	c7 44 24 04 ac 60 00 	movl   $0x60ac,0x4(%esp)
    31c1:	00 
    31c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    31c9:	e8 ac 1f 00 00       	call   517a <printf>
    exit();
    31ce:	e8 17 1e 00 00       	call   4fea <exit>
  }

  if(chdir("dd") != 0){
    31d3:	c7 04 24 81 5f 00 00 	movl   $0x5f81,(%esp)
    31da:	e8 7b 1e 00 00       	call   505a <chdir>
    31df:	85 c0                	test   %eax,%eax
    31e1:	74 19                	je     31fc <subdir+0x296>
    printf(1, "chdir dd failed\n");
    31e3:	c7 44 24 04 d0 60 00 	movl   $0x60d0,0x4(%esp)
    31ea:	00 
    31eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    31f2:	e8 83 1f 00 00       	call   517a <printf>
    exit();
    31f7:	e8 ee 1d 00 00       	call   4fea <exit>
  }
  if(chdir("dd/../../dd") != 0){
    31fc:	c7 04 24 e1 60 00 00 	movl   $0x60e1,(%esp)
    3203:	e8 52 1e 00 00       	call   505a <chdir>
    3208:	85 c0                	test   %eax,%eax
    320a:	74 19                	je     3225 <subdir+0x2bf>
    printf(1, "chdir dd/../../dd failed\n");
    320c:	c7 44 24 04 ed 60 00 	movl   $0x60ed,0x4(%esp)
    3213:	00 
    3214:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    321b:	e8 5a 1f 00 00       	call   517a <printf>
    exit();
    3220:	e8 c5 1d 00 00       	call   4fea <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    3225:	c7 04 24 07 61 00 00 	movl   $0x6107,(%esp)
    322c:	e8 29 1e 00 00       	call   505a <chdir>
    3231:	85 c0                	test   %eax,%eax
    3233:	74 19                	je     324e <subdir+0x2e8>
    printf(1, "chdir dd/../../dd failed\n");
    3235:	c7 44 24 04 ed 60 00 	movl   $0x60ed,0x4(%esp)
    323c:	00 
    323d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3244:	e8 31 1f 00 00       	call   517a <printf>
    exit();
    3249:	e8 9c 1d 00 00       	call   4fea <exit>
  }
  if(chdir("./..") != 0){
    324e:	c7 04 24 16 61 00 00 	movl   $0x6116,(%esp)
    3255:	e8 00 1e 00 00       	call   505a <chdir>
    325a:	85 c0                	test   %eax,%eax
    325c:	74 19                	je     3277 <subdir+0x311>
    printf(1, "chdir ./.. failed\n");
    325e:	c7 44 24 04 1b 61 00 	movl   $0x611b,0x4(%esp)
    3265:	00 
    3266:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    326d:	e8 08 1f 00 00       	call   517a <printf>
    exit();
    3272:	e8 73 1d 00 00       	call   4fea <exit>
  }

  fd = open("dd/dd/ffff", 0);
    3277:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    327e:	00 
    327f:	c7 04 24 64 60 00 00 	movl   $0x6064,(%esp)
    3286:	e8 9f 1d 00 00       	call   502a <open>
    328b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    328e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3292:	79 19                	jns    32ad <subdir+0x347>
    printf(1, "open dd/dd/ffff failed\n");
    3294:	c7 44 24 04 2e 61 00 	movl   $0x612e,0x4(%esp)
    329b:	00 
    329c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    32a3:	e8 d2 1e 00 00       	call   517a <printf>
    exit();
    32a8:	e8 3d 1d 00 00       	call   4fea <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    32ad:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    32b4:	00 
    32b5:	c7 44 24 04 40 9d 00 	movl   $0x9d40,0x4(%esp)
    32bc:	00 
    32bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    32c0:	89 04 24             	mov    %eax,(%esp)
    32c3:	e8 3a 1d 00 00       	call   5002 <read>
    32c8:	83 f8 02             	cmp    $0x2,%eax
    32cb:	74 19                	je     32e6 <subdir+0x380>
    printf(1, "read dd/dd/ffff wrong len\n");
    32cd:	c7 44 24 04 46 61 00 	movl   $0x6146,0x4(%esp)
    32d4:	00 
    32d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    32dc:	e8 99 1e 00 00       	call   517a <printf>
    exit();
    32e1:	e8 04 1d 00 00       	call   4fea <exit>
  }
  close(fd);
    32e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    32e9:	89 04 24             	mov    %eax,(%esp)
    32ec:	e8 21 1d 00 00       	call   5012 <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    32f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    32f8:	00 
    32f9:	c7 04 24 00 60 00 00 	movl   $0x6000,(%esp)
    3300:	e8 25 1d 00 00       	call   502a <open>
    3305:	85 c0                	test   %eax,%eax
    3307:	78 19                	js     3322 <subdir+0x3bc>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    3309:	c7 44 24 04 64 61 00 	movl   $0x6164,0x4(%esp)
    3310:	00 
    3311:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3318:	e8 5d 1e 00 00       	call   517a <printf>
    exit();
    331d:	e8 c8 1c 00 00       	call   4fea <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3322:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    3329:	00 
    332a:	c7 04 24 89 61 00 00 	movl   $0x6189,(%esp)
    3331:	e8 f4 1c 00 00       	call   502a <open>
    3336:	85 c0                	test   %eax,%eax
    3338:	78 19                	js     3353 <subdir+0x3ed>
    printf(1, "create dd/ff/ff succeeded!\n");
    333a:	c7 44 24 04 92 61 00 	movl   $0x6192,0x4(%esp)
    3341:	00 
    3342:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3349:	e8 2c 1e 00 00       	call   517a <printf>
    exit();
    334e:	e8 97 1c 00 00       	call   4fea <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3353:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    335a:	00 
    335b:	c7 04 24 ae 61 00 00 	movl   $0x61ae,(%esp)
    3362:	e8 c3 1c 00 00       	call   502a <open>
    3367:	85 c0                	test   %eax,%eax
    3369:	78 19                	js     3384 <subdir+0x41e>
    printf(1, "create dd/xx/ff succeeded!\n");
    336b:	c7 44 24 04 b7 61 00 	movl   $0x61b7,0x4(%esp)
    3372:	00 
    3373:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    337a:	e8 fb 1d 00 00       	call   517a <printf>
    exit();
    337f:	e8 66 1c 00 00       	call   4fea <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    3384:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    338b:	00 
    338c:	c7 04 24 81 5f 00 00 	movl   $0x5f81,(%esp)
    3393:	e8 92 1c 00 00       	call   502a <open>
    3398:	85 c0                	test   %eax,%eax
    339a:	78 19                	js     33b5 <subdir+0x44f>
    printf(1, "create dd succeeded!\n");
    339c:	c7 44 24 04 d3 61 00 	movl   $0x61d3,0x4(%esp)
    33a3:	00 
    33a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    33ab:	e8 ca 1d 00 00       	call   517a <printf>
    exit();
    33b0:	e8 35 1c 00 00       	call   4fea <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    33b5:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    33bc:	00 
    33bd:	c7 04 24 81 5f 00 00 	movl   $0x5f81,(%esp)
    33c4:	e8 61 1c 00 00       	call   502a <open>
    33c9:	85 c0                	test   %eax,%eax
    33cb:	78 19                	js     33e6 <subdir+0x480>
    printf(1, "open dd rdwr succeeded!\n");
    33cd:	c7 44 24 04 e9 61 00 	movl   $0x61e9,0x4(%esp)
    33d4:	00 
    33d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    33dc:	e8 99 1d 00 00       	call   517a <printf>
    exit();
    33e1:	e8 04 1c 00 00       	call   4fea <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    33e6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    33ed:	00 
    33ee:	c7 04 24 81 5f 00 00 	movl   $0x5f81,(%esp)
    33f5:	e8 30 1c 00 00       	call   502a <open>
    33fa:	85 c0                	test   %eax,%eax
    33fc:	78 19                	js     3417 <subdir+0x4b1>
    printf(1, "open dd wronly succeeded!\n");
    33fe:	c7 44 24 04 02 62 00 	movl   $0x6202,0x4(%esp)
    3405:	00 
    3406:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    340d:	e8 68 1d 00 00       	call   517a <printf>
    exit();
    3412:	e8 d3 1b 00 00       	call   4fea <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3417:	c7 44 24 04 1d 62 00 	movl   $0x621d,0x4(%esp)
    341e:	00 
    341f:	c7 04 24 89 61 00 00 	movl   $0x6189,(%esp)
    3426:	e8 1f 1c 00 00       	call   504a <link>
    342b:	85 c0                	test   %eax,%eax
    342d:	75 19                	jne    3448 <subdir+0x4e2>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    342f:	c7 44 24 04 28 62 00 	movl   $0x6228,0x4(%esp)
    3436:	00 
    3437:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    343e:	e8 37 1d 00 00       	call   517a <printf>
    exit();
    3443:	e8 a2 1b 00 00       	call   4fea <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3448:	c7 44 24 04 1d 62 00 	movl   $0x621d,0x4(%esp)
    344f:	00 
    3450:	c7 04 24 ae 61 00 00 	movl   $0x61ae,(%esp)
    3457:	e8 ee 1b 00 00       	call   504a <link>
    345c:	85 c0                	test   %eax,%eax
    345e:	75 19                	jne    3479 <subdir+0x513>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    3460:	c7 44 24 04 4c 62 00 	movl   $0x624c,0x4(%esp)
    3467:	00 
    3468:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    346f:	e8 06 1d 00 00       	call   517a <printf>
    exit();
    3474:	e8 71 1b 00 00       	call   4fea <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    3479:	c7 44 24 04 64 60 00 	movl   $0x6064,0x4(%esp)
    3480:	00 
    3481:	c7 04 24 9c 5f 00 00 	movl   $0x5f9c,(%esp)
    3488:	e8 bd 1b 00 00       	call   504a <link>
    348d:	85 c0                	test   %eax,%eax
    348f:	75 19                	jne    34aa <subdir+0x544>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    3491:	c7 44 24 04 70 62 00 	movl   $0x6270,0x4(%esp)
    3498:	00 
    3499:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    34a0:	e8 d5 1c 00 00       	call   517a <printf>
    exit();
    34a5:	e8 40 1b 00 00       	call   4fea <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    34aa:	c7 04 24 89 61 00 00 	movl   $0x6189,(%esp)
    34b1:	e8 9c 1b 00 00       	call   5052 <mkdir>
    34b6:	85 c0                	test   %eax,%eax
    34b8:	75 19                	jne    34d3 <subdir+0x56d>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    34ba:	c7 44 24 04 92 62 00 	movl   $0x6292,0x4(%esp)
    34c1:	00 
    34c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    34c9:	e8 ac 1c 00 00       	call   517a <printf>
    exit();
    34ce:	e8 17 1b 00 00       	call   4fea <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    34d3:	c7 04 24 ae 61 00 00 	movl   $0x61ae,(%esp)
    34da:	e8 73 1b 00 00       	call   5052 <mkdir>
    34df:	85 c0                	test   %eax,%eax
    34e1:	75 19                	jne    34fc <subdir+0x596>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    34e3:	c7 44 24 04 ad 62 00 	movl   $0x62ad,0x4(%esp)
    34ea:	00 
    34eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    34f2:	e8 83 1c 00 00       	call   517a <printf>
    exit();
    34f7:	e8 ee 1a 00 00       	call   4fea <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    34fc:	c7 04 24 64 60 00 00 	movl   $0x6064,(%esp)
    3503:	e8 4a 1b 00 00       	call   5052 <mkdir>
    3508:	85 c0                	test   %eax,%eax
    350a:	75 19                	jne    3525 <subdir+0x5bf>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    350c:	c7 44 24 04 c8 62 00 	movl   $0x62c8,0x4(%esp)
    3513:	00 
    3514:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    351b:	e8 5a 1c 00 00       	call   517a <printf>
    exit();
    3520:	e8 c5 1a 00 00       	call   4fea <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    3525:	c7 04 24 ae 61 00 00 	movl   $0x61ae,(%esp)
    352c:	e8 09 1b 00 00       	call   503a <unlink>
    3531:	85 c0                	test   %eax,%eax
    3533:	75 19                	jne    354e <subdir+0x5e8>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    3535:	c7 44 24 04 e5 62 00 	movl   $0x62e5,0x4(%esp)
    353c:	00 
    353d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3544:	e8 31 1c 00 00       	call   517a <printf>
    exit();
    3549:	e8 9c 1a 00 00       	call   4fea <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    354e:	c7 04 24 89 61 00 00 	movl   $0x6189,(%esp)
    3555:	e8 e0 1a 00 00       	call   503a <unlink>
    355a:	85 c0                	test   %eax,%eax
    355c:	75 19                	jne    3577 <subdir+0x611>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    355e:	c7 44 24 04 01 63 00 	movl   $0x6301,0x4(%esp)
    3565:	00 
    3566:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    356d:	e8 08 1c 00 00       	call   517a <printf>
    exit();
    3572:	e8 73 1a 00 00       	call   4fea <exit>
  }
  if(chdir("dd/ff") == 0){
    3577:	c7 04 24 9c 5f 00 00 	movl   $0x5f9c,(%esp)
    357e:	e8 d7 1a 00 00       	call   505a <chdir>
    3583:	85 c0                	test   %eax,%eax
    3585:	75 19                	jne    35a0 <subdir+0x63a>
    printf(1, "chdir dd/ff succeeded!\n");
    3587:	c7 44 24 04 1d 63 00 	movl   $0x631d,0x4(%esp)
    358e:	00 
    358f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3596:	e8 df 1b 00 00       	call   517a <printf>
    exit();
    359b:	e8 4a 1a 00 00       	call   4fea <exit>
  }
  if(chdir("dd/xx") == 0){
    35a0:	c7 04 24 35 63 00 00 	movl   $0x6335,(%esp)
    35a7:	e8 ae 1a 00 00       	call   505a <chdir>
    35ac:	85 c0                	test   %eax,%eax
    35ae:	75 19                	jne    35c9 <subdir+0x663>
    printf(1, "chdir dd/xx succeeded!\n");
    35b0:	c7 44 24 04 3b 63 00 	movl   $0x633b,0x4(%esp)
    35b7:	00 
    35b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    35bf:	e8 b6 1b 00 00       	call   517a <printf>
    exit();
    35c4:	e8 21 1a 00 00       	call   4fea <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    35c9:	c7 04 24 64 60 00 00 	movl   $0x6064,(%esp)
    35d0:	e8 65 1a 00 00       	call   503a <unlink>
    35d5:	85 c0                	test   %eax,%eax
    35d7:	74 19                	je     35f2 <subdir+0x68c>
    printf(1, "unlink dd/dd/ff failed\n");
    35d9:	c7 44 24 04 91 60 00 	movl   $0x6091,0x4(%esp)
    35e0:	00 
    35e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    35e8:	e8 8d 1b 00 00       	call   517a <printf>
    exit();
    35ed:	e8 f8 19 00 00       	call   4fea <exit>
  }
  if(unlink("dd/ff") != 0){
    35f2:	c7 04 24 9c 5f 00 00 	movl   $0x5f9c,(%esp)
    35f9:	e8 3c 1a 00 00       	call   503a <unlink>
    35fe:	85 c0                	test   %eax,%eax
    3600:	74 19                	je     361b <subdir+0x6b5>
    printf(1, "unlink dd/ff failed\n");
    3602:	c7 44 24 04 53 63 00 	movl   $0x6353,0x4(%esp)
    3609:	00 
    360a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3611:	e8 64 1b 00 00       	call   517a <printf>
    exit();
    3616:	e8 cf 19 00 00       	call   4fea <exit>
  }
  if(unlink("dd") == 0){
    361b:	c7 04 24 81 5f 00 00 	movl   $0x5f81,(%esp)
    3622:	e8 13 1a 00 00       	call   503a <unlink>
    3627:	85 c0                	test   %eax,%eax
    3629:	75 19                	jne    3644 <subdir+0x6de>
    printf(1, "unlink non-empty dd succeeded!\n");
    362b:	c7 44 24 04 68 63 00 	movl   $0x6368,0x4(%esp)
    3632:	00 
    3633:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    363a:	e8 3b 1b 00 00       	call   517a <printf>
    exit();
    363f:	e8 a6 19 00 00       	call   4fea <exit>
  }
  if(unlink("dd/dd") < 0){
    3644:	c7 04 24 88 63 00 00 	movl   $0x6388,(%esp)
    364b:	e8 ea 19 00 00       	call   503a <unlink>
    3650:	85 c0                	test   %eax,%eax
    3652:	79 19                	jns    366d <subdir+0x707>
    printf(1, "unlink dd/dd failed\n");
    3654:	c7 44 24 04 8e 63 00 	movl   $0x638e,0x4(%esp)
    365b:	00 
    365c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3663:	e8 12 1b 00 00       	call   517a <printf>
    exit();
    3668:	e8 7d 19 00 00       	call   4fea <exit>
  }
  if(unlink("dd") < 0){
    366d:	c7 04 24 81 5f 00 00 	movl   $0x5f81,(%esp)
    3674:	e8 c1 19 00 00       	call   503a <unlink>
    3679:	85 c0                	test   %eax,%eax
    367b:	79 19                	jns    3696 <subdir+0x730>
    printf(1, "unlink dd failed\n");
    367d:	c7 44 24 04 a3 63 00 	movl   $0x63a3,0x4(%esp)
    3684:	00 
    3685:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    368c:	e8 e9 1a 00 00       	call   517a <printf>
    exit();
    3691:	e8 54 19 00 00       	call   4fea <exit>
  }

  printf(1, "subdir ok\n");
    3696:	c7 44 24 04 b5 63 00 	movl   $0x63b5,0x4(%esp)
    369d:	00 
    369e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    36a5:	e8 d0 1a 00 00       	call   517a <printf>
}
    36aa:	c9                   	leave  
    36ab:	c3                   	ret    

000036ac <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    36ac:	55                   	push   %ebp
    36ad:	89 e5                	mov    %esp,%ebp
    36af:	83 ec 28             	sub    $0x28,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    36b2:	c7 44 24 04 c0 63 00 	movl   $0x63c0,0x4(%esp)
    36b9:	00 
    36ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    36c1:	e8 b4 1a 00 00       	call   517a <printf>

  unlink("bigwrite");
    36c6:	c7 04 24 cf 63 00 00 	movl   $0x63cf,(%esp)
    36cd:	e8 68 19 00 00       	call   503a <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    36d2:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%ebp)
    36d9:	e9 b3 00 00 00       	jmp    3791 <bigwrite+0xe5>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    36de:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    36e5:	00 
    36e6:	c7 04 24 cf 63 00 00 	movl   $0x63cf,(%esp)
    36ed:	e8 38 19 00 00       	call   502a <open>
    36f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    36f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    36f9:	79 19                	jns    3714 <bigwrite+0x68>
      printf(1, "cannot create bigwrite\n");
    36fb:	c7 44 24 04 d8 63 00 	movl   $0x63d8,0x4(%esp)
    3702:	00 
    3703:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    370a:	e8 6b 1a 00 00       	call   517a <printf>
      exit();
    370f:	e8 d6 18 00 00       	call   4fea <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    3714:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    371b:	eb 50                	jmp    376d <bigwrite+0xc1>
      int cc = write(fd, buf, sz);
    371d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3720:	89 44 24 08          	mov    %eax,0x8(%esp)
    3724:	c7 44 24 04 40 9d 00 	movl   $0x9d40,0x4(%esp)
    372b:	00 
    372c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    372f:	89 04 24             	mov    %eax,(%esp)
    3732:	e8 d3 18 00 00       	call   500a <write>
    3737:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(cc != sz){
    373a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    373d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3740:	74 27                	je     3769 <bigwrite+0xbd>
        printf(1, "write(%d) ret %d\n", sz, cc);
    3742:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3745:	89 44 24 0c          	mov    %eax,0xc(%esp)
    3749:	8b 45 f4             	mov    -0xc(%ebp),%eax
    374c:	89 44 24 08          	mov    %eax,0x8(%esp)
    3750:	c7 44 24 04 f0 63 00 	movl   $0x63f0,0x4(%esp)
    3757:	00 
    3758:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    375f:	e8 16 1a 00 00       	call   517a <printf>
        exit();
    3764:	e8 81 18 00 00       	call   4fea <exit>
    for(i = 0; i < 2; i++){
    3769:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    376d:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    3771:	7e aa                	jle    371d <bigwrite+0x71>
      }
    }
    close(fd);
    3773:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3776:	89 04 24             	mov    %eax,(%esp)
    3779:	e8 94 18 00 00       	call   5012 <close>
    unlink("bigwrite");
    377e:	c7 04 24 cf 63 00 00 	movl   $0x63cf,(%esp)
    3785:	e8 b0 18 00 00       	call   503a <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    378a:	81 45 f4 d7 01 00 00 	addl   $0x1d7,-0xc(%ebp)
    3791:	81 7d f4 ff 17 00 00 	cmpl   $0x17ff,-0xc(%ebp)
    3798:	0f 8e 40 ff ff ff    	jle    36de <bigwrite+0x32>
  }

  printf(1, "bigwrite ok\n");
    379e:	c7 44 24 04 02 64 00 	movl   $0x6402,0x4(%esp)
    37a5:	00 
    37a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    37ad:	e8 c8 19 00 00       	call   517a <printf>
}
    37b2:	c9                   	leave  
    37b3:	c3                   	ret    

000037b4 <bigfile>:

void
bigfile(void)
{
    37b4:	55                   	push   %ebp
    37b5:	89 e5                	mov    %esp,%ebp
    37b7:	83 ec 28             	sub    $0x28,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    37ba:	c7 44 24 04 0f 64 00 	movl   $0x640f,0x4(%esp)
    37c1:	00 
    37c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    37c9:	e8 ac 19 00 00       	call   517a <printf>

  unlink("bigfile");
    37ce:	c7 04 24 1d 64 00 00 	movl   $0x641d,(%esp)
    37d5:	e8 60 18 00 00       	call   503a <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    37da:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    37e1:	00 
    37e2:	c7 04 24 1d 64 00 00 	movl   $0x641d,(%esp)
    37e9:	e8 3c 18 00 00       	call   502a <open>
    37ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    37f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    37f5:	79 19                	jns    3810 <bigfile+0x5c>
    printf(1, "cannot create bigfile");
    37f7:	c7 44 24 04 25 64 00 	movl   $0x6425,0x4(%esp)
    37fe:	00 
    37ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3806:	e8 6f 19 00 00       	call   517a <printf>
    exit();
    380b:	e8 da 17 00 00       	call   4fea <exit>
  }
  for(i = 0; i < 20; i++){
    3810:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3817:	eb 5a                	jmp    3873 <bigfile+0xbf>
    memset(buf, i, 600);
    3819:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    3820:	00 
    3821:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3824:	89 44 24 04          	mov    %eax,0x4(%esp)
    3828:	c7 04 24 40 9d 00 00 	movl   $0x9d40,(%esp)
    382f:	e8 09 16 00 00       	call   4e3d <memset>
    if(write(fd, buf, 600) != 600){
    3834:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    383b:	00 
    383c:	c7 44 24 04 40 9d 00 	movl   $0x9d40,0x4(%esp)
    3843:	00 
    3844:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3847:	89 04 24             	mov    %eax,(%esp)
    384a:	e8 bb 17 00 00       	call   500a <write>
    384f:	3d 58 02 00 00       	cmp    $0x258,%eax
    3854:	74 19                	je     386f <bigfile+0xbb>
      printf(1, "write bigfile failed\n");
    3856:	c7 44 24 04 3b 64 00 	movl   $0x643b,0x4(%esp)
    385d:	00 
    385e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3865:	e8 10 19 00 00       	call   517a <printf>
      exit();
    386a:	e8 7b 17 00 00       	call   4fea <exit>
  for(i = 0; i < 20; i++){
    386f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3873:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    3877:	7e a0                	jle    3819 <bigfile+0x65>
    }
  }
  close(fd);
    3879:	8b 45 ec             	mov    -0x14(%ebp),%eax
    387c:	89 04 24             	mov    %eax,(%esp)
    387f:	e8 8e 17 00 00       	call   5012 <close>

  fd = open("bigfile", 0);
    3884:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    388b:	00 
    388c:	c7 04 24 1d 64 00 00 	movl   $0x641d,(%esp)
    3893:	e8 92 17 00 00       	call   502a <open>
    3898:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    389b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    389f:	79 19                	jns    38ba <bigfile+0x106>
    printf(1, "cannot open bigfile\n");
    38a1:	c7 44 24 04 51 64 00 	movl   $0x6451,0x4(%esp)
    38a8:	00 
    38a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    38b0:	e8 c5 18 00 00       	call   517a <printf>
    exit();
    38b5:	e8 30 17 00 00       	call   4fea <exit>
  }
  total = 0;
    38ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0; ; i++){
    38c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    cc = read(fd, buf, 300);
    38c8:	c7 44 24 08 2c 01 00 	movl   $0x12c,0x8(%esp)
    38cf:	00 
    38d0:	c7 44 24 04 40 9d 00 	movl   $0x9d40,0x4(%esp)
    38d7:	00 
    38d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    38db:	89 04 24             	mov    %eax,(%esp)
    38de:	e8 1f 17 00 00       	call   5002 <read>
    38e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(cc < 0){
    38e6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    38ea:	79 19                	jns    3905 <bigfile+0x151>
      printf(1, "read bigfile failed\n");
    38ec:	c7 44 24 04 66 64 00 	movl   $0x6466,0x4(%esp)
    38f3:	00 
    38f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    38fb:	e8 7a 18 00 00       	call   517a <printf>
      exit();
    3900:	e8 e5 16 00 00       	call   4fea <exit>
    }
    if(cc == 0)
    3905:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    3909:	75 1b                	jne    3926 <bigfile+0x172>
      break;
    390b:	90                   	nop
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
  close(fd);
    390c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    390f:	89 04 24             	mov    %eax,(%esp)
    3912:	e8 fb 16 00 00       	call   5012 <close>
  if(total != 20*600){
    3917:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    391e:	0f 84 99 00 00 00    	je     39bd <bigfile+0x209>
    3924:	eb 7e                	jmp    39a4 <bigfile+0x1f0>
    if(cc != 300){
    3926:	81 7d e8 2c 01 00 00 	cmpl   $0x12c,-0x18(%ebp)
    392d:	74 19                	je     3948 <bigfile+0x194>
      printf(1, "short read bigfile\n");
    392f:	c7 44 24 04 7b 64 00 	movl   $0x647b,0x4(%esp)
    3936:	00 
    3937:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    393e:	e8 37 18 00 00       	call   517a <printf>
      exit();
    3943:	e8 a2 16 00 00       	call   4fea <exit>
    if(buf[0] != i/2 || buf[299] != i/2){
    3948:	0f b6 05 40 9d 00 00 	movzbl 0x9d40,%eax
    394f:	0f be d0             	movsbl %al,%edx
    3952:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3955:	89 c1                	mov    %eax,%ecx
    3957:	c1 e9 1f             	shr    $0x1f,%ecx
    395a:	01 c8                	add    %ecx,%eax
    395c:	d1 f8                	sar    %eax
    395e:	39 c2                	cmp    %eax,%edx
    3960:	75 1a                	jne    397c <bigfile+0x1c8>
    3962:	0f b6 05 6b 9e 00 00 	movzbl 0x9e6b,%eax
    3969:	0f be d0             	movsbl %al,%edx
    396c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    396f:	89 c1                	mov    %eax,%ecx
    3971:	c1 e9 1f             	shr    $0x1f,%ecx
    3974:	01 c8                	add    %ecx,%eax
    3976:	d1 f8                	sar    %eax
    3978:	39 c2                	cmp    %eax,%edx
    397a:	74 19                	je     3995 <bigfile+0x1e1>
      printf(1, "read bigfile wrong data\n");
    397c:	c7 44 24 04 8f 64 00 	movl   $0x648f,0x4(%esp)
    3983:	00 
    3984:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    398b:	e8 ea 17 00 00       	call   517a <printf>
      exit();
    3990:	e8 55 16 00 00       	call   4fea <exit>
    total += cc;
    3995:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3998:	01 45 f0             	add    %eax,-0x10(%ebp)
  for(i = 0; ; i++){
    399b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }
    399f:	e9 24 ff ff ff       	jmp    38c8 <bigfile+0x114>
    printf(1, "read bigfile wrong total\n");
    39a4:	c7 44 24 04 a8 64 00 	movl   $0x64a8,0x4(%esp)
    39ab:	00 
    39ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    39b3:	e8 c2 17 00 00       	call   517a <printf>
    exit();
    39b8:	e8 2d 16 00 00       	call   4fea <exit>
  }
  unlink("bigfile");
    39bd:	c7 04 24 1d 64 00 00 	movl   $0x641d,(%esp)
    39c4:	e8 71 16 00 00       	call   503a <unlink>

  printf(1, "bigfile test ok\n");
    39c9:	c7 44 24 04 c2 64 00 	movl   $0x64c2,0x4(%esp)
    39d0:	00 
    39d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    39d8:	e8 9d 17 00 00       	call   517a <printf>
}
    39dd:	c9                   	leave  
    39de:	c3                   	ret    

000039df <fourteen>:

void
fourteen(void)
{
    39df:	55                   	push   %ebp
    39e0:	89 e5                	mov    %esp,%ebp
    39e2:	83 ec 28             	sub    $0x28,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    39e5:	c7 44 24 04 d3 64 00 	movl   $0x64d3,0x4(%esp)
    39ec:	00 
    39ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    39f4:	e8 81 17 00 00       	call   517a <printf>

  if(mkdir("12345678901234") != 0){
    39f9:	c7 04 24 e2 64 00 00 	movl   $0x64e2,(%esp)
    3a00:	e8 4d 16 00 00       	call   5052 <mkdir>
    3a05:	85 c0                	test   %eax,%eax
    3a07:	74 19                	je     3a22 <fourteen+0x43>
    printf(1, "mkdir 12345678901234 failed\n");
    3a09:	c7 44 24 04 f1 64 00 	movl   $0x64f1,0x4(%esp)
    3a10:	00 
    3a11:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3a18:	e8 5d 17 00 00       	call   517a <printf>
    exit();
    3a1d:	e8 c8 15 00 00       	call   4fea <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    3a22:	c7 04 24 10 65 00 00 	movl   $0x6510,(%esp)
    3a29:	e8 24 16 00 00       	call   5052 <mkdir>
    3a2e:	85 c0                	test   %eax,%eax
    3a30:	74 19                	je     3a4b <fourteen+0x6c>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    3a32:	c7 44 24 04 30 65 00 	movl   $0x6530,0x4(%esp)
    3a39:	00 
    3a3a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3a41:	e8 34 17 00 00       	call   517a <printf>
    exit();
    3a46:	e8 9f 15 00 00       	call   4fea <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    3a4b:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3a52:	00 
    3a53:	c7 04 24 60 65 00 00 	movl   $0x6560,(%esp)
    3a5a:	e8 cb 15 00 00       	call   502a <open>
    3a5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    3a62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3a66:	79 19                	jns    3a81 <fourteen+0xa2>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    3a68:	c7 44 24 04 90 65 00 	movl   $0x6590,0x4(%esp)
    3a6f:	00 
    3a70:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3a77:	e8 fe 16 00 00       	call   517a <printf>
    exit();
    3a7c:	e8 69 15 00 00       	call   4fea <exit>
  }
  close(fd);
    3a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3a84:	89 04 24             	mov    %eax,(%esp)
    3a87:	e8 86 15 00 00       	call   5012 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    3a8c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3a93:	00 
    3a94:	c7 04 24 d0 65 00 00 	movl   $0x65d0,(%esp)
    3a9b:	e8 8a 15 00 00       	call   502a <open>
    3aa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    3aa3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3aa7:	79 19                	jns    3ac2 <fourteen+0xe3>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    3aa9:	c7 44 24 04 00 66 00 	movl   $0x6600,0x4(%esp)
    3ab0:	00 
    3ab1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3ab8:	e8 bd 16 00 00       	call   517a <printf>
    exit();
    3abd:	e8 28 15 00 00       	call   4fea <exit>
  }
  close(fd);
    3ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3ac5:	89 04 24             	mov    %eax,(%esp)
    3ac8:	e8 45 15 00 00       	call   5012 <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    3acd:	c7 04 24 3a 66 00 00 	movl   $0x663a,(%esp)
    3ad4:	e8 79 15 00 00       	call   5052 <mkdir>
    3ad9:	85 c0                	test   %eax,%eax
    3adb:	75 19                	jne    3af6 <fourteen+0x117>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    3add:	c7 44 24 04 58 66 00 	movl   $0x6658,0x4(%esp)
    3ae4:	00 
    3ae5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3aec:	e8 89 16 00 00       	call   517a <printf>
    exit();
    3af1:	e8 f4 14 00 00       	call   4fea <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    3af6:	c7 04 24 88 66 00 00 	movl   $0x6688,(%esp)
    3afd:	e8 50 15 00 00       	call   5052 <mkdir>
    3b02:	85 c0                	test   %eax,%eax
    3b04:	75 19                	jne    3b1f <fourteen+0x140>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    3b06:	c7 44 24 04 a8 66 00 	movl   $0x66a8,0x4(%esp)
    3b0d:	00 
    3b0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b15:	e8 60 16 00 00       	call   517a <printf>
    exit();
    3b1a:	e8 cb 14 00 00       	call   4fea <exit>
  }

  printf(1, "fourteen ok\n");
    3b1f:	c7 44 24 04 d9 66 00 	movl   $0x66d9,0x4(%esp)
    3b26:	00 
    3b27:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b2e:	e8 47 16 00 00       	call   517a <printf>
}
    3b33:	c9                   	leave  
    3b34:	c3                   	ret    

00003b35 <rmdot>:

void
rmdot(void)
{
    3b35:	55                   	push   %ebp
    3b36:	89 e5                	mov    %esp,%ebp
    3b38:	83 ec 18             	sub    $0x18,%esp
  printf(1, "rmdot test\n");
    3b3b:	c7 44 24 04 e6 66 00 	movl   $0x66e6,0x4(%esp)
    3b42:	00 
    3b43:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b4a:	e8 2b 16 00 00       	call   517a <printf>
  if(mkdir("dots") != 0){
    3b4f:	c7 04 24 f2 66 00 00 	movl   $0x66f2,(%esp)
    3b56:	e8 f7 14 00 00       	call   5052 <mkdir>
    3b5b:	85 c0                	test   %eax,%eax
    3b5d:	74 19                	je     3b78 <rmdot+0x43>
    printf(1, "mkdir dots failed\n");
    3b5f:	c7 44 24 04 f7 66 00 	movl   $0x66f7,0x4(%esp)
    3b66:	00 
    3b67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b6e:	e8 07 16 00 00       	call   517a <printf>
    exit();
    3b73:	e8 72 14 00 00       	call   4fea <exit>
  }
  if(chdir("dots") != 0){
    3b78:	c7 04 24 f2 66 00 00 	movl   $0x66f2,(%esp)
    3b7f:	e8 d6 14 00 00       	call   505a <chdir>
    3b84:	85 c0                	test   %eax,%eax
    3b86:	74 19                	je     3ba1 <rmdot+0x6c>
    printf(1, "chdir dots failed\n");
    3b88:	c7 44 24 04 0a 67 00 	movl   $0x670a,0x4(%esp)
    3b8f:	00 
    3b90:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b97:	e8 de 15 00 00       	call   517a <printf>
    exit();
    3b9c:	e8 49 14 00 00       	call   4fea <exit>
  }
  if(unlink(".") == 0){
    3ba1:	c7 04 24 23 5e 00 00 	movl   $0x5e23,(%esp)
    3ba8:	e8 8d 14 00 00       	call   503a <unlink>
    3bad:	85 c0                	test   %eax,%eax
    3baf:	75 19                	jne    3bca <rmdot+0x95>
    printf(1, "rm . worked!\n");
    3bb1:	c7 44 24 04 1d 67 00 	movl   $0x671d,0x4(%esp)
    3bb8:	00 
    3bb9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3bc0:	e8 b5 15 00 00       	call   517a <printf>
    exit();
    3bc5:	e8 20 14 00 00       	call   4fea <exit>
  }
  if(unlink("..") == 0){
    3bca:	c7 04 24 b6 59 00 00 	movl   $0x59b6,(%esp)
    3bd1:	e8 64 14 00 00       	call   503a <unlink>
    3bd6:	85 c0                	test   %eax,%eax
    3bd8:	75 19                	jne    3bf3 <rmdot+0xbe>
    printf(1, "rm .. worked!\n");
    3bda:	c7 44 24 04 2b 67 00 	movl   $0x672b,0x4(%esp)
    3be1:	00 
    3be2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3be9:	e8 8c 15 00 00       	call   517a <printf>
    exit();
    3bee:	e8 f7 13 00 00       	call   4fea <exit>
  }
  if(chdir("/") != 0){
    3bf3:	c7 04 24 0a 56 00 00 	movl   $0x560a,(%esp)
    3bfa:	e8 5b 14 00 00       	call   505a <chdir>
    3bff:	85 c0                	test   %eax,%eax
    3c01:	74 19                	je     3c1c <rmdot+0xe7>
    printf(1, "chdir / failed\n");
    3c03:	c7 44 24 04 0c 56 00 	movl   $0x560c,0x4(%esp)
    3c0a:	00 
    3c0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3c12:	e8 63 15 00 00       	call   517a <printf>
    exit();
    3c17:	e8 ce 13 00 00       	call   4fea <exit>
  }
  if(unlink("dots/.") == 0){
    3c1c:	c7 04 24 3a 67 00 00 	movl   $0x673a,(%esp)
    3c23:	e8 12 14 00 00       	call   503a <unlink>
    3c28:	85 c0                	test   %eax,%eax
    3c2a:	75 19                	jne    3c45 <rmdot+0x110>
    printf(1, "unlink dots/. worked!\n");
    3c2c:	c7 44 24 04 41 67 00 	movl   $0x6741,0x4(%esp)
    3c33:	00 
    3c34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3c3b:	e8 3a 15 00 00       	call   517a <printf>
    exit();
    3c40:	e8 a5 13 00 00       	call   4fea <exit>
  }
  if(unlink("dots/..") == 0){
    3c45:	c7 04 24 58 67 00 00 	movl   $0x6758,(%esp)
    3c4c:	e8 e9 13 00 00       	call   503a <unlink>
    3c51:	85 c0                	test   %eax,%eax
    3c53:	75 19                	jne    3c6e <rmdot+0x139>
    printf(1, "unlink dots/.. worked!\n");
    3c55:	c7 44 24 04 60 67 00 	movl   $0x6760,0x4(%esp)
    3c5c:	00 
    3c5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3c64:	e8 11 15 00 00       	call   517a <printf>
    exit();
    3c69:	e8 7c 13 00 00       	call   4fea <exit>
  }
  if(unlink("dots") != 0){
    3c6e:	c7 04 24 f2 66 00 00 	movl   $0x66f2,(%esp)
    3c75:	e8 c0 13 00 00       	call   503a <unlink>
    3c7a:	85 c0                	test   %eax,%eax
    3c7c:	74 19                	je     3c97 <rmdot+0x162>
    printf(1, "unlink dots failed!\n");
    3c7e:	c7 44 24 04 78 67 00 	movl   $0x6778,0x4(%esp)
    3c85:	00 
    3c86:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3c8d:	e8 e8 14 00 00       	call   517a <printf>
    exit();
    3c92:	e8 53 13 00 00       	call   4fea <exit>
  }
  printf(1, "rmdot ok\n");
    3c97:	c7 44 24 04 8d 67 00 	movl   $0x678d,0x4(%esp)
    3c9e:	00 
    3c9f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3ca6:	e8 cf 14 00 00       	call   517a <printf>
}
    3cab:	c9                   	leave  
    3cac:	c3                   	ret    

00003cad <dirfile>:

void
dirfile(void)
{
    3cad:	55                   	push   %ebp
    3cae:	89 e5                	mov    %esp,%ebp
    3cb0:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(1, "dir vs file\n");
    3cb3:	c7 44 24 04 97 67 00 	movl   $0x6797,0x4(%esp)
    3cba:	00 
    3cbb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3cc2:	e8 b3 14 00 00       	call   517a <printf>

  fd = open("dirfile", O_CREATE);
    3cc7:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3cce:	00 
    3ccf:	c7 04 24 a4 67 00 00 	movl   $0x67a4,(%esp)
    3cd6:	e8 4f 13 00 00       	call   502a <open>
    3cdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    3cde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3ce2:	79 19                	jns    3cfd <dirfile+0x50>
    printf(1, "create dirfile failed\n");
    3ce4:	c7 44 24 04 ac 67 00 	movl   $0x67ac,0x4(%esp)
    3ceb:	00 
    3cec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3cf3:	e8 82 14 00 00       	call   517a <printf>
    exit();
    3cf8:	e8 ed 12 00 00       	call   4fea <exit>
  }
  close(fd);
    3cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3d00:	89 04 24             	mov    %eax,(%esp)
    3d03:	e8 0a 13 00 00       	call   5012 <close>
  if(chdir("dirfile") == 0){
    3d08:	c7 04 24 a4 67 00 00 	movl   $0x67a4,(%esp)
    3d0f:	e8 46 13 00 00       	call   505a <chdir>
    3d14:	85 c0                	test   %eax,%eax
    3d16:	75 19                	jne    3d31 <dirfile+0x84>
    printf(1, "chdir dirfile succeeded!\n");
    3d18:	c7 44 24 04 c3 67 00 	movl   $0x67c3,0x4(%esp)
    3d1f:	00 
    3d20:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3d27:	e8 4e 14 00 00       	call   517a <printf>
    exit();
    3d2c:	e8 b9 12 00 00       	call   4fea <exit>
  }
  fd = open("dirfile/xx", 0);
    3d31:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3d38:	00 
    3d39:	c7 04 24 dd 67 00 00 	movl   $0x67dd,(%esp)
    3d40:	e8 e5 12 00 00       	call   502a <open>
    3d45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    3d48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3d4c:	78 19                	js     3d67 <dirfile+0xba>
    printf(1, "create dirfile/xx succeeded!\n");
    3d4e:	c7 44 24 04 e8 67 00 	movl   $0x67e8,0x4(%esp)
    3d55:	00 
    3d56:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3d5d:	e8 18 14 00 00       	call   517a <printf>
    exit();
    3d62:	e8 83 12 00 00       	call   4fea <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    3d67:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3d6e:	00 
    3d6f:	c7 04 24 dd 67 00 00 	movl   $0x67dd,(%esp)
    3d76:	e8 af 12 00 00       	call   502a <open>
    3d7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    3d7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3d82:	78 19                	js     3d9d <dirfile+0xf0>
    printf(1, "create dirfile/xx succeeded!\n");
    3d84:	c7 44 24 04 e8 67 00 	movl   $0x67e8,0x4(%esp)
    3d8b:	00 
    3d8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3d93:	e8 e2 13 00 00       	call   517a <printf>
    exit();
    3d98:	e8 4d 12 00 00       	call   4fea <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    3d9d:	c7 04 24 dd 67 00 00 	movl   $0x67dd,(%esp)
    3da4:	e8 a9 12 00 00       	call   5052 <mkdir>
    3da9:	85 c0                	test   %eax,%eax
    3dab:	75 19                	jne    3dc6 <dirfile+0x119>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    3dad:	c7 44 24 04 06 68 00 	movl   $0x6806,0x4(%esp)
    3db4:	00 
    3db5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3dbc:	e8 b9 13 00 00       	call   517a <printf>
    exit();
    3dc1:	e8 24 12 00 00       	call   4fea <exit>
  }
  if(unlink("dirfile/xx") == 0){
    3dc6:	c7 04 24 dd 67 00 00 	movl   $0x67dd,(%esp)
    3dcd:	e8 68 12 00 00       	call   503a <unlink>
    3dd2:	85 c0                	test   %eax,%eax
    3dd4:	75 19                	jne    3def <dirfile+0x142>
    printf(1, "unlink dirfile/xx succeeded!\n");
    3dd6:	c7 44 24 04 23 68 00 	movl   $0x6823,0x4(%esp)
    3ddd:	00 
    3dde:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3de5:	e8 90 13 00 00       	call   517a <printf>
    exit();
    3dea:	e8 fb 11 00 00       	call   4fea <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    3def:	c7 44 24 04 dd 67 00 	movl   $0x67dd,0x4(%esp)
    3df6:	00 
    3df7:	c7 04 24 41 68 00 00 	movl   $0x6841,(%esp)
    3dfe:	e8 47 12 00 00       	call   504a <link>
    3e03:	85 c0                	test   %eax,%eax
    3e05:	75 19                	jne    3e20 <dirfile+0x173>
    printf(1, "link to dirfile/xx succeeded!\n");
    3e07:	c7 44 24 04 48 68 00 	movl   $0x6848,0x4(%esp)
    3e0e:	00 
    3e0f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3e16:	e8 5f 13 00 00       	call   517a <printf>
    exit();
    3e1b:	e8 ca 11 00 00       	call   4fea <exit>
  }
  if(unlink("dirfile") != 0){
    3e20:	c7 04 24 a4 67 00 00 	movl   $0x67a4,(%esp)
    3e27:	e8 0e 12 00 00       	call   503a <unlink>
    3e2c:	85 c0                	test   %eax,%eax
    3e2e:	74 19                	je     3e49 <dirfile+0x19c>
    printf(1, "unlink dirfile failed!\n");
    3e30:	c7 44 24 04 67 68 00 	movl   $0x6867,0x4(%esp)
    3e37:	00 
    3e38:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3e3f:	e8 36 13 00 00       	call   517a <printf>
    exit();
    3e44:	e8 a1 11 00 00       	call   4fea <exit>
  }

  fd = open(".", O_RDWR);
    3e49:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    3e50:	00 
    3e51:	c7 04 24 23 5e 00 00 	movl   $0x5e23,(%esp)
    3e58:	e8 cd 11 00 00       	call   502a <open>
    3e5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    3e60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3e64:	78 19                	js     3e7f <dirfile+0x1d2>
    printf(1, "open . for writing succeeded!\n");
    3e66:	c7 44 24 04 80 68 00 	movl   $0x6880,0x4(%esp)
    3e6d:	00 
    3e6e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3e75:	e8 00 13 00 00       	call   517a <printf>
    exit();
    3e7a:	e8 6b 11 00 00       	call   4fea <exit>
  }
  fd = open(".", 0);
    3e7f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3e86:	00 
    3e87:	c7 04 24 23 5e 00 00 	movl   $0x5e23,(%esp)
    3e8e:	e8 97 11 00 00       	call   502a <open>
    3e93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(write(fd, "x", 1) > 0){
    3e96:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3e9d:	00 
    3e9e:	c7 44 24 04 6f 5a 00 	movl   $0x5a6f,0x4(%esp)
    3ea5:	00 
    3ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3ea9:	89 04 24             	mov    %eax,(%esp)
    3eac:	e8 59 11 00 00       	call   500a <write>
    3eb1:	85 c0                	test   %eax,%eax
    3eb3:	7e 19                	jle    3ece <dirfile+0x221>
    printf(1, "write . succeeded!\n");
    3eb5:	c7 44 24 04 9f 68 00 	movl   $0x689f,0x4(%esp)
    3ebc:	00 
    3ebd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3ec4:	e8 b1 12 00 00       	call   517a <printf>
    exit();
    3ec9:	e8 1c 11 00 00       	call   4fea <exit>
  }
  close(fd);
    3ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3ed1:	89 04 24             	mov    %eax,(%esp)
    3ed4:	e8 39 11 00 00       	call   5012 <close>

  printf(1, "dir vs file OK\n");
    3ed9:	c7 44 24 04 b3 68 00 	movl   $0x68b3,0x4(%esp)
    3ee0:	00 
    3ee1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3ee8:	e8 8d 12 00 00       	call   517a <printf>
}
    3eed:	c9                   	leave  
    3eee:	c3                   	ret    

00003eef <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    3eef:	55                   	push   %ebp
    3ef0:	89 e5                	mov    %esp,%ebp
    3ef2:	83 ec 28             	sub    $0x28,%esp
  int i, fd;

  printf(1, "empty file name\n");
    3ef5:	c7 44 24 04 c3 68 00 	movl   $0x68c3,0x4(%esp)
    3efc:	00 
    3efd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3f04:	e8 71 12 00 00       	call   517a <printf>

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    3f09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3f10:	e9 d2 00 00 00       	jmp    3fe7 <iref+0xf8>
    if(mkdir("irefd") != 0){
    3f15:	c7 04 24 d4 68 00 00 	movl   $0x68d4,(%esp)
    3f1c:	e8 31 11 00 00       	call   5052 <mkdir>
    3f21:	85 c0                	test   %eax,%eax
    3f23:	74 19                	je     3f3e <iref+0x4f>
      printf(1, "mkdir irefd failed\n");
    3f25:	c7 44 24 04 da 68 00 	movl   $0x68da,0x4(%esp)
    3f2c:	00 
    3f2d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3f34:	e8 41 12 00 00       	call   517a <printf>
      exit();
    3f39:	e8 ac 10 00 00       	call   4fea <exit>
    }
    if(chdir("irefd") != 0){
    3f3e:	c7 04 24 d4 68 00 00 	movl   $0x68d4,(%esp)
    3f45:	e8 10 11 00 00       	call   505a <chdir>
    3f4a:	85 c0                	test   %eax,%eax
    3f4c:	74 19                	je     3f67 <iref+0x78>
      printf(1, "chdir irefd failed\n");
    3f4e:	c7 44 24 04 ee 68 00 	movl   $0x68ee,0x4(%esp)
    3f55:	00 
    3f56:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3f5d:	e8 18 12 00 00       	call   517a <printf>
      exit();
    3f62:	e8 83 10 00 00       	call   4fea <exit>
    }

    mkdir("");
    3f67:	c7 04 24 02 69 00 00 	movl   $0x6902,(%esp)
    3f6e:	e8 df 10 00 00       	call   5052 <mkdir>
    link("README", "");
    3f73:	c7 44 24 04 02 69 00 	movl   $0x6902,0x4(%esp)
    3f7a:	00 
    3f7b:	c7 04 24 41 68 00 00 	movl   $0x6841,(%esp)
    3f82:	e8 c3 10 00 00       	call   504a <link>
    fd = open("", O_CREATE);
    3f87:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3f8e:	00 
    3f8f:	c7 04 24 02 69 00 00 	movl   $0x6902,(%esp)
    3f96:	e8 8f 10 00 00       	call   502a <open>
    3f9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    3f9e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3fa2:	78 0b                	js     3faf <iref+0xc0>
      close(fd);
    3fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3fa7:	89 04 24             	mov    %eax,(%esp)
    3faa:	e8 63 10 00 00       	call   5012 <close>
    fd = open("xx", O_CREATE);
    3faf:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3fb6:	00 
    3fb7:	c7 04 24 03 69 00 00 	movl   $0x6903,(%esp)
    3fbe:	e8 67 10 00 00       	call   502a <open>
    3fc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    3fc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3fca:	78 0b                	js     3fd7 <iref+0xe8>
      close(fd);
    3fcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3fcf:	89 04 24             	mov    %eax,(%esp)
    3fd2:	e8 3b 10 00 00       	call   5012 <close>
    unlink("xx");
    3fd7:	c7 04 24 03 69 00 00 	movl   $0x6903,(%esp)
    3fde:	e8 57 10 00 00       	call   503a <unlink>
  for(i = 0; i < 50 + 1; i++){
    3fe3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    3fe7:	83 7d f4 32          	cmpl   $0x32,-0xc(%ebp)
    3feb:	0f 8e 24 ff ff ff    	jle    3f15 <iref+0x26>
  }

  chdir("/");
    3ff1:	c7 04 24 0a 56 00 00 	movl   $0x560a,(%esp)
    3ff8:	e8 5d 10 00 00       	call   505a <chdir>
  printf(1, "empty file name OK\n");
    3ffd:	c7 44 24 04 06 69 00 	movl   $0x6906,0x4(%esp)
    4004:	00 
    4005:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    400c:	e8 69 11 00 00       	call   517a <printf>
}
    4011:	c9                   	leave  
    4012:	c3                   	ret    

00004013 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    4013:	55                   	push   %ebp
    4014:	89 e5                	mov    %esp,%ebp
    4016:	83 ec 28             	sub    $0x28,%esp
  int n, pid;

  printf(1, "fork test\n");
    4019:	c7 44 24 04 1a 69 00 	movl   $0x691a,0x4(%esp)
    4020:	00 
    4021:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    4028:	e8 4d 11 00 00       	call   517a <printf>

  for(n=0; n<1000; n++){
    402d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    4034:	eb 1f                	jmp    4055 <forktest+0x42>
    pid = fork();
    4036:	e8 a7 0f 00 00       	call   4fe2 <fork>
    403b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    403e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4042:	79 02                	jns    4046 <forktest+0x33>
      break;
    4044:	eb 18                	jmp    405e <forktest+0x4b>
    if(pid == 0)
    4046:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    404a:	75 05                	jne    4051 <forktest+0x3e>
      exit();
    404c:	e8 99 0f 00 00       	call   4fea <exit>
  for(n=0; n<1000; n++){
    4051:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    4055:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    405c:	7e d8                	jle    4036 <forktest+0x23>
  }

  if(n == 1000){
    405e:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
    4065:	75 19                	jne    4080 <forktest+0x6d>
    printf(1, "fork claimed to work 1000 times!\n");
    4067:	c7 44 24 04 28 69 00 	movl   $0x6928,0x4(%esp)
    406e:	00 
    406f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    4076:	e8 ff 10 00 00       	call   517a <printf>
    exit();
    407b:	e8 6a 0f 00 00       	call   4fea <exit>
  }

  for(; n > 0; n--){
    4080:	eb 26                	jmp    40a8 <forktest+0x95>
    if(wait() < 0){
    4082:	e8 6b 0f 00 00       	call   4ff2 <wait>
    4087:	85 c0                	test   %eax,%eax
    4089:	79 19                	jns    40a4 <forktest+0x91>
      printf(1, "wait stopped early\n");
    408b:	c7 44 24 04 4a 69 00 	movl   $0x694a,0x4(%esp)
    4092:	00 
    4093:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    409a:	e8 db 10 00 00       	call   517a <printf>
      exit();
    409f:	e8 46 0f 00 00       	call   4fea <exit>
  for(; n > 0; n--){
    40a4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    40a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    40ac:	7f d4                	jg     4082 <forktest+0x6f>
    }
  }

  if(wait() != -1){
    40ae:	e8 3f 0f 00 00       	call   4ff2 <wait>
    40b3:	83 f8 ff             	cmp    $0xffffffff,%eax
    40b6:	74 19                	je     40d1 <forktest+0xbe>
    printf(1, "wait got too many\n");
    40b8:	c7 44 24 04 5e 69 00 	movl   $0x695e,0x4(%esp)
    40bf:	00 
    40c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    40c7:	e8 ae 10 00 00       	call   517a <printf>
    exit();
    40cc:	e8 19 0f 00 00       	call   4fea <exit>
  }

  printf(1, "fork test OK\n");
    40d1:	c7 44 24 04 71 69 00 	movl   $0x6971,0x4(%esp)
    40d8:	00 
    40d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    40e0:	e8 95 10 00 00       	call   517a <printf>
}
    40e5:	c9                   	leave  
    40e6:	c3                   	ret    

000040e7 <sbrktest>:

void
sbrktest(void)
{
    40e7:	55                   	push   %ebp
    40e8:	89 e5                	mov    %esp,%ebp
    40ea:	53                   	push   %ebx
    40eb:	81 ec 84 00 00 00    	sub    $0x84,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    40f1:	a1 58 75 00 00       	mov    0x7558,%eax
    40f6:	c7 44 24 04 7f 69 00 	movl   $0x697f,0x4(%esp)
    40fd:	00 
    40fe:	89 04 24             	mov    %eax,(%esp)
    4101:	e8 74 10 00 00       	call   517a <printf>
  oldbrk = sbrk(0);
    4106:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    410d:	e8 60 0f 00 00       	call   5072 <sbrk>
    4112:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    4115:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    411c:	e8 51 0f 00 00       	call   5072 <sbrk>
    4121:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int i;
  for(i = 0; i < 5000; i++){
    4124:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    412b:	eb 59                	jmp    4186 <sbrktest+0x9f>
    b = sbrk(1);
    412d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    4134:	e8 39 0f 00 00       	call   5072 <sbrk>
    4139:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(b != a){
    413c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    413f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    4142:	74 2f                	je     4173 <sbrktest+0x8c>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    4144:	a1 58 75 00 00       	mov    0x7558,%eax
    4149:	8b 55 e8             	mov    -0x18(%ebp),%edx
    414c:	89 54 24 10          	mov    %edx,0x10(%esp)
    4150:	8b 55 f4             	mov    -0xc(%ebp),%edx
    4153:	89 54 24 0c          	mov    %edx,0xc(%esp)
    4157:	8b 55 f0             	mov    -0x10(%ebp),%edx
    415a:	89 54 24 08          	mov    %edx,0x8(%esp)
    415e:	c7 44 24 04 8a 69 00 	movl   $0x698a,0x4(%esp)
    4165:	00 
    4166:	89 04 24             	mov    %eax,(%esp)
    4169:	e8 0c 10 00 00       	call   517a <printf>
      exit();
    416e:	e8 77 0e 00 00       	call   4fea <exit>
    }
    *b = 1;
    4173:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4176:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    4179:	8b 45 e8             	mov    -0x18(%ebp),%eax
    417c:	83 c0 01             	add    $0x1,%eax
    417f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; i < 5000; i++){
    4182:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    4186:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
    418d:	7e 9e                	jle    412d <sbrktest+0x46>
  }
  pid = fork();
    418f:	e8 4e 0e 00 00       	call   4fe2 <fork>
    4194:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    4197:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    419b:	79 1a                	jns    41b7 <sbrktest+0xd0>
    printf(stdout, "sbrk test fork failed\n");
    419d:	a1 58 75 00 00       	mov    0x7558,%eax
    41a2:	c7 44 24 04 a5 69 00 	movl   $0x69a5,0x4(%esp)
    41a9:	00 
    41aa:	89 04 24             	mov    %eax,(%esp)
    41ad:	e8 c8 0f 00 00       	call   517a <printf>
    exit();
    41b2:	e8 33 0e 00 00       	call   4fea <exit>
  }
  c = sbrk(1);
    41b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    41be:	e8 af 0e 00 00       	call   5072 <sbrk>
    41c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  c = sbrk(1);
    41c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    41cd:	e8 a0 0e 00 00       	call   5072 <sbrk>
    41d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a + 1){
    41d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    41d8:	83 c0 01             	add    $0x1,%eax
    41db:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    41de:	74 1a                	je     41fa <sbrktest+0x113>
    printf(stdout, "sbrk test failed post-fork\n");
    41e0:	a1 58 75 00 00       	mov    0x7558,%eax
    41e5:	c7 44 24 04 bc 69 00 	movl   $0x69bc,0x4(%esp)
    41ec:	00 
    41ed:	89 04 24             	mov    %eax,(%esp)
    41f0:	e8 85 0f 00 00       	call   517a <printf>
    exit();
    41f5:	e8 f0 0d 00 00       	call   4fea <exit>
  }
  if(pid == 0)
    41fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    41fe:	75 05                	jne    4205 <sbrktest+0x11e>
    exit();
    4200:	e8 e5 0d 00 00       	call   4fea <exit>
  wait();
    4205:	e8 e8 0d 00 00       	call   4ff2 <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    420a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4211:	e8 5c 0e 00 00       	call   5072 <sbrk>
    4216:	89 45 f4             	mov    %eax,-0xc(%ebp)
  amt = (BIG) - (uint)a;
    4219:	8b 45 f4             	mov    -0xc(%ebp),%eax
    421c:	ba 00 00 40 06       	mov    $0x6400000,%edx
    4221:	29 c2                	sub    %eax,%edx
    4223:	89 d0                	mov    %edx,%eax
    4225:	89 45 dc             	mov    %eax,-0x24(%ebp)
  p = sbrk(amt);
    4228:	8b 45 dc             	mov    -0x24(%ebp),%eax
    422b:	89 04 24             	mov    %eax,(%esp)
    422e:	e8 3f 0e 00 00       	call   5072 <sbrk>
    4233:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if (p != a) {
    4236:	8b 45 d8             	mov    -0x28(%ebp),%eax
    4239:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    423c:	74 1a                	je     4258 <sbrktest+0x171>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    423e:	a1 58 75 00 00       	mov    0x7558,%eax
    4243:	c7 44 24 04 d8 69 00 	movl   $0x69d8,0x4(%esp)
    424a:	00 
    424b:	89 04 24             	mov    %eax,(%esp)
    424e:	e8 27 0f 00 00       	call   517a <printf>
    exit();
    4253:	e8 92 0d 00 00       	call   4fea <exit>
  }
  lastaddr = (char*) (BIG-1);
    4258:	c7 45 d4 ff ff 3f 06 	movl   $0x63fffff,-0x2c(%ebp)
  *lastaddr = 99;
    425f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    4262:	c6 00 63             	movb   $0x63,(%eax)

  // can one de-allocate?
  a = sbrk(0);
    4265:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    426c:	e8 01 0e 00 00       	call   5072 <sbrk>
    4271:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-4096);
    4274:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    427b:	e8 f2 0d 00 00       	call   5072 <sbrk>
    4280:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c == (char*)0xffffffff){
    4283:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    4287:	75 1a                	jne    42a3 <sbrktest+0x1bc>
    printf(stdout, "sbrk could not deallocate\n");
    4289:	a1 58 75 00 00       	mov    0x7558,%eax
    428e:	c7 44 24 04 16 6a 00 	movl   $0x6a16,0x4(%esp)
    4295:	00 
    4296:	89 04 24             	mov    %eax,(%esp)
    4299:	e8 dc 0e 00 00       	call   517a <printf>
    exit();
    429e:	e8 47 0d 00 00       	call   4fea <exit>
  }
  c = sbrk(0);
    42a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    42aa:	e8 c3 0d 00 00       	call   5072 <sbrk>
    42af:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a - 4096){
    42b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    42b5:	2d 00 10 00 00       	sub    $0x1000,%eax
    42ba:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    42bd:	74 28                	je     42e7 <sbrktest+0x200>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    42bf:	a1 58 75 00 00       	mov    0x7558,%eax
    42c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
    42c7:	89 54 24 0c          	mov    %edx,0xc(%esp)
    42cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
    42ce:	89 54 24 08          	mov    %edx,0x8(%esp)
    42d2:	c7 44 24 04 34 6a 00 	movl   $0x6a34,0x4(%esp)
    42d9:	00 
    42da:	89 04 24             	mov    %eax,(%esp)
    42dd:	e8 98 0e 00 00       	call   517a <printf>
    exit();
    42e2:	e8 03 0d 00 00       	call   4fea <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    42e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    42ee:	e8 7f 0d 00 00       	call   5072 <sbrk>
    42f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(4096);
    42f6:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    42fd:	e8 70 0d 00 00       	call   5072 <sbrk>
    4302:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a || sbrk(0) != a + 4096){
    4305:	8b 45 e0             	mov    -0x20(%ebp),%eax
    4308:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    430b:	75 19                	jne    4326 <sbrktest+0x23f>
    430d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4314:	e8 59 0d 00 00       	call   5072 <sbrk>
    4319:	8b 55 f4             	mov    -0xc(%ebp),%edx
    431c:	81 c2 00 10 00 00    	add    $0x1000,%edx
    4322:	39 d0                	cmp    %edx,%eax
    4324:	74 28                	je     434e <sbrktest+0x267>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    4326:	a1 58 75 00 00       	mov    0x7558,%eax
    432b:	8b 55 e0             	mov    -0x20(%ebp),%edx
    432e:	89 54 24 0c          	mov    %edx,0xc(%esp)
    4332:	8b 55 f4             	mov    -0xc(%ebp),%edx
    4335:	89 54 24 08          	mov    %edx,0x8(%esp)
    4339:	c7 44 24 04 6c 6a 00 	movl   $0x6a6c,0x4(%esp)
    4340:	00 
    4341:	89 04 24             	mov    %eax,(%esp)
    4344:	e8 31 0e 00 00       	call   517a <printf>
    exit();
    4349:	e8 9c 0c 00 00       	call   4fea <exit>
  }
  if(*lastaddr == 99){
    434e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    4351:	0f b6 00             	movzbl (%eax),%eax
    4354:	3c 63                	cmp    $0x63,%al
    4356:	75 1a                	jne    4372 <sbrktest+0x28b>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    4358:	a1 58 75 00 00       	mov    0x7558,%eax
    435d:	c7 44 24 04 94 6a 00 	movl   $0x6a94,0x4(%esp)
    4364:	00 
    4365:	89 04 24             	mov    %eax,(%esp)
    4368:	e8 0d 0e 00 00       	call   517a <printf>
    exit();
    436d:	e8 78 0c 00 00       	call   4fea <exit>
  }

  a = sbrk(0);
    4372:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4379:	e8 f4 0c 00 00       	call   5072 <sbrk>
    437e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-(sbrk(0) - oldbrk));
    4381:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    4384:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    438b:	e8 e2 0c 00 00       	call   5072 <sbrk>
    4390:	29 c3                	sub    %eax,%ebx
    4392:	89 d8                	mov    %ebx,%eax
    4394:	89 04 24             	mov    %eax,(%esp)
    4397:	e8 d6 0c 00 00       	call   5072 <sbrk>
    439c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a){
    439f:	8b 45 e0             	mov    -0x20(%ebp),%eax
    43a2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    43a5:	74 28                	je     43cf <sbrktest+0x2e8>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    43a7:	a1 58 75 00 00       	mov    0x7558,%eax
    43ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
    43af:	89 54 24 0c          	mov    %edx,0xc(%esp)
    43b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
    43b6:	89 54 24 08          	mov    %edx,0x8(%esp)
    43ba:	c7 44 24 04 c4 6a 00 	movl   $0x6ac4,0x4(%esp)
    43c1:	00 
    43c2:	89 04 24             	mov    %eax,(%esp)
    43c5:	e8 b0 0d 00 00       	call   517a <printf>
    exit();
    43ca:	e8 1b 0c 00 00       	call   4fea <exit>
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    43cf:	c7 45 f4 00 00 00 80 	movl   $0x80000000,-0xc(%ebp)
    43d6:	eb 7b                	jmp    4453 <sbrktest+0x36c>
    ppid = getpid();
    43d8:	e8 8d 0c 00 00       	call   506a <getpid>
    43dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
    pid = fork();
    43e0:	e8 fd 0b 00 00       	call   4fe2 <fork>
    43e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pid < 0){
    43e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    43ec:	79 1a                	jns    4408 <sbrktest+0x321>
      printf(stdout, "fork failed\n");
    43ee:	a1 58 75 00 00       	mov    0x7558,%eax
    43f3:	c7 44 24 04 39 56 00 	movl   $0x5639,0x4(%esp)
    43fa:	00 
    43fb:	89 04 24             	mov    %eax,(%esp)
    43fe:	e8 77 0d 00 00       	call   517a <printf>
      exit();
    4403:	e8 e2 0b 00 00       	call   4fea <exit>
    }
    if(pid == 0){
    4408:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    440c:	75 39                	jne    4447 <sbrktest+0x360>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    440e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4411:	0f b6 00             	movzbl (%eax),%eax
    4414:	0f be d0             	movsbl %al,%edx
    4417:	a1 58 75 00 00       	mov    0x7558,%eax
    441c:	89 54 24 0c          	mov    %edx,0xc(%esp)
    4420:	8b 55 f4             	mov    -0xc(%ebp),%edx
    4423:	89 54 24 08          	mov    %edx,0x8(%esp)
    4427:	c7 44 24 04 e5 6a 00 	movl   $0x6ae5,0x4(%esp)
    442e:	00 
    442f:	89 04 24             	mov    %eax,(%esp)
    4432:	e8 43 0d 00 00       	call   517a <printf>
      kill(ppid);
    4437:	8b 45 d0             	mov    -0x30(%ebp),%eax
    443a:	89 04 24             	mov    %eax,(%esp)
    443d:	e8 d8 0b 00 00       	call   501a <kill>
      exit();
    4442:	e8 a3 0b 00 00       	call   4fea <exit>
    }
    wait();
    4447:	e8 a6 0b 00 00       	call   4ff2 <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    444c:	81 45 f4 50 c3 00 00 	addl   $0xc350,-0xc(%ebp)
    4453:	81 7d f4 7f 84 1e 80 	cmpl   $0x801e847f,-0xc(%ebp)
    445a:	0f 86 78 ff ff ff    	jbe    43d8 <sbrktest+0x2f1>
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    4460:	8d 45 c8             	lea    -0x38(%ebp),%eax
    4463:	89 04 24             	mov    %eax,(%esp)
    4466:	e8 8f 0b 00 00       	call   4ffa <pipe>
    446b:	85 c0                	test   %eax,%eax
    446d:	74 19                	je     4488 <sbrktest+0x3a1>
    printf(1, "pipe() failed\n");
    446f:	c7 44 24 04 0a 5a 00 	movl   $0x5a0a,0x4(%esp)
    4476:	00 
    4477:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    447e:	e8 f7 0c 00 00       	call   517a <printf>
    exit();
    4483:	e8 62 0b 00 00       	call   4fea <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4488:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    448f:	e9 87 00 00 00       	jmp    451b <sbrktest+0x434>
    if((pids[i] = fork()) == 0){
    4494:	e8 49 0b 00 00       	call   4fe2 <fork>
    4499:	8b 55 f0             	mov    -0x10(%ebp),%edx
    449c:	89 44 95 a0          	mov    %eax,-0x60(%ebp,%edx,4)
    44a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    44a3:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    44a7:	85 c0                	test   %eax,%eax
    44a9:	75 46                	jne    44f1 <sbrktest+0x40a>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    44ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    44b2:	e8 bb 0b 00 00       	call   5072 <sbrk>
    44b7:	ba 00 00 40 06       	mov    $0x6400000,%edx
    44bc:	29 c2                	sub    %eax,%edx
    44be:	89 d0                	mov    %edx,%eax
    44c0:	89 04 24             	mov    %eax,(%esp)
    44c3:	e8 aa 0b 00 00       	call   5072 <sbrk>
      write(fds[1], "x", 1);
    44c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
    44cb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    44d2:	00 
    44d3:	c7 44 24 04 6f 5a 00 	movl   $0x5a6f,0x4(%esp)
    44da:	00 
    44db:	89 04 24             	mov    %eax,(%esp)
    44de:	e8 27 0b 00 00       	call   500a <write>
      // sit around until killed
      for(;;) sleep(1000);
    44e3:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
    44ea:	e8 8b 0b 00 00       	call   507a <sleep>
    44ef:	eb f2                	jmp    44e3 <sbrktest+0x3fc>
    }
    if(pids[i] != -1)
    44f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    44f4:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    44f8:	83 f8 ff             	cmp    $0xffffffff,%eax
    44fb:	74 1a                	je     4517 <sbrktest+0x430>
      read(fds[0], &scratch, 1);
    44fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
    4500:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    4507:	00 
    4508:	8d 55 9f             	lea    -0x61(%ebp),%edx
    450b:	89 54 24 04          	mov    %edx,0x4(%esp)
    450f:	89 04 24             	mov    %eax,(%esp)
    4512:	e8 eb 0a 00 00       	call   5002 <read>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4517:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    451b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    451e:	83 f8 09             	cmp    $0x9,%eax
    4521:	0f 86 6d ff ff ff    	jbe    4494 <sbrktest+0x3ad>
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    4527:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    452e:	e8 3f 0b 00 00       	call   5072 <sbrk>
    4533:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4536:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    453d:	eb 26                	jmp    4565 <sbrktest+0x47e>
    if(pids[i] == -1)
    453f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4542:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    4546:	83 f8 ff             	cmp    $0xffffffff,%eax
    4549:	75 02                	jne    454d <sbrktest+0x466>
      continue;
    454b:	eb 14                	jmp    4561 <sbrktest+0x47a>
    kill(pids[i]);
    454d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4550:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    4554:	89 04 24             	mov    %eax,(%esp)
    4557:	e8 be 0a 00 00       	call   501a <kill>
    wait();
    455c:	e8 91 0a 00 00       	call   4ff2 <wait>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4561:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    4565:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4568:	83 f8 09             	cmp    $0x9,%eax
    456b:	76 d2                	jbe    453f <sbrktest+0x458>
  }
  if(c == (char*)0xffffffff){
    456d:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    4571:	75 1a                	jne    458d <sbrktest+0x4a6>
    printf(stdout, "failed sbrk leaked memory\n");
    4573:	a1 58 75 00 00       	mov    0x7558,%eax
    4578:	c7 44 24 04 fe 6a 00 	movl   $0x6afe,0x4(%esp)
    457f:	00 
    4580:	89 04 24             	mov    %eax,(%esp)
    4583:	e8 f2 0b 00 00       	call   517a <printf>
    exit();
    4588:	e8 5d 0a 00 00       	call   4fea <exit>
  }

  if(sbrk(0) > oldbrk)
    458d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4594:	e8 d9 0a 00 00       	call   5072 <sbrk>
    4599:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    459c:	76 1b                	jbe    45b9 <sbrktest+0x4d2>
    sbrk(-(sbrk(0) - oldbrk));
    459e:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    45a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    45a8:	e8 c5 0a 00 00       	call   5072 <sbrk>
    45ad:	29 c3                	sub    %eax,%ebx
    45af:	89 d8                	mov    %ebx,%eax
    45b1:	89 04 24             	mov    %eax,(%esp)
    45b4:	e8 b9 0a 00 00       	call   5072 <sbrk>

  printf(stdout, "sbrk test OK\n");
    45b9:	a1 58 75 00 00       	mov    0x7558,%eax
    45be:	c7 44 24 04 19 6b 00 	movl   $0x6b19,0x4(%esp)
    45c5:	00 
    45c6:	89 04 24             	mov    %eax,(%esp)
    45c9:	e8 ac 0b 00 00       	call   517a <printf>
}
    45ce:	81 c4 84 00 00 00    	add    $0x84,%esp
    45d4:	5b                   	pop    %ebx
    45d5:	5d                   	pop    %ebp
    45d6:	c3                   	ret    

000045d7 <validateint>:

void
validateint(int *p)
{
    45d7:	55                   	push   %ebp
    45d8:	89 e5                	mov    %esp,%ebp
    45da:	53                   	push   %ebx
    45db:	83 ec 10             	sub    $0x10,%esp
  int res;
  asm("mov %%esp, %%ebx\n\t"
    45de:	b8 0d 00 00 00       	mov    $0xd,%eax
    45e3:	8b 55 08             	mov    0x8(%ebp),%edx
    45e6:	89 d1                	mov    %edx,%ecx
    45e8:	89 e3                	mov    %esp,%ebx
    45ea:	89 cc                	mov    %ecx,%esp
    45ec:	cd 40                	int    $0x40
    45ee:	89 dc                	mov    %ebx,%esp
    45f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    45f3:	83 c4 10             	add    $0x10,%esp
    45f6:	5b                   	pop    %ebx
    45f7:	5d                   	pop    %ebp
    45f8:	c3                   	ret    

000045f9 <validatetest>:

void
validatetest(void)
{
    45f9:	55                   	push   %ebp
    45fa:	89 e5                	mov    %esp,%ebp
    45fc:	83 ec 28             	sub    $0x28,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    45ff:	a1 58 75 00 00       	mov    0x7558,%eax
    4604:	c7 44 24 04 27 6b 00 	movl   $0x6b27,0x4(%esp)
    460b:	00 
    460c:	89 04 24             	mov    %eax,(%esp)
    460f:	e8 66 0b 00 00       	call   517a <printf>
  hi = 1100*1024;
    4614:	c7 45 f0 00 30 11 00 	movl   $0x113000,-0x10(%ebp)

  for(p = 0; p <= (uint)hi; p += 4096){
    461b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    4622:	eb 7f                	jmp    46a3 <validatetest+0xaa>
    if((pid = fork()) == 0){
    4624:	e8 b9 09 00 00       	call   4fe2 <fork>
    4629:	89 45 ec             	mov    %eax,-0x14(%ebp)
    462c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    4630:	75 10                	jne    4642 <validatetest+0x49>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
    4632:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4635:	89 04 24             	mov    %eax,(%esp)
    4638:	e8 9a ff ff ff       	call   45d7 <validateint>
      exit();
    463d:	e8 a8 09 00 00       	call   4fea <exit>
    }
    sleep(0);
    4642:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4649:	e8 2c 0a 00 00       	call   507a <sleep>
    sleep(0);
    464e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4655:	e8 20 0a 00 00       	call   507a <sleep>
    kill(pid);
    465a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    465d:	89 04 24             	mov    %eax,(%esp)
    4660:	e8 b5 09 00 00       	call   501a <kill>
    wait();
    4665:	e8 88 09 00 00       	call   4ff2 <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    466a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    466d:	89 44 24 04          	mov    %eax,0x4(%esp)
    4671:	c7 04 24 36 6b 00 00 	movl   $0x6b36,(%esp)
    4678:	e8 cd 09 00 00       	call   504a <link>
    467d:	83 f8 ff             	cmp    $0xffffffff,%eax
    4680:	74 1a                	je     469c <validatetest+0xa3>
      printf(stdout, "link should not succeed\n");
    4682:	a1 58 75 00 00       	mov    0x7558,%eax
    4687:	c7 44 24 04 41 6b 00 	movl   $0x6b41,0x4(%esp)
    468e:	00 
    468f:	89 04 24             	mov    %eax,(%esp)
    4692:	e8 e3 0a 00 00       	call   517a <printf>
      exit();
    4697:	e8 4e 09 00 00       	call   4fea <exit>
  for(p = 0; p <= (uint)hi; p += 4096){
    469c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    46a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    46a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    46a9:	0f 83 75 ff ff ff    	jae    4624 <validatetest+0x2b>
    }
  }

  printf(stdout, "validate ok\n");
    46af:	a1 58 75 00 00       	mov    0x7558,%eax
    46b4:	c7 44 24 04 5a 6b 00 	movl   $0x6b5a,0x4(%esp)
    46bb:	00 
    46bc:	89 04 24             	mov    %eax,(%esp)
    46bf:	e8 b6 0a 00 00       	call   517a <printf>
}
    46c4:	c9                   	leave  
    46c5:	c3                   	ret    

000046c6 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    46c6:	55                   	push   %ebp
    46c7:	89 e5                	mov    %esp,%ebp
    46c9:	83 ec 28             	sub    $0x28,%esp
  int i;

  printf(stdout, "bss test\n");
    46cc:	a1 58 75 00 00       	mov    0x7558,%eax
    46d1:	c7 44 24 04 67 6b 00 	movl   $0x6b67,0x4(%esp)
    46d8:	00 
    46d9:	89 04 24             	mov    %eax,(%esp)
    46dc:	e8 99 0a 00 00       	call   517a <printf>
  for(i = 0; i < sizeof(uninit); i++){
    46e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    46e8:	eb 2d                	jmp    4717 <bsstest+0x51>
    if(uninit[i] != '\0'){
    46ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    46ed:	05 20 76 00 00       	add    $0x7620,%eax
    46f2:	0f b6 00             	movzbl (%eax),%eax
    46f5:	84 c0                	test   %al,%al
    46f7:	74 1a                	je     4713 <bsstest+0x4d>
      printf(stdout, "bss test failed\n");
    46f9:	a1 58 75 00 00       	mov    0x7558,%eax
    46fe:	c7 44 24 04 71 6b 00 	movl   $0x6b71,0x4(%esp)
    4705:	00 
    4706:	89 04 24             	mov    %eax,(%esp)
    4709:	e8 6c 0a 00 00       	call   517a <printf>
      exit();
    470e:	e8 d7 08 00 00       	call   4fea <exit>
  for(i = 0; i < sizeof(uninit); i++){
    4713:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    4717:	8b 45 f4             	mov    -0xc(%ebp),%eax
    471a:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    471f:	76 c9                	jbe    46ea <bsstest+0x24>
    }
  }
  printf(stdout, "bss test ok\n");
    4721:	a1 58 75 00 00       	mov    0x7558,%eax
    4726:	c7 44 24 04 82 6b 00 	movl   $0x6b82,0x4(%esp)
    472d:	00 
    472e:	89 04 24             	mov    %eax,(%esp)
    4731:	e8 44 0a 00 00       	call   517a <printf>
}
    4736:	c9                   	leave  
    4737:	c3                   	ret    

00004738 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    4738:	55                   	push   %ebp
    4739:	89 e5                	mov    %esp,%ebp
    473b:	83 ec 28             	sub    $0x28,%esp
  int pid, fd;

  unlink("bigarg-ok");
    473e:	c7 04 24 8f 6b 00 00 	movl   $0x6b8f,(%esp)
    4745:	e8 f0 08 00 00       	call   503a <unlink>
  pid = fork();
    474a:	e8 93 08 00 00       	call   4fe2 <fork>
    474f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    4752:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4756:	0f 85 90 00 00 00    	jne    47ec <bigargtest+0xb4>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    475c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    4763:	eb 12                	jmp    4777 <bigargtest+0x3f>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    4765:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4768:	c7 04 85 80 75 00 00 	movl   $0x6b9c,0x7580(,%eax,4)
    476f:	9c 6b 00 00 
    for(i = 0; i < MAXARG-1; i++)
    4773:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    4777:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    477b:	7e e8                	jle    4765 <bigargtest+0x2d>
    args[MAXARG-1] = 0;
    477d:	c7 05 fc 75 00 00 00 	movl   $0x0,0x75fc
    4784:	00 00 00 
    printf(stdout, "bigarg test\n");
    4787:	a1 58 75 00 00       	mov    0x7558,%eax
    478c:	c7 44 24 04 79 6c 00 	movl   $0x6c79,0x4(%esp)
    4793:	00 
    4794:	89 04 24             	mov    %eax,(%esp)
    4797:	e8 de 09 00 00       	call   517a <printf>
    exec("echo", args);
    479c:	c7 44 24 04 80 75 00 	movl   $0x7580,0x4(%esp)
    47a3:	00 
    47a4:	c7 04 24 98 55 00 00 	movl   $0x5598,(%esp)
    47ab:	e8 72 08 00 00       	call   5022 <exec>
    printf(stdout, "bigarg test ok\n");
    47b0:	a1 58 75 00 00       	mov    0x7558,%eax
    47b5:	c7 44 24 04 86 6c 00 	movl   $0x6c86,0x4(%esp)
    47bc:	00 
    47bd:	89 04 24             	mov    %eax,(%esp)
    47c0:	e8 b5 09 00 00       	call   517a <printf>
    fd = open("bigarg-ok", O_CREATE);
    47c5:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    47cc:	00 
    47cd:	c7 04 24 8f 6b 00 00 	movl   $0x6b8f,(%esp)
    47d4:	e8 51 08 00 00       	call   502a <open>
    47d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    close(fd);
    47dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
    47df:	89 04 24             	mov    %eax,(%esp)
    47e2:	e8 2b 08 00 00       	call   5012 <close>
    exit();
    47e7:	e8 fe 07 00 00       	call   4fea <exit>
  } else if(pid < 0){
    47ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    47f0:	79 1a                	jns    480c <bigargtest+0xd4>
    printf(stdout, "bigargtest: fork failed\n");
    47f2:	a1 58 75 00 00       	mov    0x7558,%eax
    47f7:	c7 44 24 04 96 6c 00 	movl   $0x6c96,0x4(%esp)
    47fe:	00 
    47ff:	89 04 24             	mov    %eax,(%esp)
    4802:	e8 73 09 00 00       	call   517a <printf>
    exit();
    4807:	e8 de 07 00 00       	call   4fea <exit>
  }
  wait();
    480c:	e8 e1 07 00 00       	call   4ff2 <wait>
  fd = open("bigarg-ok", 0);
    4811:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    4818:	00 
    4819:	c7 04 24 8f 6b 00 00 	movl   $0x6b8f,(%esp)
    4820:	e8 05 08 00 00       	call   502a <open>
    4825:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    4828:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    482c:	79 1a                	jns    4848 <bigargtest+0x110>
    printf(stdout, "bigarg test failed!\n");
    482e:	a1 58 75 00 00       	mov    0x7558,%eax
    4833:	c7 44 24 04 af 6c 00 	movl   $0x6caf,0x4(%esp)
    483a:	00 
    483b:	89 04 24             	mov    %eax,(%esp)
    483e:	e8 37 09 00 00       	call   517a <printf>
    exit();
    4843:	e8 a2 07 00 00       	call   4fea <exit>
  }
  close(fd);
    4848:	8b 45 ec             	mov    -0x14(%ebp),%eax
    484b:	89 04 24             	mov    %eax,(%esp)
    484e:	e8 bf 07 00 00       	call   5012 <close>
  unlink("bigarg-ok");
    4853:	c7 04 24 8f 6b 00 00 	movl   $0x6b8f,(%esp)
    485a:	e8 db 07 00 00       	call   503a <unlink>
}
    485f:	c9                   	leave  
    4860:	c3                   	ret    

00004861 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    4861:	55                   	push   %ebp
    4862:	89 e5                	mov    %esp,%ebp
    4864:	53                   	push   %ebx
    4865:	83 ec 74             	sub    $0x74,%esp
  int nfiles;
  int fsblocks = 0;
    4868:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  printf(1, "fsfull test\n");
    486f:	c7 44 24 04 c4 6c 00 	movl   $0x6cc4,0x4(%esp)
    4876:	00 
    4877:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    487e:	e8 f7 08 00 00       	call   517a <printf>

  for(nfiles = 0; ; nfiles++){
    4883:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char name[64];
    name[0] = 'f';
    488a:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    488e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    4891:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    4896:	89 c8                	mov    %ecx,%eax
    4898:	f7 ea                	imul   %edx
    489a:	c1 fa 06             	sar    $0x6,%edx
    489d:	89 c8                	mov    %ecx,%eax
    489f:	c1 f8 1f             	sar    $0x1f,%eax
    48a2:	29 c2                	sub    %eax,%edx
    48a4:	89 d0                	mov    %edx,%eax
    48a6:	83 c0 30             	add    $0x30,%eax
    48a9:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    48ac:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    48af:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    48b4:	89 d8                	mov    %ebx,%eax
    48b6:	f7 ea                	imul   %edx
    48b8:	c1 fa 06             	sar    $0x6,%edx
    48bb:	89 d8                	mov    %ebx,%eax
    48bd:	c1 f8 1f             	sar    $0x1f,%eax
    48c0:	89 d1                	mov    %edx,%ecx
    48c2:	29 c1                	sub    %eax,%ecx
    48c4:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    48ca:	29 c3                	sub    %eax,%ebx
    48cc:	89 d9                	mov    %ebx,%ecx
    48ce:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    48d3:	89 c8                	mov    %ecx,%eax
    48d5:	f7 ea                	imul   %edx
    48d7:	c1 fa 05             	sar    $0x5,%edx
    48da:	89 c8                	mov    %ecx,%eax
    48dc:	c1 f8 1f             	sar    $0x1f,%eax
    48df:	29 c2                	sub    %eax,%edx
    48e1:	89 d0                	mov    %edx,%eax
    48e3:	83 c0 30             	add    $0x30,%eax
    48e6:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    48e9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    48ec:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    48f1:	89 d8                	mov    %ebx,%eax
    48f3:	f7 ea                	imul   %edx
    48f5:	c1 fa 05             	sar    $0x5,%edx
    48f8:	89 d8                	mov    %ebx,%eax
    48fa:	c1 f8 1f             	sar    $0x1f,%eax
    48fd:	89 d1                	mov    %edx,%ecx
    48ff:	29 c1                	sub    %eax,%ecx
    4901:	6b c1 64             	imul   $0x64,%ecx,%eax
    4904:	29 c3                	sub    %eax,%ebx
    4906:	89 d9                	mov    %ebx,%ecx
    4908:	ba 67 66 66 66       	mov    $0x66666667,%edx
    490d:	89 c8                	mov    %ecx,%eax
    490f:	f7 ea                	imul   %edx
    4911:	c1 fa 02             	sar    $0x2,%edx
    4914:	89 c8                	mov    %ecx,%eax
    4916:	c1 f8 1f             	sar    $0x1f,%eax
    4919:	29 c2                	sub    %eax,%edx
    491b:	89 d0                	mov    %edx,%eax
    491d:	83 c0 30             	add    $0x30,%eax
    4920:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    4923:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    4926:	ba 67 66 66 66       	mov    $0x66666667,%edx
    492b:	89 c8                	mov    %ecx,%eax
    492d:	f7 ea                	imul   %edx
    492f:	c1 fa 02             	sar    $0x2,%edx
    4932:	89 c8                	mov    %ecx,%eax
    4934:	c1 f8 1f             	sar    $0x1f,%eax
    4937:	29 c2                	sub    %eax,%edx
    4939:	89 d0                	mov    %edx,%eax
    493b:	c1 e0 02             	shl    $0x2,%eax
    493e:	01 d0                	add    %edx,%eax
    4940:	01 c0                	add    %eax,%eax
    4942:	29 c1                	sub    %eax,%ecx
    4944:	89 ca                	mov    %ecx,%edx
    4946:	89 d0                	mov    %edx,%eax
    4948:	83 c0 30             	add    $0x30,%eax
    494b:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    494e:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    printf(1, "writing %s\n", name);
    4952:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    4955:	89 44 24 08          	mov    %eax,0x8(%esp)
    4959:	c7 44 24 04 d1 6c 00 	movl   $0x6cd1,0x4(%esp)
    4960:	00 
    4961:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    4968:	e8 0d 08 00 00       	call   517a <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    496d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    4974:	00 
    4975:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    4978:	89 04 24             	mov    %eax,(%esp)
    497b:	e8 aa 06 00 00       	call   502a <open>
    4980:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fd < 0){
    4983:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    4987:	79 1d                	jns    49a6 <fsfull+0x145>
      printf(1, "open %s failed\n", name);
    4989:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    498c:	89 44 24 08          	mov    %eax,0x8(%esp)
    4990:	c7 44 24 04 dd 6c 00 	movl   $0x6cdd,0x4(%esp)
    4997:	00 
    4998:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    499f:	e8 d6 07 00 00       	call   517a <printf>
      break;
    49a4:	eb 74                	jmp    4a1a <fsfull+0x1b9>
    }
    int total = 0;
    49a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while(1){
      int cc = write(fd, buf, 512);
    49ad:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    49b4:	00 
    49b5:	c7 44 24 04 40 9d 00 	movl   $0x9d40,0x4(%esp)
    49bc:	00 
    49bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
    49c0:	89 04 24             	mov    %eax,(%esp)
    49c3:	e8 42 06 00 00       	call   500a <write>
    49c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(cc < 512)
    49cb:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%ebp)
    49d2:	7f 2f                	jg     4a03 <fsfull+0x1a2>
        break;
    49d4:	90                   	nop
      total += cc;
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    49d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    49d8:	89 44 24 08          	mov    %eax,0x8(%esp)
    49dc:	c7 44 24 04 ed 6c 00 	movl   $0x6ced,0x4(%esp)
    49e3:	00 
    49e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    49eb:	e8 8a 07 00 00       	call   517a <printf>
    close(fd);
    49f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
    49f3:	89 04 24             	mov    %eax,(%esp)
    49f6:	e8 17 06 00 00       	call   5012 <close>
    if(total == 0)
    49fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    49ff:	75 10                	jne    4a11 <fsfull+0x1b0>
    4a01:	eb 0c                	jmp    4a0f <fsfull+0x1ae>
      total += cc;
    4a03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    4a06:	01 45 ec             	add    %eax,-0x14(%ebp)
      fsblocks++;
    4a09:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    }
    4a0d:	eb 9e                	jmp    49ad <fsfull+0x14c>
      break;
    4a0f:	eb 09                	jmp    4a1a <fsfull+0x1b9>
  for(nfiles = 0; ; nfiles++){
    4a11:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }
    4a15:	e9 70 fe ff ff       	jmp    488a <fsfull+0x29>

  while(nfiles >= 0){
    4a1a:	e9 d7 00 00 00       	jmp    4af6 <fsfull+0x295>
    char name[64];
    name[0] = 'f';
    4a1f:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    4a23:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    4a26:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    4a2b:	89 c8                	mov    %ecx,%eax
    4a2d:	f7 ea                	imul   %edx
    4a2f:	c1 fa 06             	sar    $0x6,%edx
    4a32:	89 c8                	mov    %ecx,%eax
    4a34:	c1 f8 1f             	sar    $0x1f,%eax
    4a37:	29 c2                	sub    %eax,%edx
    4a39:	89 d0                	mov    %edx,%eax
    4a3b:	83 c0 30             	add    $0x30,%eax
    4a3e:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    4a41:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    4a44:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    4a49:	89 d8                	mov    %ebx,%eax
    4a4b:	f7 ea                	imul   %edx
    4a4d:	c1 fa 06             	sar    $0x6,%edx
    4a50:	89 d8                	mov    %ebx,%eax
    4a52:	c1 f8 1f             	sar    $0x1f,%eax
    4a55:	89 d1                	mov    %edx,%ecx
    4a57:	29 c1                	sub    %eax,%ecx
    4a59:	69 c1 e8 03 00 00    	imul   $0x3e8,%ecx,%eax
    4a5f:	29 c3                	sub    %eax,%ebx
    4a61:	89 d9                	mov    %ebx,%ecx
    4a63:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    4a68:	89 c8                	mov    %ecx,%eax
    4a6a:	f7 ea                	imul   %edx
    4a6c:	c1 fa 05             	sar    $0x5,%edx
    4a6f:	89 c8                	mov    %ecx,%eax
    4a71:	c1 f8 1f             	sar    $0x1f,%eax
    4a74:	29 c2                	sub    %eax,%edx
    4a76:	89 d0                	mov    %edx,%eax
    4a78:	83 c0 30             	add    $0x30,%eax
    4a7b:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    4a7e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    4a81:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
    4a86:	89 d8                	mov    %ebx,%eax
    4a88:	f7 ea                	imul   %edx
    4a8a:	c1 fa 05             	sar    $0x5,%edx
    4a8d:	89 d8                	mov    %ebx,%eax
    4a8f:	c1 f8 1f             	sar    $0x1f,%eax
    4a92:	89 d1                	mov    %edx,%ecx
    4a94:	29 c1                	sub    %eax,%ecx
    4a96:	6b c1 64             	imul   $0x64,%ecx,%eax
    4a99:	29 c3                	sub    %eax,%ebx
    4a9b:	89 d9                	mov    %ebx,%ecx
    4a9d:	ba 67 66 66 66       	mov    $0x66666667,%edx
    4aa2:	89 c8                	mov    %ecx,%eax
    4aa4:	f7 ea                	imul   %edx
    4aa6:	c1 fa 02             	sar    $0x2,%edx
    4aa9:	89 c8                	mov    %ecx,%eax
    4aab:	c1 f8 1f             	sar    $0x1f,%eax
    4aae:	29 c2                	sub    %eax,%edx
    4ab0:	89 d0                	mov    %edx,%eax
    4ab2:	83 c0 30             	add    $0x30,%eax
    4ab5:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    4ab8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    4abb:	ba 67 66 66 66       	mov    $0x66666667,%edx
    4ac0:	89 c8                	mov    %ecx,%eax
    4ac2:	f7 ea                	imul   %edx
    4ac4:	c1 fa 02             	sar    $0x2,%edx
    4ac7:	89 c8                	mov    %ecx,%eax
    4ac9:	c1 f8 1f             	sar    $0x1f,%eax
    4acc:	29 c2                	sub    %eax,%edx
    4ace:	89 d0                	mov    %edx,%eax
    4ad0:	c1 e0 02             	shl    $0x2,%eax
    4ad3:	01 d0                	add    %edx,%eax
    4ad5:	01 c0                	add    %eax,%eax
    4ad7:	29 c1                	sub    %eax,%ecx
    4ad9:	89 ca                	mov    %ecx,%edx
    4adb:	89 d0                	mov    %edx,%eax
    4add:	83 c0 30             	add    $0x30,%eax
    4ae0:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    4ae3:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    unlink(name);
    4ae7:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    4aea:	89 04 24             	mov    %eax,(%esp)
    4aed:	e8 48 05 00 00       	call   503a <unlink>
    nfiles--;
    4af2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  while(nfiles >= 0){
    4af6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4afa:	0f 89 1f ff ff ff    	jns    4a1f <fsfull+0x1be>
  }

  printf(1, "fsfull test finished\n");
    4b00:	c7 44 24 04 fd 6c 00 	movl   $0x6cfd,0x4(%esp)
    4b07:	00 
    4b08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    4b0f:	e8 66 06 00 00       	call   517a <printf>
}
    4b14:	83 c4 74             	add    $0x74,%esp
    4b17:	5b                   	pop    %ebx
    4b18:	5d                   	pop    %ebp
    4b19:	c3                   	ret    

00004b1a <uio>:

void
uio()
{
    4b1a:	55                   	push   %ebp
    4b1b:	89 e5                	mov    %esp,%ebp
    4b1d:	83 ec 28             	sub    $0x28,%esp
  #define RTC_ADDR 0x70
  #define RTC_DATA 0x71

  ushort port = 0;
    4b20:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
  uchar val = 0;
    4b26:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
  int pid;

  printf(1, "uio test\n");
    4b2a:	c7 44 24 04 13 6d 00 	movl   $0x6d13,0x4(%esp)
    4b31:	00 
    4b32:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    4b39:	e8 3c 06 00 00       	call   517a <printf>
  pid = fork();
    4b3e:	e8 9f 04 00 00       	call   4fe2 <fork>
    4b43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    4b46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4b4a:	75 3c                	jne    4b88 <uio+0x6e>
    port = RTC_ADDR;
    4b4c:	66 c7 45 f6 70 00    	movw   $0x70,-0xa(%ebp)
    val = 0x09;  /* year */
    4b52:	c6 45 f5 09          	movb   $0x9,-0xb(%ebp)
    /* http://wiki.osdev.org/Inline_Assembly/Examples */
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    4b56:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    4b5a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
    4b5e:	ee                   	out    %al,(%dx)
    port = RTC_DATA;
    4b5f:	66 c7 45 f6 71 00    	movw   $0x71,-0xa(%ebp)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    4b65:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    4b69:	89 c2                	mov    %eax,%edx
    4b6b:	ec                   	in     (%dx),%al
    4b6c:	88 45 f5             	mov    %al,-0xb(%ebp)
    printf(1, "uio: uio succeeded; test FAILED\n");
    4b6f:	c7 44 24 04 20 6d 00 	movl   $0x6d20,0x4(%esp)
    4b76:	00 
    4b77:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    4b7e:	e8 f7 05 00 00       	call   517a <printf>
    exit();
    4b83:	e8 62 04 00 00       	call   4fea <exit>
  } else if(pid < 0){
    4b88:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4b8c:	79 19                	jns    4ba7 <uio+0x8d>
    printf (1, "fork failed\n");
    4b8e:	c7 44 24 04 39 56 00 	movl   $0x5639,0x4(%esp)
    4b95:	00 
    4b96:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    4b9d:	e8 d8 05 00 00       	call   517a <printf>
    exit();
    4ba2:	e8 43 04 00 00       	call   4fea <exit>
  }
  wait();
    4ba7:	e8 46 04 00 00       	call   4ff2 <wait>
  printf(1, "uio test done\n");
    4bac:	c7 44 24 04 41 6d 00 	movl   $0x6d41,0x4(%esp)
    4bb3:	00 
    4bb4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    4bbb:	e8 ba 05 00 00       	call   517a <printf>
}
    4bc0:	c9                   	leave  
    4bc1:	c3                   	ret    

00004bc2 <argptest>:

void argptest()
{
    4bc2:	55                   	push   %ebp
    4bc3:	89 e5                	mov    %esp,%ebp
    4bc5:	83 ec 28             	sub    $0x28,%esp
  int fd;
  fd = open("init", O_RDONLY);
    4bc8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    4bcf:	00 
    4bd0:	c7 04 24 50 6d 00 00 	movl   $0x6d50,(%esp)
    4bd7:	e8 4e 04 00 00       	call   502a <open>
    4bdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (fd < 0) {
    4bdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4be3:	79 19                	jns    4bfe <argptest+0x3c>
    printf(2, "open failed\n");
    4be5:	c7 44 24 04 55 6d 00 	movl   $0x6d55,0x4(%esp)
    4bec:	00 
    4bed:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    4bf4:	e8 81 05 00 00       	call   517a <printf>
    exit();
    4bf9:	e8 ec 03 00 00       	call   4fea <exit>
  }
  read(fd, sbrk(0) - 1, -1);
    4bfe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4c05:	e8 68 04 00 00       	call   5072 <sbrk>
    4c0a:	83 e8 01             	sub    $0x1,%eax
    4c0d:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
    4c14:	ff 
    4c15:	89 44 24 04          	mov    %eax,0x4(%esp)
    4c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4c1c:	89 04 24             	mov    %eax,(%esp)
    4c1f:	e8 de 03 00 00       	call   5002 <read>
  close(fd);
    4c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4c27:	89 04 24             	mov    %eax,(%esp)
    4c2a:	e8 e3 03 00 00       	call   5012 <close>
  printf(1, "arg test passed\n");
    4c2f:	c7 44 24 04 62 6d 00 	movl   $0x6d62,0x4(%esp)
    4c36:	00 
    4c37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    4c3e:	e8 37 05 00 00       	call   517a <printf>
}
    4c43:	c9                   	leave  
    4c44:	c3                   	ret    

00004c45 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    4c45:	55                   	push   %ebp
    4c46:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    4c48:	a1 5c 75 00 00       	mov    0x755c,%eax
    4c4d:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
    4c53:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    4c58:	a3 5c 75 00 00       	mov    %eax,0x755c
  return randstate;
    4c5d:	a1 5c 75 00 00       	mov    0x755c,%eax
}
    4c62:	5d                   	pop    %ebp
    4c63:	c3                   	ret    

00004c64 <main>:

int
main(int argc, char *argv[])
{
    4c64:	55                   	push   %ebp
    4c65:	89 e5                	mov    %esp,%ebp
    4c67:	83 e4 f0             	and    $0xfffffff0,%esp
    4c6a:	83 ec 10             	sub    $0x10,%esp
  printf(1, "usertests starting\n");
    4c6d:	c7 44 24 04 73 6d 00 	movl   $0x6d73,0x4(%esp)
    4c74:	00 
    4c75:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    4c7c:	e8 f9 04 00 00       	call   517a <printf>

  if(open("usertests.ran", 0) >= 0){
    4c81:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    4c88:	00 
    4c89:	c7 04 24 87 6d 00 00 	movl   $0x6d87,(%esp)
    4c90:	e8 95 03 00 00       	call   502a <open>
    4c95:	85 c0                	test   %eax,%eax
    4c97:	78 19                	js     4cb2 <main+0x4e>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    4c99:	c7 44 24 04 98 6d 00 	movl   $0x6d98,0x4(%esp)
    4ca0:	00 
    4ca1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    4ca8:	e8 cd 04 00 00       	call   517a <printf>
    exit();
    4cad:	e8 38 03 00 00       	call   4fea <exit>
  }
  close(open("usertests.ran", O_CREATE));
    4cb2:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    4cb9:	00 
    4cba:	c7 04 24 87 6d 00 00 	movl   $0x6d87,(%esp)
    4cc1:	e8 64 03 00 00       	call   502a <open>
    4cc6:	89 04 24             	mov    %eax,(%esp)
    4cc9:	e8 44 03 00 00       	call   5012 <close>

  argptest();
    4cce:	e8 ef fe ff ff       	call   4bc2 <argptest>
  createdelete();
    4cd3:	e8 aa d5 ff ff       	call   2282 <createdelete>
  linkunlink();
    4cd8:	e8 ee df ff ff       	call   2ccb <linkunlink>
  concreate();
    4cdd:	e8 36 dc ff ff       	call   2918 <concreate>
  fourfiles();
    4ce2:	e8 33 d3 ff ff       	call   201a <fourfiles>
  sharedfd();
    4ce7:	e8 30 d1 ff ff       	call   1e1c <sharedfd>

  bigargtest();
    4cec:	e8 47 fa ff ff       	call   4738 <bigargtest>
  bigwrite();
    4cf1:	e8 b6 e9 ff ff       	call   36ac <bigwrite>
  bigargtest();
    4cf6:	e8 3d fa ff ff       	call   4738 <bigargtest>
  bsstest();
    4cfb:	e8 c6 f9 ff ff       	call   46c6 <bsstest>
  sbrktest();
    4d00:	e8 e2 f3 ff ff       	call   40e7 <sbrktest>
  validatetest();
    4d05:	e8 ef f8 ff ff       	call   45f9 <validatetest>

  opentest();
    4d0a:	e8 b8 c5 ff ff       	call   12c7 <opentest>
  writetest();
    4d0f:	e8 5e c6 ff ff       	call   1372 <writetest>
  writetest1();
    4d14:	e8 6e c8 ff ff       	call   1587 <writetest1>
  createtest();
    4d19:	e8 74 ca ff ff       	call   1792 <createtest>

  openiputtest();
    4d1e:	e8 a3 c4 ff ff       	call   11c6 <openiputtest>
  exitiputtest();
    4d23:	e8 b2 c3 ff ff       	call   10da <exitiputtest>
  iputtest();
    4d28:	e8 d3 c2 ff ff       	call   1000 <iputtest>

  mem();
    4d2d:	e8 05 d0 ff ff       	call   1d37 <mem>
  pipe1();
    4d32:	e8 3c cc ff ff       	call   1973 <pipe1>
  preempt();
    4d37:	e8 24 ce ff ff       	call   1b60 <preempt>
  exitwait();
    4d3c:	e8 78 cf ff ff       	call   1cb9 <exitwait>

  rmdot();
    4d41:	e8 ef ed ff ff       	call   3b35 <rmdot>
  fourteen();
    4d46:	e8 94 ec ff ff       	call   39df <fourteen>
  bigfile();
    4d4b:	e8 64 ea ff ff       	call   37b4 <bigfile>
  subdir();
    4d50:	e8 11 e2 ff ff       	call   2f66 <subdir>
  linktest();
    4d55:	e8 75 d9 ff ff       	call   26cf <linktest>
  unlinkread();
    4d5a:	e8 9b d7 ff ff       	call   24fa <unlinkread>
  dirfile();
    4d5f:	e8 49 ef ff ff       	call   3cad <dirfile>
  iref();
    4d64:	e8 86 f1 ff ff       	call   3eef <iref>
  forktest();
    4d69:	e8 a5 f2 ff ff       	call   4013 <forktest>
  bigdir(); // slow
    4d6e:	e8 86 e0 ff ff       	call   2df9 <bigdir>

  uio();
    4d73:	e8 a2 fd ff ff       	call   4b1a <uio>

  exectest();
    4d78:	e8 a7 cb ff ff       	call   1924 <exectest>

  exit();
    4d7d:	e8 68 02 00 00       	call   4fea <exit>

00004d82 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    4d82:	55                   	push   %ebp
    4d83:	89 e5                	mov    %esp,%ebp
    4d85:	57                   	push   %edi
    4d86:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    4d87:	8b 4d 08             	mov    0x8(%ebp),%ecx
    4d8a:	8b 55 10             	mov    0x10(%ebp),%edx
    4d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
    4d90:	89 cb                	mov    %ecx,%ebx
    4d92:	89 df                	mov    %ebx,%edi
    4d94:	89 d1                	mov    %edx,%ecx
    4d96:	fc                   	cld    
    4d97:	f3 aa                	rep stos %al,%es:(%edi)
    4d99:	89 ca                	mov    %ecx,%edx
    4d9b:	89 fb                	mov    %edi,%ebx
    4d9d:	89 5d 08             	mov    %ebx,0x8(%ebp)
    4da0:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    4da3:	5b                   	pop    %ebx
    4da4:	5f                   	pop    %edi
    4da5:	5d                   	pop    %ebp
    4da6:	c3                   	ret    

00004da7 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    4da7:	55                   	push   %ebp
    4da8:	89 e5                	mov    %esp,%ebp
    4daa:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    4dad:	8b 45 08             	mov    0x8(%ebp),%eax
    4db0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    4db3:	90                   	nop
    4db4:	8b 45 08             	mov    0x8(%ebp),%eax
    4db7:	8d 50 01             	lea    0x1(%eax),%edx
    4dba:	89 55 08             	mov    %edx,0x8(%ebp)
    4dbd:	8b 55 0c             	mov    0xc(%ebp),%edx
    4dc0:	8d 4a 01             	lea    0x1(%edx),%ecx
    4dc3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    4dc6:	0f b6 12             	movzbl (%edx),%edx
    4dc9:	88 10                	mov    %dl,(%eax)
    4dcb:	0f b6 00             	movzbl (%eax),%eax
    4dce:	84 c0                	test   %al,%al
    4dd0:	75 e2                	jne    4db4 <strcpy+0xd>
    ;
  return os;
    4dd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    4dd5:	c9                   	leave  
    4dd6:	c3                   	ret    

00004dd7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    4dd7:	55                   	push   %ebp
    4dd8:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    4dda:	eb 08                	jmp    4de4 <strcmp+0xd>
    p++, q++;
    4ddc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    4de0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
    4de4:	8b 45 08             	mov    0x8(%ebp),%eax
    4de7:	0f b6 00             	movzbl (%eax),%eax
    4dea:	84 c0                	test   %al,%al
    4dec:	74 10                	je     4dfe <strcmp+0x27>
    4dee:	8b 45 08             	mov    0x8(%ebp),%eax
    4df1:	0f b6 10             	movzbl (%eax),%edx
    4df4:	8b 45 0c             	mov    0xc(%ebp),%eax
    4df7:	0f b6 00             	movzbl (%eax),%eax
    4dfa:	38 c2                	cmp    %al,%dl
    4dfc:	74 de                	je     4ddc <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
    4dfe:	8b 45 08             	mov    0x8(%ebp),%eax
    4e01:	0f b6 00             	movzbl (%eax),%eax
    4e04:	0f b6 d0             	movzbl %al,%edx
    4e07:	8b 45 0c             	mov    0xc(%ebp),%eax
    4e0a:	0f b6 00             	movzbl (%eax),%eax
    4e0d:	0f b6 c0             	movzbl %al,%eax
    4e10:	29 c2                	sub    %eax,%edx
    4e12:	89 d0                	mov    %edx,%eax
}
    4e14:	5d                   	pop    %ebp
    4e15:	c3                   	ret    

00004e16 <strlen>:

uint
strlen(char *s)
{
    4e16:	55                   	push   %ebp
    4e17:	89 e5                	mov    %esp,%ebp
    4e19:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    4e1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    4e23:	eb 04                	jmp    4e29 <strlen+0x13>
    4e25:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    4e29:	8b 55 fc             	mov    -0x4(%ebp),%edx
    4e2c:	8b 45 08             	mov    0x8(%ebp),%eax
    4e2f:	01 d0                	add    %edx,%eax
    4e31:	0f b6 00             	movzbl (%eax),%eax
    4e34:	84 c0                	test   %al,%al
    4e36:	75 ed                	jne    4e25 <strlen+0xf>
    ;
  return n;
    4e38:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    4e3b:	c9                   	leave  
    4e3c:	c3                   	ret    

00004e3d <memset>:

void*
memset(void *dst, int c, uint n)
{
    4e3d:	55                   	push   %ebp
    4e3e:	89 e5                	mov    %esp,%ebp
    4e40:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    4e43:	8b 45 10             	mov    0x10(%ebp),%eax
    4e46:	89 44 24 08          	mov    %eax,0x8(%esp)
    4e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
    4e4d:	89 44 24 04          	mov    %eax,0x4(%esp)
    4e51:	8b 45 08             	mov    0x8(%ebp),%eax
    4e54:	89 04 24             	mov    %eax,(%esp)
    4e57:	e8 26 ff ff ff       	call   4d82 <stosb>
  return dst;
    4e5c:	8b 45 08             	mov    0x8(%ebp),%eax
}
    4e5f:	c9                   	leave  
    4e60:	c3                   	ret    

00004e61 <strchr>:

char*
strchr(const char *s, char c)
{
    4e61:	55                   	push   %ebp
    4e62:	89 e5                	mov    %esp,%ebp
    4e64:	83 ec 04             	sub    $0x4,%esp
    4e67:	8b 45 0c             	mov    0xc(%ebp),%eax
    4e6a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    4e6d:	eb 14                	jmp    4e83 <strchr+0x22>
    if(*s == c)
    4e6f:	8b 45 08             	mov    0x8(%ebp),%eax
    4e72:	0f b6 00             	movzbl (%eax),%eax
    4e75:	3a 45 fc             	cmp    -0x4(%ebp),%al
    4e78:	75 05                	jne    4e7f <strchr+0x1e>
      return (char*)s;
    4e7a:	8b 45 08             	mov    0x8(%ebp),%eax
    4e7d:	eb 13                	jmp    4e92 <strchr+0x31>
  for(; *s; s++)
    4e7f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    4e83:	8b 45 08             	mov    0x8(%ebp),%eax
    4e86:	0f b6 00             	movzbl (%eax),%eax
    4e89:	84 c0                	test   %al,%al
    4e8b:	75 e2                	jne    4e6f <strchr+0xe>
  return 0;
    4e8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
    4e92:	c9                   	leave  
    4e93:	c3                   	ret    

00004e94 <gets>:

char*
gets(char *buf, int max)
{
    4e94:	55                   	push   %ebp
    4e95:	89 e5                	mov    %esp,%ebp
    4e97:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4e9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    4ea1:	eb 4c                	jmp    4eef <gets+0x5b>
    cc = read(0, &c, 1);
    4ea3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    4eaa:	00 
    4eab:	8d 45 ef             	lea    -0x11(%ebp),%eax
    4eae:	89 44 24 04          	mov    %eax,0x4(%esp)
    4eb2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    4eb9:	e8 44 01 00 00       	call   5002 <read>
    4ebe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    4ec1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4ec5:	7f 02                	jg     4ec9 <gets+0x35>
      break;
    4ec7:	eb 31                	jmp    4efa <gets+0x66>
    buf[i++] = c;
    4ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4ecc:	8d 50 01             	lea    0x1(%eax),%edx
    4ecf:	89 55 f4             	mov    %edx,-0xc(%ebp)
    4ed2:	89 c2                	mov    %eax,%edx
    4ed4:	8b 45 08             	mov    0x8(%ebp),%eax
    4ed7:	01 c2                	add    %eax,%edx
    4ed9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    4edd:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    4edf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    4ee3:	3c 0a                	cmp    $0xa,%al
    4ee5:	74 13                	je     4efa <gets+0x66>
    4ee7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    4eeb:	3c 0d                	cmp    $0xd,%al
    4eed:	74 0b                	je     4efa <gets+0x66>
  for(i=0; i+1 < max; ){
    4eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4ef2:	83 c0 01             	add    $0x1,%eax
    4ef5:	3b 45 0c             	cmp    0xc(%ebp),%eax
    4ef8:	7c a9                	jl     4ea3 <gets+0xf>
      break;
  }
  buf[i] = '\0';
    4efa:	8b 55 f4             	mov    -0xc(%ebp),%edx
    4efd:	8b 45 08             	mov    0x8(%ebp),%eax
    4f00:	01 d0                	add    %edx,%eax
    4f02:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    4f05:	8b 45 08             	mov    0x8(%ebp),%eax
}
    4f08:	c9                   	leave  
    4f09:	c3                   	ret    

00004f0a <stat>:

int
stat(char *n, struct stat *st)
{
    4f0a:	55                   	push   %ebp
    4f0b:	89 e5                	mov    %esp,%ebp
    4f0d:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4f10:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    4f17:	00 
    4f18:	8b 45 08             	mov    0x8(%ebp),%eax
    4f1b:	89 04 24             	mov    %eax,(%esp)
    4f1e:	e8 07 01 00 00       	call   502a <open>
    4f23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    4f26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4f2a:	79 07                	jns    4f33 <stat+0x29>
    return -1;
    4f2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    4f31:	eb 23                	jmp    4f56 <stat+0x4c>
  r = fstat(fd, st);
    4f33:	8b 45 0c             	mov    0xc(%ebp),%eax
    4f36:	89 44 24 04          	mov    %eax,0x4(%esp)
    4f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4f3d:	89 04 24             	mov    %eax,(%esp)
    4f40:	e8 fd 00 00 00       	call   5042 <fstat>
    4f45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    4f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4f4b:	89 04 24             	mov    %eax,(%esp)
    4f4e:	e8 bf 00 00 00       	call   5012 <close>
  return r;
    4f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    4f56:	c9                   	leave  
    4f57:	c3                   	ret    

00004f58 <atoi>:

int
atoi(const char *s)
{
    4f58:	55                   	push   %ebp
    4f59:	89 e5                	mov    %esp,%ebp
    4f5b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    4f5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    4f65:	eb 25                	jmp    4f8c <atoi+0x34>
    n = n*10 + *s++ - '0';
    4f67:	8b 55 fc             	mov    -0x4(%ebp),%edx
    4f6a:	89 d0                	mov    %edx,%eax
    4f6c:	c1 e0 02             	shl    $0x2,%eax
    4f6f:	01 d0                	add    %edx,%eax
    4f71:	01 c0                	add    %eax,%eax
    4f73:	89 c1                	mov    %eax,%ecx
    4f75:	8b 45 08             	mov    0x8(%ebp),%eax
    4f78:	8d 50 01             	lea    0x1(%eax),%edx
    4f7b:	89 55 08             	mov    %edx,0x8(%ebp)
    4f7e:	0f b6 00             	movzbl (%eax),%eax
    4f81:	0f be c0             	movsbl %al,%eax
    4f84:	01 c8                	add    %ecx,%eax
    4f86:	83 e8 30             	sub    $0x30,%eax
    4f89:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    4f8c:	8b 45 08             	mov    0x8(%ebp),%eax
    4f8f:	0f b6 00             	movzbl (%eax),%eax
    4f92:	3c 2f                	cmp    $0x2f,%al
    4f94:	7e 0a                	jle    4fa0 <atoi+0x48>
    4f96:	8b 45 08             	mov    0x8(%ebp),%eax
    4f99:	0f b6 00             	movzbl (%eax),%eax
    4f9c:	3c 39                	cmp    $0x39,%al
    4f9e:	7e c7                	jle    4f67 <atoi+0xf>
  return n;
    4fa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    4fa3:	c9                   	leave  
    4fa4:	c3                   	ret    

00004fa5 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    4fa5:	55                   	push   %ebp
    4fa6:	89 e5                	mov    %esp,%ebp
    4fa8:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    4fab:	8b 45 08             	mov    0x8(%ebp),%eax
    4fae:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    4fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
    4fb4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    4fb7:	eb 17                	jmp    4fd0 <memmove+0x2b>
    *dst++ = *src++;
    4fb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4fbc:	8d 50 01             	lea    0x1(%eax),%edx
    4fbf:	89 55 fc             	mov    %edx,-0x4(%ebp)
    4fc2:	8b 55 f8             	mov    -0x8(%ebp),%edx
    4fc5:	8d 4a 01             	lea    0x1(%edx),%ecx
    4fc8:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    4fcb:	0f b6 12             	movzbl (%edx),%edx
    4fce:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
    4fd0:	8b 45 10             	mov    0x10(%ebp),%eax
    4fd3:	8d 50 ff             	lea    -0x1(%eax),%edx
    4fd6:	89 55 10             	mov    %edx,0x10(%ebp)
    4fd9:	85 c0                	test   %eax,%eax
    4fdb:	7f dc                	jg     4fb9 <memmove+0x14>
  return vdst;
    4fdd:	8b 45 08             	mov    0x8(%ebp),%eax
}
    4fe0:	c9                   	leave  
    4fe1:	c3                   	ret    

00004fe2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    4fe2:	b8 01 00 00 00       	mov    $0x1,%eax
    4fe7:	cd 40                	int    $0x40
    4fe9:	c3                   	ret    

00004fea <exit>:
SYSCALL(exit)
    4fea:	b8 02 00 00 00       	mov    $0x2,%eax
    4fef:	cd 40                	int    $0x40
    4ff1:	c3                   	ret    

00004ff2 <wait>:
SYSCALL(wait)
    4ff2:	b8 03 00 00 00       	mov    $0x3,%eax
    4ff7:	cd 40                	int    $0x40
    4ff9:	c3                   	ret    

00004ffa <pipe>:
SYSCALL(pipe)
    4ffa:	b8 04 00 00 00       	mov    $0x4,%eax
    4fff:	cd 40                	int    $0x40
    5001:	c3                   	ret    

00005002 <read>:
SYSCALL(read)
    5002:	b8 05 00 00 00       	mov    $0x5,%eax
    5007:	cd 40                	int    $0x40
    5009:	c3                   	ret    

0000500a <write>:
SYSCALL(write)
    500a:	b8 10 00 00 00       	mov    $0x10,%eax
    500f:	cd 40                	int    $0x40
    5011:	c3                   	ret    

00005012 <close>:
SYSCALL(close)
    5012:	b8 15 00 00 00       	mov    $0x15,%eax
    5017:	cd 40                	int    $0x40
    5019:	c3                   	ret    

0000501a <kill>:
SYSCALL(kill)
    501a:	b8 06 00 00 00       	mov    $0x6,%eax
    501f:	cd 40                	int    $0x40
    5021:	c3                   	ret    

00005022 <exec>:
SYSCALL(exec)
    5022:	b8 07 00 00 00       	mov    $0x7,%eax
    5027:	cd 40                	int    $0x40
    5029:	c3                   	ret    

0000502a <open>:
SYSCALL(open)
    502a:	b8 0f 00 00 00       	mov    $0xf,%eax
    502f:	cd 40                	int    $0x40
    5031:	c3                   	ret    

00005032 <mknod>:
SYSCALL(mknod)
    5032:	b8 11 00 00 00       	mov    $0x11,%eax
    5037:	cd 40                	int    $0x40
    5039:	c3                   	ret    

0000503a <unlink>:
SYSCALL(unlink)
    503a:	b8 12 00 00 00       	mov    $0x12,%eax
    503f:	cd 40                	int    $0x40
    5041:	c3                   	ret    

00005042 <fstat>:
SYSCALL(fstat)
    5042:	b8 08 00 00 00       	mov    $0x8,%eax
    5047:	cd 40                	int    $0x40
    5049:	c3                   	ret    

0000504a <link>:
SYSCALL(link)
    504a:	b8 13 00 00 00       	mov    $0x13,%eax
    504f:	cd 40                	int    $0x40
    5051:	c3                   	ret    

00005052 <mkdir>:
SYSCALL(mkdir)
    5052:	b8 14 00 00 00       	mov    $0x14,%eax
    5057:	cd 40                	int    $0x40
    5059:	c3                   	ret    

0000505a <chdir>:
SYSCALL(chdir)
    505a:	b8 09 00 00 00       	mov    $0x9,%eax
    505f:	cd 40                	int    $0x40
    5061:	c3                   	ret    

00005062 <dup>:
SYSCALL(dup)
    5062:	b8 0a 00 00 00       	mov    $0xa,%eax
    5067:	cd 40                	int    $0x40
    5069:	c3                   	ret    

0000506a <getpid>:
SYSCALL(getpid)
    506a:	b8 0b 00 00 00       	mov    $0xb,%eax
    506f:	cd 40                	int    $0x40
    5071:	c3                   	ret    

00005072 <sbrk>:
SYSCALL(sbrk)
    5072:	b8 0c 00 00 00       	mov    $0xc,%eax
    5077:	cd 40                	int    $0x40
    5079:	c3                   	ret    

0000507a <sleep>:
SYSCALL(sleep)
    507a:	b8 0d 00 00 00       	mov    $0xd,%eax
    507f:	cd 40                	int    $0x40
    5081:	c3                   	ret    

00005082 <uptime>:
SYSCALL(uptime)
    5082:	b8 0e 00 00 00       	mov    $0xe,%eax
    5087:	cd 40                	int    $0x40
    5089:	c3                   	ret    

0000508a <shm_open>:
SYSCALL(shm_open)
    508a:	b8 16 00 00 00       	mov    $0x16,%eax
    508f:	cd 40                	int    $0x40
    5091:	c3                   	ret    

00005092 <shm_close>:
SYSCALL(shm_close)	
    5092:	b8 17 00 00 00       	mov    $0x17,%eax
    5097:	cd 40                	int    $0x40
    5099:	c3                   	ret    

0000509a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    509a:	55                   	push   %ebp
    509b:	89 e5                	mov    %esp,%ebp
    509d:	83 ec 18             	sub    $0x18,%esp
    50a0:	8b 45 0c             	mov    0xc(%ebp),%eax
    50a3:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    50a6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    50ad:	00 
    50ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
    50b1:	89 44 24 04          	mov    %eax,0x4(%esp)
    50b5:	8b 45 08             	mov    0x8(%ebp),%eax
    50b8:	89 04 24             	mov    %eax,(%esp)
    50bb:	e8 4a ff ff ff       	call   500a <write>
}
    50c0:	c9                   	leave  
    50c1:	c3                   	ret    

000050c2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    50c2:	55                   	push   %ebp
    50c3:	89 e5                	mov    %esp,%ebp
    50c5:	56                   	push   %esi
    50c6:	53                   	push   %ebx
    50c7:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    50ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    50d1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    50d5:	74 17                	je     50ee <printint+0x2c>
    50d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    50db:	79 11                	jns    50ee <printint+0x2c>
    neg = 1;
    50dd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    50e4:	8b 45 0c             	mov    0xc(%ebp),%eax
    50e7:	f7 d8                	neg    %eax
    50e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    50ec:	eb 06                	jmp    50f4 <printint+0x32>
  } else {
    x = xx;
    50ee:	8b 45 0c             	mov    0xc(%ebp),%eax
    50f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    50f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    50fb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    50fe:	8d 41 01             	lea    0x1(%ecx),%eax
    5101:	89 45 f4             	mov    %eax,-0xc(%ebp)
    5104:	8b 5d 10             	mov    0x10(%ebp),%ebx
    5107:	8b 45 ec             	mov    -0x14(%ebp),%eax
    510a:	ba 00 00 00 00       	mov    $0x0,%edx
    510f:	f7 f3                	div    %ebx
    5111:	89 d0                	mov    %edx,%eax
    5113:	0f b6 80 60 75 00 00 	movzbl 0x7560(%eax),%eax
    511a:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    511e:	8b 75 10             	mov    0x10(%ebp),%esi
    5121:	8b 45 ec             	mov    -0x14(%ebp),%eax
    5124:	ba 00 00 00 00       	mov    $0x0,%edx
    5129:	f7 f6                	div    %esi
    512b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    512e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    5132:	75 c7                	jne    50fb <printint+0x39>
  if(neg)
    5134:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    5138:	74 10                	je     514a <printint+0x88>
    buf[i++] = '-';
    513a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    513d:	8d 50 01             	lea    0x1(%eax),%edx
    5140:	89 55 f4             	mov    %edx,-0xc(%ebp)
    5143:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    5148:	eb 1f                	jmp    5169 <printint+0xa7>
    514a:	eb 1d                	jmp    5169 <printint+0xa7>
    putc(fd, buf[i]);
    514c:	8d 55 dc             	lea    -0x24(%ebp),%edx
    514f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5152:	01 d0                	add    %edx,%eax
    5154:	0f b6 00             	movzbl (%eax),%eax
    5157:	0f be c0             	movsbl %al,%eax
    515a:	89 44 24 04          	mov    %eax,0x4(%esp)
    515e:	8b 45 08             	mov    0x8(%ebp),%eax
    5161:	89 04 24             	mov    %eax,(%esp)
    5164:	e8 31 ff ff ff       	call   509a <putc>
  while(--i >= 0)
    5169:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    516d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    5171:	79 d9                	jns    514c <printint+0x8a>
}
    5173:	83 c4 30             	add    $0x30,%esp
    5176:	5b                   	pop    %ebx
    5177:	5e                   	pop    %esi
    5178:	5d                   	pop    %ebp
    5179:	c3                   	ret    

0000517a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    517a:	55                   	push   %ebp
    517b:	89 e5                	mov    %esp,%ebp
    517d:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    5180:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    5187:	8d 45 0c             	lea    0xc(%ebp),%eax
    518a:	83 c0 04             	add    $0x4,%eax
    518d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    5190:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    5197:	e9 7c 01 00 00       	jmp    5318 <printf+0x19e>
    c = fmt[i] & 0xff;
    519c:	8b 55 0c             	mov    0xc(%ebp),%edx
    519f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    51a2:	01 d0                	add    %edx,%eax
    51a4:	0f b6 00             	movzbl (%eax),%eax
    51a7:	0f be c0             	movsbl %al,%eax
    51aa:	25 ff 00 00 00       	and    $0xff,%eax
    51af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    51b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    51b6:	75 2c                	jne    51e4 <printf+0x6a>
      if(c == '%'){
    51b8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    51bc:	75 0c                	jne    51ca <printf+0x50>
        state = '%';
    51be:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    51c5:	e9 4a 01 00 00       	jmp    5314 <printf+0x19a>
      } else {
        putc(fd, c);
    51ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    51cd:	0f be c0             	movsbl %al,%eax
    51d0:	89 44 24 04          	mov    %eax,0x4(%esp)
    51d4:	8b 45 08             	mov    0x8(%ebp),%eax
    51d7:	89 04 24             	mov    %eax,(%esp)
    51da:	e8 bb fe ff ff       	call   509a <putc>
    51df:	e9 30 01 00 00       	jmp    5314 <printf+0x19a>
      }
    } else if(state == '%'){
    51e4:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    51e8:	0f 85 26 01 00 00    	jne    5314 <printf+0x19a>
      if(c == 'd'){
    51ee:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    51f2:	75 2d                	jne    5221 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    51f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
    51f7:	8b 00                	mov    (%eax),%eax
    51f9:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    5200:	00 
    5201:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    5208:	00 
    5209:	89 44 24 04          	mov    %eax,0x4(%esp)
    520d:	8b 45 08             	mov    0x8(%ebp),%eax
    5210:	89 04 24             	mov    %eax,(%esp)
    5213:	e8 aa fe ff ff       	call   50c2 <printint>
        ap++;
    5218:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    521c:	e9 ec 00 00 00       	jmp    530d <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    5221:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    5225:	74 06                	je     522d <printf+0xb3>
    5227:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    522b:	75 2d                	jne    525a <printf+0xe0>
        printint(fd, *ap, 16, 0);
    522d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    5230:	8b 00                	mov    (%eax),%eax
    5232:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    5239:	00 
    523a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    5241:	00 
    5242:	89 44 24 04          	mov    %eax,0x4(%esp)
    5246:	8b 45 08             	mov    0x8(%ebp),%eax
    5249:	89 04 24             	mov    %eax,(%esp)
    524c:	e8 71 fe ff ff       	call   50c2 <printint>
        ap++;
    5251:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    5255:	e9 b3 00 00 00       	jmp    530d <printf+0x193>
      } else if(c == 's'){
    525a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    525e:	75 45                	jne    52a5 <printf+0x12b>
        s = (char*)*ap;
    5260:	8b 45 e8             	mov    -0x18(%ebp),%eax
    5263:	8b 00                	mov    (%eax),%eax
    5265:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    5268:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    526c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    5270:	75 09                	jne    527b <printf+0x101>
          s = "(null)";
    5272:	c7 45 f4 c2 6d 00 00 	movl   $0x6dc2,-0xc(%ebp)
        while(*s != 0){
    5279:	eb 1e                	jmp    5299 <printf+0x11f>
    527b:	eb 1c                	jmp    5299 <printf+0x11f>
          putc(fd, *s);
    527d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5280:	0f b6 00             	movzbl (%eax),%eax
    5283:	0f be c0             	movsbl %al,%eax
    5286:	89 44 24 04          	mov    %eax,0x4(%esp)
    528a:	8b 45 08             	mov    0x8(%ebp),%eax
    528d:	89 04 24             	mov    %eax,(%esp)
    5290:	e8 05 fe ff ff       	call   509a <putc>
          s++;
    5295:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
    5299:	8b 45 f4             	mov    -0xc(%ebp),%eax
    529c:	0f b6 00             	movzbl (%eax),%eax
    529f:	84 c0                	test   %al,%al
    52a1:	75 da                	jne    527d <printf+0x103>
    52a3:	eb 68                	jmp    530d <printf+0x193>
        }
      } else if(c == 'c'){
    52a5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    52a9:	75 1d                	jne    52c8 <printf+0x14e>
        putc(fd, *ap);
    52ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
    52ae:	8b 00                	mov    (%eax),%eax
    52b0:	0f be c0             	movsbl %al,%eax
    52b3:	89 44 24 04          	mov    %eax,0x4(%esp)
    52b7:	8b 45 08             	mov    0x8(%ebp),%eax
    52ba:	89 04 24             	mov    %eax,(%esp)
    52bd:	e8 d8 fd ff ff       	call   509a <putc>
        ap++;
    52c2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    52c6:	eb 45                	jmp    530d <printf+0x193>
      } else if(c == '%'){
    52c8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    52cc:	75 17                	jne    52e5 <printf+0x16b>
        putc(fd, c);
    52ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    52d1:	0f be c0             	movsbl %al,%eax
    52d4:	89 44 24 04          	mov    %eax,0x4(%esp)
    52d8:	8b 45 08             	mov    0x8(%ebp),%eax
    52db:	89 04 24             	mov    %eax,(%esp)
    52de:	e8 b7 fd ff ff       	call   509a <putc>
    52e3:	eb 28                	jmp    530d <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    52e5:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    52ec:	00 
    52ed:	8b 45 08             	mov    0x8(%ebp),%eax
    52f0:	89 04 24             	mov    %eax,(%esp)
    52f3:	e8 a2 fd ff ff       	call   509a <putc>
        putc(fd, c);
    52f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    52fb:	0f be c0             	movsbl %al,%eax
    52fe:	89 44 24 04          	mov    %eax,0x4(%esp)
    5302:	8b 45 08             	mov    0x8(%ebp),%eax
    5305:	89 04 24             	mov    %eax,(%esp)
    5308:	e8 8d fd ff ff       	call   509a <putc>
      }
      state = 0;
    530d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    5314:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    5318:	8b 55 0c             	mov    0xc(%ebp),%edx
    531b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    531e:	01 d0                	add    %edx,%eax
    5320:	0f b6 00             	movzbl (%eax),%eax
    5323:	84 c0                	test   %al,%al
    5325:	0f 85 71 fe ff ff    	jne    519c <printf+0x22>
    }
  }
}
    532b:	c9                   	leave  
    532c:	c3                   	ret    

0000532d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    532d:	55                   	push   %ebp
    532e:	89 e5                	mov    %esp,%ebp
    5330:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5333:	8b 45 08             	mov    0x8(%ebp),%eax
    5336:	83 e8 08             	sub    $0x8,%eax
    5339:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    533c:	a1 08 76 00 00       	mov    0x7608,%eax
    5341:	89 45 fc             	mov    %eax,-0x4(%ebp)
    5344:	eb 24                	jmp    536a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5346:	8b 45 fc             	mov    -0x4(%ebp),%eax
    5349:	8b 00                	mov    (%eax),%eax
    534b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    534e:	77 12                	ja     5362 <free+0x35>
    5350:	8b 45 f8             	mov    -0x8(%ebp),%eax
    5353:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    5356:	77 24                	ja     537c <free+0x4f>
    5358:	8b 45 fc             	mov    -0x4(%ebp),%eax
    535b:	8b 00                	mov    (%eax),%eax
    535d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    5360:	77 1a                	ja     537c <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5362:	8b 45 fc             	mov    -0x4(%ebp),%eax
    5365:	8b 00                	mov    (%eax),%eax
    5367:	89 45 fc             	mov    %eax,-0x4(%ebp)
    536a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    536d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    5370:	76 d4                	jbe    5346 <free+0x19>
    5372:	8b 45 fc             	mov    -0x4(%ebp),%eax
    5375:	8b 00                	mov    (%eax),%eax
    5377:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    537a:	76 ca                	jbe    5346 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    537c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    537f:	8b 40 04             	mov    0x4(%eax),%eax
    5382:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    5389:	8b 45 f8             	mov    -0x8(%ebp),%eax
    538c:	01 c2                	add    %eax,%edx
    538e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    5391:	8b 00                	mov    (%eax),%eax
    5393:	39 c2                	cmp    %eax,%edx
    5395:	75 24                	jne    53bb <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    5397:	8b 45 f8             	mov    -0x8(%ebp),%eax
    539a:	8b 50 04             	mov    0x4(%eax),%edx
    539d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    53a0:	8b 00                	mov    (%eax),%eax
    53a2:	8b 40 04             	mov    0x4(%eax),%eax
    53a5:	01 c2                	add    %eax,%edx
    53a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    53aa:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    53ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
    53b0:	8b 00                	mov    (%eax),%eax
    53b2:	8b 10                	mov    (%eax),%edx
    53b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    53b7:	89 10                	mov    %edx,(%eax)
    53b9:	eb 0a                	jmp    53c5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    53bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    53be:	8b 10                	mov    (%eax),%edx
    53c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    53c3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    53c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    53c8:	8b 40 04             	mov    0x4(%eax),%eax
    53cb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    53d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    53d5:	01 d0                	add    %edx,%eax
    53d7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    53da:	75 20                	jne    53fc <free+0xcf>
    p->s.size += bp->s.size;
    53dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    53df:	8b 50 04             	mov    0x4(%eax),%edx
    53e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    53e5:	8b 40 04             	mov    0x4(%eax),%eax
    53e8:	01 c2                	add    %eax,%edx
    53ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
    53ed:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    53f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    53f3:	8b 10                	mov    (%eax),%edx
    53f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    53f8:	89 10                	mov    %edx,(%eax)
    53fa:	eb 08                	jmp    5404 <free+0xd7>
  } else
    p->s.ptr = bp;
    53fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    53ff:	8b 55 f8             	mov    -0x8(%ebp),%edx
    5402:	89 10                	mov    %edx,(%eax)
  freep = p;
    5404:	8b 45 fc             	mov    -0x4(%ebp),%eax
    5407:	a3 08 76 00 00       	mov    %eax,0x7608
}
    540c:	c9                   	leave  
    540d:	c3                   	ret    

0000540e <morecore>:

static Header*
morecore(uint nu)
{
    540e:	55                   	push   %ebp
    540f:	89 e5                	mov    %esp,%ebp
    5411:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    5414:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    541b:	77 07                	ja     5424 <morecore+0x16>
    nu = 4096;
    541d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    5424:	8b 45 08             	mov    0x8(%ebp),%eax
    5427:	c1 e0 03             	shl    $0x3,%eax
    542a:	89 04 24             	mov    %eax,(%esp)
    542d:	e8 40 fc ff ff       	call   5072 <sbrk>
    5432:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    5435:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    5439:	75 07                	jne    5442 <morecore+0x34>
    return 0;
    543b:	b8 00 00 00 00       	mov    $0x0,%eax
    5440:	eb 22                	jmp    5464 <morecore+0x56>
  hp = (Header*)p;
    5442:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5445:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    5448:	8b 45 f0             	mov    -0x10(%ebp),%eax
    544b:	8b 55 08             	mov    0x8(%ebp),%edx
    544e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    5451:	8b 45 f0             	mov    -0x10(%ebp),%eax
    5454:	83 c0 08             	add    $0x8,%eax
    5457:	89 04 24             	mov    %eax,(%esp)
    545a:	e8 ce fe ff ff       	call   532d <free>
  return freep;
    545f:	a1 08 76 00 00       	mov    0x7608,%eax
}
    5464:	c9                   	leave  
    5465:	c3                   	ret    

00005466 <malloc>:

void*
malloc(uint nbytes)
{
    5466:	55                   	push   %ebp
    5467:	89 e5                	mov    %esp,%ebp
    5469:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    546c:	8b 45 08             	mov    0x8(%ebp),%eax
    546f:	83 c0 07             	add    $0x7,%eax
    5472:	c1 e8 03             	shr    $0x3,%eax
    5475:	83 c0 01             	add    $0x1,%eax
    5478:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    547b:	a1 08 76 00 00       	mov    0x7608,%eax
    5480:	89 45 f0             	mov    %eax,-0x10(%ebp)
    5483:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    5487:	75 23                	jne    54ac <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    5489:	c7 45 f0 00 76 00 00 	movl   $0x7600,-0x10(%ebp)
    5490:	8b 45 f0             	mov    -0x10(%ebp),%eax
    5493:	a3 08 76 00 00       	mov    %eax,0x7608
    5498:	a1 08 76 00 00       	mov    0x7608,%eax
    549d:	a3 00 76 00 00       	mov    %eax,0x7600
    base.s.size = 0;
    54a2:	c7 05 04 76 00 00 00 	movl   $0x0,0x7604
    54a9:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    54ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
    54af:	8b 00                	mov    (%eax),%eax
    54b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    54b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    54b7:	8b 40 04             	mov    0x4(%eax),%eax
    54ba:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    54bd:	72 4d                	jb     550c <malloc+0xa6>
      if(p->s.size == nunits)
    54bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    54c2:	8b 40 04             	mov    0x4(%eax),%eax
    54c5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    54c8:	75 0c                	jne    54d6 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    54ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    54cd:	8b 10                	mov    (%eax),%edx
    54cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
    54d2:	89 10                	mov    %edx,(%eax)
    54d4:	eb 26                	jmp    54fc <malloc+0x96>
      else {
        p->s.size -= nunits;
    54d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    54d9:	8b 40 04             	mov    0x4(%eax),%eax
    54dc:	2b 45 ec             	sub    -0x14(%ebp),%eax
    54df:	89 c2                	mov    %eax,%edx
    54e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    54e4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    54e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    54ea:	8b 40 04             	mov    0x4(%eax),%eax
    54ed:	c1 e0 03             	shl    $0x3,%eax
    54f0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    54f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    54f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
    54f9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    54fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    54ff:	a3 08 76 00 00       	mov    %eax,0x7608
      return (void*)(p + 1);
    5504:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5507:	83 c0 08             	add    $0x8,%eax
    550a:	eb 38                	jmp    5544 <malloc+0xde>
    }
    if(p == freep)
    550c:	a1 08 76 00 00       	mov    0x7608,%eax
    5511:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    5514:	75 1b                	jne    5531 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    5516:	8b 45 ec             	mov    -0x14(%ebp),%eax
    5519:	89 04 24             	mov    %eax,(%esp)
    551c:	e8 ed fe ff ff       	call   540e <morecore>
    5521:	89 45 f4             	mov    %eax,-0xc(%ebp)
    5524:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    5528:	75 07                	jne    5531 <malloc+0xcb>
        return 0;
    552a:	b8 00 00 00 00       	mov    $0x0,%eax
    552f:	eb 13                	jmp    5544 <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5531:	8b 45 f4             	mov    -0xc(%ebp),%eax
    5534:	89 45 f0             	mov    %eax,-0x10(%ebp)
    5537:	8b 45 f4             	mov    -0xc(%ebp),%eax
    553a:	8b 00                	mov    (%eax),%eax
    553c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
    553f:	e9 70 ff ff ff       	jmp    54b4 <malloc+0x4e>
}
    5544:	c9                   	leave  
    5545:	c3                   	ret    

00005546 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    5546:	55                   	push   %ebp
    5547:	89 e5                	mov    %esp,%ebp
    5549:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    554c:	8b 55 08             	mov    0x8(%ebp),%edx
    554f:	8b 45 0c             	mov    0xc(%ebp),%eax
    5552:	8b 4d 08             	mov    0x8(%ebp),%ecx
    5555:	f0 87 02             	lock xchg %eax,(%edx)
    5558:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    555b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    555e:	c9                   	leave  
    555f:	c3                   	ret    

00005560 <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    5560:	55                   	push   %ebp
    5561:	89 e5                	mov    %esp,%ebp
    5563:	83 ec 08             	sub    $0x8,%esp
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    5566:	90                   	nop
    5567:	8b 45 08             	mov    0x8(%ebp),%eax
    556a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    5571:	00 
    5572:	89 04 24             	mov    %eax,(%esp)
    5575:	e8 cc ff ff ff       	call   5546 <xchg>
    557a:	85 c0                	test   %eax,%eax
    557c:	75 e9                	jne    5567 <uacquire+0x7>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    557e:	0f ae f0             	mfence 
}
    5581:	c9                   	leave  
    5582:	c3                   	ret    

00005583 <urelease>:

void urelease (struct uspinlock *lk) {
    5583:	55                   	push   %ebp
    5584:	89 e5                	mov    %esp,%ebp
  __sync_synchronize();
    5586:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    5589:	8b 45 08             	mov    0x8(%ebp),%eax
    558c:	8b 55 08             	mov    0x8(%ebp),%edx
    558f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    5595:	5d                   	pop    %ebp
    5596:	c3                   	ret    
