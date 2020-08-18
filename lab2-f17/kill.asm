
_kill:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
    1009:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
    100d:	7f 19                	jg     1028 <main+0x28>
    printf(2, "usage: kill pid...\n");
    100f:	c7 44 24 04 7c 18 00 	movl   $0x187c,0x4(%esp)
    1016:	00 
    1017:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    101e:	e8 3c 04 00 00       	call   145f <printf>
    exit();
    1023:	e8 a7 02 00 00       	call   12cf <exit>
  }
  for(i=1; i<argc; i++)
    1028:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    102f:	00 
    1030:	eb 27                	jmp    1059 <main+0x59>
    kill(atoi(argv[i]));
    1032:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1036:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    103d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1040:	01 d0                	add    %edx,%eax
    1042:	8b 00                	mov    (%eax),%eax
    1044:	89 04 24             	mov    %eax,(%esp)
    1047:	e8 f1 01 00 00       	call   123d <atoi>
    104c:	89 04 24             	mov    %eax,(%esp)
    104f:	e8 ab 02 00 00       	call   12ff <kill>
  for(i=1; i<argc; i++)
    1054:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
    1059:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    105d:	3b 45 08             	cmp    0x8(%ebp),%eax
    1060:	7c d0                	jl     1032 <main+0x32>
  exit();
    1062:	e8 68 02 00 00       	call   12cf <exit>

00001067 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1067:	55                   	push   %ebp
    1068:	89 e5                	mov    %esp,%ebp
    106a:	57                   	push   %edi
    106b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    106c:	8b 4d 08             	mov    0x8(%ebp),%ecx
    106f:	8b 55 10             	mov    0x10(%ebp),%edx
    1072:	8b 45 0c             	mov    0xc(%ebp),%eax
    1075:	89 cb                	mov    %ecx,%ebx
    1077:	89 df                	mov    %ebx,%edi
    1079:	89 d1                	mov    %edx,%ecx
    107b:	fc                   	cld    
    107c:	f3 aa                	rep stos %al,%es:(%edi)
    107e:	89 ca                	mov    %ecx,%edx
    1080:	89 fb                	mov    %edi,%ebx
    1082:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1085:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1088:	5b                   	pop    %ebx
    1089:	5f                   	pop    %edi
    108a:	5d                   	pop    %ebp
    108b:	c3                   	ret    

0000108c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    108c:	55                   	push   %ebp
    108d:	89 e5                	mov    %esp,%ebp
    108f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1092:	8b 45 08             	mov    0x8(%ebp),%eax
    1095:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1098:	90                   	nop
    1099:	8b 45 08             	mov    0x8(%ebp),%eax
    109c:	8d 50 01             	lea    0x1(%eax),%edx
    109f:	89 55 08             	mov    %edx,0x8(%ebp)
    10a2:	8b 55 0c             	mov    0xc(%ebp),%edx
    10a5:	8d 4a 01             	lea    0x1(%edx),%ecx
    10a8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    10ab:	0f b6 12             	movzbl (%edx),%edx
    10ae:	88 10                	mov    %dl,(%eax)
    10b0:	0f b6 00             	movzbl (%eax),%eax
    10b3:	84 c0                	test   %al,%al
    10b5:	75 e2                	jne    1099 <strcpy+0xd>
    ;
  return os;
    10b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10ba:	c9                   	leave  
    10bb:	c3                   	ret    

000010bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10bc:	55                   	push   %ebp
    10bd:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10bf:	eb 08                	jmp    10c9 <strcmp+0xd>
    p++, q++;
    10c1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    10c5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
    10c9:	8b 45 08             	mov    0x8(%ebp),%eax
    10cc:	0f b6 00             	movzbl (%eax),%eax
    10cf:	84 c0                	test   %al,%al
    10d1:	74 10                	je     10e3 <strcmp+0x27>
    10d3:	8b 45 08             	mov    0x8(%ebp),%eax
    10d6:	0f b6 10             	movzbl (%eax),%edx
    10d9:	8b 45 0c             	mov    0xc(%ebp),%eax
    10dc:	0f b6 00             	movzbl (%eax),%eax
    10df:	38 c2                	cmp    %al,%dl
    10e1:	74 de                	je     10c1 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
    10e3:	8b 45 08             	mov    0x8(%ebp),%eax
    10e6:	0f b6 00             	movzbl (%eax),%eax
    10e9:	0f b6 d0             	movzbl %al,%edx
    10ec:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ef:	0f b6 00             	movzbl (%eax),%eax
    10f2:	0f b6 c0             	movzbl %al,%eax
    10f5:	29 c2                	sub    %eax,%edx
    10f7:	89 d0                	mov    %edx,%eax
}
    10f9:	5d                   	pop    %ebp
    10fa:	c3                   	ret    

