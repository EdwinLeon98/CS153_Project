
_echo:     file format elf32-i386


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
    1006:	83 ec 20             	sub    $0x20,%esp
  int i;

  for(i = 1; i < argc; i++)
    1009:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    1010:	00 
    1011:	eb 4b                	jmp    105e <main+0x5e>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
    1013:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1017:	83 c0 01             	add    $0x1,%eax
    101a:	3b 45 08             	cmp    0x8(%ebp),%eax
    101d:	7d 07                	jge    1026 <main+0x26>
    101f:	b8 81 18 00 00       	mov    $0x1881,%eax
    1024:	eb 05                	jmp    102b <main+0x2b>
    1026:	b8 83 18 00 00       	mov    $0x1883,%eax
    102b:	8b 54 24 1c          	mov    0x1c(%esp),%edx
    102f:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
    1036:	8b 55 0c             	mov    0xc(%ebp),%edx
    1039:	01 ca                	add    %ecx,%edx
    103b:	8b 12                	mov    (%edx),%edx
    103d:	89 44 24 0c          	mov    %eax,0xc(%esp)
    1041:	89 54 24 08          	mov    %edx,0x8(%esp)
    1045:	c7 44 24 04 85 18 00 	movl   $0x1885,0x4(%esp)
    104c:	00 
    104d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1054:	e8 0b 04 00 00       	call   1464 <printf>
  for(i = 1; i < argc; i++)
    1059:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
    105e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1062:	3b 45 08             	cmp    0x8(%ebp),%eax
    1065:	7c ac                	jl     1013 <main+0x13>
  exit();
    1067:	e8 68 02 00 00       	call   12d4 <exit>

0000106c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    106c:	55                   	push   %ebp
    106d:	89 e5                	mov    %esp,%ebp
    106f:	57                   	push   %edi
    1070:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1071:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1074:	8b 55 10             	mov    0x10(%ebp),%edx
    1077:	8b 45 0c             	mov    0xc(%ebp),%eax
    107a:	89 cb                	mov    %ecx,%ebx
    107c:	89 df                	mov    %ebx,%edi
    107e:	89 d1                	mov    %edx,%ecx
    1080:	fc                   	cld    
    1081:	f3 aa                	rep stos %al,%es:(%edi)
    1083:	89 ca                	mov    %ecx,%edx
    1085:	89 fb                	mov    %edi,%ebx
    1087:	89 5d 08             	mov    %ebx,0x8(%ebp)
    108a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    108d:	5b                   	pop    %ebx
    108e:	5f                   	pop    %edi
    108f:	5d                   	pop    %ebp
    1090:	c3                   	ret    

00001091 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1091:	55                   	push   %ebp
    1092:	89 e5                	mov    %esp,%ebp
    1094:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1097:	8b 45 08             	mov    0x8(%ebp),%eax
    109a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    109d:	90                   	nop
    109e:	8b 45 08             	mov    0x8(%ebp),%eax
    10a1:	8d 50 01             	lea    0x1(%eax),%edx
    10a4:	89 55 08             	mov    %edx,0x8(%ebp)
    10a7:	8b 55 0c             	mov    0xc(%ebp),%edx
    10aa:	8d 4a 01             	lea    0x1(%edx),%ecx
    10ad:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    10b0:	0f b6 12             	movzbl (%edx),%edx
    10b3:	88 10                	mov    %dl,(%eax)
    10b5:	0f b6 00             	movzbl (%eax),%eax
    10b8:	84 c0                	test   %al,%al
    10ba:	75 e2                	jne    109e <strcpy+0xd>
    ;
  return os;
    10bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10bf:	c9                   	leave  
    10c0:	c3                   	ret    

000010c1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10c1:	55                   	push   %ebp
    10c2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10c4:	eb 08                	jmp    10ce <strcmp+0xd>
    p++, q++;
    10c6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    10ca:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
    10ce:	8b 45 08             	mov    0x8(%ebp),%eax
    10d1:	0f b6 00             	movzbl (%eax),%eax
    10d4:	84 c0                	test   %al,%al
    10d6:	74 10                	je     10e8 <strcmp+0x27>
    10d8:	8b 45 08             	mov    0x8(%ebp),%eax
    10db:	0f b6 10             	movzbl (%eax),%edx
    10de:	8b 45 0c             	mov    0xc(%ebp),%eax
    10e1:	0f b6 00             	movzbl (%eax),%eax
    10e4:	38 c2                	cmp    %al,%dl
    10e6:	74 de                	je     10c6 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
    10e8:	8b 45 08             	mov    0x8(%ebp),%eax
    10eb:	0f b6 00             	movzbl (%eax),%eax
    10ee:	0f b6 d0             	movzbl %al,%edx
    10f1:	8b 45 0c             	mov    0xc(%ebp),%eax
    10f4:	0f b6 00             	movzbl (%eax),%eax
    10f7:	0f b6 c0             	movzbl %al,%eax
    10fa:	29 c2                	sub    %eax,%edx
    10fc:	89 d0                	mov    %edx,%eax
}
    10fe:	5d                   	pop    %ebp
    10ff:	c3                   	ret    

