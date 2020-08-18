
_ln:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 10             	sub    $0x10,%esp
  if(argc != 3){
    1009:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
    100d:	74 19                	je     1028 <main+0x28>
    printf(2, "Usage: ln old new\n");
    100f:	c7 44 24 04 8e 18 00 	movl   $0x188e,0x4(%esp)
    1016:	00 
    1017:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    101e:	e8 4e 04 00 00       	call   1471 <printf>
    exit();
    1023:	e8 b9 02 00 00       	call   12e1 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
    1028:	8b 45 0c             	mov    0xc(%ebp),%eax
    102b:	83 c0 08             	add    $0x8,%eax
    102e:	8b 10                	mov    (%eax),%edx
    1030:	8b 45 0c             	mov    0xc(%ebp),%eax
    1033:	83 c0 04             	add    $0x4,%eax
    1036:	8b 00                	mov    (%eax),%eax
    1038:	89 54 24 04          	mov    %edx,0x4(%esp)
    103c:	89 04 24             	mov    %eax,(%esp)
    103f:	e8 fd 02 00 00       	call   1341 <link>
    1044:	85 c0                	test   %eax,%eax
    1046:	79 2c                	jns    1074 <main+0x74>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
    1048:	8b 45 0c             	mov    0xc(%ebp),%eax
    104b:	83 c0 08             	add    $0x8,%eax
    104e:	8b 10                	mov    (%eax),%edx
    1050:	8b 45 0c             	mov    0xc(%ebp),%eax
    1053:	83 c0 04             	add    $0x4,%eax
    1056:	8b 00                	mov    (%eax),%eax
    1058:	89 54 24 0c          	mov    %edx,0xc(%esp)
    105c:	89 44 24 08          	mov    %eax,0x8(%esp)
    1060:	c7 44 24 04 a1 18 00 	movl   $0x18a1,0x4(%esp)
    1067:	00 
    1068:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    106f:	e8 fd 03 00 00       	call   1471 <printf>
  exit();
    1074:	e8 68 02 00 00       	call   12e1 <exit>

00001079 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1079:	55                   	push   %ebp
    107a:	89 e5                	mov    %esp,%ebp
    107c:	57                   	push   %edi
    107d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    107e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1081:	8b 55 10             	mov    0x10(%ebp),%edx
    1084:	8b 45 0c             	mov    0xc(%ebp),%eax
    1087:	89 cb                	mov    %ecx,%ebx
    1089:	89 df                	mov    %ebx,%edi
    108b:	89 d1                	mov    %edx,%ecx
    108d:	fc                   	cld    
    108e:	f3 aa                	rep stos %al,%es:(%edi)
    1090:	89 ca                	mov    %ecx,%edx
    1092:	89 fb                	mov    %edi,%ebx
    1094:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1097:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    109a:	5b                   	pop    %ebx
    109b:	5f                   	pop    %edi
    109c:	5d                   	pop    %ebp
    109d:	c3                   	ret    

0000109e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    109e:	55                   	push   %ebp
    109f:	89 e5                	mov    %esp,%ebp
    10a1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    10a4:	8b 45 08             	mov    0x8(%ebp),%eax
    10a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    10aa:	90                   	nop
    10ab:	8b 45 08             	mov    0x8(%ebp),%eax
    10ae:	8d 50 01             	lea    0x1(%eax),%edx
    10b1:	89 55 08             	mov    %edx,0x8(%ebp)
    10b4:	8b 55 0c             	mov    0xc(%ebp),%edx
    10b7:	8d 4a 01             	lea    0x1(%edx),%ecx
    10ba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    10bd:	0f b6 12             	movzbl (%edx),%edx
    10c0:	88 10                	mov    %dl,(%eax)
    10c2:	0f b6 00             	movzbl (%eax),%eax
    10c5:	84 c0                	test   %al,%al
    10c7:	75 e2                	jne    10ab <strcpy+0xd>
    ;
  return os;
    10c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10cc:	c9                   	leave  
    10cd:	c3                   	ret    

000010ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10ce:	55                   	push   %ebp
    10cf:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10d1:	eb 08                	jmp    10db <strcmp+0xd>
    p++, q++;
    10d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    10d7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
    10db:	8b 45 08             	mov    0x8(%ebp),%eax
    10de:	0f b6 00             	movzbl (%eax),%eax
    10e1:	84 c0                	test   %al,%al
    10e3:	74 10                	je     10f5 <strcmp+0x27>
    10e5:	8b 45 08             	mov    0x8(%ebp),%eax
    10e8:	0f b6 10             	movzbl (%eax),%edx
    10eb:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ee:	0f b6 00             	movzbl (%eax),%eax
    10f1:	38 c2                	cmp    %al,%dl
    10f3:	74 de                	je     10d3 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
    10f5:	8b 45 08             	mov    0x8(%ebp),%eax
    10f8:	0f b6 00             	movzbl (%eax),%eax
    10fb:	0f b6 d0             	movzbl %al,%edx
    10fe:	8b 45 0c             	mov    0xc(%ebp),%eax
    1101:	0f b6 00             	movzbl (%eax),%eax
    1104:	0f b6 c0             	movzbl %al,%eax
    1107:	29 c2                	sub    %eax,%edx
    1109:	89 d0                	mov    %edx,%eax
}
    110b:	5d                   	pop    %ebp
    110c:	c3                   	ret    

