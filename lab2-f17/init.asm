
_init:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    1009:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    1010:	00 
    1011:	c7 04 24 27 19 00 00 	movl   $0x1927,(%esp)
    1018:	e8 9a 03 00 00       	call   13b7 <open>
    101d:	85 c0                	test   %eax,%eax
    101f:	79 30                	jns    1051 <main+0x51>
    mknod("console", 1, 1);
    1021:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1028:	00 
    1029:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1030:	00 
    1031:	c7 04 24 27 19 00 00 	movl   $0x1927,(%esp)
    1038:	e8 82 03 00 00       	call   13bf <mknod>
    open("console", O_RDWR);
    103d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    1044:	00 
    1045:	c7 04 24 27 19 00 00 	movl   $0x1927,(%esp)
    104c:	e8 66 03 00 00       	call   13b7 <open>
  }
  dup(0);  // stdout
    1051:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1058:	e8 92 03 00 00       	call   13ef <dup>
  dup(0);  // stderr
    105d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1064:	e8 86 03 00 00       	call   13ef <dup>

  for(;;){
    printf(1, "init: starting sh\n");
    1069:	c7 44 24 04 2f 19 00 	movl   $0x192f,0x4(%esp)
    1070:	00 
    1071:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1078:	e8 8a 04 00 00       	call   1507 <printf>
    pid = fork();
    107d:	e8 ed 02 00 00       	call   136f <fork>
    1082:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
    1086:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
    108b:	79 19                	jns    10a6 <main+0xa6>
      printf(1, "init: fork failed\n");
    108d:	c7 44 24 04 42 19 00 	movl   $0x1942,0x4(%esp)
    1094:	00 
    1095:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    109c:	e8 66 04 00 00       	call   1507 <printf>
      exit();
    10a1:	e8 d1 02 00 00       	call   1377 <exit>
    }
    if(pid == 0){
    10a6:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
    10ab:	75 2d                	jne    10da <main+0xda>
      exec("sh", argv);
    10ad:	c7 44 24 04 20 1c 00 	movl   $0x1c20,0x4(%esp)
    10b4:	00 
    10b5:	c7 04 24 24 19 00 00 	movl   $0x1924,(%esp)
    10bc:	e8 ee 02 00 00       	call   13af <exec>
      printf(1, "init: exec sh failed\n");
    10c1:	c7 44 24 04 55 19 00 	movl   $0x1955,0x4(%esp)
    10c8:	00 
    10c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10d0:	e8 32 04 00 00       	call   1507 <printf>
      exit();
    10d5:	e8 9d 02 00 00       	call   1377 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
    10da:	eb 14                	jmp    10f0 <main+0xf0>
      printf(1, "zombie!\n");
    10dc:	c7 44 24 04 6b 19 00 	movl   $0x196b,0x4(%esp)
    10e3:	00 
    10e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10eb:	e8 17 04 00 00       	call   1507 <printf>
    while((wpid=wait()) >= 0 && wpid != pid)
    10f0:	e8 8a 02 00 00       	call   137f <wait>
    10f5:	89 44 24 18          	mov    %eax,0x18(%esp)
    10f9:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
    10fe:	78 0a                	js     110a <main+0x10a>
    1100:	8b 44 24 18          	mov    0x18(%esp),%eax
    1104:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
    1108:	75 d2                	jne    10dc <main+0xdc>
  }
    110a:	e9 5a ff ff ff       	jmp    1069 <main+0x69>

0000110f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    110f:	55                   	push   %ebp
    1110:	89 e5                	mov    %esp,%ebp
    1112:	57                   	push   %edi
    1113:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1114:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1117:	8b 55 10             	mov    0x10(%ebp),%edx
    111a:	8b 45 0c             	mov    0xc(%ebp),%eax
    111d:	89 cb                	mov    %ecx,%ebx
    111f:	89 df                	mov    %ebx,%edi
    1121:	89 d1                	mov    %edx,%ecx
    1123:	fc                   	cld    
    1124:	f3 aa                	rep stos %al,%es:(%edi)
    1126:	89 ca                	mov    %ecx,%edx
    1128:	89 fb                	mov    %edi,%ebx
    112a:	89 5d 08             	mov    %ebx,0x8(%ebp)
    112d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1130:	5b                   	pop    %ebx
    1131:	5f                   	pop    %edi
    1132:	5d                   	pop    %ebp
    1133:	c3                   	ret    

00001134 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1134:	55                   	push   %ebp
    1135:	89 e5                	mov    %esp,%ebp
    1137:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    113a:	8b 45 08             	mov    0x8(%ebp),%eax
    113d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1140:	90                   	nop
    1141:	8b 45 08             	mov    0x8(%ebp),%eax
    1144:	8d 50 01             	lea    0x1(%eax),%edx
    1147:	89 55 08             	mov    %edx,0x8(%ebp)
    114a:	8b 55 0c             	mov    0xc(%ebp),%edx
    114d:	8d 4a 01             	lea    0x1(%edx),%ecx
    1150:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1153:	0f b6 12             	movzbl (%edx),%edx
    1156:	88 10                	mov    %dl,(%eax)
    1158:	0f b6 00             	movzbl (%eax),%eax
    115b:	84 c0                	test   %al,%al
    115d:	75 e2                	jne    1141 <strcpy+0xd>
    ;
  return os;
    115f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1162:	c9                   	leave  
    1163:	c3                   	ret    

