
_rm:     file format elf32-i386


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

  if(argc < 2){
    1009:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
    100d:	7f 19                	jg     1028 <main+0x28>
    printf(2, "Usage: rm files...\n");
    100f:	c7 44 24 04 a4 18 00 	movl   $0x18a4,0x4(%esp)
    1016:	00 
    1017:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    101e:	e8 64 04 00 00       	call   1487 <printf>
    exit();
    1023:	e8 cf 02 00 00       	call   12f7 <exit>
  }

  for(i = 1; i < argc; i++){
    1028:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    102f:	00 
    1030:	eb 4f                	jmp    1081 <main+0x81>
    if(unlink(argv[i]) < 0){
    1032:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1036:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    103d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1040:	01 d0                	add    %edx,%eax
    1042:	8b 00                	mov    (%eax),%eax
    1044:	89 04 24             	mov    %eax,(%esp)
    1047:	e8 fb 02 00 00       	call   1347 <unlink>
    104c:	85 c0                	test   %eax,%eax
    104e:	79 2c                	jns    107c <main+0x7c>
      printf(2, "rm: %s failed to delete\n", argv[i]);
    1050:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1054:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    105b:	8b 45 0c             	mov    0xc(%ebp),%eax
    105e:	01 d0                	add    %edx,%eax
    1060:	8b 00                	mov    (%eax),%eax
    1062:	89 44 24 08          	mov    %eax,0x8(%esp)
    1066:	c7 44 24 04 b8 18 00 	movl   $0x18b8,0x4(%esp)
    106d:	00 
    106e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1075:	e8 0d 04 00 00       	call   1487 <printf>
      break;
    107a:	eb 0e                	jmp    108a <main+0x8a>
  for(i = 1; i < argc; i++){
    107c:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
    1081:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1085:	3b 45 08             	cmp    0x8(%ebp),%eax
    1088:	7c a8                	jl     1032 <main+0x32>
    }
  }

  exit();
    108a:	e8 68 02 00 00       	call   12f7 <exit>

0000108f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    108f:	55                   	push   %ebp
    1090:	89 e5                	mov    %esp,%ebp
    1092:	57                   	push   %edi
    1093:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1094:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1097:	8b 55 10             	mov    0x10(%ebp),%edx
    109a:	8b 45 0c             	mov    0xc(%ebp),%eax
    109d:	89 cb                	mov    %ecx,%ebx
    109f:	89 df                	mov    %ebx,%edi
    10a1:	89 d1                	mov    %edx,%ecx
    10a3:	fc                   	cld    
    10a4:	f3 aa                	rep stos %al,%es:(%edi)
    10a6:	89 ca                	mov    %ecx,%edx
    10a8:	89 fb                	mov    %edi,%ebx
    10aa:	89 5d 08             	mov    %ebx,0x8(%ebp)
    10ad:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10b0:	5b                   	pop    %ebx
    10b1:	5f                   	pop    %edi
    10b2:	5d                   	pop    %ebp
    10b3:	c3                   	ret    

000010b4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10b4:	55                   	push   %ebp
    10b5:	89 e5                	mov    %esp,%ebp
    10b7:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    10ba:	8b 45 08             	mov    0x8(%ebp),%eax
    10bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    10c0:	90                   	nop
    10c1:	8b 45 08             	mov    0x8(%ebp),%eax
    10c4:	8d 50 01             	lea    0x1(%eax),%edx
    10c7:	89 55 08             	mov    %edx,0x8(%ebp)
    10ca:	8b 55 0c             	mov    0xc(%ebp),%edx
    10cd:	8d 4a 01             	lea    0x1(%edx),%ecx
    10d0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    10d3:	0f b6 12             	movzbl (%edx),%edx
    10d6:	88 10                	mov    %dl,(%eax)
    10d8:	0f b6 00             	movzbl (%eax),%eax
    10db:	84 c0                	test   %al,%al
    10dd:	75 e2                	jne    10c1 <strcpy+0xd>
    ;
  return os;
    10df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10e2:	c9                   	leave  
    10e3:	c3                   	ret    

000010e4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10e4:	55                   	push   %ebp
    10e5:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10e7:	eb 08                	jmp    10f1 <strcmp+0xd>
    p++, q++;
    10e9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    10ed:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
    10f1:	8b 45 08             	mov    0x8(%ebp),%eax
    10f4:	0f b6 00             	movzbl (%eax),%eax
    10f7:	84 c0                	test   %al,%al
    10f9:	74 10                	je     110b <strcmp+0x27>
    10fb:	8b 45 08             	mov    0x8(%ebp),%eax
    10fe:	0f b6 10             	movzbl (%eax),%edx
    1101:	8b 45 0c             	mov    0xc(%ebp),%eax
    1104:	0f b6 00             	movzbl (%eax),%eax
    1107:	38 c2                	cmp    %al,%dl
    1109:	74 de                	je     10e9 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
    110b:	8b 45 08             	mov    0x8(%ebp),%eax
    110e:	0f b6 00             	movzbl (%eax),%eax
    1111:	0f b6 d0             	movzbl %al,%edx
    1114:	8b 45 0c             	mov    0xc(%ebp),%eax
    1117:	0f b6 00             	movzbl (%eax),%eax
    111a:	0f b6 c0             	movzbl %al,%eax
    111d:	29 c2                	sub    %eax,%edx
    111f:	89 d0                	mov    %edx,%eax
}
    1121:	5d                   	pop    %ebp
    1122:	c3                   	ret    

