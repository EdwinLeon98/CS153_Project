
_zombie:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
    1009:	e8 75 02 00 00       	call   1283 <fork>
    100e:	85 c0                	test   %eax,%eax
    1010:	7e 0c                	jle    101e <main+0x1e>
    sleep(5);  // Let child exit before parent.
    1012:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
    1019:	e8 fd 02 00 00       	call   131b <sleep>
  exit();
    101e:	e8 68 02 00 00       	call   128b <exit>

00001023 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1023:	55                   	push   %ebp
    1024:	89 e5                	mov    %esp,%ebp
    1026:	57                   	push   %edi
    1027:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1028:	8b 4d 08             	mov    0x8(%ebp),%ecx
    102b:	8b 55 10             	mov    0x10(%ebp),%edx
    102e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1031:	89 cb                	mov    %ecx,%ebx
    1033:	89 df                	mov    %ebx,%edi
    1035:	89 d1                	mov    %edx,%ecx
    1037:	fc                   	cld    
    1038:	f3 aa                	rep stos %al,%es:(%edi)
    103a:	89 ca                	mov    %ecx,%edx
    103c:	89 fb                	mov    %edi,%ebx
    103e:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1041:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1044:	5b                   	pop    %ebx
    1045:	5f                   	pop    %edi
    1046:	5d                   	pop    %ebp
    1047:	c3                   	ret    

00001048 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1048:	55                   	push   %ebp
    1049:	89 e5                	mov    %esp,%ebp
    104b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    104e:	8b 45 08             	mov    0x8(%ebp),%eax
    1051:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1054:	90                   	nop
    1055:	8b 45 08             	mov    0x8(%ebp),%eax
    1058:	8d 50 01             	lea    0x1(%eax),%edx
    105b:	89 55 08             	mov    %edx,0x8(%ebp)
    105e:	8b 55 0c             	mov    0xc(%ebp),%edx
    1061:	8d 4a 01             	lea    0x1(%edx),%ecx
    1064:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1067:	0f b6 12             	movzbl (%edx),%edx
    106a:	88 10                	mov    %dl,(%eax)
    106c:	0f b6 00             	movzbl (%eax),%eax
    106f:	84 c0                	test   %al,%al
    1071:	75 e2                	jne    1055 <strcpy+0xd>
    ;
  return os;
    1073:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1076:	c9                   	leave  
    1077:	c3                   	ret    

00001078 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1078:	55                   	push   %ebp
    1079:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    107b:	eb 08                	jmp    1085 <strcmp+0xd>
    p++, q++;
    107d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1081:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
    1085:	8b 45 08             	mov    0x8(%ebp),%eax
    1088:	0f b6 00             	movzbl (%eax),%eax
    108b:	84 c0                	test   %al,%al
    108d:	74 10                	je     109f <strcmp+0x27>
    108f:	8b 45 08             	mov    0x8(%ebp),%eax
    1092:	0f b6 10             	movzbl (%eax),%edx
    1095:	8b 45 0c             	mov    0xc(%ebp),%eax
    1098:	0f b6 00             	movzbl (%eax),%eax
    109b:	38 c2                	cmp    %al,%dl
    109d:	74 de                	je     107d <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
    109f:	8b 45 08             	mov    0x8(%ebp),%eax
    10a2:	0f b6 00             	movzbl (%eax),%eax
    10a5:	0f b6 d0             	movzbl %al,%edx
    10a8:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ab:	0f b6 00             	movzbl (%eax),%eax
    10ae:	0f b6 c0             	movzbl %al,%eax
    10b1:	29 c2                	sub    %eax,%edx
    10b3:	89 d0                	mov    %edx,%eax
}
    10b5:	5d                   	pop    %ebp
    10b6:	c3                   	ret    

000010b7 <strlen>:

uint
strlen(char *s)
{
    10b7:	55                   	push   %ebp
    10b8:	89 e5                	mov    %esp,%ebp
    10ba:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    10bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    10c4:	eb 04                	jmp    10ca <strlen+0x13>
    10c6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    10ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
    10cd:	8b 45 08             	mov    0x8(%ebp),%eax
    10d0:	01 d0                	add    %edx,%eax
    10d2:	0f b6 00             	movzbl (%eax),%eax
    10d5:	84 c0                	test   %al,%al
    10d7:	75 ed                	jne    10c6 <strlen+0xf>
    ;
  return n;
    10d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10dc:	c9                   	leave  
    10dd:	c3                   	ret    

000010de <memset>:

void*
memset(void *dst, int c, uint n)
{
    10de:	55                   	push   %ebp
    10df:	89 e5                	mov    %esp,%ebp
    10e1:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    10e4:	8b 45 10             	mov    0x10(%ebp),%eax
    10e7:	89 44 24 08          	mov    %eax,0x8(%esp)
    10eb:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ee:	89 44 24 04          	mov    %eax,0x4(%esp)
    10f2:	8b 45 08             	mov    0x8(%ebp),%eax
    10f5:	89 04 24             	mov    %eax,(%esp)
    10f8:	e8 26 ff ff ff       	call   1023 <stosb>
  return dst;
    10fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1100:	c9                   	leave  
    1101:	c3                   	ret    

00001102 <strchr>:

char*
strchr(const char *s, char c)
{
    1102:	55                   	push   %ebp
    1103:	89 e5                	mov    %esp,%ebp
    1105:	83 ec 04             	sub    $0x4,%esp
    1108:	8b 45 0c             	mov    0xc(%ebp),%eax
    110b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    110e:	eb 14                	jmp    1124 <strchr+0x22>
    if(*s == c)
    1110:	8b 45 08             	mov    0x8(%ebp),%eax
    1113:	0f b6 00             	movzbl (%eax),%eax
    1116:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1119:	75 05                	jne    1120 <strchr+0x1e>
      return (char*)s;
    111b:	8b 45 08             	mov    0x8(%ebp),%eax
    111e:	eb 13                	jmp    1133 <strchr+0x31>
  for(; *s; s++)
    1120:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1124:	8b 45 08             	mov    0x8(%ebp),%eax
    1127:	0f b6 00             	movzbl (%eax),%eax
    112a:	84 c0                	test   %al,%al
    112c:	75 e2                	jne    1110 <strchr+0xe>
  return 0;
    112e:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1133:	c9                   	leave  
    1134:	c3                   	ret    

00001135 <gets>:

char*
gets(char *buf, int max)
{
    1135:	55                   	push   %ebp
    1136:	89 e5                	mov    %esp,%ebp
    1138:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    113b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1142:	eb 4c                	jmp    1190 <gets+0x5b>
    cc = read(0, &c, 1);
    1144:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    114b:	00 
    114c:	8d 45 ef             	lea    -0x11(%ebp),%eax
    114f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1153:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    115a:	e8 44 01 00 00       	call   12a3 <read>
    115f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1166:	7f 02                	jg     116a <gets+0x35>
      break;
    1168:	eb 31                	jmp    119b <gets+0x66>
    buf[i++] = c;
    116a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    116d:	8d 50 01             	lea    0x1(%eax),%edx
    1170:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1173:	89 c2                	mov    %eax,%edx
    1175:	8b 45 08             	mov    0x8(%ebp),%eax
    1178:	01 c2                	add    %eax,%edx
    117a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    117e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1180:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1184:	3c 0a                	cmp    $0xa,%al
    1186:	74 13                	je     119b <gets+0x66>
    1188:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    118c:	3c 0d                	cmp    $0xd,%al
    118e:	74 0b                	je     119b <gets+0x66>
  for(i=0; i+1 < max; ){
    1190:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1193:	83 c0 01             	add    $0x1,%eax
    1196:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1199:	7c a9                	jl     1144 <gets+0xf>
      break;
  }
  buf[i] = '\0';
    119b:	8b 55 f4             	mov    -0xc(%ebp),%edx
    119e:	8b 45 08             	mov    0x8(%ebp),%eax
    11a1:	01 d0                	add    %edx,%eax
    11a3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11a9:	c9                   	leave  
    11aa:	c3                   	ret    

000011ab <stat>:

int
stat(char *n, struct stat *st)
{
    11ab:	55                   	push   %ebp
    11ac:	89 e5                	mov    %esp,%ebp
    11ae:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    11b8:	00 
    11b9:	8b 45 08             	mov    0x8(%ebp),%eax
    11bc:	89 04 24             	mov    %eax,(%esp)
    11bf:	e8 07 01 00 00       	call   12cb <open>
    11c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    11c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11cb:	79 07                	jns    11d4 <stat+0x29>
    return -1;
    11cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    11d2:	eb 23                	jmp    11f7 <stat+0x4c>
  r = fstat(fd, st);
    11d4:	8b 45 0c             	mov    0xc(%ebp),%eax
    11d7:	89 44 24 04          	mov    %eax,0x4(%esp)
    11db:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11de:	89 04 24             	mov    %eax,(%esp)
    11e1:	e8 fd 00 00 00       	call   12e3 <fstat>
    11e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    11e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ec:	89 04 24             	mov    %eax,(%esp)
    11ef:	e8 bf 00 00 00       	call   12b3 <close>
  return r;
    11f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    11f7:	c9                   	leave  
    11f8:	c3                   	ret    

000011f9 <atoi>:

int
atoi(const char *s)
{
    11f9:	55                   	push   %ebp
    11fa:	89 e5                	mov    %esp,%ebp
    11fc:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    11ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1206:	eb 25                	jmp    122d <atoi+0x34>
    n = n*10 + *s++ - '0';
    1208:	8b 55 fc             	mov    -0x4(%ebp),%edx
    120b:	89 d0                	mov    %edx,%eax
    120d:	c1 e0 02             	shl    $0x2,%eax
    1210:	01 d0                	add    %edx,%eax
    1212:	01 c0                	add    %eax,%eax
    1214:	89 c1                	mov    %eax,%ecx
    1216:	8b 45 08             	mov    0x8(%ebp),%eax
    1219:	8d 50 01             	lea    0x1(%eax),%edx
    121c:	89 55 08             	mov    %edx,0x8(%ebp)
    121f:	0f b6 00             	movzbl (%eax),%eax
    1222:	0f be c0             	movsbl %al,%eax
    1225:	01 c8                	add    %ecx,%eax
    1227:	83 e8 30             	sub    $0x30,%eax
    122a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    122d:	8b 45 08             	mov    0x8(%ebp),%eax
    1230:	0f b6 00             	movzbl (%eax),%eax
    1233:	3c 2f                	cmp    $0x2f,%al
    1235:	7e 0a                	jle    1241 <atoi+0x48>
    1237:	8b 45 08             	mov    0x8(%ebp),%eax
    123a:	0f b6 00             	movzbl (%eax),%eax
    123d:	3c 39                	cmp    $0x39,%al
    123f:	7e c7                	jle    1208 <atoi+0xf>
  return n;
    1241:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1244:	c9                   	leave  
    1245:	c3                   	ret    

00001246 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1246:	55                   	push   %ebp
    1247:	89 e5                	mov    %esp,%ebp
    1249:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    124c:	8b 45 08             	mov    0x8(%ebp),%eax
    124f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1252:	8b 45 0c             	mov    0xc(%ebp),%eax
    1255:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1258:	eb 17                	jmp    1271 <memmove+0x2b>
    *dst++ = *src++;
    125a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    125d:	8d 50 01             	lea    0x1(%eax),%edx
    1260:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1263:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1266:	8d 4a 01             	lea    0x1(%edx),%ecx
    1269:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    126c:	0f b6 12             	movzbl (%edx),%edx
    126f:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
    1271:	8b 45 10             	mov    0x10(%ebp),%eax
    1274:	8d 50 ff             	lea    -0x1(%eax),%edx
    1277:	89 55 10             	mov    %edx,0x10(%ebp)
    127a:	85 c0                	test   %eax,%eax
    127c:	7f dc                	jg     125a <memmove+0x14>
  return vdst;
    127e:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1281:	c9                   	leave  
    1282:	c3                   	ret    

00001283 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1283:	b8 01 00 00 00       	mov    $0x1,%eax
    1288:	cd 40                	int    $0x40
    128a:	c3                   	ret    

0000128b <exit>:
SYSCALL(exit)
    128b:	b8 02 00 00 00       	mov    $0x2,%eax
    1290:	cd 40                	int    $0x40
    1292:	c3                   	ret    

00001293 <wait>:
SYSCALL(wait)
    1293:	b8 03 00 00 00       	mov    $0x3,%eax
    1298:	cd 40                	int    $0x40
    129a:	c3                   	ret    

0000129b <pipe>:
SYSCALL(pipe)
    129b:	b8 04 00 00 00       	mov    $0x4,%eax
    12a0:	cd 40                	int    $0x40
    12a2:	c3                   	ret    

000012a3 <read>:
SYSCALL(read)
    12a3:	b8 05 00 00 00       	mov    $0x5,%eax
    12a8:	cd 40                	int    $0x40
    12aa:	c3                   	ret    

000012ab <write>:
SYSCALL(write)
    12ab:	b8 10 00 00 00       	mov    $0x10,%eax
    12b0:	cd 40                	int    $0x40
    12b2:	c3                   	ret    

000012b3 <close>:
SYSCALL(close)
    12b3:	b8 15 00 00 00       	mov    $0x15,%eax
    12b8:	cd 40                	int    $0x40
    12ba:	c3                   	ret    

000012bb <kill>:
SYSCALL(kill)
    12bb:	b8 06 00 00 00       	mov    $0x6,%eax
    12c0:	cd 40                	int    $0x40
    12c2:	c3                   	ret    

000012c3 <exec>:
SYSCALL(exec)
    12c3:	b8 07 00 00 00       	mov    $0x7,%eax
    12c8:	cd 40                	int    $0x40
    12ca:	c3                   	ret    

000012cb <open>:
SYSCALL(open)
    12cb:	b8 0f 00 00 00       	mov    $0xf,%eax
    12d0:	cd 40                	int    $0x40
    12d2:	c3                   	ret    

000012d3 <mknod>:
SYSCALL(mknod)
    12d3:	b8 11 00 00 00       	mov    $0x11,%eax
    12d8:	cd 40                	int    $0x40
    12da:	c3                   	ret    

000012db <unlink>:
SYSCALL(unlink)
    12db:	b8 12 00 00 00       	mov    $0x12,%eax
    12e0:	cd 40                	int    $0x40
    12e2:	c3                   	ret    

000012e3 <fstat>:
SYSCALL(fstat)
    12e3:	b8 08 00 00 00       	mov    $0x8,%eax
    12e8:	cd 40                	int    $0x40
    12ea:	c3                   	ret    

000012eb <link>:
SYSCALL(link)
    12eb:	b8 13 00 00 00       	mov    $0x13,%eax
    12f0:	cd 40                	int    $0x40
    12f2:	c3                   	ret    

000012f3 <mkdir>:
SYSCALL(mkdir)
    12f3:	b8 14 00 00 00       	mov    $0x14,%eax
    12f8:	cd 40                	int    $0x40
    12fa:	c3                   	ret    

000012fb <chdir>:
SYSCALL(chdir)
    12fb:	b8 09 00 00 00       	mov    $0x9,%eax
    1300:	cd 40                	int    $0x40
    1302:	c3                   	ret    

00001303 <dup>:
SYSCALL(dup)
    1303:	b8 0a 00 00 00       	mov    $0xa,%eax
    1308:	cd 40                	int    $0x40
    130a:	c3                   	ret    

0000130b <getpid>:
SYSCALL(getpid)
    130b:	b8 0b 00 00 00       	mov    $0xb,%eax
    1310:	cd 40                	int    $0x40
    1312:	c3                   	ret    

00001313 <sbrk>:
SYSCALL(sbrk)
    1313:	b8 0c 00 00 00       	mov    $0xc,%eax
    1318:	cd 40                	int    $0x40
    131a:	c3                   	ret    

0000131b <sleep>:
SYSCALL(sleep)
    131b:	b8 0d 00 00 00       	mov    $0xd,%eax
    1320:	cd 40                	int    $0x40
    1322:	c3                   	ret    

00001323 <uptime>:
SYSCALL(uptime)
    1323:	b8 0e 00 00 00       	mov    $0xe,%eax
    1328:	cd 40                	int    $0x40
    132a:	c3                   	ret    

0000132b <shm_open>:
SYSCALL(shm_open)
    132b:	b8 16 00 00 00       	mov    $0x16,%eax
    1330:	cd 40                	int    $0x40
    1332:	c3                   	ret    

00001333 <shm_close>:
SYSCALL(shm_close)	
    1333:	b8 17 00 00 00       	mov    $0x17,%eax
    1338:	cd 40                	int    $0x40
    133a:	c3                   	ret    

0000133b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    133b:	55                   	push   %ebp
    133c:	89 e5                	mov    %esp,%ebp
    133e:	83 ec 18             	sub    $0x18,%esp
    1341:	8b 45 0c             	mov    0xc(%ebp),%eax
    1344:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1347:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    134e:	00 
    134f:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1352:	89 44 24 04          	mov    %eax,0x4(%esp)
    1356:	8b 45 08             	mov    0x8(%ebp),%eax
    1359:	89 04 24             	mov    %eax,(%esp)
    135c:	e8 4a ff ff ff       	call   12ab <write>
}
    1361:	c9                   	leave  
    1362:	c3                   	ret    

00001363 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1363:	55                   	push   %ebp
    1364:	89 e5                	mov    %esp,%ebp
    1366:	56                   	push   %esi
    1367:	53                   	push   %ebx
    1368:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    136b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1372:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1376:	74 17                	je     138f <printint+0x2c>
    1378:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    137c:	79 11                	jns    138f <printint+0x2c>
    neg = 1;
    137e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1385:	8b 45 0c             	mov    0xc(%ebp),%eax
    1388:	f7 d8                	neg    %eax
    138a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    138d:	eb 06                	jmp    1395 <printint+0x32>
  } else {
    x = xx;
    138f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1392:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1395:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    139c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    139f:	8d 41 01             	lea    0x1(%ecx),%eax
    13a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    13a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13ab:	ba 00 00 00 00       	mov    $0x0,%edx
    13b0:	f7 f3                	div    %ebx
    13b2:	89 d0                	mov    %edx,%eax
    13b4:	0f b6 80 e4 1a 00 00 	movzbl 0x1ae4(%eax),%eax
    13bb:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    13bf:	8b 75 10             	mov    0x10(%ebp),%esi
    13c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13c5:	ba 00 00 00 00       	mov    $0x0,%edx
    13ca:	f7 f6                	div    %esi
    13cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    13d3:	75 c7                	jne    139c <printint+0x39>
  if(neg)
    13d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13d9:	74 10                	je     13eb <printint+0x88>
    buf[i++] = '-';
    13db:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13de:	8d 50 01             	lea    0x1(%eax),%edx
    13e1:	89 55 f4             	mov    %edx,-0xc(%ebp)
    13e4:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    13e9:	eb 1f                	jmp    140a <printint+0xa7>
    13eb:	eb 1d                	jmp    140a <printint+0xa7>
    putc(fd, buf[i]);
    13ed:	8d 55 dc             	lea    -0x24(%ebp),%edx
    13f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13f3:	01 d0                	add    %edx,%eax
    13f5:	0f b6 00             	movzbl (%eax),%eax
    13f8:	0f be c0             	movsbl %al,%eax
    13fb:	89 44 24 04          	mov    %eax,0x4(%esp)
    13ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1402:	89 04 24             	mov    %eax,(%esp)
    1405:	e8 31 ff ff ff       	call   133b <putc>
  while(--i >= 0)
    140a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    140e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1412:	79 d9                	jns    13ed <printint+0x8a>
}
    1414:	83 c4 30             	add    $0x30,%esp
    1417:	5b                   	pop    %ebx
    1418:	5e                   	pop    %esi
    1419:	5d                   	pop    %ebp
    141a:	c3                   	ret    

0000141b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    141b:	55                   	push   %ebp
    141c:	89 e5                	mov    %esp,%ebp
    141e:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1421:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1428:	8d 45 0c             	lea    0xc(%ebp),%eax
    142b:	83 c0 04             	add    $0x4,%eax
    142e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1431:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1438:	e9 7c 01 00 00       	jmp    15b9 <printf+0x19e>
    c = fmt[i] & 0xff;
    143d:	8b 55 0c             	mov    0xc(%ebp),%edx
    1440:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1443:	01 d0                	add    %edx,%eax
    1445:	0f b6 00             	movzbl (%eax),%eax
    1448:	0f be c0             	movsbl %al,%eax
    144b:	25 ff 00 00 00       	and    $0xff,%eax
    1450:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1453:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1457:	75 2c                	jne    1485 <printf+0x6a>
      if(c == '%'){
    1459:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    145d:	75 0c                	jne    146b <printf+0x50>
        state = '%';
    145f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1466:	e9 4a 01 00 00       	jmp    15b5 <printf+0x19a>
      } else {
        putc(fd, c);
    146b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    146e:	0f be c0             	movsbl %al,%eax
    1471:	89 44 24 04          	mov    %eax,0x4(%esp)
    1475:	8b 45 08             	mov    0x8(%ebp),%eax
    1478:	89 04 24             	mov    %eax,(%esp)
    147b:	e8 bb fe ff ff       	call   133b <putc>
    1480:	e9 30 01 00 00       	jmp    15b5 <printf+0x19a>
      }
    } else if(state == '%'){
    1485:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1489:	0f 85 26 01 00 00    	jne    15b5 <printf+0x19a>
      if(c == 'd'){
    148f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1493:	75 2d                	jne    14c2 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    1495:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1498:	8b 00                	mov    (%eax),%eax
    149a:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    14a1:	00 
    14a2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    14a9:	00 
    14aa:	89 44 24 04          	mov    %eax,0x4(%esp)
    14ae:	8b 45 08             	mov    0x8(%ebp),%eax
    14b1:	89 04 24             	mov    %eax,(%esp)
    14b4:	e8 aa fe ff ff       	call   1363 <printint>
        ap++;
    14b9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14bd:	e9 ec 00 00 00       	jmp    15ae <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    14c2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    14c6:	74 06                	je     14ce <printf+0xb3>
    14c8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    14cc:	75 2d                	jne    14fb <printf+0xe0>
        printint(fd, *ap, 16, 0);
    14ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14d1:	8b 00                	mov    (%eax),%eax
    14d3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    14da:	00 
    14db:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    14e2:	00 
    14e3:	89 44 24 04          	mov    %eax,0x4(%esp)
    14e7:	8b 45 08             	mov    0x8(%ebp),%eax
    14ea:	89 04 24             	mov    %eax,(%esp)
    14ed:	e8 71 fe ff ff       	call   1363 <printint>
        ap++;
    14f2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14f6:	e9 b3 00 00 00       	jmp    15ae <printf+0x193>
      } else if(c == 's'){
    14fb:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    14ff:	75 45                	jne    1546 <printf+0x12b>
        s = (char*)*ap;
    1501:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1504:	8b 00                	mov    (%eax),%eax
    1506:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1509:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    150d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1511:	75 09                	jne    151c <printf+0x101>
          s = "(null)";
    1513:	c7 45 f4 38 18 00 00 	movl   $0x1838,-0xc(%ebp)
        while(*s != 0){
    151a:	eb 1e                	jmp    153a <printf+0x11f>
    151c:	eb 1c                	jmp    153a <printf+0x11f>
          putc(fd, *s);
    151e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1521:	0f b6 00             	movzbl (%eax),%eax
    1524:	0f be c0             	movsbl %al,%eax
    1527:	89 44 24 04          	mov    %eax,0x4(%esp)
    152b:	8b 45 08             	mov    0x8(%ebp),%eax
    152e:	89 04 24             	mov    %eax,(%esp)
    1531:	e8 05 fe ff ff       	call   133b <putc>
          s++;
    1536:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
    153a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    153d:	0f b6 00             	movzbl (%eax),%eax
    1540:	84 c0                	test   %al,%al
    1542:	75 da                	jne    151e <printf+0x103>
    1544:	eb 68                	jmp    15ae <printf+0x193>
        }
      } else if(c == 'c'){
    1546:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    154a:	75 1d                	jne    1569 <printf+0x14e>
        putc(fd, *ap);
    154c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    154f:	8b 00                	mov    (%eax),%eax
    1551:	0f be c0             	movsbl %al,%eax
    1554:	89 44 24 04          	mov    %eax,0x4(%esp)
    1558:	8b 45 08             	mov    0x8(%ebp),%eax
    155b:	89 04 24             	mov    %eax,(%esp)
    155e:	e8 d8 fd ff ff       	call   133b <putc>
        ap++;
    1563:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1567:	eb 45                	jmp    15ae <printf+0x193>
      } else if(c == '%'){
    1569:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    156d:	75 17                	jne    1586 <printf+0x16b>
        putc(fd, c);
    156f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1572:	0f be c0             	movsbl %al,%eax
    1575:	89 44 24 04          	mov    %eax,0x4(%esp)
    1579:	8b 45 08             	mov    0x8(%ebp),%eax
    157c:	89 04 24             	mov    %eax,(%esp)
    157f:	e8 b7 fd ff ff       	call   133b <putc>
    1584:	eb 28                	jmp    15ae <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1586:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    158d:	00 
    158e:	8b 45 08             	mov    0x8(%ebp),%eax
    1591:	89 04 24             	mov    %eax,(%esp)
    1594:	e8 a2 fd ff ff       	call   133b <putc>
        putc(fd, c);
    1599:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    159c:	0f be c0             	movsbl %al,%eax
    159f:	89 44 24 04          	mov    %eax,0x4(%esp)
    15a3:	8b 45 08             	mov    0x8(%ebp),%eax
    15a6:	89 04 24             	mov    %eax,(%esp)
    15a9:	e8 8d fd ff ff       	call   133b <putc>
      }
      state = 0;
    15ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    15b5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    15b9:	8b 55 0c             	mov    0xc(%ebp),%edx
    15bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15bf:	01 d0                	add    %edx,%eax
    15c1:	0f b6 00             	movzbl (%eax),%eax
    15c4:	84 c0                	test   %al,%al
    15c6:	0f 85 71 fe ff ff    	jne    143d <printf+0x22>
    }
  }
}
    15cc:	c9                   	leave  
    15cd:	c3                   	ret    

000015ce <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    15ce:	55                   	push   %ebp
    15cf:	89 e5                	mov    %esp,%ebp
    15d1:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    15d4:	8b 45 08             	mov    0x8(%ebp),%eax
    15d7:	83 e8 08             	sub    $0x8,%eax
    15da:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15dd:	a1 00 1b 00 00       	mov    0x1b00,%eax
    15e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    15e5:	eb 24                	jmp    160b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    15e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15ea:	8b 00                	mov    (%eax),%eax
    15ec:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    15ef:	77 12                	ja     1603 <free+0x35>
    15f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15f4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    15f7:	77 24                	ja     161d <free+0x4f>
    15f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15fc:	8b 00                	mov    (%eax),%eax
    15fe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1601:	77 1a                	ja     161d <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1603:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1606:	8b 00                	mov    (%eax),%eax
    1608:	89 45 fc             	mov    %eax,-0x4(%ebp)
    160b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    160e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1611:	76 d4                	jbe    15e7 <free+0x19>
    1613:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1616:	8b 00                	mov    (%eax),%eax
    1618:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    161b:	76 ca                	jbe    15e7 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    161d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1620:	8b 40 04             	mov    0x4(%eax),%eax
    1623:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    162a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    162d:	01 c2                	add    %eax,%edx
    162f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1632:	8b 00                	mov    (%eax),%eax
    1634:	39 c2                	cmp    %eax,%edx
    1636:	75 24                	jne    165c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1638:	8b 45 f8             	mov    -0x8(%ebp),%eax
    163b:	8b 50 04             	mov    0x4(%eax),%edx
    163e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1641:	8b 00                	mov    (%eax),%eax
    1643:	8b 40 04             	mov    0x4(%eax),%eax
    1646:	01 c2                	add    %eax,%edx
    1648:	8b 45 f8             	mov    -0x8(%ebp),%eax
    164b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    164e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1651:	8b 00                	mov    (%eax),%eax
    1653:	8b 10                	mov    (%eax),%edx
    1655:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1658:	89 10                	mov    %edx,(%eax)
    165a:	eb 0a                	jmp    1666 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    165c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    165f:	8b 10                	mov    (%eax),%edx
    1661:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1664:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1666:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1669:	8b 40 04             	mov    0x4(%eax),%eax
    166c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1673:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1676:	01 d0                	add    %edx,%eax
    1678:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    167b:	75 20                	jne    169d <free+0xcf>
    p->s.size += bp->s.size;
    167d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1680:	8b 50 04             	mov    0x4(%eax),%edx
    1683:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1686:	8b 40 04             	mov    0x4(%eax),%eax
    1689:	01 c2                	add    %eax,%edx
    168b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    168e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1691:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1694:	8b 10                	mov    (%eax),%edx
    1696:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1699:	89 10                	mov    %edx,(%eax)
    169b:	eb 08                	jmp    16a5 <free+0xd7>
  } else
    p->s.ptr = bp;
    169d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a0:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16a3:	89 10                	mov    %edx,(%eax)
  freep = p;
    16a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a8:	a3 00 1b 00 00       	mov    %eax,0x1b00
}
    16ad:	c9                   	leave  
    16ae:	c3                   	ret    