00001164 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1164:	55                   	push   %ebp
    1165:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1167:	eb 08                	jmp    1171 <strcmp+0xd>
    p++, q++;
    1169:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    116d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
    1171:	8b 45 08             	mov    0x8(%ebp),%eax
    1174:	0f b6 00             	movzbl (%eax),%eax
    1177:	84 c0                	test   %al,%al
    1179:	74 10                	je     118b <strcmp+0x27>
    117b:	8b 45 08             	mov    0x8(%ebp),%eax
    117e:	0f b6 10             	movzbl (%eax),%edx
    1181:	8b 45 0c             	mov    0xc(%ebp),%eax
    1184:	0f b6 00             	movzbl (%eax),%eax
    1187:	38 c2                	cmp    %al,%dl
    1189:	74 de                	je     1169 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
    118b:	8b 45 08             	mov    0x8(%ebp),%eax
    118e:	0f b6 00             	movzbl (%eax),%eax
    1191:	0f b6 d0             	movzbl %al,%edx
    1194:	8b 45 0c             	mov    0xc(%ebp),%eax
    1197:	0f b6 00             	movzbl (%eax),%eax
    119a:	0f b6 c0             	movzbl %al,%eax
    119d:	29 c2                	sub    %eax,%edx
    119f:	89 d0                	mov    %edx,%eax
}
    11a1:	5d                   	pop    %ebp
    11a2:	c3                   	ret    

000011a3 <strlen>:

uint
strlen(char *s)
{
    11a3:	55                   	push   %ebp
    11a4:	89 e5                	mov    %esp,%ebp
    11a6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    11a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    11b0:	eb 04                	jmp    11b6 <strlen+0x13>
    11b2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    11b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11b9:	8b 45 08             	mov    0x8(%ebp),%eax
    11bc:	01 d0                	add    %edx,%eax
    11be:	0f b6 00             	movzbl (%eax),%eax
    11c1:	84 c0                	test   %al,%al
    11c3:	75 ed                	jne    11b2 <strlen+0xf>
    ;
  return n;
    11c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11c8:	c9                   	leave  
    11c9:	c3                   	ret    

000011ca <memset>:

void*
memset(void *dst, int c, uint n)
{
    11ca:	55                   	push   %ebp
    11cb:	89 e5                	mov    %esp,%ebp
    11cd:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    11d0:	8b 45 10             	mov    0x10(%ebp),%eax
    11d3:	89 44 24 08          	mov    %eax,0x8(%esp)
    11d7:	8b 45 0c             	mov    0xc(%ebp),%eax
    11da:	89 44 24 04          	mov    %eax,0x4(%esp)
    11de:	8b 45 08             	mov    0x8(%ebp),%eax
    11e1:	89 04 24             	mov    %eax,(%esp)
    11e4:	e8 26 ff ff ff       	call   110f <stosb>
  return dst;
    11e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11ec:	c9                   	leave  
    11ed:	c3                   	ret    

000011ee <strchr>:

char*
strchr(const char *s, char c)
{
    11ee:	55                   	push   %ebp
    11ef:	89 e5                	mov    %esp,%ebp
    11f1:	83 ec 04             	sub    $0x4,%esp
    11f4:	8b 45 0c             	mov    0xc(%ebp),%eax
    11f7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    11fa:	eb 14                	jmp    1210 <strchr+0x22>
    if(*s == c)
    11fc:	8b 45 08             	mov    0x8(%ebp),%eax
    11ff:	0f b6 00             	movzbl (%eax),%eax
    1202:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1205:	75 05                	jne    120c <strchr+0x1e>
      return (char*)s;
    1207:	8b 45 08             	mov    0x8(%ebp),%eax
    120a:	eb 13                	jmp    121f <strchr+0x31>
  for(; *s; s++)
    120c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1210:	8b 45 08             	mov    0x8(%ebp),%eax
    1213:	0f b6 00             	movzbl (%eax),%eax
    1216:	84 c0                	test   %al,%al
    1218:	75 e2                	jne    11fc <strchr+0xe>
  return 0;
    121a:	b8 00 00 00 00       	mov    $0x0,%eax
}
    121f:	c9                   	leave  
    1220:	c3                   	ret    

00001221 <gets>:

char*
gets(char *buf, int max)
{
    1221:	55                   	push   %ebp
    1222:	89 e5                	mov    %esp,%ebp
    1224:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1227:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    122e:	eb 4c                	jmp    127c <gets+0x5b>
    cc = read(0, &c, 1);
    1230:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1237:	00 
    1238:	8d 45 ef             	lea    -0x11(%ebp),%eax
    123b:	89 44 24 04          	mov    %eax,0x4(%esp)
    123f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1246:	e8 44 01 00 00       	call   138f <read>
    124b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    124e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1252:	7f 02                	jg     1256 <gets+0x35>
      break;
    1254:	eb 31                	jmp    1287 <gets+0x66>
    buf[i++] = c;
    1256:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1259:	8d 50 01             	lea    0x1(%eax),%edx
    125c:	89 55 f4             	mov    %edx,-0xc(%ebp)
    125f:	89 c2                	mov    %eax,%edx
    1261:	8b 45 08             	mov    0x8(%ebp),%eax
    1264:	01 c2                	add    %eax,%edx
    1266:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    126a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    126c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1270:	3c 0a                	cmp    $0xa,%al
    1272:	74 13                	je     1287 <gets+0x66>
    1274:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1278:	3c 0d                	cmp    $0xd,%al
    127a:	74 0b                	je     1287 <gets+0x66>
  for(i=0; i+1 < max; ){
    127c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    127f:	83 c0 01             	add    $0x1,%eax
    1282:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1285:	7c a9                	jl     1230 <gets+0xf>
      break;
  }
  buf[i] = '\0';
    1287:	8b 55 f4             	mov    -0xc(%ebp),%edx
    128a:	8b 45 08             	mov    0x8(%ebp),%eax
    128d:	01 d0                	add    %edx,%eax
    128f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1292:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1295:	c9                   	leave  
    1296:	c3                   	ret    

00001297 <stat>:

int
stat(char *n, struct stat *st)
{
    1297:	55                   	push   %ebp
    1298:	89 e5                	mov    %esp,%ebp
    129a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    129d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    12a4:	00 
    12a5:	8b 45 08             	mov    0x8(%ebp),%eax
    12a8:	89 04 24             	mov    %eax,(%esp)
    12ab:	e8 07 01 00 00       	call   13b7 <open>
    12b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    12b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12b7:	79 07                	jns    12c0 <stat+0x29>
    return -1;
    12b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12be:	eb 23                	jmp    12e3 <stat+0x4c>
  r = fstat(fd, st);
    12c0:	8b 45 0c             	mov    0xc(%ebp),%eax
    12c3:	89 44 24 04          	mov    %eax,0x4(%esp)
    12c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12ca:	89 04 24             	mov    %eax,(%esp)
    12cd:	e8 fd 00 00 00       	call   13cf <fstat>
    12d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    12d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12d8:	89 04 24             	mov    %eax,(%esp)
    12db:	e8 bf 00 00 00       	call   139f <close>
  return r;
    12e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    12e3:	c9                   	leave  
    12e4:	c3                   	ret    

000012e5 <atoi>:

int
atoi(const char *s)
{
    12e5:	55                   	push   %ebp
    12e6:	89 e5                	mov    %esp,%ebp
    12e8:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    12eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    12f2:	eb 25                	jmp    1319 <atoi+0x34>
    n = n*10 + *s++ - '0';
    12f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
    12f7:	89 d0                	mov    %edx,%eax
    12f9:	c1 e0 02             	shl    $0x2,%eax
    12fc:	01 d0                	add    %edx,%eax
    12fe:	01 c0                	add    %eax,%eax
    1300:	89 c1                	mov    %eax,%ecx
    1302:	8b 45 08             	mov    0x8(%ebp),%eax
    1305:	8d 50 01             	lea    0x1(%eax),%edx
    1308:	89 55 08             	mov    %edx,0x8(%ebp)
    130b:	0f b6 00             	movzbl (%eax),%eax
    130e:	0f be c0             	movsbl %al,%eax
    1311:	01 c8                	add    %ecx,%eax
    1313:	83 e8 30             	sub    $0x30,%eax
    1316:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1319:	8b 45 08             	mov    0x8(%ebp),%eax
    131c:	0f b6 00             	movzbl (%eax),%eax
    131f:	3c 2f                	cmp    $0x2f,%al
    1321:	7e 0a                	jle    132d <atoi+0x48>
    1323:	8b 45 08             	mov    0x8(%ebp),%eax
    1326:	0f b6 00             	movzbl (%eax),%eax
    1329:	3c 39                	cmp    $0x39,%al
    132b:	7e c7                	jle    12f4 <atoi+0xf>
  return n;
    132d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1330:	c9                   	leave  
    1331:	c3                   	ret    

00001332 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1332:	55                   	push   %ebp
    1333:	89 e5                	mov    %esp,%ebp
    1335:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    1338:	8b 45 08             	mov    0x8(%ebp),%eax
    133b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    133e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1341:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1344:	eb 17                	jmp    135d <memmove+0x2b>
    *dst++ = *src++;
    1346:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1349:	8d 50 01             	lea    0x1(%eax),%edx
    134c:	89 55 fc             	mov    %edx,-0x4(%ebp)
    134f:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1352:	8d 4a 01             	lea    0x1(%edx),%ecx
    1355:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1358:	0f b6 12             	movzbl (%edx),%edx
    135b:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
    135d:	8b 45 10             	mov    0x10(%ebp),%eax
    1360:	8d 50 ff             	lea    -0x1(%eax),%edx
    1363:	89 55 10             	mov    %edx,0x10(%ebp)
    1366:	85 c0                	test   %eax,%eax
    1368:	7f dc                	jg     1346 <memmove+0x14>
  return vdst;
    136a:	8b 45 08             	mov    0x8(%ebp),%eax
}
    136d:	c9                   	leave  
    136e:	c3                   	ret    

0000136f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    136f:	b8 01 00 00 00       	mov    $0x1,%eax
    1374:	cd 40                	int    $0x40
    1376:	c3                   	ret    

00001377 <exit>:
SYSCALL(exit)
    1377:	b8 02 00 00 00       	mov    $0x2,%eax
    137c:	cd 40                	int    $0x40
    137e:	c3                   	ret    

0000137f <wait>:
SYSCALL(wait)
    137f:	b8 03 00 00 00       	mov    $0x3,%eax
    1384:	cd 40                	int    $0x40
    1386:	c3                   	ret    

00001387 <pipe>:
SYSCALL(pipe)
    1387:	b8 04 00 00 00       	mov    $0x4,%eax
    138c:	cd 40                	int    $0x40
    138e:	c3                   	ret    

0000138f <read>:
SYSCALL(read)
    138f:	b8 05 00 00 00       	mov    $0x5,%eax
    1394:	cd 40                	int    $0x40
    1396:	c3                   	ret    

00001397 <write>:
SYSCALL(write)
    1397:	b8 10 00 00 00       	mov    $0x10,%eax
    139c:	cd 40                	int    $0x40
    139e:	c3                   	ret    

0000139f <close>:
SYSCALL(close)
    139f:	b8 15 00 00 00       	mov    $0x15,%eax
    13a4:	cd 40                	int    $0x40
    13a6:	c3                   	ret    

000013a7 <kill>:
SYSCALL(kill)
    13a7:	b8 06 00 00 00       	mov    $0x6,%eax
    13ac:	cd 40                	int    $0x40
    13ae:	c3                   	ret    

000013af <exec>:
SYSCALL(exec)
    13af:	b8 07 00 00 00       	mov    $0x7,%eax
    13b4:	cd 40                	int    $0x40
    13b6:	c3                   	ret    

000013b7 <open>:
SYSCALL(open)
    13b7:	b8 0f 00 00 00       	mov    $0xf,%eax
    13bc:	cd 40                	int    $0x40
    13be:	c3                   	ret    

000013bf <mknod>:
SYSCALL(mknod)
    13bf:	b8 11 00 00 00       	mov    $0x11,%eax
    13c4:	cd 40                	int    $0x40
    13c6:	c3                   	ret    

000013c7 <unlink>:
SYSCALL(unlink)
    13c7:	b8 12 00 00 00       	mov    $0x12,%eax
    13cc:	cd 40                	int    $0x40
    13ce:	c3                   	ret    

000013cf <fstat>:
SYSCALL(fstat)
    13cf:	b8 08 00 00 00       	mov    $0x8,%eax
    13d4:	cd 40                	int    $0x40
    13d6:	c3                   	ret    

000013d7 <link>:
SYSCALL(link)
    13d7:	b8 13 00 00 00       	mov    $0x13,%eax
    13dc:	cd 40                	int    $0x40
    13de:	c3                   	ret    

000013df <mkdir>:
SYSCALL(mkdir)
    13df:	b8 14 00 00 00       	mov    $0x14,%eax
    13e4:	cd 40                	int    $0x40
    13e6:	c3                   	ret    

000013e7 <chdir>:
SYSCALL(chdir)
    13e7:	b8 09 00 00 00       	mov    $0x9,%eax
    13ec:	cd 40                	int    $0x40
    13ee:	c3                   	ret    

000013ef <dup>:
SYSCALL(dup)
    13ef:	b8 0a 00 00 00       	mov    $0xa,%eax
    13f4:	cd 40                	int    $0x40
    13f6:	c3                   	ret    

000013f7 <getpid>:
SYSCALL(getpid)
    13f7:	b8 0b 00 00 00       	mov    $0xb,%eax
    13fc:	cd 40                	int    $0x40
    13fe:	c3                   	ret    

000013ff <sbrk>:
SYSCALL(sbrk)
    13ff:	b8 0c 00 00 00       	mov    $0xc,%eax
    1404:	cd 40                	int    $0x40
    1406:	c3                   	ret    

00001407 <sleep>:
SYSCALL(sleep)
    1407:	b8 0d 00 00 00       	mov    $0xd,%eax
    140c:	cd 40                	int    $0x40
    140e:	c3                   	ret    

0000140f <uptime>:
SYSCALL(uptime)
    140f:	b8 0e 00 00 00       	mov    $0xe,%eax
    1414:	cd 40                	int    $0x40
    1416:	c3                   	ret    

00001417 <shm_open>:
SYSCALL(shm_open)
    1417:	b8 16 00 00 00       	mov    $0x16,%eax
    141c:	cd 40                	int    $0x40
    141e:	c3                   	ret    

0000141f <shm_close>:
SYSCALL(shm_close)	
    141f:	b8 17 00 00 00       	mov    $0x17,%eax
    1424:	cd 40                	int    $0x40
    1426:	c3                   	ret    

00001427 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1427:	55                   	push   %ebp
    1428:	89 e5                	mov    %esp,%ebp
    142a:	83 ec 18             	sub    $0x18,%esp
    142d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1430:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1433:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    143a:	00 
    143b:	8d 45 f4             	lea    -0xc(%ebp),%eax
    143e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1442:	8b 45 08             	mov    0x8(%ebp),%eax
    1445:	89 04 24             	mov    %eax,(%esp)
    1448:	e8 4a ff ff ff       	call   1397 <write>
}
    144d:	c9                   	leave  
    144e:	c3                   	ret    

0000144f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    144f:	55                   	push   %ebp
    1450:	89 e5                	mov    %esp,%ebp
    1452:	56                   	push   %esi
    1453:	53                   	push   %ebx
    1454:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1457:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    145e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1462:	74 17                	je     147b <printint+0x2c>
    1464:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1468:	79 11                	jns    147b <printint+0x2c>
    neg = 1;
    146a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1471:	8b 45 0c             	mov    0xc(%ebp),%eax
    1474:	f7 d8                	neg    %eax
    1476:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1479:	eb 06                	jmp    1481 <printint+0x32>
  } else {
    x = xx;
    147b:	8b 45 0c             	mov    0xc(%ebp),%eax
    147e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1481:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1488:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    148b:	8d 41 01             	lea    0x1(%ecx),%eax
    148e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1491:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1494:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1497:	ba 00 00 00 00       	mov    $0x0,%edx
    149c:	f7 f3                	div    %ebx
    149e:	89 d0                	mov    %edx,%eax
    14a0:	0f b6 80 28 1c 00 00 	movzbl 0x1c28(%eax),%eax
    14a7:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    14ab:	8b 75 10             	mov    0x10(%ebp),%esi
    14ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14b1:	ba 00 00 00 00       	mov    $0x0,%edx
    14b6:	f7 f6                	div    %esi
    14b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14bf:	75 c7                	jne    1488 <printint+0x39>
  if(neg)
    14c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    14c5:	74 10                	je     14d7 <printint+0x88>
    buf[i++] = '-';
    14c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14ca:	8d 50 01             	lea    0x1(%eax),%edx
    14cd:	89 55 f4             	mov    %edx,-0xc(%ebp)
    14d0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    14d5:	eb 1f                	jmp    14f6 <printint+0xa7>
    14d7:	eb 1d                	jmp    14f6 <printint+0xa7>
    putc(fd, buf[i]);
    14d9:	8d 55 dc             	lea    -0x24(%ebp),%edx
    14dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14df:	01 d0                	add    %edx,%eax
    14e1:	0f b6 00             	movzbl (%eax),%eax
    14e4:	0f be c0             	movsbl %al,%eax
    14e7:	89 44 24 04          	mov    %eax,0x4(%esp)
    14eb:	8b 45 08             	mov    0x8(%ebp),%eax
    14ee:	89 04 24             	mov    %eax,(%esp)
    14f1:	e8 31 ff ff ff       	call   1427 <putc>
  while(--i >= 0)
    14f6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    14fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14fe:	79 d9                	jns    14d9 <printint+0x8a>
}
    1500:	83 c4 30             	add    $0x30,%esp
    1503:	5b                   	pop    %ebx
    1504:	5e                   	pop    %esi
    1505:	5d                   	pop    %ebp
    1506:	c3                   	ret    

00001507 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1507:	55                   	push   %ebp
    1508:	89 e5                	mov    %esp,%ebp
    150a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    150d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1514:	8d 45 0c             	lea    0xc(%ebp),%eax
    1517:	83 c0 04             	add    $0x4,%eax
    151a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    151d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1524:	e9 7c 01 00 00       	jmp    16a5 <printf+0x19e>
    c = fmt[i] & 0xff;
    1529:	8b 55 0c             	mov    0xc(%ebp),%edx
    152c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    152f:	01 d0                	add    %edx,%eax
    1531:	0f b6 00             	movzbl (%eax),%eax
    1534:	0f be c0             	movsbl %al,%eax
    1537:	25 ff 00 00 00       	and    $0xff,%eax
    153c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    153f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1543:	75 2c                	jne    1571 <printf+0x6a>
      if(c == '%'){
    1545:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1549:	75 0c                	jne    1557 <printf+0x50>
        state = '%';
    154b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1552:	e9 4a 01 00 00       	jmp    16a1 <printf+0x19a>
      } else {
        putc(fd, c);
    1557:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    155a:	0f be c0             	movsbl %al,%eax
    155d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1561:	8b 45 08             	mov    0x8(%ebp),%eax
    1564:	89 04 24             	mov    %eax,(%esp)
    1567:	e8 bb fe ff ff       	call   1427 <putc>
    156c:	e9 30 01 00 00       	jmp    16a1 <printf+0x19a>
      }
    } else if(state == '%'){
    1571:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1575:	0f 85 26 01 00 00    	jne    16a1 <printf+0x19a>
      if(c == 'd'){
    157b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    157f:	75 2d                	jne    15ae <printf+0xa7>
        printint(fd, *ap, 10, 1);
    1581:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1584:	8b 00                	mov    (%eax),%eax
    1586:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    158d:	00 
    158e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1595:	00 
    1596:	89 44 24 04          	mov    %eax,0x4(%esp)
    159a:	8b 45 08             	mov    0x8(%ebp),%eax
    159d:	89 04 24             	mov    %eax,(%esp)
    15a0:	e8 aa fe ff ff       	call   144f <printint>
        ap++;
    15a5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15a9:	e9 ec 00 00 00       	jmp    169a <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    15ae:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    15b2:	74 06                	je     15ba <printf+0xb3>
    15b4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    15b8:	75 2d                	jne    15e7 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    15ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15bd:	8b 00                	mov    (%eax),%eax
    15bf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    15c6:	00 
    15c7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    15ce:	00 
    15cf:	89 44 24 04          	mov    %eax,0x4(%esp)
    15d3:	8b 45 08             	mov    0x8(%ebp),%eax
    15d6:	89 04 24             	mov    %eax,(%esp)
    15d9:	e8 71 fe ff ff       	call   144f <printint>
        ap++;
    15de:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15e2:	e9 b3 00 00 00       	jmp    169a <printf+0x193>
      } else if(c == 's'){
    15e7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    15eb:	75 45                	jne    1632 <printf+0x12b>
        s = (char*)*ap;
    15ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15f0:	8b 00                	mov    (%eax),%eax
    15f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    15f5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    15f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15fd:	75 09                	jne    1608 <printf+0x101>
          s = "(null)";
    15ff:	c7 45 f4 74 19 00 00 	movl   $0x1974,-0xc(%ebp)
        while(*s != 0){
    1606:	eb 1e                	jmp    1626 <printf+0x11f>
    1608:	eb 1c                	jmp    1626 <printf+0x11f>
          putc(fd, *s);
    160a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    160d:	0f b6 00             	movzbl (%eax),%eax
    1610:	0f be c0             	movsbl %al,%eax
    1613:	89 44 24 04          	mov    %eax,0x4(%esp)
    1617:	8b 45 08             	mov    0x8(%ebp),%eax
    161a:	89 04 24             	mov    %eax,(%esp)
    161d:	e8 05 fe ff ff       	call   1427 <putc>
          s++;
    1622:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
    1626:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1629:	0f b6 00             	movzbl (%eax),%eax
    162c:	84 c0                	test   %al,%al
    162e:	75 da                	jne    160a <printf+0x103>
    1630:	eb 68                	jmp    169a <printf+0x193>
        }
      } else if(c == 'c'){
    1632:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1636:	75 1d                	jne    1655 <printf+0x14e>
        putc(fd, *ap);
    1638:	8b 45 e8             	mov    -0x18(%ebp),%eax
    163b:	8b 00                	mov    (%eax),%eax
    163d:	0f be c0             	movsbl %al,%eax
    1640:	89 44 24 04          	mov    %eax,0x4(%esp)
    1644:	8b 45 08             	mov    0x8(%ebp),%eax
    1647:	89 04 24             	mov    %eax,(%esp)
    164a:	e8 d8 fd ff ff       	call   1427 <putc>
        ap++;
    164f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1653:	eb 45                	jmp    169a <printf+0x193>
      } else if(c == '%'){
    1655:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1659:	75 17                	jne    1672 <printf+0x16b>
        putc(fd, c);
    165b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    165e:	0f be c0             	movsbl %al,%eax
    1661:	89 44 24 04          	mov    %eax,0x4(%esp)
    1665:	8b 45 08             	mov    0x8(%ebp),%eax
    1668:	89 04 24             	mov    %eax,(%esp)
    166b:	e8 b7 fd ff ff       	call   1427 <putc>
    1670:	eb 28                	jmp    169a <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1672:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1679:	00 
    167a:	8b 45 08             	mov    0x8(%ebp),%eax
    167d:	89 04 24             	mov    %eax,(%esp)
    1680:	e8 a2 fd ff ff       	call   1427 <putc>
        putc(fd, c);
    1685:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1688:	0f be c0             	movsbl %al,%eax
    168b:	89 44 24 04          	mov    %eax,0x4(%esp)
    168f:	8b 45 08             	mov    0x8(%ebp),%eax
    1692:	89 04 24             	mov    %eax,(%esp)
    1695:	e8 8d fd ff ff       	call   1427 <putc>
      }
      state = 0;
    169a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    16a1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    16a5:	8b 55 0c             	mov    0xc(%ebp),%edx
    16a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16ab:	01 d0                	add    %edx,%eax
    16ad:	0f b6 00             	movzbl (%eax),%eax
    16b0:	84 c0                	test   %al,%al
    16b2:	0f 85 71 fe ff ff    	jne    1529 <printf+0x22>
    }
  }
}
    16b8:	c9                   	leave  
    16b9:	c3                   	ret    