000010fb <strlen>:

uint
strlen(char *s)
{
    10fb:	55                   	push   %ebp
    10fc:	89 e5                	mov    %esp,%ebp
    10fe:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1101:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1108:	eb 04                	jmp    110e <strlen+0x13>
    110a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    110e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1111:	8b 45 08             	mov    0x8(%ebp),%eax
    1114:	01 d0                	add    %edx,%eax
    1116:	0f b6 00             	movzbl (%eax),%eax
    1119:	84 c0                	test   %al,%al
    111b:	75 ed                	jne    110a <strlen+0xf>
    ;
  return n;
    111d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1120:	c9                   	leave  
    1121:	c3                   	ret    

00001122 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1122:	55                   	push   %ebp
    1123:	89 e5                	mov    %esp,%ebp
    1125:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1128:	8b 45 10             	mov    0x10(%ebp),%eax
    112b:	89 44 24 08          	mov    %eax,0x8(%esp)
    112f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1132:	89 44 24 04          	mov    %eax,0x4(%esp)
    1136:	8b 45 08             	mov    0x8(%ebp),%eax
    1139:	89 04 24             	mov    %eax,(%esp)
    113c:	e8 26 ff ff ff       	call   1067 <stosb>
  return dst;
    1141:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1144:	c9                   	leave  
    1145:	c3                   	ret    

00001146 <strchr>:

char*
strchr(const char *s, char c)
{
    1146:	55                   	push   %ebp
    1147:	89 e5                	mov    %esp,%ebp
    1149:	83 ec 04             	sub    $0x4,%esp
    114c:	8b 45 0c             	mov    0xc(%ebp),%eax
    114f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1152:	eb 14                	jmp    1168 <strchr+0x22>
    if(*s == c)
    1154:	8b 45 08             	mov    0x8(%ebp),%eax
    1157:	0f b6 00             	movzbl (%eax),%eax
    115a:	3a 45 fc             	cmp    -0x4(%ebp),%al
    115d:	75 05                	jne    1164 <strchr+0x1e>
      return (char*)s;
    115f:	8b 45 08             	mov    0x8(%ebp),%eax
    1162:	eb 13                	jmp    1177 <strchr+0x31>
  for(; *s; s++)
    1164:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1168:	8b 45 08             	mov    0x8(%ebp),%eax
    116b:	0f b6 00             	movzbl (%eax),%eax
    116e:	84 c0                	test   %al,%al
    1170:	75 e2                	jne    1154 <strchr+0xe>
  return 0;
    1172:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1177:	c9                   	leave  
    1178:	c3                   	ret    

00001179 <gets>:

char*
gets(char *buf, int max)
{
    1179:	55                   	push   %ebp
    117a:	89 e5                	mov    %esp,%ebp
    117c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    117f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1186:	eb 4c                	jmp    11d4 <gets+0x5b>
    cc = read(0, &c, 1);
    1188:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    118f:	00 
    1190:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1193:	89 44 24 04          	mov    %eax,0x4(%esp)
    1197:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    119e:	e8 44 01 00 00       	call   12e7 <read>
    11a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    11a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11aa:	7f 02                	jg     11ae <gets+0x35>
      break;
    11ac:	eb 31                	jmp    11df <gets+0x66>
    buf[i++] = c;
    11ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11b1:	8d 50 01             	lea    0x1(%eax),%edx
    11b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
    11b7:	89 c2                	mov    %eax,%edx
    11b9:	8b 45 08             	mov    0x8(%ebp),%eax
    11bc:	01 c2                	add    %eax,%edx
    11be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11c2:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    11c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11c8:	3c 0a                	cmp    $0xa,%al
    11ca:	74 13                	je     11df <gets+0x66>
    11cc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11d0:	3c 0d                	cmp    $0xd,%al
    11d2:	74 0b                	je     11df <gets+0x66>
  for(i=0; i+1 < max; ){
    11d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11d7:	83 c0 01             	add    $0x1,%eax
    11da:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11dd:	7c a9                	jl     1188 <gets+0xf>
      break;
  }
  buf[i] = '\0';
    11df:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11e2:	8b 45 08             	mov    0x8(%ebp),%eax
    11e5:	01 d0                	add    %edx,%eax
    11e7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11ed:	c9                   	leave  
    11ee:	c3                   	ret    

000011ef <stat>:

int
stat(char *n, struct stat *st)
{
    11ef:	55                   	push   %ebp
    11f0:	89 e5                	mov    %esp,%ebp
    11f2:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    11fc:	00 
    11fd:	8b 45 08             	mov    0x8(%ebp),%eax
    1200:	89 04 24             	mov    %eax,(%esp)
    1203:	e8 07 01 00 00       	call   130f <open>
    1208:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    120b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    120f:	79 07                	jns    1218 <stat+0x29>
    return -1;
    1211:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1216:	eb 23                	jmp    123b <stat+0x4c>
  r = fstat(fd, st);
    1218:	8b 45 0c             	mov    0xc(%ebp),%eax
    121b:	89 44 24 04          	mov    %eax,0x4(%esp)
    121f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1222:	89 04 24             	mov    %eax,(%esp)
    1225:	e8 fd 00 00 00       	call   1327 <fstat>
    122a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    122d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1230:	89 04 24             	mov    %eax,(%esp)
    1233:	e8 bf 00 00 00       	call   12f7 <close>
  return r;
    1238:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    123b:	c9                   	leave  
    123c:	c3                   	ret    

0000123d <atoi>:

int
atoi(const char *s)
{
    123d:	55                   	push   %ebp
    123e:	89 e5                	mov    %esp,%ebp
    1240:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1243:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    124a:	eb 25                	jmp    1271 <atoi+0x34>
    n = n*10 + *s++ - '0';
    124c:	8b 55 fc             	mov    -0x4(%ebp),%edx
    124f:	89 d0                	mov    %edx,%eax
    1251:	c1 e0 02             	shl    $0x2,%eax
    1254:	01 d0                	add    %edx,%eax
    1256:	01 c0                	add    %eax,%eax
    1258:	89 c1                	mov    %eax,%ecx
    125a:	8b 45 08             	mov    0x8(%ebp),%eax
    125d:	8d 50 01             	lea    0x1(%eax),%edx
    1260:	89 55 08             	mov    %edx,0x8(%ebp)
    1263:	0f b6 00             	movzbl (%eax),%eax
    1266:	0f be c0             	movsbl %al,%eax
    1269:	01 c8                	add    %ecx,%eax
    126b:	83 e8 30             	sub    $0x30,%eax
    126e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1271:	8b 45 08             	mov    0x8(%ebp),%eax
    1274:	0f b6 00             	movzbl (%eax),%eax
    1277:	3c 2f                	cmp    $0x2f,%al
    1279:	7e 0a                	jle    1285 <atoi+0x48>
    127b:	8b 45 08             	mov    0x8(%ebp),%eax
    127e:	0f b6 00             	movzbl (%eax),%eax
    1281:	3c 39                	cmp    $0x39,%al
    1283:	7e c7                	jle    124c <atoi+0xf>
  return n;
    1285:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1288:	c9                   	leave  
    1289:	c3                   	ret    

0000128a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    128a:	55                   	push   %ebp
    128b:	89 e5                	mov    %esp,%ebp
    128d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    1290:	8b 45 08             	mov    0x8(%ebp),%eax
    1293:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1296:	8b 45 0c             	mov    0xc(%ebp),%eax
    1299:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    129c:	eb 17                	jmp    12b5 <memmove+0x2b>
    *dst++ = *src++;
    129e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12a1:	8d 50 01             	lea    0x1(%eax),%edx
    12a4:	89 55 fc             	mov    %edx,-0x4(%ebp)
    12a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
    12aa:	8d 4a 01             	lea    0x1(%edx),%ecx
    12ad:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    12b0:	0f b6 12             	movzbl (%edx),%edx
    12b3:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
    12b5:	8b 45 10             	mov    0x10(%ebp),%eax
    12b8:	8d 50 ff             	lea    -0x1(%eax),%edx
    12bb:	89 55 10             	mov    %edx,0x10(%ebp)
    12be:	85 c0                	test   %eax,%eax
    12c0:	7f dc                	jg     129e <memmove+0x14>
  return vdst;
    12c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12c5:	c9                   	leave  
    12c6:	c3                   	ret    

000012c7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12c7:	b8 01 00 00 00       	mov    $0x1,%eax
    12cc:	cd 40                	int    $0x40
    12ce:	c3                   	ret    

000012cf <exit>:
SYSCALL(exit)
    12cf:	b8 02 00 00 00       	mov    $0x2,%eax
    12d4:	cd 40                	int    $0x40
    12d6:	c3                   	ret    

000012d7 <wait>:
SYSCALL(wait)
    12d7:	b8 03 00 00 00       	mov    $0x3,%eax
    12dc:	cd 40                	int    $0x40
    12de:	c3                   	ret    

000012df <pipe>:
SYSCALL(pipe)
    12df:	b8 04 00 00 00       	mov    $0x4,%eax
    12e4:	cd 40                	int    $0x40
    12e6:	c3                   	ret    

000012e7 <read>:
SYSCALL(read)
    12e7:	b8 05 00 00 00       	mov    $0x5,%eax
    12ec:	cd 40                	int    $0x40
    12ee:	c3                   	ret    

000012ef <write>:
SYSCALL(write)
    12ef:	b8 10 00 00 00       	mov    $0x10,%eax
    12f4:	cd 40                	int    $0x40
    12f6:	c3                   	ret    

000012f7 <close>:
SYSCALL(close)
    12f7:	b8 15 00 00 00       	mov    $0x15,%eax
    12fc:	cd 40                	int    $0x40
    12fe:	c3                   	ret    

000012ff <kill>:
SYSCALL(kill)
    12ff:	b8 06 00 00 00       	mov    $0x6,%eax
    1304:	cd 40                	int    $0x40
    1306:	c3                   	ret    

00001307 <exec>:
SYSCALL(exec)
    1307:	b8 07 00 00 00       	mov    $0x7,%eax
    130c:	cd 40                	int    $0x40
    130e:	c3                   	ret    

0000130f <open>:
SYSCALL(open)
    130f:	b8 0f 00 00 00       	mov    $0xf,%eax
    1314:	cd 40                	int    $0x40
    1316:	c3                   	ret    

00001317 <mknod>:
SYSCALL(mknod)
    1317:	b8 11 00 00 00       	mov    $0x11,%eax
    131c:	cd 40                	int    $0x40
    131e:	c3                   	ret    

0000131f <unlink>:
SYSCALL(unlink)
    131f:	b8 12 00 00 00       	mov    $0x12,%eax
    1324:	cd 40                	int    $0x40
    1326:	c3                   	ret    

00001327 <fstat>:
SYSCALL(fstat)
    1327:	b8 08 00 00 00       	mov    $0x8,%eax
    132c:	cd 40                	int    $0x40
    132e:	c3                   	ret    

0000132f <link>:
SYSCALL(link)
    132f:	b8 13 00 00 00       	mov    $0x13,%eax
    1334:	cd 40                	int    $0x40
    1336:	c3                   	ret    

00001337 <mkdir>:
SYSCALL(mkdir)
    1337:	b8 14 00 00 00       	mov    $0x14,%eax
    133c:	cd 40                	int    $0x40
    133e:	c3                   	ret    

0000133f <chdir>:
SYSCALL(chdir)
    133f:	b8 09 00 00 00       	mov    $0x9,%eax
    1344:	cd 40                	int    $0x40
    1346:	c3                   	ret    

00001347 <dup>:
SYSCALL(dup)
    1347:	b8 0a 00 00 00       	mov    $0xa,%eax
    134c:	cd 40                	int    $0x40
    134e:	c3                   	ret    

0000134f <getpid>:
SYSCALL(getpid)
    134f:	b8 0b 00 00 00       	mov    $0xb,%eax
    1354:	cd 40                	int    $0x40
    1356:	c3                   	ret    

00001357 <sbrk>:
SYSCALL(sbrk)
    1357:	b8 0c 00 00 00       	mov    $0xc,%eax
    135c:	cd 40                	int    $0x40
    135e:	c3                   	ret    

0000135f <sleep>:
SYSCALL(sleep)
    135f:	b8 0d 00 00 00       	mov    $0xd,%eax
    1364:	cd 40                	int    $0x40
    1366:	c3                   	ret    

00001367 <uptime>:
SYSCALL(uptime)
    1367:	b8 0e 00 00 00       	mov    $0xe,%eax
    136c:	cd 40                	int    $0x40
    136e:	c3                   	ret    

0000136f <shm_open>:
SYSCALL(shm_open)
    136f:	b8 16 00 00 00       	mov    $0x16,%eax
    1374:	cd 40                	int    $0x40
    1376:	c3                   	ret    

00001377 <shm_close>:
SYSCALL(shm_close)	
    1377:	b8 17 00 00 00       	mov    $0x17,%eax
    137c:	cd 40                	int    $0x40
    137e:	c3                   	ret    

0000137f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    137f:	55                   	push   %ebp
    1380:	89 e5                	mov    %esp,%ebp
    1382:	83 ec 18             	sub    $0x18,%esp
    1385:	8b 45 0c             	mov    0xc(%ebp),%eax
    1388:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    138b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1392:	00 
    1393:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1396:	89 44 24 04          	mov    %eax,0x4(%esp)
    139a:	8b 45 08             	mov    0x8(%ebp),%eax
    139d:	89 04 24             	mov    %eax,(%esp)
    13a0:	e8 4a ff ff ff       	call   12ef <write>
}
    13a5:	c9                   	leave  
    13a6:	c3                   	ret    

000013a7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13a7:	55                   	push   %ebp
    13a8:	89 e5                	mov    %esp,%ebp
    13aa:	56                   	push   %esi
    13ab:	53                   	push   %ebx
    13ac:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    13af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    13b6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    13ba:	74 17                	je     13d3 <printint+0x2c>
    13bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    13c0:	79 11                	jns    13d3 <printint+0x2c>
    neg = 1;
    13c2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13c9:	8b 45 0c             	mov    0xc(%ebp),%eax
    13cc:	f7 d8                	neg    %eax
    13ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13d1:	eb 06                	jmp    13d9 <printint+0x32>
  } else {
    x = xx;
    13d3:	8b 45 0c             	mov    0xc(%ebp),%eax
    13d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    13e0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    13e3:	8d 41 01             	lea    0x1(%ecx),%eax
    13e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    13e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13ef:	ba 00 00 00 00       	mov    $0x0,%edx
    13f4:	f7 f3                	div    %ebx
    13f6:	89 d0                	mov    %edx,%eax
    13f8:	0f b6 80 3c 1b 00 00 	movzbl 0x1b3c(%eax),%eax
    13ff:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1403:	8b 75 10             	mov    0x10(%ebp),%esi
    1406:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1409:	ba 00 00 00 00       	mov    $0x0,%edx
    140e:	f7 f6                	div    %esi
    1410:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1413:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1417:	75 c7                	jne    13e0 <printint+0x39>
  if(neg)
    1419:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    141d:	74 10                	je     142f <printint+0x88>
    buf[i++] = '-';
    141f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1422:	8d 50 01             	lea    0x1(%eax),%edx
    1425:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1428:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    142d:	eb 1f                	jmp    144e <printint+0xa7>
    142f:	eb 1d                	jmp    144e <printint+0xa7>
    putc(fd, buf[i]);
    1431:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1434:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1437:	01 d0                	add    %edx,%eax
    1439:	0f b6 00             	movzbl (%eax),%eax
    143c:	0f be c0             	movsbl %al,%eax
    143f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1443:	8b 45 08             	mov    0x8(%ebp),%eax
    1446:	89 04 24             	mov    %eax,(%esp)
    1449:	e8 31 ff ff ff       	call   137f <putc>
  while(--i >= 0)
    144e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1452:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1456:	79 d9                	jns    1431 <printint+0x8a>
}
    1458:	83 c4 30             	add    $0x30,%esp
    145b:	5b                   	pop    %ebx
    145c:	5e                   	pop    %esi
    145d:	5d                   	pop    %ebp
    145e:	c3                   	ret    

0000145f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    145f:	55                   	push   %ebp
    1460:	89 e5                	mov    %esp,%ebp
    1462:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1465:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    146c:	8d 45 0c             	lea    0xc(%ebp),%eax
    146f:	83 c0 04             	add    $0x4,%eax
    1472:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1475:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    147c:	e9 7c 01 00 00       	jmp    15fd <printf+0x19e>
    c = fmt[i] & 0xff;
    1481:	8b 55 0c             	mov    0xc(%ebp),%edx
    1484:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1487:	01 d0                	add    %edx,%eax
    1489:	0f b6 00             	movzbl (%eax),%eax
    148c:	0f be c0             	movsbl %al,%eax
    148f:	25 ff 00 00 00       	and    $0xff,%eax
    1494:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1497:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    149b:	75 2c                	jne    14c9 <printf+0x6a>
      if(c == '%'){
    149d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    14a1:	75 0c                	jne    14af <printf+0x50>
        state = '%';
    14a3:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    14aa:	e9 4a 01 00 00       	jmp    15f9 <printf+0x19a>
      } else {
        putc(fd, c);
    14af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    14b2:	0f be c0             	movsbl %al,%eax
    14b5:	89 44 24 04          	mov    %eax,0x4(%esp)
    14b9:	8b 45 08             	mov    0x8(%ebp),%eax
    14bc:	89 04 24             	mov    %eax,(%esp)
    14bf:	e8 bb fe ff ff       	call   137f <putc>
    14c4:	e9 30 01 00 00       	jmp    15f9 <printf+0x19a>
      }
    } else if(state == '%'){
    14c9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14cd:	0f 85 26 01 00 00    	jne    15f9 <printf+0x19a>
      if(c == 'd'){
    14d3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14d7:	75 2d                	jne    1506 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    14d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14dc:	8b 00                	mov    (%eax),%eax
    14de:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    14e5:	00 
    14e6:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    14ed:	00 
    14ee:	89 44 24 04          	mov    %eax,0x4(%esp)
    14f2:	8b 45 08             	mov    0x8(%ebp),%eax
    14f5:	89 04 24             	mov    %eax,(%esp)
    14f8:	e8 aa fe ff ff       	call   13a7 <printint>
        ap++;
    14fd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1501:	e9 ec 00 00 00       	jmp    15f2 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    1506:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    150a:	74 06                	je     1512 <printf+0xb3>
    150c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1510:	75 2d                	jne    153f <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1512:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1515:	8b 00                	mov    (%eax),%eax
    1517:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    151e:	00 
    151f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1526:	00 
    1527:	89 44 24 04          	mov    %eax,0x4(%esp)
    152b:	8b 45 08             	mov    0x8(%ebp),%eax
    152e:	89 04 24             	mov    %eax,(%esp)
    1531:	e8 71 fe ff ff       	call   13a7 <printint>
        ap++;
    1536:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    153a:	e9 b3 00 00 00       	jmp    15f2 <printf+0x193>
      } else if(c == 's'){
    153f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1543:	75 45                	jne    158a <printf+0x12b>
        s = (char*)*ap;
    1545:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1548:	8b 00                	mov    (%eax),%eax
    154a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    154d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1551:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1555:	75 09                	jne    1560 <printf+0x101>
          s = "(null)";
    1557:	c7 45 f4 90 18 00 00 	movl   $0x1890,-0xc(%ebp)
        while(*s != 0){
    155e:	eb 1e                	jmp    157e <printf+0x11f>
    1560:	eb 1c                	jmp    157e <printf+0x11f>
          putc(fd, *s);
    1562:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1565:	0f b6 00             	movzbl (%eax),%eax
    1568:	0f be c0             	movsbl %al,%eax
    156b:	89 44 24 04          	mov    %eax,0x4(%esp)
    156f:	8b 45 08             	mov    0x8(%ebp),%eax
    1572:	89 04 24             	mov    %eax,(%esp)
    1575:	e8 05 fe ff ff       	call   137f <putc>
          s++;
    157a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
    157e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1581:	0f b6 00             	movzbl (%eax),%eax
    1584:	84 c0                	test   %al,%al
    1586:	75 da                	jne    1562 <printf+0x103>
    1588:	eb 68                	jmp    15f2 <printf+0x193>
        }
      } else if(c == 'c'){
    158a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    158e:	75 1d                	jne    15ad <printf+0x14e>
        putc(fd, *ap);
    1590:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1593:	8b 00                	mov    (%eax),%eax
    1595:	0f be c0             	movsbl %al,%eax
    1598:	89 44 24 04          	mov    %eax,0x4(%esp)
    159c:	8b 45 08             	mov    0x8(%ebp),%eax
    159f:	89 04 24             	mov    %eax,(%esp)
    15a2:	e8 d8 fd ff ff       	call   137f <putc>
        ap++;
    15a7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15ab:	eb 45                	jmp    15f2 <printf+0x193>
      } else if(c == '%'){
    15ad:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15b1:	75 17                	jne    15ca <printf+0x16b>
        putc(fd, c);
    15b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15b6:	0f be c0             	movsbl %al,%eax
    15b9:	89 44 24 04          	mov    %eax,0x4(%esp)
    15bd:	8b 45 08             	mov    0x8(%ebp),%eax
    15c0:	89 04 24             	mov    %eax,(%esp)
    15c3:	e8 b7 fd ff ff       	call   137f <putc>
    15c8:	eb 28                	jmp    15f2 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15ca:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    15d1:	00 
    15d2:	8b 45 08             	mov    0x8(%ebp),%eax
    15d5:	89 04 24             	mov    %eax,(%esp)
    15d8:	e8 a2 fd ff ff       	call   137f <putc>
        putc(fd, c);
    15dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15e0:	0f be c0             	movsbl %al,%eax
    15e3:	89 44 24 04          	mov    %eax,0x4(%esp)
    15e7:	8b 45 08             	mov    0x8(%ebp),%eax
    15ea:	89 04 24             	mov    %eax,(%esp)
    15ed:	e8 8d fd ff ff       	call   137f <putc>
      }
      state = 0;
    15f2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    15f9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    15fd:	8b 55 0c             	mov    0xc(%ebp),%edx
    1600:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1603:	01 d0                	add    %edx,%eax
    1605:	0f b6 00             	movzbl (%eax),%eax
    1608:	84 c0                	test   %al,%al
    160a:	0f 85 71 fe ff ff    	jne    1481 <printf+0x22>
    }
  }
}
    1610:	c9                   	leave  
    1611:	c3                   	ret    