0000110d <strlen>:

uint
strlen(char *s)
{
    110d:	55                   	push   %ebp
    110e:	89 e5                	mov    %esp,%ebp
    1110:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1113:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    111a:	eb 04                	jmp    1120 <strlen+0x13>
    111c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1120:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1123:	8b 45 08             	mov    0x8(%ebp),%eax
    1126:	01 d0                	add    %edx,%eax
    1128:	0f b6 00             	movzbl (%eax),%eax
    112b:	84 c0                	test   %al,%al
    112d:	75 ed                	jne    111c <strlen+0xf>
    ;
  return n;
    112f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1132:	c9                   	leave  
    1133:	c3                   	ret    

00001134 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1134:	55                   	push   %ebp
    1135:	89 e5                	mov    %esp,%ebp
    1137:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    113a:	8b 45 10             	mov    0x10(%ebp),%eax
    113d:	89 44 24 08          	mov    %eax,0x8(%esp)
    1141:	8b 45 0c             	mov    0xc(%ebp),%eax
    1144:	89 44 24 04          	mov    %eax,0x4(%esp)
    1148:	8b 45 08             	mov    0x8(%ebp),%eax
    114b:	89 04 24             	mov    %eax,(%esp)
    114e:	e8 26 ff ff ff       	call   1079 <stosb>
  return dst;
    1153:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1156:	c9                   	leave  
    1157:	c3                   	ret    

00001158 <strchr>:

char*
strchr(const char *s, char c)
{
    1158:	55                   	push   %ebp
    1159:	89 e5                	mov    %esp,%ebp
    115b:	83 ec 04             	sub    $0x4,%esp
    115e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1161:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1164:	eb 14                	jmp    117a <strchr+0x22>
    if(*s == c)
    1166:	8b 45 08             	mov    0x8(%ebp),%eax
    1169:	0f b6 00             	movzbl (%eax),%eax
    116c:	3a 45 fc             	cmp    -0x4(%ebp),%al
    116f:	75 05                	jne    1176 <strchr+0x1e>
      return (char*)s;
    1171:	8b 45 08             	mov    0x8(%ebp),%eax
    1174:	eb 13                	jmp    1189 <strchr+0x31>
  for(; *s; s++)
    1176:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    117a:	8b 45 08             	mov    0x8(%ebp),%eax
    117d:	0f b6 00             	movzbl (%eax),%eax
    1180:	84 c0                	test   %al,%al
    1182:	75 e2                	jne    1166 <strchr+0xe>
  return 0;
    1184:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1189:	c9                   	leave  
    118a:	c3                   	ret    

0000118b <gets>:

char*
gets(char *buf, int max)
{
    118b:	55                   	push   %ebp
    118c:	89 e5                	mov    %esp,%ebp
    118e:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1191:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1198:	eb 4c                	jmp    11e6 <gets+0x5b>
    cc = read(0, &c, 1);
    119a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    11a1:	00 
    11a2:	8d 45 ef             	lea    -0x11(%ebp),%eax
    11a5:	89 44 24 04          	mov    %eax,0x4(%esp)
    11a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    11b0:	e8 44 01 00 00       	call   12f9 <read>
    11b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    11b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11bc:	7f 02                	jg     11c0 <gets+0x35>
      break;
    11be:	eb 31                	jmp    11f1 <gets+0x66>
    buf[i++] = c;
    11c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11c3:	8d 50 01             	lea    0x1(%eax),%edx
    11c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
    11c9:	89 c2                	mov    %eax,%edx
    11cb:	8b 45 08             	mov    0x8(%ebp),%eax
    11ce:	01 c2                	add    %eax,%edx
    11d0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11d4:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    11d6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11da:	3c 0a                	cmp    $0xa,%al
    11dc:	74 13                	je     11f1 <gets+0x66>
    11de:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11e2:	3c 0d                	cmp    $0xd,%al
    11e4:	74 0b                	je     11f1 <gets+0x66>
  for(i=0; i+1 < max; ){
    11e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11e9:	83 c0 01             	add    $0x1,%eax
    11ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11ef:	7c a9                	jl     119a <gets+0xf>
      break;
  }
  buf[i] = '\0';
    11f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11f4:	8b 45 08             	mov    0x8(%ebp),%eax
    11f7:	01 d0                	add    %edx,%eax
    11f9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11ff:	c9                   	leave  
    1200:	c3                   	ret    

00001201 <stat>:

int
stat(char *n, struct stat *st)
{
    1201:	55                   	push   %ebp
    1202:	89 e5                	mov    %esp,%ebp
    1204:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1207:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    120e:	00 
    120f:	8b 45 08             	mov    0x8(%ebp),%eax
    1212:	89 04 24             	mov    %eax,(%esp)
    1215:	e8 07 01 00 00       	call   1321 <open>
    121a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    121d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1221:	79 07                	jns    122a <stat+0x29>
    return -1;
    1223:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1228:	eb 23                	jmp    124d <stat+0x4c>
  r = fstat(fd, st);
    122a:	8b 45 0c             	mov    0xc(%ebp),%eax
    122d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1231:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1234:	89 04 24             	mov    %eax,(%esp)
    1237:	e8 fd 00 00 00       	call   1339 <fstat>
    123c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    123f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1242:	89 04 24             	mov    %eax,(%esp)
    1245:	e8 bf 00 00 00       	call   1309 <close>
  return r;
    124a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    124d:	c9                   	leave  
    124e:	c3                   	ret    

0000124f <atoi>:

int
atoi(const char *s)
{
    124f:	55                   	push   %ebp
    1250:	89 e5                	mov    %esp,%ebp
    1252:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1255:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    125c:	eb 25                	jmp    1283 <atoi+0x34>
    n = n*10 + *s++ - '0';
    125e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1261:	89 d0                	mov    %edx,%eax
    1263:	c1 e0 02             	shl    $0x2,%eax
    1266:	01 d0                	add    %edx,%eax
    1268:	01 c0                	add    %eax,%eax
    126a:	89 c1                	mov    %eax,%ecx
    126c:	8b 45 08             	mov    0x8(%ebp),%eax
    126f:	8d 50 01             	lea    0x1(%eax),%edx
    1272:	89 55 08             	mov    %edx,0x8(%ebp)
    1275:	0f b6 00             	movzbl (%eax),%eax
    1278:	0f be c0             	movsbl %al,%eax
    127b:	01 c8                	add    %ecx,%eax
    127d:	83 e8 30             	sub    $0x30,%eax
    1280:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1283:	8b 45 08             	mov    0x8(%ebp),%eax
    1286:	0f b6 00             	movzbl (%eax),%eax
    1289:	3c 2f                	cmp    $0x2f,%al
    128b:	7e 0a                	jle    1297 <atoi+0x48>
    128d:	8b 45 08             	mov    0x8(%ebp),%eax
    1290:	0f b6 00             	movzbl (%eax),%eax
    1293:	3c 39                	cmp    $0x39,%al
    1295:	7e c7                	jle    125e <atoi+0xf>
  return n;
    1297:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    129a:	c9                   	leave  
    129b:	c3                   	ret    

0000129c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    129c:	55                   	push   %ebp
    129d:	89 e5                	mov    %esp,%ebp
    129f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    12a2:	8b 45 08             	mov    0x8(%ebp),%eax
    12a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    12a8:	8b 45 0c             	mov    0xc(%ebp),%eax
    12ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    12ae:	eb 17                	jmp    12c7 <memmove+0x2b>
    *dst++ = *src++;
    12b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12b3:	8d 50 01             	lea    0x1(%eax),%edx
    12b6:	89 55 fc             	mov    %edx,-0x4(%ebp)
    12b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
    12bc:	8d 4a 01             	lea    0x1(%edx),%ecx
    12bf:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    12c2:	0f b6 12             	movzbl (%edx),%edx
    12c5:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
    12c7:	8b 45 10             	mov    0x10(%ebp),%eax
    12ca:	8d 50 ff             	lea    -0x1(%eax),%edx
    12cd:	89 55 10             	mov    %edx,0x10(%ebp)
    12d0:	85 c0                	test   %eax,%eax
    12d2:	7f dc                	jg     12b0 <memmove+0x14>
  return vdst;
    12d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12d7:	c9                   	leave  
    12d8:	c3                   	ret    

000012d9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12d9:	b8 01 00 00 00       	mov    $0x1,%eax
    12de:	cd 40                	int    $0x40
    12e0:	c3                   	ret    

000012e1 <exit>:
SYSCALL(exit)
    12e1:	b8 02 00 00 00       	mov    $0x2,%eax
    12e6:	cd 40                	int    $0x40
    12e8:	c3                   	ret    

000012e9 <wait>:
SYSCALL(wait)
    12e9:	b8 03 00 00 00       	mov    $0x3,%eax
    12ee:	cd 40                	int    $0x40
    12f0:	c3                   	ret    

000012f1 <pipe>:
SYSCALL(pipe)
    12f1:	b8 04 00 00 00       	mov    $0x4,%eax
    12f6:	cd 40                	int    $0x40
    12f8:	c3                   	ret    

000012f9 <read>:
SYSCALL(read)
    12f9:	b8 05 00 00 00       	mov    $0x5,%eax
    12fe:	cd 40                	int    $0x40
    1300:	c3                   	ret    

00001301 <write>:
SYSCALL(write)
    1301:	b8 10 00 00 00       	mov    $0x10,%eax
    1306:	cd 40                	int    $0x40
    1308:	c3                   	ret    

00001309 <close>:
SYSCALL(close)
    1309:	b8 15 00 00 00       	mov    $0x15,%eax
    130e:	cd 40                	int    $0x40
    1310:	c3                   	ret    

00001311 <kill>:
SYSCALL(kill)
    1311:	b8 06 00 00 00       	mov    $0x6,%eax
    1316:	cd 40                	int    $0x40
    1318:	c3                   	ret    

00001319 <exec>:
SYSCALL(exec)
    1319:	b8 07 00 00 00       	mov    $0x7,%eax
    131e:	cd 40                	int    $0x40
    1320:	c3                   	ret    

00001321 <open>:
SYSCALL(open)
    1321:	b8 0f 00 00 00       	mov    $0xf,%eax
    1326:	cd 40                	int    $0x40
    1328:	c3                   	ret    

00001329 <mknod>:
SYSCALL(mknod)
    1329:	b8 11 00 00 00       	mov    $0x11,%eax
    132e:	cd 40                	int    $0x40
    1330:	c3                   	ret    

00001331 <unlink>:
SYSCALL(unlink)
    1331:	b8 12 00 00 00       	mov    $0x12,%eax
    1336:	cd 40                	int    $0x40
    1338:	c3                   	ret    

00001339 <fstat>:
SYSCALL(fstat)
    1339:	b8 08 00 00 00       	mov    $0x8,%eax
    133e:	cd 40                	int    $0x40
    1340:	c3                   	ret    

00001341 <link>:
SYSCALL(link)
    1341:	b8 13 00 00 00       	mov    $0x13,%eax
    1346:	cd 40                	int    $0x40
    1348:	c3                   	ret    

00001349 <mkdir>:
SYSCALL(mkdir)
    1349:	b8 14 00 00 00       	mov    $0x14,%eax
    134e:	cd 40                	int    $0x40
    1350:	c3                   	ret    

00001351 <chdir>:
SYSCALL(chdir)
    1351:	b8 09 00 00 00       	mov    $0x9,%eax
    1356:	cd 40                	int    $0x40
    1358:	c3                   	ret    

00001359 <dup>:
SYSCALL(dup)
    1359:	b8 0a 00 00 00       	mov    $0xa,%eax
    135e:	cd 40                	int    $0x40
    1360:	c3                   	ret    

00001361 <getpid>:
SYSCALL(getpid)
    1361:	b8 0b 00 00 00       	mov    $0xb,%eax
    1366:	cd 40                	int    $0x40
    1368:	c3                   	ret    

00001369 <sbrk>:
SYSCALL(sbrk)
    1369:	b8 0c 00 00 00       	mov    $0xc,%eax
    136e:	cd 40                	int    $0x40
    1370:	c3                   	ret    

00001371 <sleep>:
SYSCALL(sleep)
    1371:	b8 0d 00 00 00       	mov    $0xd,%eax
    1376:	cd 40                	int    $0x40
    1378:	c3                   	ret    

00001379 <uptime>:
SYSCALL(uptime)
    1379:	b8 0e 00 00 00       	mov    $0xe,%eax
    137e:	cd 40                	int    $0x40
    1380:	c3                   	ret    

00001381 <shm_open>:
SYSCALL(shm_open)
    1381:	b8 16 00 00 00       	mov    $0x16,%eax
    1386:	cd 40                	int    $0x40
    1388:	c3                   	ret    

00001389 <shm_close>:
SYSCALL(shm_close)	
    1389:	b8 17 00 00 00       	mov    $0x17,%eax
    138e:	cd 40                	int    $0x40
    1390:	c3                   	ret    

00001391 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1391:	55                   	push   %ebp
    1392:	89 e5                	mov    %esp,%ebp
    1394:	83 ec 18             	sub    $0x18,%esp
    1397:	8b 45 0c             	mov    0xc(%ebp),%eax
    139a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    139d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    13a4:	00 
    13a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
    13a8:	89 44 24 04          	mov    %eax,0x4(%esp)
    13ac:	8b 45 08             	mov    0x8(%ebp),%eax
    13af:	89 04 24             	mov    %eax,(%esp)
    13b2:	e8 4a ff ff ff       	call   1301 <write>
}
    13b7:	c9                   	leave  
    13b8:	c3                   	ret    

000013b9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13b9:	55                   	push   %ebp
    13ba:	89 e5                	mov    %esp,%ebp
    13bc:	56                   	push   %esi
    13bd:	53                   	push   %ebx
    13be:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    13c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    13c8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    13cc:	74 17                	je     13e5 <printint+0x2c>
    13ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    13d2:	79 11                	jns    13e5 <printint+0x2c>
    neg = 1;
    13d4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13db:	8b 45 0c             	mov    0xc(%ebp),%eax
    13de:	f7 d8                	neg    %eax
    13e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13e3:	eb 06                	jmp    13eb <printint+0x32>
  } else {
    x = xx;
    13e5:	8b 45 0c             	mov    0xc(%ebp),%eax
    13e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    13f2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    13f5:	8d 41 01             	lea    0x1(%ecx),%eax
    13f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    13fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1401:	ba 00 00 00 00       	mov    $0x0,%edx
    1406:	f7 f3                	div    %ebx
    1408:	89 d0                	mov    %edx,%eax
    140a:	0f b6 80 60 1b 00 00 	movzbl 0x1b60(%eax),%eax
    1411:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1415:	8b 75 10             	mov    0x10(%ebp),%esi
    1418:	8b 45 ec             	mov    -0x14(%ebp),%eax
    141b:	ba 00 00 00 00       	mov    $0x0,%edx
    1420:	f7 f6                	div    %esi
    1422:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1425:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1429:	75 c7                	jne    13f2 <printint+0x39>
  if(neg)
    142b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    142f:	74 10                	je     1441 <printint+0x88>
    buf[i++] = '-';
    1431:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1434:	8d 50 01             	lea    0x1(%eax),%edx
    1437:	89 55 f4             	mov    %edx,-0xc(%ebp)
    143a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    143f:	eb 1f                	jmp    1460 <printint+0xa7>
    1441:	eb 1d                	jmp    1460 <printint+0xa7>
    putc(fd, buf[i]);
    1443:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1446:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1449:	01 d0                	add    %edx,%eax
    144b:	0f b6 00             	movzbl (%eax),%eax
    144e:	0f be c0             	movsbl %al,%eax
    1451:	89 44 24 04          	mov    %eax,0x4(%esp)
    1455:	8b 45 08             	mov    0x8(%ebp),%eax
    1458:	89 04 24             	mov    %eax,(%esp)
    145b:	e8 31 ff ff ff       	call   1391 <putc>
  while(--i >= 0)
    1460:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1464:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1468:	79 d9                	jns    1443 <printint+0x8a>
}
    146a:	83 c4 30             	add    $0x30,%esp
    146d:	5b                   	pop    %ebx
    146e:	5e                   	pop    %esi
    146f:	5d                   	pop    %ebp
    1470:	c3                   	ret    

00001471 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1471:	55                   	push   %ebp
    1472:	89 e5                	mov    %esp,%ebp
    1474:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1477:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    147e:	8d 45 0c             	lea    0xc(%ebp),%eax
    1481:	83 c0 04             	add    $0x4,%eax
    1484:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1487:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    148e:	e9 7c 01 00 00       	jmp    160f <printf+0x19e>
    c = fmt[i] & 0xff;
    1493:	8b 55 0c             	mov    0xc(%ebp),%edx
    1496:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1499:	01 d0                	add    %edx,%eax
    149b:	0f b6 00             	movzbl (%eax),%eax
    149e:	0f be c0             	movsbl %al,%eax
    14a1:	25 ff 00 00 00       	and    $0xff,%eax
    14a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    14a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14ad:	75 2c                	jne    14db <printf+0x6a>
      if(c == '%'){
    14af:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    14b3:	75 0c                	jne    14c1 <printf+0x50>
        state = '%';
    14b5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    14bc:	e9 4a 01 00 00       	jmp    160b <printf+0x19a>
      } else {
        putc(fd, c);
    14c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    14c4:	0f be c0             	movsbl %al,%eax
    14c7:	89 44 24 04          	mov    %eax,0x4(%esp)
    14cb:	8b 45 08             	mov    0x8(%ebp),%eax
    14ce:	89 04 24             	mov    %eax,(%esp)
    14d1:	e8 bb fe ff ff       	call   1391 <putc>
    14d6:	e9 30 01 00 00       	jmp    160b <printf+0x19a>
      }
    } else if(state == '%'){
    14db:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14df:	0f 85 26 01 00 00    	jne    160b <printf+0x19a>
      if(c == 'd'){
    14e5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14e9:	75 2d                	jne    1518 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    14eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14ee:	8b 00                	mov    (%eax),%eax
    14f0:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    14f7:	00 
    14f8:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    14ff:	00 
    1500:	89 44 24 04          	mov    %eax,0x4(%esp)
    1504:	8b 45 08             	mov    0x8(%ebp),%eax
    1507:	89 04 24             	mov    %eax,(%esp)
    150a:	e8 aa fe ff ff       	call   13b9 <printint>
        ap++;
    150f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1513:	e9 ec 00 00 00       	jmp    1604 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    1518:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    151c:	74 06                	je     1524 <printf+0xb3>
    151e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1522:	75 2d                	jne    1551 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1524:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1527:	8b 00                	mov    (%eax),%eax
    1529:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1530:	00 
    1531:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1538:	00 
    1539:	89 44 24 04          	mov    %eax,0x4(%esp)
    153d:	8b 45 08             	mov    0x8(%ebp),%eax
    1540:	89 04 24             	mov    %eax,(%esp)
    1543:	e8 71 fe ff ff       	call   13b9 <printint>
        ap++;
    1548:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    154c:	e9 b3 00 00 00       	jmp    1604 <printf+0x193>
      } else if(c == 's'){
    1551:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1555:	75 45                	jne    159c <printf+0x12b>
        s = (char*)*ap;
    1557:	8b 45 e8             	mov    -0x18(%ebp),%eax
    155a:	8b 00                	mov    (%eax),%eax
    155c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    155f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1563:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1567:	75 09                	jne    1572 <printf+0x101>
          s = "(null)";
    1569:	c7 45 f4 b5 18 00 00 	movl   $0x18b5,-0xc(%ebp)
        while(*s != 0){
    1570:	eb 1e                	jmp    1590 <printf+0x11f>
    1572:	eb 1c                	jmp    1590 <printf+0x11f>
          putc(fd, *s);
    1574:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1577:	0f b6 00             	movzbl (%eax),%eax
    157a:	0f be c0             	movsbl %al,%eax
    157d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1581:	8b 45 08             	mov    0x8(%ebp),%eax
    1584:	89 04 24             	mov    %eax,(%esp)
    1587:	e8 05 fe ff ff       	call   1391 <putc>
          s++;
    158c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
    1590:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1593:	0f b6 00             	movzbl (%eax),%eax
    1596:	84 c0                	test   %al,%al
    1598:	75 da                	jne    1574 <printf+0x103>
    159a:	eb 68                	jmp    1604 <printf+0x193>
        }
      } else if(c == 'c'){
    159c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    15a0:	75 1d                	jne    15bf <printf+0x14e>
        putc(fd, *ap);
    15a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15a5:	8b 00                	mov    (%eax),%eax
    15a7:	0f be c0             	movsbl %al,%eax
    15aa:	89 44 24 04          	mov    %eax,0x4(%esp)
    15ae:	8b 45 08             	mov    0x8(%ebp),%eax
    15b1:	89 04 24             	mov    %eax,(%esp)
    15b4:	e8 d8 fd ff ff       	call   1391 <putc>
        ap++;
    15b9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15bd:	eb 45                	jmp    1604 <printf+0x193>
      } else if(c == '%'){
    15bf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15c3:	75 17                	jne    15dc <printf+0x16b>
        putc(fd, c);
    15c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15c8:	0f be c0             	movsbl %al,%eax
    15cb:	89 44 24 04          	mov    %eax,0x4(%esp)
    15cf:	8b 45 08             	mov    0x8(%ebp),%eax
    15d2:	89 04 24             	mov    %eax,(%esp)
    15d5:	e8 b7 fd ff ff       	call   1391 <putc>
    15da:	eb 28                	jmp    1604 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15dc:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    15e3:	00 
    15e4:	8b 45 08             	mov    0x8(%ebp),%eax
    15e7:	89 04 24             	mov    %eax,(%esp)
    15ea:	e8 a2 fd ff ff       	call   1391 <putc>
        putc(fd, c);
    15ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15f2:	0f be c0             	movsbl %al,%eax
    15f5:	89 44 24 04          	mov    %eax,0x4(%esp)
    15f9:	8b 45 08             	mov    0x8(%ebp),%eax
    15fc:	89 04 24             	mov    %eax,(%esp)
    15ff:	e8 8d fd ff ff       	call   1391 <putc>
      }
      state = 0;
    1604:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    160b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    160f:	8b 55 0c             	mov    0xc(%ebp),%edx
    1612:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1615:	01 d0                	add    %edx,%eax
    1617:	0f b6 00             	movzbl (%eax),%eax
    161a:	84 c0                	test   %al,%al
    161c:	0f 85 71 fe ff ff    	jne    1493 <printf+0x22>
    }
  }
}
    1622:	c9                   	leave  
    1623:	c3                   	ret    