000016ba <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16ba:	55                   	push   %ebp
    16bb:	89 e5                	mov    %esp,%ebp
    16bd:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    16c0:	8b 45 08             	mov    0x8(%ebp),%eax
    16c3:	83 e8 08             	sub    $0x8,%eax
    16c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16c9:	a1 44 1c 00 00       	mov    0x1c44,%eax
    16ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16d1:	eb 24                	jmp    16f7 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d6:	8b 00                	mov    (%eax),%eax
    16d8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16db:	77 12                	ja     16ef <free+0x35>
    16dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16e0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16e3:	77 24                	ja     1709 <free+0x4f>
    16e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e8:	8b 00                	mov    (%eax),%eax
    16ea:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16ed:	77 1a                	ja     1709 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16f2:	8b 00                	mov    (%eax),%eax
    16f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16fa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16fd:	76 d4                	jbe    16d3 <free+0x19>
    16ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1702:	8b 00                	mov    (%eax),%eax
    1704:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1707:	76 ca                	jbe    16d3 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1709:	8b 45 f8             	mov    -0x8(%ebp),%eax
    170c:	8b 40 04             	mov    0x4(%eax),%eax
    170f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1716:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1719:	01 c2                	add    %eax,%edx
    171b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    171e:	8b 00                	mov    (%eax),%eax
    1720:	39 c2                	cmp    %eax,%edx
    1722:	75 24                	jne    1748 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1724:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1727:	8b 50 04             	mov    0x4(%eax),%edx
    172a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    172d:	8b 00                	mov    (%eax),%eax
    172f:	8b 40 04             	mov    0x4(%eax),%eax
    1732:	01 c2                	add    %eax,%edx
    1734:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1737:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    173a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    173d:	8b 00                	mov    (%eax),%eax
    173f:	8b 10                	mov    (%eax),%edx
    1741:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1744:	89 10                	mov    %edx,(%eax)
    1746:	eb 0a                	jmp    1752 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1748:	8b 45 fc             	mov    -0x4(%ebp),%eax
    174b:	8b 10                	mov    (%eax),%edx
    174d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1750:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1752:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1755:	8b 40 04             	mov    0x4(%eax),%eax
    1758:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    175f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1762:	01 d0                	add    %edx,%eax
    1764:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1767:	75 20                	jne    1789 <free+0xcf>
    p->s.size += bp->s.size;
    1769:	8b 45 fc             	mov    -0x4(%ebp),%eax
    176c:	8b 50 04             	mov    0x4(%eax),%edx
    176f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1772:	8b 40 04             	mov    0x4(%eax),%eax
    1775:	01 c2                	add    %eax,%edx
    1777:	8b 45 fc             	mov    -0x4(%ebp),%eax
    177a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    177d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1780:	8b 10                	mov    (%eax),%edx
    1782:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1785:	89 10                	mov    %edx,(%eax)
    1787:	eb 08                	jmp    1791 <free+0xd7>
  } else
    p->s.ptr = bp;
    1789:	8b 45 fc             	mov    -0x4(%ebp),%eax
    178c:	8b 55 f8             	mov    -0x8(%ebp),%edx
    178f:	89 10                	mov    %edx,(%eax)
  freep = p;
    1791:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1794:	a3 44 1c 00 00       	mov    %eax,0x1c44
}
    1799:	c9                   	leave  
    179a:	c3                   	ret    