00001100 <strlen>:

uint
strlen(char *s)
{
    1100:	55                   	push   %ebp
    1101:	89 e5                	mov    %esp,%ebp
    1103:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1106:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    110d:	eb 04                	jmp    1113 <strlen+0x13>
    110f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1113:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1116:	8b 45 08             	mov    0x8(%ebp),%eax
    1119:	01 d0                	add    %edx,%eax
    111b:	0f b6 00             	movzbl (%eax),%eax
    111e:	84 c0                	test   %al,%al
    1120:	75 ed                	jne    110f <strlen+0xf>
    ;
  return n;
    1122:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1125:	c9                   	leave  
    1126:	c3                   	ret    

00001127 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1127:	55                   	push   %ebp
    1128:	89 e5                	mov    %esp,%ebp
    112a:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    112d:	8b 45 10             	mov    0x10(%ebp),%eax
    1130:	89 44 24 08          	mov    %eax,0x8(%esp)
    1134:	8b 45 0c             	mov    0xc(%ebp),%eax
    1137:	89 44 24 04          	mov    %eax,0x4(%esp)
    113b:	8b 45 08             	mov    0x8(%ebp),%eax
    113e:	89 04 24             	mov    %eax,(%esp)
    1141:	e8 26 ff ff ff       	call   106c <stosb>
  return dst;
    1146:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1149:	c9                   	leave  
    114a:	c3                   	ret    

0000114b <strchr>:

char*
strchr(const char *s, char c)
{
    114b:	55                   	push   %ebp
    114c:	89 e5                	mov    %esp,%ebp
    114e:	83 ec 04             	sub    $0x4,%esp
    1151:	8b 45 0c             	mov    0xc(%ebp),%eax
    1154:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1157:	eb 14                	jmp    116d <strchr+0x22>
    if(*s == c)
    1159:	8b 45 08             	mov    0x8(%ebp),%eax
    115c:	0f b6 00             	movzbl (%eax),%eax
    115f:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1162:	75 05                	jne    1169 <strchr+0x1e>
      return (char*)s;
    1164:	8b 45 08             	mov    0x8(%ebp),%eax
    1167:	eb 13                	jmp    117c <strchr+0x31>
  for(; *s; s++)
    1169:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    116d:	8b 45 08             	mov    0x8(%ebp),%eax
    1170:	0f b6 00             	movzbl (%eax),%eax
    1173:	84 c0                	test   %al,%al
    1175:	75 e2                	jne    1159 <strchr+0xe>
  return 0;
    1177:	b8 00 00 00 00       	mov    $0x0,%eax
}
    117c:	c9                   	leave  
    117d:	c3                   	ret    

0000117e <gets>:

char*
gets(char *buf, int max)
{
    117e:	55                   	push   %ebp
    117f:	89 e5                	mov    %esp,%ebp
    1181:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1184:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    118b:	eb 4c                	jmp    11d9 <gets+0x5b>
    cc = read(0, &c, 1);
    118d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1194:	00 
    1195:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1198:	89 44 24 04          	mov    %eax,0x4(%esp)
    119c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    11a3:	e8 44 01 00 00       	call   12ec <read>
    11a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    11ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11af:	7f 02                	jg     11b3 <gets+0x35>
      break;
    11b1:	eb 31                	jmp    11e4 <gets+0x66>
    buf[i++] = c;
    11b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11b6:	8d 50 01             	lea    0x1(%eax),%edx
    11b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
    11bc:	89 c2                	mov    %eax,%edx
    11be:	8b 45 08             	mov    0x8(%ebp),%eax
    11c1:	01 c2                	add    %eax,%edx
    11c3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11c7:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    11c9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11cd:	3c 0a                	cmp    $0xa,%al
    11cf:	74 13                	je     11e4 <gets+0x66>
    11d1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11d5:	3c 0d                	cmp    $0xd,%al
    11d7:	74 0b                	je     11e4 <gets+0x66>
  for(i=0; i+1 < max; ){
    11d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11dc:	83 c0 01             	add    $0x1,%eax
    11df:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11e2:	7c a9                	jl     118d <gets+0xf>
      break;
  }
  buf[i] = '\0';
    11e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11e7:	8b 45 08             	mov    0x8(%ebp),%eax
    11ea:	01 d0                	add    %edx,%eax
    11ec:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11f2:	c9                   	leave  
    11f3:	c3                   	ret    

000011f4 <stat>:

int
stat(char *n, struct stat *st)
{
    11f4:	55                   	push   %ebp
    11f5:	89 e5                	mov    %esp,%ebp
    11f7:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1201:	00 
    1202:	8b 45 08             	mov    0x8(%ebp),%eax
    1205:	89 04 24             	mov    %eax,(%esp)
    1208:	e8 07 01 00 00       	call   1314 <open>
    120d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1210:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1214:	79 07                	jns    121d <stat+0x29>
    return -1;
    1216:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    121b:	eb 23                	jmp    1240 <stat+0x4c>
  r = fstat(fd, st);
    121d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1220:	89 44 24 04          	mov    %eax,0x4(%esp)
    1224:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1227:	89 04 24             	mov    %eax,(%esp)
    122a:	e8 fd 00 00 00       	call   132c <fstat>
    122f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1232:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1235:	89 04 24             	mov    %eax,(%esp)
    1238:	e8 bf 00 00 00       	call   12fc <close>
  return r;
    123d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1240:	c9                   	leave  
    1241:	c3                   	ret    

00001242 <atoi>:

int
atoi(const char *s)
{
    1242:	55                   	push   %ebp
    1243:	89 e5                	mov    %esp,%ebp
    1245:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    124f:	eb 25                	jmp    1276 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1251:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1254:	89 d0                	mov    %edx,%eax
    1256:	c1 e0 02             	shl    $0x2,%eax
    1259:	01 d0                	add    %edx,%eax
    125b:	01 c0                	add    %eax,%eax
    125d:	89 c1                	mov    %eax,%ecx
    125f:	8b 45 08             	mov    0x8(%ebp),%eax
    1262:	8d 50 01             	lea    0x1(%eax),%edx
    1265:	89 55 08             	mov    %edx,0x8(%ebp)
    1268:	0f b6 00             	movzbl (%eax),%eax
    126b:	0f be c0             	movsbl %al,%eax
    126e:	01 c8                	add    %ecx,%eax
    1270:	83 e8 30             	sub    $0x30,%eax
    1273:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1276:	8b 45 08             	mov    0x8(%ebp),%eax
    1279:	0f b6 00             	movzbl (%eax),%eax
    127c:	3c 2f                	cmp    $0x2f,%al
    127e:	7e 0a                	jle    128a <atoi+0x48>
    1280:	8b 45 08             	mov    0x8(%ebp),%eax
    1283:	0f b6 00             	movzbl (%eax),%eax
    1286:	3c 39                	cmp    $0x39,%al
    1288:	7e c7                	jle    1251 <atoi+0xf>
  return n;
    128a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    128d:	c9                   	leave  
    128e:	c3                   	ret    

0000128f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    128f:	55                   	push   %ebp
    1290:	89 e5                	mov    %esp,%ebp
    1292:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    1295:	8b 45 08             	mov    0x8(%ebp),%eax
    1298:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    129b:	8b 45 0c             	mov    0xc(%ebp),%eax
    129e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    12a1:	eb 17                	jmp    12ba <memmove+0x2b>
    *dst++ = *src++;
    12a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12a6:	8d 50 01             	lea    0x1(%eax),%edx
    12a9:	89 55 fc             	mov    %edx,-0x4(%ebp)
    12ac:	8b 55 f8             	mov    -0x8(%ebp),%edx
    12af:	8d 4a 01             	lea    0x1(%edx),%ecx
    12b2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    12b5:	0f b6 12             	movzbl (%edx),%edx
    12b8:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
    12ba:	8b 45 10             	mov    0x10(%ebp),%eax
    12bd:	8d 50 ff             	lea    -0x1(%eax),%edx
    12c0:	89 55 10             	mov    %edx,0x10(%ebp)
    12c3:	85 c0                	test   %eax,%eax
    12c5:	7f dc                	jg     12a3 <memmove+0x14>
  return vdst;
    12c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12ca:	c9                   	leave  
    12cb:	c3                   	ret    

000012cc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12cc:	b8 01 00 00 00       	mov    $0x1,%eax
    12d1:	cd 40                	int    $0x40
    12d3:	c3                   	ret    

000012d4 <exit>:
SYSCALL(exit)
    12d4:	b8 02 00 00 00       	mov    $0x2,%eax
    12d9:	cd 40                	int    $0x40
    12db:	c3                   	ret    

000012dc <wait>:
SYSCALL(wait)
    12dc:	b8 03 00 00 00       	mov    $0x3,%eax
    12e1:	cd 40                	int    $0x40
    12e3:	c3                   	ret    

000012e4 <pipe>:
SYSCALL(pipe)
    12e4:	b8 04 00 00 00       	mov    $0x4,%eax
    12e9:	cd 40                	int    $0x40
    12eb:	c3                   	ret    

000012ec <read>:
SYSCALL(read)
    12ec:	b8 05 00 00 00       	mov    $0x5,%eax
    12f1:	cd 40                	int    $0x40
    12f3:	c3                   	ret    

000012f4 <write>:
SYSCALL(write)
    12f4:	b8 10 00 00 00       	mov    $0x10,%eax
    12f9:	cd 40                	int    $0x40
    12fb:	c3                   	ret    

000012fc <close>:
SYSCALL(close)
    12fc:	b8 15 00 00 00       	mov    $0x15,%eax
    1301:	cd 40                	int    $0x40
    1303:	c3                   	ret    

00001304 <kill>:
SYSCALL(kill)
    1304:	b8 06 00 00 00       	mov    $0x6,%eax
    1309:	cd 40                	int    $0x40
    130b:	c3                   	ret    

0000130c <exec>:
SYSCALL(exec)
    130c:	b8 07 00 00 00       	mov    $0x7,%eax
    1311:	cd 40                	int    $0x40
    1313:	c3                   	ret    

00001314 <open>:
SYSCALL(open)
    1314:	b8 0f 00 00 00       	mov    $0xf,%eax
    1319:	cd 40                	int    $0x40
    131b:	c3                   	ret    

0000131c <mknod>:
SYSCALL(mknod)
    131c:	b8 11 00 00 00       	mov    $0x11,%eax
    1321:	cd 40                	int    $0x40
    1323:	c3                   	ret    

00001324 <unlink>:
SYSCALL(unlink)
    1324:	b8 12 00 00 00       	mov    $0x12,%eax
    1329:	cd 40                	int    $0x40
    132b:	c3                   	ret    

0000132c <fstat>:
SYSCALL(fstat)
    132c:	b8 08 00 00 00       	mov    $0x8,%eax
    1331:	cd 40                	int    $0x40
    1333:	c3                   	ret    

00001334 <link>:
SYSCALL(link)
    1334:	b8 13 00 00 00       	mov    $0x13,%eax
    1339:	cd 40                	int    $0x40
    133b:	c3                   	ret    

0000133c <mkdir>:
SYSCALL(mkdir)
    133c:	b8 14 00 00 00       	mov    $0x14,%eax
    1341:	cd 40                	int    $0x40
    1343:	c3                   	ret    

00001344 <chdir>:
SYSCALL(chdir)
    1344:	b8 09 00 00 00       	mov    $0x9,%eax
    1349:	cd 40                	int    $0x40
    134b:	c3                   	ret    

0000134c <dup>:
SYSCALL(dup)
    134c:	b8 0a 00 00 00       	mov    $0xa,%eax
    1351:	cd 40                	int    $0x40
    1353:	c3                   	ret    

00001354 <getpid>:
SYSCALL(getpid)
    1354:	b8 0b 00 00 00       	mov    $0xb,%eax
    1359:	cd 40                	int    $0x40
    135b:	c3                   	ret    

0000135c <sbrk>:
SYSCALL(sbrk)
    135c:	b8 0c 00 00 00       	mov    $0xc,%eax
    1361:	cd 40                	int    $0x40
    1363:	c3                   	ret    

00001364 <sleep>:
SYSCALL(sleep)
    1364:	b8 0d 00 00 00       	mov    $0xd,%eax
    1369:	cd 40                	int    $0x40
    136b:	c3                   	ret    

0000136c <uptime>:
SYSCALL(uptime)
    136c:	b8 0e 00 00 00       	mov    $0xe,%eax
    1371:	cd 40                	int    $0x40
    1373:	c3                   	ret    

00001374 <shm_open>:
SYSCALL(shm_open)
    1374:	b8 16 00 00 00       	mov    $0x16,%eax
    1379:	cd 40                	int    $0x40
    137b:	c3                   	ret    

0000137c <shm_close>:
SYSCALL(shm_close)	
    137c:	b8 17 00 00 00       	mov    $0x17,%eax
    1381:	cd 40                	int    $0x40
    1383:	c3                   	ret    

00001384 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1384:	55                   	push   %ebp
    1385:	89 e5                	mov    %esp,%ebp
    1387:	83 ec 18             	sub    $0x18,%esp
    138a:	8b 45 0c             	mov    0xc(%ebp),%eax
    138d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1390:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1397:	00 
    1398:	8d 45 f4             	lea    -0xc(%ebp),%eax
    139b:	89 44 24 04          	mov    %eax,0x4(%esp)
    139f:	8b 45 08             	mov    0x8(%ebp),%eax
    13a2:	89 04 24             	mov    %eax,(%esp)
    13a5:	e8 4a ff ff ff       	call   12f4 <write>
}
    13aa:	c9                   	leave  
    13ab:	c3                   	ret    

000013ac <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13ac:	55                   	push   %ebp
    13ad:	89 e5                	mov    %esp,%ebp
    13af:	56                   	push   %esi
    13b0:	53                   	push   %ebx
    13b1:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    13b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    13bb:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    13bf:	74 17                	je     13d8 <printint+0x2c>
    13c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    13c5:	79 11                	jns    13d8 <printint+0x2c>
    neg = 1;
    13c7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13ce:	8b 45 0c             	mov    0xc(%ebp),%eax
    13d1:	f7 d8                	neg    %eax
    13d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13d6:	eb 06                	jmp    13de <printint+0x32>
  } else {
    x = xx;
    13d8:	8b 45 0c             	mov    0xc(%ebp),%eax
    13db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    13e5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    13e8:	8d 41 01             	lea    0x1(%ecx),%eax
    13eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    13ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13f4:	ba 00 00 00 00       	mov    $0x0,%edx
    13f9:	f7 f3                	div    %ebx
    13fb:	89 d0                	mov    %edx,%eax
    13fd:	0f b6 80 38 1b 00 00 	movzbl 0x1b38(%eax),%eax
    1404:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1408:	8b 75 10             	mov    0x10(%ebp),%esi
    140b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    140e:	ba 00 00 00 00       	mov    $0x0,%edx
    1413:	f7 f6                	div    %esi
    1415:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1418:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    141c:	75 c7                	jne    13e5 <printint+0x39>
  if(neg)
    141e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1422:	74 10                	je     1434 <printint+0x88>
    buf[i++] = '-';
    1424:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1427:	8d 50 01             	lea    0x1(%eax),%edx
    142a:	89 55 f4             	mov    %edx,-0xc(%ebp)
    142d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1432:	eb 1f                	jmp    1453 <printint+0xa7>
    1434:	eb 1d                	jmp    1453 <printint+0xa7>
    putc(fd, buf[i]);
    1436:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1439:	8b 45 f4             	mov    -0xc(%ebp),%eax
    143c:	01 d0                	add    %edx,%eax
    143e:	0f b6 00             	movzbl (%eax),%eax
    1441:	0f be c0             	movsbl %al,%eax
    1444:	89 44 24 04          	mov    %eax,0x4(%esp)
    1448:	8b 45 08             	mov    0x8(%ebp),%eax
    144b:	89 04 24             	mov    %eax,(%esp)
    144e:	e8 31 ff ff ff       	call   1384 <putc>
  while(--i >= 0)
    1453:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1457:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    145b:	79 d9                	jns    1436 <printint+0x8a>
}
    145d:	83 c4 30             	add    $0x30,%esp
    1460:	5b                   	pop    %ebx
    1461:	5e                   	pop    %esi
    1462:	5d                   	pop    %ebp
    1463:	c3                   	ret    

00001464 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1464:	55                   	push   %ebp
    1465:	89 e5                	mov    %esp,%ebp
    1467:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    146a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1471:	8d 45 0c             	lea    0xc(%ebp),%eax
    1474:	83 c0 04             	add    $0x4,%eax
    1477:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    147a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1481:	e9 7c 01 00 00       	jmp    1602 <printf+0x19e>
    c = fmt[i] & 0xff;
    1486:	8b 55 0c             	mov    0xc(%ebp),%edx
    1489:	8b 45 f0             	mov    -0x10(%ebp),%eax
    148c:	01 d0                	add    %edx,%eax
    148e:	0f b6 00             	movzbl (%eax),%eax
    1491:	0f be c0             	movsbl %al,%eax
    1494:	25 ff 00 00 00       	and    $0xff,%eax
    1499:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    149c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14a0:	75 2c                	jne    14ce <printf+0x6a>
      if(c == '%'){
    14a2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    14a6:	75 0c                	jne    14b4 <printf+0x50>
        state = '%';
    14a8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    14af:	e9 4a 01 00 00       	jmp    15fe <printf+0x19a>
      } else {
        putc(fd, c);
    14b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    14b7:	0f be c0             	movsbl %al,%eax
    14ba:	89 44 24 04          	mov    %eax,0x4(%esp)
    14be:	8b 45 08             	mov    0x8(%ebp),%eax
    14c1:	89 04 24             	mov    %eax,(%esp)
    14c4:	e8 bb fe ff ff       	call   1384 <putc>
    14c9:	e9 30 01 00 00       	jmp    15fe <printf+0x19a>
      }
    } else if(state == '%'){
    14ce:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14d2:	0f 85 26 01 00 00    	jne    15fe <printf+0x19a>
      if(c == 'd'){
    14d8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14dc:	75 2d                	jne    150b <printf+0xa7>
        printint(fd, *ap, 10, 1);
    14de:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14e1:	8b 00                	mov    (%eax),%eax
    14e3:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    14ea:	00 
    14eb:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    14f2:	00 
    14f3:	89 44 24 04          	mov    %eax,0x4(%esp)
    14f7:	8b 45 08             	mov    0x8(%ebp),%eax
    14fa:	89 04 24             	mov    %eax,(%esp)
    14fd:	e8 aa fe ff ff       	call   13ac <printint>
        ap++;
    1502:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1506:	e9 ec 00 00 00       	jmp    15f7 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    150b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    150f:	74 06                	je     1517 <printf+0xb3>
    1511:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1515:	75 2d                	jne    1544 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1517:	8b 45 e8             	mov    -0x18(%ebp),%eax
    151a:	8b 00                	mov    (%eax),%eax
    151c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1523:	00 
    1524:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    152b:	00 
    152c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1530:	8b 45 08             	mov    0x8(%ebp),%eax
    1533:	89 04 24             	mov    %eax,(%esp)
    1536:	e8 71 fe ff ff       	call   13ac <printint>
        ap++;
    153b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    153f:	e9 b3 00 00 00       	jmp    15f7 <printf+0x193>
      } else if(c == 's'){
    1544:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1548:	75 45                	jne    158f <printf+0x12b>
        s = (char*)*ap;
    154a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    154d:	8b 00                	mov    (%eax),%eax
    154f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1552:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1556:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    155a:	75 09                	jne    1565 <printf+0x101>
          s = "(null)";
    155c:	c7 45 f4 8a 18 00 00 	movl   $0x188a,-0xc(%ebp)
        while(*s != 0){
    1563:	eb 1e                	jmp    1583 <printf+0x11f>
    1565:	eb 1c                	jmp    1583 <printf+0x11f>
          putc(fd, *s);
    1567:	8b 45 f4             	mov    -0xc(%ebp),%eax
    156a:	0f b6 00             	movzbl (%eax),%eax
    156d:	0f be c0             	movsbl %al,%eax
    1570:	89 44 24 04          	mov    %eax,0x4(%esp)
    1574:	8b 45 08             	mov    0x8(%ebp),%eax
    1577:	89 04 24             	mov    %eax,(%esp)
    157a:	e8 05 fe ff ff       	call   1384 <putc>
          s++;
    157f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
    1583:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1586:	0f b6 00             	movzbl (%eax),%eax
    1589:	84 c0                	test   %al,%al
    158b:	75 da                	jne    1567 <printf+0x103>
    158d:	eb 68                	jmp    15f7 <printf+0x193>
        }
      } else if(c == 'c'){
    158f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1593:	75 1d                	jne    15b2 <printf+0x14e>
        putc(fd, *ap);
    1595:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1598:	8b 00                	mov    (%eax),%eax
    159a:	0f be c0             	movsbl %al,%eax
    159d:	89 44 24 04          	mov    %eax,0x4(%esp)
    15a1:	8b 45 08             	mov    0x8(%ebp),%eax
    15a4:	89 04 24             	mov    %eax,(%esp)
    15a7:	e8 d8 fd ff ff       	call   1384 <putc>
        ap++;
    15ac:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15b0:	eb 45                	jmp    15f7 <printf+0x193>
      } else if(c == '%'){
    15b2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15b6:	75 17                	jne    15cf <printf+0x16b>
        putc(fd, c);
    15b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15bb:	0f be c0             	movsbl %al,%eax
    15be:	89 44 24 04          	mov    %eax,0x4(%esp)
    15c2:	8b 45 08             	mov    0x8(%ebp),%eax
    15c5:	89 04 24             	mov    %eax,(%esp)
    15c8:	e8 b7 fd ff ff       	call   1384 <putc>
    15cd:	eb 28                	jmp    15f7 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15cf:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    15d6:	00 
    15d7:	8b 45 08             	mov    0x8(%ebp),%eax
    15da:	89 04 24             	mov    %eax,(%esp)
    15dd:	e8 a2 fd ff ff       	call   1384 <putc>
        putc(fd, c);
    15e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15e5:	0f be c0             	movsbl %al,%eax
    15e8:	89 44 24 04          	mov    %eax,0x4(%esp)
    15ec:	8b 45 08             	mov    0x8(%ebp),%eax
    15ef:	89 04 24             	mov    %eax,(%esp)
    15f2:	e8 8d fd ff ff       	call   1384 <putc>
      }
      state = 0;
    15f7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    15fe:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1602:	8b 55 0c             	mov    0xc(%ebp),%edx
    1605:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1608:	01 d0                	add    %edx,%eax
    160a:	0f b6 00             	movzbl (%eax),%eax
    160d:	84 c0                	test   %al,%al
    160f:	0f 85 71 fe ff ff    	jne    1486 <printf+0x22>
    }
  }
}
    1615:	c9                   	leave  
    1616:	c3                   	ret    