00001624 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1624:	55                   	push   %ebp
    1625:	89 e5                	mov    %esp,%ebp
    1627:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    162a:	8b 45 08             	mov    0x8(%ebp),%eax
    162d:	83 e8 08             	sub    $0x8,%eax
    1630:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1633:	a1 7c 1b 00 00       	mov    0x1b7c,%eax
    1638:	89 45 fc             	mov    %eax,-0x4(%ebp)
    163b:	eb 24                	jmp    1661 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    163d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1640:	8b 00                	mov    (%eax),%eax
    1642:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1645:	77 12                	ja     1659 <free+0x35>
    1647:	8b 45 f8             	mov    -0x8(%ebp),%eax
    164a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    164d:	77 24                	ja     1673 <free+0x4f>
    164f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1652:	8b 00                	mov    (%eax),%eax
    1654:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1657:	77 1a                	ja     1673 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1659:	8b 45 fc             	mov    -0x4(%ebp),%eax
    165c:	8b 00                	mov    (%eax),%eax
    165e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1661:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1664:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1667:	76 d4                	jbe    163d <free+0x19>
    1669:	8b 45 fc             	mov    -0x4(%ebp),%eax
    166c:	8b 00                	mov    (%eax),%eax
    166e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1671:	76 ca                	jbe    163d <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1673:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1676:	8b 40 04             	mov    0x4(%eax),%eax
    1679:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1680:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1683:	01 c2                	add    %eax,%edx
    1685:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1688:	8b 00                	mov    (%eax),%eax
    168a:	39 c2                	cmp    %eax,%edx
    168c:	75 24                	jne    16b2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    168e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1691:	8b 50 04             	mov    0x4(%eax),%edx
    1694:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1697:	8b 00                	mov    (%eax),%eax
    1699:	8b 40 04             	mov    0x4(%eax),%eax
    169c:	01 c2                	add    %eax,%edx
    169e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16a1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    16a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a7:	8b 00                	mov    (%eax),%eax
    16a9:	8b 10                	mov    (%eax),%edx
    16ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16ae:	89 10                	mov    %edx,(%eax)
    16b0:	eb 0a                	jmp    16bc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    16b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b5:	8b 10                	mov    (%eax),%edx
    16b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16ba:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    16bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16bf:	8b 40 04             	mov    0x4(%eax),%eax
    16c2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16cc:	01 d0                	add    %edx,%eax
    16ce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16d1:	75 20                	jne    16f3 <free+0xcf>
    p->s.size += bp->s.size;
    16d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d6:	8b 50 04             	mov    0x4(%eax),%edx
    16d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16dc:	8b 40 04             	mov    0x4(%eax),%eax
    16df:	01 c2                	add    %eax,%edx
    16e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16ea:	8b 10                	mov    (%eax),%edx
    16ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ef:	89 10                	mov    %edx,(%eax)
    16f1:	eb 08                	jmp    16fb <free+0xd7>
  } else
    p->s.ptr = bp;
    16f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16f6:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16f9:	89 10                	mov    %edx,(%eax)
  freep = p;
    16fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16fe:	a3 7c 1b 00 00       	mov    %eax,0x1b7c
}
    1703:	c9                   	leave  
    1704:	c3                   	ret    