0000179b <morecore>:

static Header*
morecore(uint nu)
{
    179b:	55                   	push   %ebp
    179c:	89 e5                	mov    %esp,%ebp
    179e:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    17a1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    17a8:	77 07                	ja     17b1 <morecore+0x16>
    nu = 4096;
    17aa:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    17b1:	8b 45 08             	mov    0x8(%ebp),%eax
    17b4:	c1 e0 03             	shl    $0x3,%eax
    17b7:	89 04 24             	mov    %eax,(%esp)
    17ba:	e8 40 fc ff ff       	call   13ff <sbrk>
    17bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    17c2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    17c6:	75 07                	jne    17cf <morecore+0x34>
    return 0;
    17c8:	b8 00 00 00 00       	mov    $0x0,%eax
    17cd:	eb 22                	jmp    17f1 <morecore+0x56>
  hp = (Header*)p;
    17cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    17d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17d8:	8b 55 08             	mov    0x8(%ebp),%edx
    17db:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    17de:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17e1:	83 c0 08             	add    $0x8,%eax
    17e4:	89 04 24             	mov    %eax,(%esp)
    17e7:	e8 ce fe ff ff       	call   16ba <free>
  return freep;
    17ec:	a1 44 1c 00 00       	mov    0x1c44,%eax
}
    17f1:	c9                   	leave  
    17f2:	c3                   	ret    