00001617 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1617:	55                   	push   %ebp
    1618:	89 e5                	mov    %esp,%ebp
    161a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    161d:	8b 45 08             	mov    0x8(%ebp),%eax
    1620:	83 e8 08             	sub    $0x8,%eax
    1623:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1626:	a1 54 1b 00 00       	mov    0x1b54,%eax
    162b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    162e:	eb 24                	jmp    1654 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1630:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1633:	8b 00                	mov    (%eax),%eax
    1635:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1638:	77 12                	ja     164c <free+0x35>
    163a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    163d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1640:	77 24                	ja     1666 <free+0x4f>
    1642:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1645:	8b 00                	mov    (%eax),%eax
    1647:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    164a:	77 1a                	ja     1666 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    164c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    164f:	8b 00                	mov    (%eax),%eax
    1651:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1654:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1657:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    165a:	76 d4                	jbe    1630 <free+0x19>
    165c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    165f:	8b 00                	mov    (%eax),%eax
    1661:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1664:	76 ca                	jbe    1630 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1666:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1669:	8b 40 04             	mov    0x4(%eax),%eax
    166c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1673:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1676:	01 c2                	add    %eax,%edx
    1678:	8b 45 fc             	mov    -0x4(%ebp),%eax
    167b:	8b 00                	mov    (%eax),%eax
    167d:	39 c2                	cmp    %eax,%edx
    167f:	75 24                	jne    16a5 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1681:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1684:	8b 50 04             	mov    0x4(%eax),%edx
    1687:	8b 45 fc             	mov    -0x4(%ebp),%eax
    168a:	8b 00                	mov    (%eax),%eax
    168c:	8b 40 04             	mov    0x4(%eax),%eax
    168f:	01 c2                	add    %eax,%edx
    1691:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1694:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1697:	8b 45 fc             	mov    -0x4(%ebp),%eax
    169a:	8b 00                	mov    (%eax),%eax
    169c:	8b 10                	mov    (%eax),%edx
    169e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16a1:	89 10                	mov    %edx,(%eax)
    16a3:	eb 0a                	jmp    16af <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    16a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a8:	8b 10                	mov    (%eax),%edx
    16aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16ad:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    16af:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b2:	8b 40 04             	mov    0x4(%eax),%eax
    16b5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16bf:	01 d0                	add    %edx,%eax
    16c1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16c4:	75 20                	jne    16e6 <free+0xcf>
    p->s.size += bp->s.size;
    16c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c9:	8b 50 04             	mov    0x4(%eax),%edx
    16cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16cf:	8b 40 04             	mov    0x4(%eax),%eax
    16d2:	01 c2                	add    %eax,%edx
    16d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16da:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16dd:	8b 10                	mov    (%eax),%edx
    16df:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e2:	89 10                	mov    %edx,(%eax)
    16e4:	eb 08                	jmp    16ee <free+0xd7>
  } else
    p->s.ptr = bp;
    16e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e9:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16ec:	89 10                	mov    %edx,(%eax)
  freep = p;
    16ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16f1:	a3 54 1b 00 00       	mov    %eax,0x1b54
}
    16f6:	c9                   	leave  
    16f7:	c3                   	ret    