000016af <morecore>:

static Header*
morecore(uint nu)
{
    16af:	55                   	push   %ebp
    16b0:	89 e5                	mov    %esp,%ebp
    16b2:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    16b5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    16bc:	77 07                	ja     16c5 <morecore+0x16>
    nu = 4096;
    16be:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    16c5:	8b 45 08             	mov    0x8(%ebp),%eax
    16c8:	c1 e0 03             	shl    $0x3,%eax
    16cb:	89 04 24             	mov    %eax,(%esp)
    16ce:	e8 40 fc ff ff       	call   1313 <sbrk>
    16d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    16d6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    16da:	75 07                	jne    16e3 <morecore+0x34>
    return 0;
    16dc:	b8 00 00 00 00       	mov    $0x0,%eax
    16e1:	eb 22                	jmp    1705 <morecore+0x56>
  hp = (Header*)p;
    16e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    16e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16ec:	8b 55 08             	mov    0x8(%ebp),%edx
    16ef:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    16f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16f5:	83 c0 08             	add    $0x8,%eax
    16f8:	89 04 24             	mov    %eax,(%esp)
    16fb:	e8 ce fe ff ff       	call   15ce <free>
  return freep;
    1700:	a1 00 1b 00 00       	mov    0x1b00,%eax
}
    1705:	c9                   	leave  
    1706:	c3                   	ret    