00001123 <strlen>:

uint
strlen(char *s)
{
    1123:	55                   	push   %ebp
    1124:	89 e5                	mov    %esp,%ebp
    1126:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1129:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1130:	eb 04                	jmp    1136 <strlen+0x13>
    1132:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1136:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1139:	8b 45 08             	mov    0x8(%ebp),%eax
    113c:	01 d0                	add    %edx,%eax
    113e:	0f b6 00             	movzbl (%eax),%eax
    1141:	84 c0                	test   %al,%al
    1143:	75 ed                	jne    1132 <strlen+0xf>
    ;
  return n;
    1145:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1148:	c9                   	leave  
    1149:	c3                   	ret    

0000114a <memset>:

void*
memset(void *dst, int c, uint n)
{
    114a:	55                   	push   %ebp
    114b:	89 e5                	mov    %esp,%ebp
    114d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1150:	8b 45 10             	mov    0x10(%ebp),%eax
    1153:	89 44 24 08          	mov    %eax,0x8(%esp)
    1157:	8b 45 0c             	mov    0xc(%ebp),%eax
    115a:	89 44 24 04          	mov    %eax,0x4(%esp)
    115e:	8b 45 08             	mov    0x8(%ebp),%eax
    1161:	89 04 24             	mov    %eax,(%esp)
    1164:	e8 26 ff ff ff       	call   108f <stosb>
  return dst;
    1169:	8b 45 08             	mov    0x8(%ebp),%eax
}
    116c:	c9                   	leave  
    116d:	c3                   	ret    

0000116e <strchr>:

char*
strchr(const char *s, char c)
{
    116e:	55                   	push   %ebp
    116f:	89 e5                	mov    %esp,%ebp
    1171:	83 ec 04             	sub    $0x4,%esp
    1174:	8b 45 0c             	mov    0xc(%ebp),%eax
    1177:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    117a:	eb 14                	jmp    1190 <strchr+0x22>
    if(*s == c)
    117c:	8b 45 08             	mov    0x8(%ebp),%eax
    117f:	0f b6 00             	movzbl (%eax),%eax
    1182:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1185:	75 05                	jne    118c <strchr+0x1e>
      return (char*)s;
    1187:	8b 45 08             	mov    0x8(%ebp),%eax
    118a:	eb 13                	jmp    119f <strchr+0x31>
  for(; *s; s++)
    118c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1190:	8b 45 08             	mov    0x8(%ebp),%eax
    1193:	0f b6 00             	movzbl (%eax),%eax
    1196:	84 c0                	test   %al,%al
    1198:	75 e2                	jne    117c <strchr+0xe>
  return 0;
    119a:	b8 00 00 00 00       	mov    $0x0,%eax
}
    119f:	c9                   	leave  
    11a0:	c3                   	ret    

000011a1 <gets>:

char*
gets(char *buf, int max)
{
    11a1:	55                   	push   %ebp
    11a2:	89 e5                	mov    %esp,%ebp
    11a4:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11ae:	eb 4c                	jmp    11fc <gets+0x5b>
    cc = read(0, &c, 1);
    11b0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    11b7:	00 
    11b8:	8d 45 ef             	lea    -0x11(%ebp),%eax
    11bb:	89 44 24 04          	mov    %eax,0x4(%esp)
    11bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    11c6:	e8 44 01 00 00       	call   130f <read>
    11cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    11ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11d2:	7f 02                	jg     11d6 <gets+0x35>
      break;
    11d4:	eb 31                	jmp    1207 <gets+0x66>
    buf[i++] = c;
    11d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11d9:	8d 50 01             	lea    0x1(%eax),%edx
    11dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
    11df:	89 c2                	mov    %eax,%edx
    11e1:	8b 45 08             	mov    0x8(%ebp),%eax
    11e4:	01 c2                	add    %eax,%edx
    11e6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11ea:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    11ec:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11f0:	3c 0a                	cmp    $0xa,%al
    11f2:	74 13                	je     1207 <gets+0x66>
    11f4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11f8:	3c 0d                	cmp    $0xd,%al
    11fa:	74 0b                	je     1207 <gets+0x66>
  for(i=0; i+1 < max; ){
    11fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ff:	83 c0 01             	add    $0x1,%eax
    1202:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1205:	7c a9                	jl     11b0 <gets+0xf>
      break;
  }
  buf[i] = '\0';
    1207:	8b 55 f4             	mov    -0xc(%ebp),%edx
    120a:	8b 45 08             	mov    0x8(%ebp),%eax
    120d:	01 d0                	add    %edx,%eax
    120f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1212:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1215:	c9                   	leave  
    1216:	c3                   	ret    

00001217 <stat>:

int
stat(char *n, struct stat *st)
{
    1217:	55                   	push   %ebp
    1218:	89 e5                	mov    %esp,%ebp
    121a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    121d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1224:	00 
    1225:	8b 45 08             	mov    0x8(%ebp),%eax
    1228:	89 04 24             	mov    %eax,(%esp)
    122b:	e8 07 01 00 00       	call   1337 <open>
    1230:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1233:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1237:	79 07                	jns    1240 <stat+0x29>
    return -1;
    1239:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    123e:	eb 23                	jmp    1263 <stat+0x4c>
  r = fstat(fd, st);
    1240:	8b 45 0c             	mov    0xc(%ebp),%eax
    1243:	89 44 24 04          	mov    %eax,0x4(%esp)
    1247:	8b 45 f4             	mov    -0xc(%ebp),%eax
    124a:	89 04 24             	mov    %eax,(%esp)
    124d:	e8 fd 00 00 00       	call   134f <fstat>
    1252:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1255:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1258:	89 04 24             	mov    %eax,(%esp)
    125b:	e8 bf 00 00 00       	call   131f <close>
  return r;
    1260:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1263:	c9                   	leave  
    1264:	c3                   	ret    

00001265 <atoi>:

int
atoi(const char *s)
{
    1265:	55                   	push   %ebp
    1266:	89 e5                	mov    %esp,%ebp
    1268:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1272:	eb 25                	jmp    1299 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1274:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1277:	89 d0                	mov    %edx,%eax
    1279:	c1 e0 02             	shl    $0x2,%eax
    127c:	01 d0                	add    %edx,%eax
    127e:	01 c0                	add    %eax,%eax
    1280:	89 c1                	mov    %eax,%ecx
    1282:	8b 45 08             	mov    0x8(%ebp),%eax
    1285:	8d 50 01             	lea    0x1(%eax),%edx
    1288:	89 55 08             	mov    %edx,0x8(%ebp)
    128b:	0f b6 00             	movzbl (%eax),%eax
    128e:	0f be c0             	movsbl %al,%eax
    1291:	01 c8                	add    %ecx,%eax
    1293:	83 e8 30             	sub    $0x30,%eax
    1296:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1299:	8b 45 08             	mov    0x8(%ebp),%eax
    129c:	0f b6 00             	movzbl (%eax),%eax
    129f:	3c 2f                	cmp    $0x2f,%al
    12a1:	7e 0a                	jle    12ad <atoi+0x48>
    12a3:	8b 45 08             	mov    0x8(%ebp),%eax
    12a6:	0f b6 00             	movzbl (%eax),%eax
    12a9:	3c 39                	cmp    $0x39,%al
    12ab:	7e c7                	jle    1274 <atoi+0xf>
  return n;
    12ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    12b0:	c9                   	leave  
    12b1:	c3                   	ret    

000012b2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    12b2:	55                   	push   %ebp
    12b3:	89 e5                	mov    %esp,%ebp
    12b5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    12b8:	8b 45 08             	mov    0x8(%ebp),%eax
    12bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    12be:	8b 45 0c             	mov    0xc(%ebp),%eax
    12c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    12c4:	eb 17                	jmp    12dd <memmove+0x2b>
    *dst++ = *src++;
    12c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12c9:	8d 50 01             	lea    0x1(%eax),%edx
    12cc:	89 55 fc             	mov    %edx,-0x4(%ebp)
    12cf:	8b 55 f8             	mov    -0x8(%ebp),%edx
    12d2:	8d 4a 01             	lea    0x1(%edx),%ecx
    12d5:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    12d8:	0f b6 12             	movzbl (%edx),%edx
    12db:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
    12dd:	8b 45 10             	mov    0x10(%ebp),%eax
    12e0:	8d 50 ff             	lea    -0x1(%eax),%edx
    12e3:	89 55 10             	mov    %edx,0x10(%ebp)
    12e6:	85 c0                	test   %eax,%eax
    12e8:	7f dc                	jg     12c6 <memmove+0x14>
  return vdst;
    12ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12ed:	c9                   	leave  
    12ee:	c3                   	ret    

000012ef <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12ef:	b8 01 00 00 00       	mov    $0x1,%eax
    12f4:	cd 40                	int    $0x40
    12f6:	c3                   	ret    

000012f7 <exit>:
SYSCALL(exit)
    12f7:	b8 02 00 00 00       	mov    $0x2,%eax
    12fc:	cd 40                	int    $0x40
    12fe:	c3                   	ret    

000012ff <wait>:
SYSCALL(wait)
    12ff:	b8 03 00 00 00       	mov    $0x3,%eax
    1304:	cd 40                	int    $0x40
    1306:	c3                   	ret    

00001307 <pipe>:
SYSCALL(pipe)
    1307:	b8 04 00 00 00       	mov    $0x4,%eax
    130c:	cd 40                	int    $0x40
    130e:	c3                   	ret    

0000130f <read>:
SYSCALL(read)
    130f:	b8 05 00 00 00       	mov    $0x5,%eax
    1314:	cd 40                	int    $0x40
    1316:	c3                   	ret    

00001317 <write>:
SYSCALL(write)
    1317:	b8 10 00 00 00       	mov    $0x10,%eax
    131c:	cd 40                	int    $0x40
    131e:	c3                   	ret    

0000131f <close>:
SYSCALL(close)
    131f:	b8 15 00 00 00       	mov    $0x15,%eax
    1324:	cd 40                	int    $0x40
    1326:	c3                   	ret    

00001327 <kill>:
SYSCALL(kill)
    1327:	b8 06 00 00 00       	mov    $0x6,%eax
    132c:	cd 40                	int    $0x40
    132e:	c3                   	ret    

0000132f <exec>:
SYSCALL(exec)
    132f:	b8 07 00 00 00       	mov    $0x7,%eax
    1334:	cd 40                	int    $0x40
    1336:	c3                   	ret    

00001337 <open>:
SYSCALL(open)
    1337:	b8 0f 00 00 00       	mov    $0xf,%eax
    133c:	cd 40                	int    $0x40
    133e:	c3                   	ret    

0000133f <mknod>:
SYSCALL(mknod)
    133f:	b8 11 00 00 00       	mov    $0x11,%eax
    1344:	cd 40                	int    $0x40
    1346:	c3                   	ret    

00001347 <unlink>:
SYSCALL(unlink)
    1347:	b8 12 00 00 00       	mov    $0x12,%eax
    134c:	cd 40                	int    $0x40
    134e:	c3                   	ret    

0000134f <fstat>:
SYSCALL(fstat)
    134f:	b8 08 00 00 00       	mov    $0x8,%eax
    1354:	cd 40                	int    $0x40
    1356:	c3                   	ret    

00001357 <link>:
SYSCALL(link)
    1357:	b8 13 00 00 00       	mov    $0x13,%eax
    135c:	cd 40                	int    $0x40
    135e:	c3                   	ret    

0000135f <mkdir>:
SYSCALL(mkdir)
    135f:	b8 14 00 00 00       	mov    $0x14,%eax
    1364:	cd 40                	int    $0x40
    1366:	c3                   	ret    

00001367 <chdir>:
SYSCALL(chdir)
    1367:	b8 09 00 00 00       	mov    $0x9,%eax
    136c:	cd 40                	int    $0x40
    136e:	c3                   	ret    

0000136f <dup>:
SYSCALL(dup)
    136f:	b8 0a 00 00 00       	mov    $0xa,%eax
    1374:	cd 40                	int    $0x40
    1376:	c3                   	ret    

00001377 <getpid>:
SYSCALL(getpid)
    1377:	b8 0b 00 00 00       	mov    $0xb,%eax
    137c:	cd 40                	int    $0x40
    137e:	c3                   	ret    

0000137f <sbrk>:
SYSCALL(sbrk)
    137f:	b8 0c 00 00 00       	mov    $0xc,%eax
    1384:	cd 40                	int    $0x40
    1386:	c3                   	ret    

00001387 <sleep>:
SYSCALL(sleep)
    1387:	b8 0d 00 00 00       	mov    $0xd,%eax
    138c:	cd 40                	int    $0x40
    138e:	c3                   	ret    

0000138f <uptime>:
SYSCALL(uptime)
    138f:	b8 0e 00 00 00       	mov    $0xe,%eax
    1394:	cd 40                	int    $0x40
    1396:	c3                   	ret    

00001397 <shm_open>:
SYSCALL(shm_open)
    1397:	b8 16 00 00 00       	mov    $0x16,%eax
    139c:	cd 40                	int    $0x40
    139e:	c3                   	ret    

0000139f <shm_close>:
SYSCALL(shm_close)	
    139f:	b8 17 00 00 00       	mov    $0x17,%eax
    13a4:	cd 40                	int    $0x40
    13a6:	c3                   	ret    

000013a7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    13a7:	55                   	push   %ebp
    13a8:	89 e5                	mov    %esp,%ebp
    13aa:	83 ec 18             	sub    $0x18,%esp
    13ad:	8b 45 0c             	mov    0xc(%ebp),%eax
    13b0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    13b3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    13ba:	00 
    13bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
    13be:	89 44 24 04          	mov    %eax,0x4(%esp)
    13c2:	8b 45 08             	mov    0x8(%ebp),%eax
    13c5:	89 04 24             	mov    %eax,(%esp)
    13c8:	e8 4a ff ff ff       	call   1317 <write>
}
    13cd:	c9                   	leave  
    13ce:	c3                   	ret    

000013cf <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13cf:	55                   	push   %ebp
    13d0:	89 e5                	mov    %esp,%ebp
    13d2:	56                   	push   %esi
    13d3:	53                   	push   %ebx
    13d4:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    13d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    13de:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    13e2:	74 17                	je     13fb <printint+0x2c>
    13e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    13e8:	79 11                	jns    13fb <printint+0x2c>
    neg = 1;
    13ea:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13f1:	8b 45 0c             	mov    0xc(%ebp),%eax
    13f4:	f7 d8                	neg    %eax
    13f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13f9:	eb 06                	jmp    1401 <printint+0x32>
  } else {
    x = xx;
    13fb:	8b 45 0c             	mov    0xc(%ebp),%eax
    13fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1401:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1408:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    140b:	8d 41 01             	lea    0x1(%ecx),%eax
    140e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1411:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1414:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1417:	ba 00 00 00 00       	mov    $0x0,%edx
    141c:	f7 f3                	div    %ebx
    141e:	89 d0                	mov    %edx,%eax
    1420:	0f b6 80 7c 1b 00 00 	movzbl 0x1b7c(%eax),%eax
    1427:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    142b:	8b 75 10             	mov    0x10(%ebp),%esi
    142e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1431:	ba 00 00 00 00       	mov    $0x0,%edx
    1436:	f7 f6                	div    %esi
    1438:	89 45 ec             	mov    %eax,-0x14(%ebp)
    143b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    143f:	75 c7                	jne    1408 <printint+0x39>
  if(neg)
    1441:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1445:	74 10                	je     1457 <printint+0x88>
    buf[i++] = '-';
    1447:	8b 45 f4             	mov    -0xc(%ebp),%eax
    144a:	8d 50 01             	lea    0x1(%eax),%edx
    144d:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1450:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1455:	eb 1f                	jmp    1476 <printint+0xa7>
    1457:	eb 1d                	jmp    1476 <printint+0xa7>
    putc(fd, buf[i]);
    1459:	8d 55 dc             	lea    -0x24(%ebp),%edx
    145c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    145f:	01 d0                	add    %edx,%eax
    1461:	0f b6 00             	movzbl (%eax),%eax
    1464:	0f be c0             	movsbl %al,%eax
    1467:	89 44 24 04          	mov    %eax,0x4(%esp)
    146b:	8b 45 08             	mov    0x8(%ebp),%eax
    146e:	89 04 24             	mov    %eax,(%esp)
    1471:	e8 31 ff ff ff       	call   13a7 <putc>
  while(--i >= 0)
    1476:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    147a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    147e:	79 d9                	jns    1459 <printint+0x8a>
}
    1480:	83 c4 30             	add    $0x30,%esp
    1483:	5b                   	pop    %ebx
    1484:	5e                   	pop    %esi
    1485:	5d                   	pop    %ebp
    1486:	c3                   	ret    

00001487 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1487:	55                   	push   %ebp
    1488:	89 e5                	mov    %esp,%ebp
    148a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    148d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1494:	8d 45 0c             	lea    0xc(%ebp),%eax
    1497:	83 c0 04             	add    $0x4,%eax
    149a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    149d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    14a4:	e9 7c 01 00 00       	jmp    1625 <printf+0x19e>
    c = fmt[i] & 0xff;
    14a9:	8b 55 0c             	mov    0xc(%ebp),%edx
    14ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
    14af:	01 d0                	add    %edx,%eax
    14b1:	0f b6 00             	movzbl (%eax),%eax
    14b4:	0f be c0             	movsbl %al,%eax
    14b7:	25 ff 00 00 00       	and    $0xff,%eax
    14bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    14bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14c3:	75 2c                	jne    14f1 <printf+0x6a>
      if(c == '%'){
    14c5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    14c9:	75 0c                	jne    14d7 <printf+0x50>
        state = '%';
    14cb:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    14d2:	e9 4a 01 00 00       	jmp    1621 <printf+0x19a>
      } else {
        putc(fd, c);
    14d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    14da:	0f be c0             	movsbl %al,%eax
    14dd:	89 44 24 04          	mov    %eax,0x4(%esp)
    14e1:	8b 45 08             	mov    0x8(%ebp),%eax
    14e4:	89 04 24             	mov    %eax,(%esp)
    14e7:	e8 bb fe ff ff       	call   13a7 <putc>
    14ec:	e9 30 01 00 00       	jmp    1621 <printf+0x19a>
      }
    } else if(state == '%'){
    14f1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14f5:	0f 85 26 01 00 00    	jne    1621 <printf+0x19a>
      if(c == 'd'){
    14fb:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14ff:	75 2d                	jne    152e <printf+0xa7>
        printint(fd, *ap, 10, 1);
    1501:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1504:	8b 00                	mov    (%eax),%eax
    1506:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    150d:	00 
    150e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1515:	00 
    1516:	89 44 24 04          	mov    %eax,0x4(%esp)
    151a:	8b 45 08             	mov    0x8(%ebp),%eax
    151d:	89 04 24             	mov    %eax,(%esp)
    1520:	e8 aa fe ff ff       	call   13cf <printint>
        ap++;
    1525:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1529:	e9 ec 00 00 00       	jmp    161a <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    152e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1532:	74 06                	je     153a <printf+0xb3>
    1534:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1538:	75 2d                	jne    1567 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    153a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    153d:	8b 00                	mov    (%eax),%eax
    153f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1546:	00 
    1547:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    154e:	00 
    154f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1553:	8b 45 08             	mov    0x8(%ebp),%eax
    1556:	89 04 24             	mov    %eax,(%esp)
    1559:	e8 71 fe ff ff       	call   13cf <printint>
        ap++;
    155e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1562:	e9 b3 00 00 00       	jmp    161a <printf+0x193>
      } else if(c == 's'){
    1567:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    156b:	75 45                	jne    15b2 <printf+0x12b>
        s = (char*)*ap;
    156d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1570:	8b 00                	mov    (%eax),%eax
    1572:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1575:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1579:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    157d:	75 09                	jne    1588 <printf+0x101>
          s = "(null)";
    157f:	c7 45 f4 d1 18 00 00 	movl   $0x18d1,-0xc(%ebp)
        while(*s != 0){
    1586:	eb 1e                	jmp    15a6 <printf+0x11f>
    1588:	eb 1c                	jmp    15a6 <printf+0x11f>
          putc(fd, *s);
    158a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    158d:	0f b6 00             	movzbl (%eax),%eax
    1590:	0f be c0             	movsbl %al,%eax
    1593:	89 44 24 04          	mov    %eax,0x4(%esp)
    1597:	8b 45 08             	mov    0x8(%ebp),%eax
    159a:	89 04 24             	mov    %eax,(%esp)
    159d:	e8 05 fe ff ff       	call   13a7 <putc>
          s++;
    15a2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
    15a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15a9:	0f b6 00             	movzbl (%eax),%eax
    15ac:	84 c0                	test   %al,%al
    15ae:	75 da                	jne    158a <printf+0x103>
    15b0:	eb 68                	jmp    161a <printf+0x193>
        }
      } else if(c == 'c'){
    15b2:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    15b6:	75 1d                	jne    15d5 <printf+0x14e>
        putc(fd, *ap);
    15b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15bb:	8b 00                	mov    (%eax),%eax
    15bd:	0f be c0             	movsbl %al,%eax
    15c0:	89 44 24 04          	mov    %eax,0x4(%esp)
    15c4:	8b 45 08             	mov    0x8(%ebp),%eax
    15c7:	89 04 24             	mov    %eax,(%esp)
    15ca:	e8 d8 fd ff ff       	call   13a7 <putc>
        ap++;
    15cf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15d3:	eb 45                	jmp    161a <printf+0x193>
      } else if(c == '%'){
    15d5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15d9:	75 17                	jne    15f2 <printf+0x16b>
        putc(fd, c);
    15db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15de:	0f be c0             	movsbl %al,%eax
    15e1:	89 44 24 04          	mov    %eax,0x4(%esp)
    15e5:	8b 45 08             	mov    0x8(%ebp),%eax
    15e8:	89 04 24             	mov    %eax,(%esp)
    15eb:	e8 b7 fd ff ff       	call   13a7 <putc>
    15f0:	eb 28                	jmp    161a <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15f2:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    15f9:	00 
    15fa:	8b 45 08             	mov    0x8(%ebp),%eax
    15fd:	89 04 24             	mov    %eax,(%esp)
    1600:	e8 a2 fd ff ff       	call   13a7 <putc>
        putc(fd, c);
    1605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1608:	0f be c0             	movsbl %al,%eax
    160b:	89 44 24 04          	mov    %eax,0x4(%esp)
    160f:	8b 45 08             	mov    0x8(%ebp),%eax
    1612:	89 04 24             	mov    %eax,(%esp)
    1615:	e8 8d fd ff ff       	call   13a7 <putc>
      }
      state = 0;
    161a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    1621:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1625:	8b 55 0c             	mov    0xc(%ebp),%edx
    1628:	8b 45 f0             	mov    -0x10(%ebp),%eax
    162b:	01 d0                	add    %edx,%eax
    162d:	0f b6 00             	movzbl (%eax),%eax
    1630:	84 c0                	test   %al,%al
    1632:	0f 85 71 fe ff ff    	jne    14a9 <printf+0x22>
    }
  }
}
    1638:	c9                   	leave  
    1639:	c3                   	ret    