00001612 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1612:	55                   	push   %ebp
    1613:	89 e5                	mov    %esp,%ebp
    1615:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1618:	8b 45 08             	mov    0x8(%ebp),%eax
    161b:	83 e8 08             	sub    $0x8,%eax
    161e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1621:	a1 58 1b 00 00       	mov    0x1b58,%eax
    1626:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1629:	eb 24                	jmp    164f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    162b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    162e:	8b 00                	mov    (%eax),%eax
    1630:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1633:	77 12                	ja     1647 <free+0x35>
    1635:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1638:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    163b:	77 24                	ja     1661 <free+0x4f>
    163d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1640:	8b 00                	mov    (%eax),%eax
    1642:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1645:	77 1a                	ja     1661 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1647:	8b 45 fc             	mov    -0x4(%ebp),%eax
    164a:	8b 00                	mov    (%eax),%eax
    164c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    164f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1652:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1655:	76 d4                	jbe    162b <free+0x19>
    1657:	8b 45 fc             	mov    -0x4(%ebp),%eax
    165a:	8b 00                	mov    (%eax),%eax
    165c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    165f:	76 ca                	jbe    162b <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1661:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1664:	8b 40 04             	mov    0x4(%eax),%eax
    1667:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    166e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1671:	01 c2                	add    %eax,%edx
    1673:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1676:	8b 00                	mov    (%eax),%eax
    1678:	39 c2                	cmp    %eax,%edx
    167a:	75 24                	jne    16a0 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    167c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    167f:	8b 50 04             	mov    0x4(%eax),%edx
    1682:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1685:	8b 00                	mov    (%eax),%eax
    1687:	8b 40 04             	mov    0x4(%eax),%eax
    168a:	01 c2                	add    %eax,%edx
    168c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    168f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1692:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1695:	8b 00                	mov    (%eax),%eax
    1697:	8b 10                	mov    (%eax),%edx
    1699:	8b 45 f8             	mov    -0x8(%ebp),%eax
    169c:	89 10                	mov    %edx,(%eax)
    169e:	eb 0a                	jmp    16aa <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    16a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a3:	8b 10                	mov    (%eax),%edx
    16a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16a8:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    16aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ad:	8b 40 04             	mov    0x4(%eax),%eax
    16b0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ba:	01 d0                	add    %edx,%eax
    16bc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16bf:	75 20                	jne    16e1 <free+0xcf>
    p->s.size += bp->s.size;
    16c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c4:	8b 50 04             	mov    0x4(%eax),%edx
    16c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16ca:	8b 40 04             	mov    0x4(%eax),%eax
    16cd:	01 c2                	add    %eax,%edx
    16cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16d8:	8b 10                	mov    (%eax),%edx
    16da:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16dd:	89 10                	mov    %edx,(%eax)
    16df:	eb 08                	jmp    16e9 <free+0xd7>
  } else
    p->s.ptr = bp;
    16e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e4:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16e7:	89 10                	mov    %edx,(%eax)
  freep = p;
    16e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ec:	a3 58 1b 00 00       	mov    %eax,0x1b58
}
    16f1:	c9                   	leave  
    16f2:	c3                   	ret    