000017f3 <malloc>:

void*
malloc(uint nbytes)
{
    17f3:	55                   	push   %ebp
    17f4:	89 e5                	mov    %esp,%ebp
    17f6:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    17f9:	8b 45 08             	mov    0x8(%ebp),%eax
    17fc:	83 c0 07             	add    $0x7,%eax
    17ff:	c1 e8 03             	shr    $0x3,%eax
    1802:	83 c0 01             	add    $0x1,%eax
    1805:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1808:	a1 44 1c 00 00       	mov    0x1c44,%eax
    180d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1810:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1814:	75 23                	jne    1839 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1816:	c7 45 f0 3c 1c 00 00 	movl   $0x1c3c,-0x10(%ebp)
    181d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1820:	a3 44 1c 00 00       	mov    %eax,0x1c44
    1825:	a1 44 1c 00 00       	mov    0x1c44,%eax
    182a:	a3 3c 1c 00 00       	mov    %eax,0x1c3c
    base.s.size = 0;
    182f:	c7 05 40 1c 00 00 00 	movl   $0x0,0x1c40
    1836:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1839:	8b 45 f0             	mov    -0x10(%ebp),%eax
    183c:	8b 00                	mov    (%eax),%eax
    183e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1841:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1844:	8b 40 04             	mov    0x4(%eax),%eax
    1847:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    184a:	72 4d                	jb     1899 <malloc+0xa6>
      if(p->s.size == nunits)
    184c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    184f:	8b 40 04             	mov    0x4(%eax),%eax
    1852:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1855:	75 0c                	jne    1863 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1857:	8b 45 f4             	mov    -0xc(%ebp),%eax
    185a:	8b 10                	mov    (%eax),%edx
    185c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    185f:	89 10                	mov    %edx,(%eax)
    1861:	eb 26                	jmp    1889 <malloc+0x96>
      else {
        p->s.size -= nunits;
    1863:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1866:	8b 40 04             	mov    0x4(%eax),%eax
    1869:	2b 45 ec             	sub    -0x14(%ebp),%eax
    186c:	89 c2                	mov    %eax,%edx
    186e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1871:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1874:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1877:	8b 40 04             	mov    0x4(%eax),%eax
    187a:	c1 e0 03             	shl    $0x3,%eax
    187d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1880:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1883:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1886:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1889:	8b 45 f0             	mov    -0x10(%ebp),%eax
    188c:	a3 44 1c 00 00       	mov    %eax,0x1c44
      return (void*)(p + 1);
    1891:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1894:	83 c0 08             	add    $0x8,%eax
    1897:	eb 38                	jmp    18d1 <malloc+0xde>
    }
    if(p == freep)
    1899:	a1 44 1c 00 00       	mov    0x1c44,%eax
    189e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    18a1:	75 1b                	jne    18be <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    18a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    18a6:	89 04 24             	mov    %eax,(%esp)
    18a9:	e8 ed fe ff ff       	call   179b <morecore>
    18ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    18b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18b5:	75 07                	jne    18be <malloc+0xcb>
        return 0;
    18b7:	b8 00 00 00 00       	mov    $0x0,%eax
    18bc:	eb 13                	jmp    18d1 <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18be:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18c7:	8b 00                	mov    (%eax),%eax
    18c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
    18cc:	e9 70 ff ff ff       	jmp    1841 <malloc+0x4e>
}
    18d1:	c9                   	leave  
    18d2:	c3                   	ret    