0000163a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    163a:	55                   	push   %ebp
    163b:	89 e5                	mov    %esp,%ebp
    163d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1640:	8b 45 08             	mov    0x8(%ebp),%eax
    1643:	83 e8 08             	sub    $0x8,%eax
    1646:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1649:	a1 98 1b 00 00       	mov    0x1b98,%eax
    164e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1651:	eb 24                	jmp    1677 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1653:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1656:	8b 00                	mov    (%eax),%eax
    1658:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    165b:	77 12                	ja     166f <free+0x35>
    165d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1660:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1663:	77 24                	ja     1689 <free+0x4f>
    1665:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1668:	8b 00                	mov    (%eax),%eax
    166a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    166d:	77 1a                	ja     1689 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    166f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1672:	8b 00                	mov    (%eax),%eax
    1674:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1677:	8b 45 f8             	mov    -0x8(%ebp),%eax
    167a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    167d:	76 d4                	jbe    1653 <free+0x19>
    167f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1682:	8b 00                	mov    (%eax),%eax
    1684:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1687:	76 ca                	jbe    1653 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1689:	8b 45 f8             	mov    -0x8(%ebp),%eax
    168c:	8b 40 04             	mov    0x4(%eax),%eax
    168f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1696:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1699:	01 c2                	add    %eax,%edx
    169b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    169e:	8b 00                	mov    (%eax),%eax
    16a0:	39 c2                	cmp    %eax,%edx
    16a2:	75 24                	jne    16c8 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    16a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16a7:	8b 50 04             	mov    0x4(%eax),%edx
    16aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ad:	8b 00                	mov    (%eax),%eax
    16af:	8b 40 04             	mov    0x4(%eax),%eax
    16b2:	01 c2                	add    %eax,%edx
    16b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16b7:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    16ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16bd:	8b 00                	mov    (%eax),%eax
    16bf:	8b 10                	mov    (%eax),%edx
    16c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16c4:	89 10                	mov    %edx,(%eax)
    16c6:	eb 0a                	jmp    16d2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    16c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16cb:	8b 10                	mov    (%eax),%edx
    16cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16d0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    16d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d5:	8b 40 04             	mov    0x4(%eax),%eax
    16d8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16df:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e2:	01 d0                	add    %edx,%eax
    16e4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16e7:	75 20                	jne    1709 <free+0xcf>
    p->s.size += bp->s.size;
    16e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ec:	8b 50 04             	mov    0x4(%eax),%edx
    16ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16f2:	8b 40 04             	mov    0x4(%eax),%eax
    16f5:	01 c2                	add    %eax,%edx
    16f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16fa:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1700:	8b 10                	mov    (%eax),%edx
    1702:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1705:	89 10                	mov    %edx,(%eax)
    1707:	eb 08                	jmp    1711 <free+0xd7>
  } else
    p->s.ptr = bp;
    1709:	8b 45 fc             	mov    -0x4(%ebp),%eax
    170c:	8b 55 f8             	mov    -0x8(%ebp),%edx
    170f:	89 10                	mov    %edx,(%eax)
  freep = p;
    1711:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1714:	a3 98 1b 00 00       	mov    %eax,0x1b98
}
    1719:	c9                   	leave  
    171a:	c3                   	ret    