000016f8 <morecore>:

static Header*
morecore(uint nu)
{
    16f8:	55                   	push   %ebp
    16f9:	89 e5                	mov    %esp,%ebp
    16fb:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    16fe:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1705:	77 07                	ja     170e <morecore+0x16>
    nu = 4096;
    1707:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    170e:	8b 45 08             	mov    0x8(%ebp),%eax
    1711:	c1 e0 03             	shl    $0x3,%eax
    1714:	89 04 24             	mov    %eax,(%esp)
    1717:	e8 40 fc ff ff       	call   135c <sbrk>
    171c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    171f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1723:	75 07                	jne    172c <morecore+0x34>
    return 0;
    1725:	b8 00 00 00 00       	mov    $0x0,%eax
    172a:	eb 22                	jmp    174e <morecore+0x56>
  hp = (Header*)p;
    172c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    172f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1732:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1735:	8b 55 08             	mov    0x8(%ebp),%edx
    1738:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    173b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    173e:	83 c0 08             	add    $0x8,%eax
    1741:	89 04 24             	mov    %eax,(%esp)
    1744:	e8 ce fe ff ff       	call   1617 <free>
  return freep;
    1749:	a1 54 1b 00 00       	mov    0x1b54,%eax
}
    174e:	c9                   	leave  
    174f:	c3                   	ret    