00001707 <malloc>:

void*
malloc(uint nbytes)
{
    1707:	55                   	push   %ebp
    1708:	89 e5                	mov    %esp,%ebp
    170a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    170d:	8b 45 08             	mov    0x8(%ebp),%eax
    1710:	83 c0 07             	add    $0x7,%eax
    1713:	c1 e8 03             	shr    $0x3,%eax
    1716:	83 c0 01             	add    $0x1,%eax
    1719:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    171c:	a1 00 1b 00 00       	mov    0x1b00,%eax
    1721:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1724:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1728:	75 23                	jne    174d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    172a:	c7 45 f0 f8 1a 00 00 	movl   $0x1af8,-0x10(%ebp)
    1731:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1734:	a3 00 1b 00 00       	mov    %eax,0x1b00
    1739:	a1 00 1b 00 00       	mov    0x1b00,%eax
    173e:	a3 f8 1a 00 00       	mov    %eax,0x1af8
    base.s.size = 0;
    1743:	c7 05 fc 1a 00 00 00 	movl   $0x0,0x1afc
    174a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    174d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1750:	8b 00                	mov    (%eax),%eax
    1752:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1755:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1758:	8b 40 04             	mov    0x4(%eax),%eax
    175b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    175e:	72 4d                	jb     17ad <malloc+0xa6>
      if(p->s.size == nunits)
    1760:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1763:	8b 40 04             	mov    0x4(%eax),%eax
    1766:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1769:	75 0c                	jne    1777 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    176b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    176e:	8b 10                	mov    (%eax),%edx
    1770:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1773:	89 10                	mov    %edx,(%eax)
    1775:	eb 26                	jmp    179d <malloc+0x96>
      else {
        p->s.size -= nunits;
    1777:	8b 45 f4             	mov    -0xc(%ebp),%eax
    177a:	8b 40 04             	mov    0x4(%eax),%eax
    177d:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1780:	89 c2                	mov    %eax,%edx
    1782:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1785:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1788:	8b 45 f4             	mov    -0xc(%ebp),%eax
    178b:	8b 40 04             	mov    0x4(%eax),%eax
    178e:	c1 e0 03             	shl    $0x3,%eax
    1791:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1794:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1797:	8b 55 ec             	mov    -0x14(%ebp),%edx
    179a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    179d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17a0:	a3 00 1b 00 00       	mov    %eax,0x1b00
      return (void*)(p + 1);
    17a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17a8:	83 c0 08             	add    $0x8,%eax
    17ab:	eb 38                	jmp    17e5 <malloc+0xde>
    }
    if(p == freep)
    17ad:	a1 00 1b 00 00       	mov    0x1b00,%eax
    17b2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    17b5:	75 1b                	jne    17d2 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    17b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    17ba:	89 04 24             	mov    %eax,(%esp)
    17bd:	e8 ed fe ff ff       	call   16af <morecore>
    17c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    17c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17c9:	75 07                	jne    17d2 <malloc+0xcb>
        return 0;
    17cb:	b8 00 00 00 00       	mov    $0x0,%eax
    17d0:	eb 13                	jmp    17e5 <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    17d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17db:	8b 00                	mov    (%eax),%eax
    17dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
    17e0:	e9 70 ff ff ff       	jmp    1755 <malloc+0x4e>
}
    17e5:	c9                   	leave  
    17e6:	c3                   	ret    