0000171b <morecore>:

static Header*
morecore(uint nu)
{
    171b:	55                   	push   %ebp
    171c:	89 e5                	mov    %esp,%ebp
    171e:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1721:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1728:	77 07                	ja     1731 <morecore+0x16>
    nu = 4096;
    172a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1731:	8b 45 08             	mov    0x8(%ebp),%eax
    1734:	c1 e0 03             	shl    $0x3,%eax
    1737:	89 04 24             	mov    %eax,(%esp)
    173a:	e8 40 fc ff ff       	call   137f <sbrk>
    173f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1742:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1746:	75 07                	jne    174f <morecore+0x34>
    return 0;
    1748:	b8 00 00 00 00       	mov    $0x0,%eax
    174d:	eb 22                	jmp    1771 <morecore+0x56>
  hp = (Header*)p;
    174f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1752:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1755:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1758:	8b 55 08             	mov    0x8(%ebp),%edx
    175b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    175e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1761:	83 c0 08             	add    $0x8,%eax
    1764:	89 04 24             	mov    %eax,(%esp)
    1767:	e8 ce fe ff ff       	call   163a <free>
  return freep;
    176c:	a1 98 1b 00 00       	mov    0x1b98,%eax
}
    1771:	c9                   	leave  
    1772:	c3                   	ret    