000016f3 <morecore>:

static Header*
morecore(uint nu)
{
    16f3:	55                   	push   %ebp
    16f4:	89 e5                	mov    %esp,%ebp
    16f6:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    16f9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1700:	77 07                	ja     1709 <morecore+0x16>
    nu = 4096;
    1702:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1709:	8b 45 08             	mov    0x8(%ebp),%eax
    170c:	c1 e0 03             	shl    $0x3,%eax
    170f:	89 04 24             	mov    %eax,(%esp)
    1712:	e8 40 fc ff ff       	call   1357 <sbrk>
    1717:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    171a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    171e:	75 07                	jne    1727 <morecore+0x34>
    return 0;
    1720:	b8 00 00 00 00       	mov    $0x0,%eax
    1725:	eb 22                	jmp    1749 <morecore+0x56>
  hp = (Header*)p;
    1727:	8b 45 f4             	mov    -0xc(%ebp),%eax
    172a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    172d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1730:	8b 55 08             	mov    0x8(%ebp),%edx
    1733:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1736:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1739:	83 c0 08             	add    $0x8,%eax
    173c:	89 04 24             	mov    %eax,(%esp)
    173f:	e8 ce fe ff ff       	call   1612 <free>
  return freep;
    1744:	a1 58 1b 00 00       	mov    0x1b58,%eax
}
    1749:	c9                   	leave  
    174a:	c3                   	ret    