000018d3 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    18d3:	55                   	push   %ebp
    18d4:	89 e5                	mov    %esp,%ebp
    18d6:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    18d9:	8b 55 08             	mov    0x8(%ebp),%edx
    18dc:	8b 45 0c             	mov    0xc(%ebp),%eax
    18df:	8b 4d 08             	mov    0x8(%ebp),%ecx
    18e2:	f0 87 02             	lock xchg %eax,(%edx)
    18e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    18e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    18eb:	c9                   	leave  
    18ec:	c3                   	ret    

000018ed <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    18ed:	55                   	push   %ebp
    18ee:	89 e5                	mov    %esp,%ebp
    18f0:	83 ec 08             	sub    $0x8,%esp
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    18f3:	90                   	nop
    18f4:	8b 45 08             	mov    0x8(%ebp),%eax
    18f7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    18fe:	00 
    18ff:	89 04 24             	mov    %eax,(%esp)
    1902:	e8 cc ff ff ff       	call   18d3 <xchg>
    1907:	85 c0                	test   %eax,%eax
    1909:	75 e9                	jne    18f4 <uacquire+0x7>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    190b:	0f ae f0             	mfence 
}
    190e:	c9                   	leave  
    190f:	c3                   	ret    

00001910 <urelease>:

void urelease (struct uspinlock *lk) {
    1910:	55                   	push   %ebp
    1911:	89 e5                	mov    %esp,%ebp
  __sync_synchronize();
    1913:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    1916:	8b 45 08             	mov    0x8(%ebp),%eax
    1919:	8b 55 08             	mov    0x8(%ebp),%edx
    191c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1922:	5d                   	pop    %ebp
    1923:	c3                   	ret    