00001773 <malloc>:

void*
malloc(uint nbytes)
{
    1773:	55                   	push   %ebp
    1774:	89 e5                	mov    %esp,%ebp
    1776:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1779:	8b 45 08             	mov    0x8(%ebp),%eax
    177c:	83 c0 07             	add    $0x7,%eax
    177f:	c1 e8 03             	shr    $0x3,%eax
    1782:	83 c0 01             	add    $0x1,%eax
    1785:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1788:	a1 98 1b 00 00       	mov    0x1b98,%eax
    178d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1790:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1794:	75 23                	jne    17b9 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1796:	c7 45 f0 90 1b 00 00 	movl   $0x1b90,-0x10(%ebp)
    179d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17a0:	a3 98 1b 00 00       	mov    %eax,0x1b98
    17a5:	a1 98 1b 00 00       	mov    0x1b98,%eax
    17aa:	a3 90 1b 00 00       	mov    %eax,0x1b90
    base.s.size = 0;
    17af:	c7 05 94 1b 00 00 00 	movl   $0x0,0x1b94
    17b6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17bc:	8b 00                	mov    (%eax),%eax
    17be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    17c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c4:	8b 40 04             	mov    0x4(%eax),%eax
    17c7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17ca:	72 4d                	jb     1819 <malloc+0xa6>
      if(p->s.size == nunits)
    17cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17cf:	8b 40 04             	mov    0x4(%eax),%eax
    17d2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17d5:	75 0c                	jne    17e3 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    17d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17da:	8b 10                	mov    (%eax),%edx
    17dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17df:	89 10                	mov    %edx,(%eax)
    17e1:	eb 26                	jmp    1809 <malloc+0x96>
      else {
        p->s.size -= nunits;
    17e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17e6:	8b 40 04             	mov    0x4(%eax),%eax
    17e9:	2b 45 ec             	sub    -0x14(%ebp),%eax
    17ec:	89 c2                	mov    %eax,%edx
    17ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17f1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    17f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17f7:	8b 40 04             	mov    0x4(%eax),%eax
    17fa:	c1 e0 03             	shl    $0x3,%eax
    17fd:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1800:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1803:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1806:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1809:	8b 45 f0             	mov    -0x10(%ebp),%eax
    180c:	a3 98 1b 00 00       	mov    %eax,0x1b98
      return (void*)(p + 1);
    1811:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1814:	83 c0 08             	add    $0x8,%eax
    1817:	eb 38                	jmp    1851 <malloc+0xde>
    }
    if(p == freep)
    1819:	a1 98 1b 00 00       	mov    0x1b98,%eax
    181e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1821:	75 1b                	jne    183e <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1823:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1826:	89 04 24             	mov    %eax,(%esp)
    1829:	e8 ed fe ff ff       	call   171b <morecore>
    182e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1831:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1835:	75 07                	jne    183e <malloc+0xcb>
        return 0;
    1837:	b8 00 00 00 00       	mov    $0x0,%eax
    183c:	eb 13                	jmp    1851 <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    183e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1841:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1844:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1847:	8b 00                	mov    (%eax),%eax
    1849:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
    184c:	e9 70 ff ff ff       	jmp    17c1 <malloc+0x4e>
}
    1851:	c9                   	leave  
    1852:	c3                   	ret    