0000174b <malloc>:

void*
malloc(uint nbytes)
{
    174b:	55                   	push   %ebp
    174c:	89 e5                	mov    %esp,%ebp
    174e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1751:	8b 45 08             	mov    0x8(%ebp),%eax
    1754:	83 c0 07             	add    $0x7,%eax
    1757:	c1 e8 03             	shr    $0x3,%eax
    175a:	83 c0 01             	add    $0x1,%eax
    175d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1760:	a1 58 1b 00 00       	mov    0x1b58,%eax
    1765:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1768:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    176c:	75 23                	jne    1791 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    176e:	c7 45 f0 50 1b 00 00 	movl   $0x1b50,-0x10(%ebp)
    1775:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1778:	a3 58 1b 00 00       	mov    %eax,0x1b58
    177d:	a1 58 1b 00 00       	mov    0x1b58,%eax
    1782:	a3 50 1b 00 00       	mov    %eax,0x1b50
    base.s.size = 0;
    1787:	c7 05 54 1b 00 00 00 	movl   $0x0,0x1b54
    178e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1791:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1794:	8b 00                	mov    (%eax),%eax
    1796:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1799:	8b 45 f4             	mov    -0xc(%ebp),%eax
    179c:	8b 40 04             	mov    0x4(%eax),%eax
    179f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17a2:	72 4d                	jb     17f1 <malloc+0xa6>
      if(p->s.size == nunits)
    17a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17a7:	8b 40 04             	mov    0x4(%eax),%eax
    17aa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17ad:	75 0c                	jne    17bb <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    17af:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17b2:	8b 10                	mov    (%eax),%edx
    17b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17b7:	89 10                	mov    %edx,(%eax)
    17b9:	eb 26                	jmp    17e1 <malloc+0x96>
      else {
        p->s.size -= nunits;
    17bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17be:	8b 40 04             	mov    0x4(%eax),%eax
    17c1:	2b 45 ec             	sub    -0x14(%ebp),%eax
    17c4:	89 c2                	mov    %eax,%edx
    17c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    17cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17cf:	8b 40 04             	mov    0x4(%eax),%eax
    17d2:	c1 e0 03             	shl    $0x3,%eax
    17d5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17db:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17de:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    17e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17e4:	a3 58 1b 00 00       	mov    %eax,0x1b58
      return (void*)(p + 1);
    17e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ec:	83 c0 08             	add    $0x8,%eax
    17ef:	eb 38                	jmp    1829 <malloc+0xde>
    }
    if(p == freep)
    17f1:	a1 58 1b 00 00       	mov    0x1b58,%eax
    17f6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    17f9:	75 1b                	jne    1816 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    17fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
    17fe:	89 04 24             	mov    %eax,(%esp)
    1801:	e8 ed fe ff ff       	call   16f3 <morecore>
    1806:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1809:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    180d:	75 07                	jne    1816 <malloc+0xcb>
        return 0;
    180f:	b8 00 00 00 00       	mov    $0x0,%eax
    1814:	eb 13                	jmp    1829 <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1816:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1819:	89 45 f0             	mov    %eax,-0x10(%ebp)
    181c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    181f:	8b 00                	mov    (%eax),%eax
    1821:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
    1824:	e9 70 ff ff ff       	jmp    1799 <malloc+0x4e>
}
    1829:	c9                   	leave  
    182a:	c3                   	ret    