00001705 <morecore>:

static Header*
morecore(uint nu)
{
    1705:	55                   	push   %ebp
    1706:	89 e5                	mov    %esp,%ebp
    1708:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    170b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1712:	77 07                	ja     171b <morecore+0x16>
    nu = 4096;
    1714:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    171b:	8b 45 08             	mov    0x8(%ebp),%eax
    171e:	c1 e0 03             	shl    $0x3,%eax
    1721:	89 04 24             	mov    %eax,(%esp)
    1724:	e8 40 fc ff ff       	call   1369 <sbrk>
    1729:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    172c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1730:	75 07                	jne    1739 <morecore+0x34>
    return 0;
    1732:	b8 00 00 00 00       	mov    $0x0,%eax
    1737:	eb 22                	jmp    175b <morecore+0x56>
  hp = (Header*)p;
    1739:	8b 45 f4             	mov    -0xc(%ebp),%eax
    173c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    173f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1742:	8b 55 08             	mov    0x8(%ebp),%edx
    1745:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1748:	8b 45 f0             	mov    -0x10(%ebp),%eax
    174b:	83 c0 08             	add    $0x8,%eax
    174e:	89 04 24             	mov    %eax,(%esp)
    1751:	e8 ce fe ff ff       	call   1624 <free>
  return freep;
    1756:	a1 7c 1b 00 00       	mov    0x1b7c,%eax
}
    175b:	c9                   	leave  
    175c:	c3                   	ret    