000017e7 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    17e7:	55                   	push   %ebp
    17e8:	89 e5                	mov    %esp,%ebp
    17ea:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    17ed:	8b 55 08             	mov    0x8(%ebp),%edx
    17f0:	8b 45 0c             	mov    0xc(%ebp),%eax
    17f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
    17f6:	f0 87 02             	lock xchg %eax,(%edx)
    17f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    17fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    17ff:	c9                   	leave  
    1800:	c3                   	ret    

00001801 <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    1801:	55                   	push   %ebp
    1802:	89 e5                	mov    %esp,%ebp
    1804:	83 ec 08             	sub    $0x8,%esp
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    1807:	90                   	nop
    1808:	8b 45 08             	mov    0x8(%ebp),%eax
    180b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1812:	00 
    1813:	89 04 24             	mov    %eax,(%esp)
    1816:	e8 cc ff ff ff       	call   17e7 <xchg>
    181b:	85 c0                	test   %eax,%eax
    181d:	75 e9                	jne    1808 <uacquire+0x7>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    181f:	0f ae f0             	mfence 
}
    1822:	c9                   	leave  
    1823:	c3                   	ret    

00001824 <urelease>:

void urelease (struct uspinlock *lk) {
    1824:	55                   	push   %ebp
    1825:	89 e5                	mov    %esp,%ebp
  __sync_synchronize();
    1827:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    182a:	8b 45 08             	mov    0x8(%ebp),%eax
    182d:	8b 55 08             	mov    0x8(%ebp),%edx
    1830:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1836:	5d                   	pop    %ebp
    1837:	c3                   	ret    