00001750 <malloc>:

void*
malloc(uint nbytes)
{
    1750:	55                   	push   %ebp
    1751:	89 e5                	mov    %esp,%ebp
    1753:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1756:	8b 45 08             	mov    0x8(%ebp),%eax
    1759:	83 c0 07             	add    $0x7,%eax
    175c:	c1 e8 03             	shr    $0x3,%eax
    175f:	83 c0 01             	add    $0x1,%eax
    1762:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1765:	a1 54 1b 00 00       	mov    0x1b54,%eax
    176a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    176d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1771:	75 23                	jne    1796 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1773:	c7 45 f0 4c 1b 00 00 	movl   $0x1b4c,-0x10(%ebp)
    177a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    177d:	a3 54 1b 00 00       	mov    %eax,0x1b54
    1782:	a1 54 1b 00 00       	mov    0x1b54,%eax
    1787:	a3 4c 1b 00 00       	mov    %eax,0x1b4c
    base.s.size = 0;
    178c:	c7 05 50 1b 00 00 00 	movl   $0x0,0x1b50
    1793:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1796:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1799:	8b 00                	mov    (%eax),%eax
    179b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    179e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17a1:	8b 40 04             	mov    0x4(%eax),%eax
    17a4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17a7:	72 4d                	jb     17f6 <malloc+0xa6>
      if(p->s.size == nunits)
    17a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ac:	8b 40 04             	mov    0x4(%eax),%eax
    17af:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17b2:	75 0c                	jne    17c0 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    17b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17b7:	8b 10                	mov    (%eax),%edx
    17b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17bc:	89 10                	mov    %edx,(%eax)
    17be:	eb 26                	jmp    17e6 <malloc+0x96>
      else {
        p->s.size -= nunits;
    17c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c3:	8b 40 04             	mov    0x4(%eax),%eax
    17c6:	2b 45 ec             	sub    -0x14(%ebp),%eax
    17c9:	89 c2                	mov    %eax,%edx
    17cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ce:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    17d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d4:	8b 40 04             	mov    0x4(%eax),%eax
    17d7:	c1 e0 03             	shl    $0x3,%eax
    17da:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17e3:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    17e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17e9:	a3 54 1b 00 00       	mov    %eax,0x1b54
      return (void*)(p + 1);
    17ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17f1:	83 c0 08             	add    $0x8,%eax
    17f4:	eb 38                	jmp    182e <malloc+0xde>
    }
    if(p == freep)
    17f6:	a1 54 1b 00 00       	mov    0x1b54,%eax
    17fb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    17fe:	75 1b                	jne    181b <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1800:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1803:	89 04 24             	mov    %eax,(%esp)
    1806:	e8 ed fe ff ff       	call   16f8 <morecore>
    180b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    180e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1812:	75 07                	jne    181b <malloc+0xcb>
        return 0;
    1814:	b8 00 00 00 00       	mov    $0x0,%eax
    1819:	eb 13                	jmp    182e <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    181b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    181e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1821:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1824:	8b 00                	mov    (%eax),%eax
    1826:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
    1829:	e9 70 ff ff ff       	jmp    179e <malloc+0x4e>
}
    182e:	c9                   	leave  
    182f:	c3                   	ret    