0000175d <malloc>:

void*
malloc(uint nbytes)
{
    175d:	55                   	push   %ebp
    175e:	89 e5                	mov    %esp,%ebp
    1760:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1763:	8b 45 08             	mov    0x8(%ebp),%eax
    1766:	83 c0 07             	add    $0x7,%eax
    1769:	c1 e8 03             	shr    $0x3,%eax
    176c:	83 c0 01             	add    $0x1,%eax
    176f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1772:	a1 7c 1b 00 00       	mov    0x1b7c,%eax
    1777:	89 45 f0             	mov    %eax,-0x10(%ebp)
    177a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    177e:	75 23                	jne    17a3 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1780:	c7 45 f0 74 1b 00 00 	movl   $0x1b74,-0x10(%ebp)
    1787:	8b 45 f0             	mov    -0x10(%ebp),%eax
    178a:	a3 7c 1b 00 00       	mov    %eax,0x1b7c
    178f:	a1 7c 1b 00 00       	mov    0x1b7c,%eax
    1794:	a3 74 1b 00 00       	mov    %eax,0x1b74
    base.s.size = 0;
    1799:	c7 05 78 1b 00 00 00 	movl   $0x0,0x1b78
    17a0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17a6:	8b 00                	mov    (%eax),%eax
    17a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    17ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ae:	8b 40 04             	mov    0x4(%eax),%eax
    17b1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17b4:	72 4d                	jb     1803 <malloc+0xa6>
      if(p->s.size == nunits)
    17b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17b9:	8b 40 04             	mov    0x4(%eax),%eax
    17bc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17bf:	75 0c                	jne    17cd <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    17c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c4:	8b 10                	mov    (%eax),%edx
    17c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17c9:	89 10                	mov    %edx,(%eax)
    17cb:	eb 26                	jmp    17f3 <malloc+0x96>
      else {
        p->s.size -= nunits;
    17cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d0:	8b 40 04             	mov    0x4(%eax),%eax
    17d3:	2b 45 ec             	sub    -0x14(%ebp),%eax
    17d6:	89 c2                	mov    %eax,%edx
    17d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17db:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    17de:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17e1:	8b 40 04             	mov    0x4(%eax),%eax
    17e4:	c1 e0 03             	shl    $0x3,%eax
    17e7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17f0:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    17f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17f6:	a3 7c 1b 00 00       	mov    %eax,0x1b7c
      return (void*)(p + 1);
    17fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17fe:	83 c0 08             	add    $0x8,%eax
    1801:	eb 38                	jmp    183b <malloc+0xde>
    }
    if(p == freep)
    1803:	a1 7c 1b 00 00       	mov    0x1b7c,%eax
    1808:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    180b:	75 1b                	jne    1828 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    180d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1810:	89 04 24             	mov    %eax,(%esp)
    1813:	e8 ed fe ff ff       	call   1705 <morecore>
    1818:	89 45 f4             	mov    %eax,-0xc(%ebp)
    181b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    181f:	75 07                	jne    1828 <malloc+0xcb>
        return 0;
    1821:	b8 00 00 00 00       	mov    $0x0,%eax
    1826:	eb 13                	jmp    183b <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1828:	8b 45 f4             	mov    -0xc(%ebp),%eax
    182b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    182e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1831:	8b 00                	mov    (%eax),%eax
    1833:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
    1836:	e9 70 ff ff ff       	jmp    17ab <malloc+0x4e>
}
    183b:	c9                   	leave  
    183c:	c3                   	ret    