0000182b <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    182b:	55                   	push   %ebp
    182c:	89 e5                	mov    %esp,%ebp
    182e:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1831:	8b 55 08             	mov    0x8(%ebp),%edx
    1834:	8b 45 0c             	mov    0xc(%ebp),%eax
    1837:	8b 4d 08             	mov    0x8(%ebp),%ecx
    183a:	f0 87 02             	lock xchg %eax,(%edx)
    183d:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1840:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1843:	c9                   	leave  
    1844:	c3                   	ret    

00001845 <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    1845:	55                   	push   %ebp
    1846:	89 e5                	mov    %esp,%ebp
    1848:	83 ec 08             	sub    $0x8,%esp
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    184b:	90                   	nop
    184c:	8b 45 08             	mov    0x8(%ebp),%eax
    184f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1856:	00 
    1857:	89 04 24             	mov    %eax,(%esp)
    185a:	e8 cc ff ff ff       	call   182b <xchg>
    185f:	85 c0                	test   %eax,%eax
    1861:	75 e9                	jne    184c <uacquire+0x7>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    1863:	0f ae f0             	mfence 
}
    1866:	c9                   	leave  
    1867:	c3                   	ret    

00001868 <urelease>:

void urelease (struct uspinlock *lk) {
    1868:	55                   	push   %ebp
    1869:	89 e5                	mov    %esp,%ebp
  __sync_synchronize();
    186b:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    186e:	8b 45 08             	mov    0x8(%ebp),%eax
    1871:	8b 55 08             	mov    0x8(%ebp),%edx
    1874:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    187a:	5d                   	pop    %ebp
    187b:	c3                   	ret    