00001853 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    1853:	55                   	push   %ebp
    1854:	89 e5                	mov    %esp,%ebp
    1856:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1859:	8b 55 08             	mov    0x8(%ebp),%edx
    185c:	8b 45 0c             	mov    0xc(%ebp),%eax
    185f:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1862:	f0 87 02             	lock xchg %eax,(%edx)
    1865:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1868:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    186b:	c9                   	leave  
    186c:	c3                   	ret    

0000186d <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    186d:	55                   	push   %ebp
    186e:	89 e5                	mov    %esp,%ebp
    1870:	83 ec 08             	sub    $0x8,%esp
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    1873:	90                   	nop
    1874:	8b 45 08             	mov    0x8(%ebp),%eax
    1877:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    187e:	00 
    187f:	89 04 24             	mov    %eax,(%esp)
    1882:	e8 cc ff ff ff       	call   1853 <xchg>
    1887:	85 c0                	test   %eax,%eax
    1889:	75 e9                	jne    1874 <uacquire+0x7>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    188b:	0f ae f0             	mfence 
}
    188e:	c9                   	leave  
    188f:	c3                   	ret    

00001890 <urelease>:

void urelease (struct uspinlock *lk) {
    1890:	55                   	push   %ebp
    1891:	89 e5                	mov    %esp,%ebp
  __sync_synchronize();
    1893:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    1896:	8b 45 08             	mov    0x8(%ebp),%eax
    1899:	8b 55 08             	mov    0x8(%ebp),%edx
    189c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    18a2:	5d                   	pop    %ebp
    18a3:	c3                   	ret    