0000183d <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    183d:	55                   	push   %ebp
    183e:	89 e5                	mov    %esp,%ebp
    1840:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1843:	8b 55 08             	mov    0x8(%ebp),%edx
    1846:	8b 45 0c             	mov    0xc(%ebp),%eax
    1849:	8b 4d 08             	mov    0x8(%ebp),%ecx
    184c:	f0 87 02             	lock xchg %eax,(%edx)
    184f:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1852:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1855:	c9                   	leave  
    1856:	c3                   	ret    

00001857 <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    1857:	55                   	push   %ebp
    1858:	89 e5                	mov    %esp,%ebp
    185a:	83 ec 08             	sub    $0x8,%esp
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    185d:	90                   	nop
    185e:	8b 45 08             	mov    0x8(%ebp),%eax
    1861:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1868:	00 
    1869:	89 04 24             	mov    %eax,(%esp)
    186c:	e8 cc ff ff ff       	call   183d <xchg>
    1871:	85 c0                	test   %eax,%eax
    1873:	75 e9                	jne    185e <uacquire+0x7>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    1875:	0f ae f0             	mfence 
}
    1878:	c9                   	leave  
    1879:	c3                   	ret    

0000187a <urelease>:

void urelease (struct uspinlock *lk) {
    187a:	55                   	push   %ebp
    187b:	89 e5                	mov    %esp,%ebp
  __sync_synchronize();
    187d:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    1880:	8b 45 08             	mov    0x8(%ebp),%eax
    1883:	8b 55 08             	mov    0x8(%ebp),%edx
    1886:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    188c:	5d                   	pop    %ebp
    188d:	c3                   	ret    