00001830 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    1830:	55                   	push   %ebp
    1831:	89 e5                	mov    %esp,%ebp
    1833:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1836:	8b 55 08             	mov    0x8(%ebp),%edx
    1839:	8b 45 0c             	mov    0xc(%ebp),%eax
    183c:	8b 4d 08             	mov    0x8(%ebp),%ecx
    183f:	f0 87 02             	lock xchg %eax,(%edx)
    1842:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1845:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1848:	c9                   	leave  
    1849:	c3                   	ret    

0000184a <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    184a:	55                   	push   %ebp
    184b:	89 e5                	mov    %esp,%ebp
    184d:	83 ec 08             	sub    $0x8,%esp
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    1850:	90                   	nop
    1851:	8b 45 08             	mov    0x8(%ebp),%eax
    1854:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    185b:	00 
    185c:	89 04 24             	mov    %eax,(%esp)
    185f:	e8 cc ff ff ff       	call   1830 <xchg>
    1864:	85 c0                	test   %eax,%eax
    1866:	75 e9                	jne    1851 <uacquire+0x7>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    1868:	0f ae f0             	mfence 
}
    186b:	c9                   	leave  
    186c:	c3                   	ret    

0000186d <urelease>:

void urelease (struct uspinlock *lk) {
    186d:	55                   	push   %ebp
    186e:	89 e5                	mov    %esp,%ebp
  __sync_synchronize();
    1870:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    1873:	8b 45 08             	mov    0x8(%ebp),%eax
    1876:	8b 55 08             	mov    0x8(%ebp),%edx
    1879:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    187f:	5d                   	pop    %ebp
    1880:	c3                   	ret    
