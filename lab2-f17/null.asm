
_null:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 20             	sub    $0x20,%esp
int *i = 0;
    1009:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
    1010:	00 

(*i)++;
    1011:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1015:	8b 00                	mov    (%eax),%eax
    1017:	8d 50 01             	lea    0x1(%eax),%edx
    101a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    101e:	89 10                	mov    %edx,(%eax)

printf(1,"Hi %d",*i);
    1020:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1024:	8b 00                	mov    (%eax),%eax
    1026:	89 44 24 08          	mov    %eax,0x8(%esp)
    102a:	c7 44 24 04 5a 18 00 	movl   $0x185a,0x4(%esp)
    1031:	00 
    1032:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1039:	e8 ff 03 00 00       	call   143d <printf>

return 1;
    103e:	b8 01 00 00 00       	mov    $0x1,%eax
}
    1043:	c9                   	leave  
    1044:	c3                   	ret    

00001045 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1045:	55                   	push   %ebp
    1046:	89 e5                	mov    %esp,%ebp
    1048:	57                   	push   %edi
    1049:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    104a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    104d:	8b 55 10             	mov    0x10(%ebp),%edx
    1050:	8b 45 0c             	mov    0xc(%ebp),%eax
    1053:	89 cb                	mov    %ecx,%ebx
    1055:	89 df                	mov    %ebx,%edi
    1057:	89 d1                	mov    %edx,%ecx
    1059:	fc                   	cld    
    105a:	f3 aa                	rep stos %al,%es:(%edi)
    105c:	89 ca                	mov    %ecx,%edx
    105e:	89 fb                	mov    %edi,%ebx
    1060:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1063:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1066:	5b                   	pop    %ebx
    1067:	5f                   	pop    %edi
    1068:	5d                   	pop    %ebp
    1069:	c3                   	ret    

0000106a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    106a:	55                   	push   %ebp
    106b:	89 e5                	mov    %esp,%ebp
    106d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1070:	8b 45 08             	mov    0x8(%ebp),%eax
    1073:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1076:	90                   	nop
    1077:	8b 45 08             	mov    0x8(%ebp),%eax
    107a:	8d 50 01             	lea    0x1(%eax),%edx
    107d:	89 55 08             	mov    %edx,0x8(%ebp)
    1080:	8b 55 0c             	mov    0xc(%ebp),%edx
    1083:	8d 4a 01             	lea    0x1(%edx),%ecx
    1086:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1089:	0f b6 12             	movzbl (%edx),%edx
    108c:	88 10                	mov    %dl,(%eax)
    108e:	0f b6 00             	movzbl (%eax),%eax
    1091:	84 c0                	test   %al,%al
    1093:	75 e2                	jne    1077 <strcpy+0xd>
    ;
  return os;
    1095:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1098:	c9                   	leave  
    1099:	c3                   	ret    

0000109a <strcmp>:

int
strcmp(const char *p, const char *q)
{
    109a:	55                   	push   %ebp
    109b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    109d:	eb 08                	jmp    10a7 <strcmp+0xd>
    p++, q++;
    109f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    10a3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
    10a7:	8b 45 08             	mov    0x8(%ebp),%eax
    10aa:	0f b6 00             	movzbl (%eax),%eax
    10ad:	84 c0                	test   %al,%al
    10af:	74 10                	je     10c1 <strcmp+0x27>
    10b1:	8b 45 08             	mov    0x8(%ebp),%eax
    10b4:	0f b6 10             	movzbl (%eax),%edx
    10b7:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ba:	0f b6 00             	movzbl (%eax),%eax
    10bd:	38 c2                	cmp    %al,%dl
    10bf:	74 de                	je     109f <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
    10c1:	8b 45 08             	mov    0x8(%ebp),%eax
    10c4:	0f b6 00             	movzbl (%eax),%eax
    10c7:	0f b6 d0             	movzbl %al,%edx
    10ca:	8b 45 0c             	mov    0xc(%ebp),%eax
    10cd:	0f b6 00             	movzbl (%eax),%eax
    10d0:	0f b6 c0             	movzbl %al,%eax
    10d3:	29 c2                	sub    %eax,%edx
    10d5:	89 d0                	mov    %edx,%eax
}
    10d7:	5d                   	pop    %ebp
    10d8:	c3                   	ret    

000010d9 <strlen>:

uint
strlen(char *s)
{
    10d9:	55                   	push   %ebp
    10da:	89 e5                	mov    %esp,%ebp
    10dc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    10df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    10e6:	eb 04                	jmp    10ec <strlen+0x13>
    10e8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    10ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
    10ef:	8b 45 08             	mov    0x8(%ebp),%eax
    10f2:	01 d0                	add    %edx,%eax
    10f4:	0f b6 00             	movzbl (%eax),%eax
    10f7:	84 c0                	test   %al,%al
    10f9:	75 ed                	jne    10e8 <strlen+0xf>
    ;
  return n;
    10fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10fe:	c9                   	leave  
    10ff:	c3                   	ret    

00001100 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1100:	55                   	push   %ebp
    1101:	89 e5                	mov    %esp,%ebp
    1103:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1106:	8b 45 10             	mov    0x10(%ebp),%eax
    1109:	89 44 24 08          	mov    %eax,0x8(%esp)
    110d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1110:	89 44 24 04          	mov    %eax,0x4(%esp)
    1114:	8b 45 08             	mov    0x8(%ebp),%eax
    1117:	89 04 24             	mov    %eax,(%esp)
    111a:	e8 26 ff ff ff       	call   1045 <stosb>
  return dst;
    111f:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1122:	c9                   	leave  
    1123:	c3                   	ret    

00001124 <strchr>:

char*
strchr(const char *s, char c)
{
    1124:	55                   	push   %ebp
    1125:	89 e5                	mov    %esp,%ebp
    1127:	83 ec 04             	sub    $0x4,%esp
    112a:	8b 45 0c             	mov    0xc(%ebp),%eax
    112d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1130:	eb 14                	jmp    1146 <strchr+0x22>
    if(*s == c)
    1132:	8b 45 08             	mov    0x8(%ebp),%eax
    1135:	0f b6 00             	movzbl (%eax),%eax
    1138:	3a 45 fc             	cmp    -0x4(%ebp),%al
    113b:	75 05                	jne    1142 <strchr+0x1e>
      return (char*)s;
    113d:	8b 45 08             	mov    0x8(%ebp),%eax
    1140:	eb 13                	jmp    1155 <strchr+0x31>
  for(; *s; s++)
    1142:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1146:	8b 45 08             	mov    0x8(%ebp),%eax
    1149:	0f b6 00             	movzbl (%eax),%eax
    114c:	84 c0                	test   %al,%al
    114e:	75 e2                	jne    1132 <strchr+0xe>
  return 0;
    1150:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1155:	c9                   	leave  
    1156:	c3                   	ret    

00001157 <gets>:

char*
gets(char *buf, int max)
{
    1157:	55                   	push   %ebp
    1158:	89 e5                	mov    %esp,%ebp
    115a:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    115d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1164:	eb 4c                	jmp    11b2 <gets+0x5b>
    cc = read(0, &c, 1);
    1166:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    116d:	00 
    116e:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1171:	89 44 24 04          	mov    %eax,0x4(%esp)
    1175:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    117c:	e8 44 01 00 00       	call   12c5 <read>
    1181:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1184:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1188:	7f 02                	jg     118c <gets+0x35>
      break;
    118a:	eb 31                	jmp    11bd <gets+0x66>
    buf[i++] = c;
    118c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    118f:	8d 50 01             	lea    0x1(%eax),%edx
    1192:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1195:	89 c2                	mov    %eax,%edx
    1197:	8b 45 08             	mov    0x8(%ebp),%eax
    119a:	01 c2                	add    %eax,%edx
    119c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11a0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    11a2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11a6:	3c 0a                	cmp    $0xa,%al
    11a8:	74 13                	je     11bd <gets+0x66>
    11aa:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    11ae:	3c 0d                	cmp    $0xd,%al
    11b0:	74 0b                	je     11bd <gets+0x66>
  for(i=0; i+1 < max; ){
    11b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11b5:	83 c0 01             	add    $0x1,%eax
    11b8:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11bb:	7c a9                	jl     1166 <gets+0xf>
      break;
  }
  buf[i] = '\0';
    11bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11c0:	8b 45 08             	mov    0x8(%ebp),%eax
    11c3:	01 d0                	add    %edx,%eax
    11c5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11c8:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11cb:	c9                   	leave  
    11cc:	c3                   	ret    

000011cd <stat>:

int
stat(char *n, struct stat *st)
{
    11cd:	55                   	push   %ebp
    11ce:	89 e5                	mov    %esp,%ebp
    11d0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11d3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    11da:	00 
    11db:	8b 45 08             	mov    0x8(%ebp),%eax
    11de:	89 04 24             	mov    %eax,(%esp)
    11e1:	e8 07 01 00 00       	call   12ed <open>
    11e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    11e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11ed:	79 07                	jns    11f6 <stat+0x29>
    return -1;
    11ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    11f4:	eb 23                	jmp    1219 <stat+0x4c>
  r = fstat(fd, st);
    11f6:	8b 45 0c             	mov    0xc(%ebp),%eax
    11f9:	89 44 24 04          	mov    %eax,0x4(%esp)
    11fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1200:	89 04 24             	mov    %eax,(%esp)
    1203:	e8 fd 00 00 00       	call   1305 <fstat>
    1208:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    120b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    120e:	89 04 24             	mov    %eax,(%esp)
    1211:	e8 bf 00 00 00       	call   12d5 <close>
  return r;
    1216:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1219:	c9                   	leave  
    121a:	c3                   	ret    

0000121b <atoi>:

int
atoi(const char *s)
{
    121b:	55                   	push   %ebp
    121c:	89 e5                	mov    %esp,%ebp
    121e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1221:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1228:	eb 25                	jmp    124f <atoi+0x34>
    n = n*10 + *s++ - '0';
    122a:	8b 55 fc             	mov    -0x4(%ebp),%edx
    122d:	89 d0                	mov    %edx,%eax
    122f:	c1 e0 02             	shl    $0x2,%eax
    1232:	01 d0                	add    %edx,%eax
    1234:	01 c0                	add    %eax,%eax
    1236:	89 c1                	mov    %eax,%ecx
    1238:	8b 45 08             	mov    0x8(%ebp),%eax
    123b:	8d 50 01             	lea    0x1(%eax),%edx
    123e:	89 55 08             	mov    %edx,0x8(%ebp)
    1241:	0f b6 00             	movzbl (%eax),%eax
    1244:	0f be c0             	movsbl %al,%eax
    1247:	01 c8                	add    %ecx,%eax
    1249:	83 e8 30             	sub    $0x30,%eax
    124c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    124f:	8b 45 08             	mov    0x8(%ebp),%eax
    1252:	0f b6 00             	movzbl (%eax),%eax
    1255:	3c 2f                	cmp    $0x2f,%al
    1257:	7e 0a                	jle    1263 <atoi+0x48>
    1259:	8b 45 08             	mov    0x8(%ebp),%eax
    125c:	0f b6 00             	movzbl (%eax),%eax
    125f:	3c 39                	cmp    $0x39,%al
    1261:	7e c7                	jle    122a <atoi+0xf>
  return n;
    1263:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1266:	c9                   	leave  
    1267:	c3                   	ret    

00001268 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1268:	55                   	push   %ebp
    1269:	89 e5                	mov    %esp,%ebp
    126b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    126e:	8b 45 08             	mov    0x8(%ebp),%eax
    1271:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1274:	8b 45 0c             	mov    0xc(%ebp),%eax
    1277:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    127a:	eb 17                	jmp    1293 <memmove+0x2b>
    *dst++ = *src++;
    127c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    127f:	8d 50 01             	lea    0x1(%eax),%edx
    1282:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1285:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1288:	8d 4a 01             	lea    0x1(%edx),%ecx
    128b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    128e:	0f b6 12             	movzbl (%edx),%edx
    1291:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
    1293:	8b 45 10             	mov    0x10(%ebp),%eax
    1296:	8d 50 ff             	lea    -0x1(%eax),%edx
    1299:	89 55 10             	mov    %edx,0x10(%ebp)
    129c:	85 c0                	test   %eax,%eax
    129e:	7f dc                	jg     127c <memmove+0x14>
  return vdst;
    12a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12a3:	c9                   	leave  
    12a4:	c3                   	ret    

000012a5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12a5:	b8 01 00 00 00       	mov    $0x1,%eax
    12aa:	cd 40                	int    $0x40
    12ac:	c3                   	ret    

000012ad <exit>:
SYSCALL(exit)
    12ad:	b8 02 00 00 00       	mov    $0x2,%eax
    12b2:	cd 40                	int    $0x40
    12b4:	c3                   	ret    

000012b5 <wait>:
SYSCALL(wait)
    12b5:	b8 03 00 00 00       	mov    $0x3,%eax
    12ba:	cd 40                	int    $0x40
    12bc:	c3                   	ret    

000012bd <pipe>:
SYSCALL(pipe)
    12bd:	b8 04 00 00 00       	mov    $0x4,%eax
    12c2:	cd 40                	int    $0x40
    12c4:	c3                   	ret    

000012c5 <read>:
SYSCALL(read)
    12c5:	b8 05 00 00 00       	mov    $0x5,%eax
    12ca:	cd 40                	int    $0x40
    12cc:	c3                   	ret    

000012cd <write>:
SYSCALL(write)
    12cd:	b8 10 00 00 00       	mov    $0x10,%eax
    12d2:	cd 40                	int    $0x40
    12d4:	c3                   	ret    

000012d5 <close>:
SYSCALL(close)
    12d5:	b8 15 00 00 00       	mov    $0x15,%eax
    12da:	cd 40                	int    $0x40
    12dc:	c3                   	ret    

000012dd <kill>:
SYSCALL(kill)
    12dd:	b8 06 00 00 00       	mov    $0x6,%eax
    12e2:	cd 40                	int    $0x40
    12e4:	c3                   	ret    

000012e5 <exec>:
SYSCALL(exec)
    12e5:	b8 07 00 00 00       	mov    $0x7,%eax
    12ea:	cd 40                	int    $0x40
    12ec:	c3                   	ret    

000012ed <open>:
SYSCALL(open)
    12ed:	b8 0f 00 00 00       	mov    $0xf,%eax
    12f2:	cd 40                	int    $0x40
    12f4:	c3                   	ret    

000012f5 <mknod>:
SYSCALL(mknod)
    12f5:	b8 11 00 00 00       	mov    $0x11,%eax
    12fa:	cd 40                	int    $0x40
    12fc:	c3                   	ret    

000012fd <unlink>:
SYSCALL(unlink)
    12fd:	b8 12 00 00 00       	mov    $0x12,%eax
    1302:	cd 40                	int    $0x40
    1304:	c3                   	ret    

00001305 <fstat>:
SYSCALL(fstat)
    1305:	b8 08 00 00 00       	mov    $0x8,%eax
    130a:	cd 40                	int    $0x40
    130c:	c3                   	ret    

0000130d <link>:
SYSCALL(link)
    130d:	b8 13 00 00 00       	mov    $0x13,%eax
    1312:	cd 40                	int    $0x40
    1314:	c3                   	ret    

00001315 <mkdir>:
SYSCALL(mkdir)
    1315:	b8 14 00 00 00       	mov    $0x14,%eax
    131a:	cd 40                	int    $0x40
    131c:	c3                   	ret    

0000131d <chdir>:
SYSCALL(chdir)
    131d:	b8 09 00 00 00       	mov    $0x9,%eax
    1322:	cd 40                	int    $0x40
    1324:	c3                   	ret    

00001325 <dup>:
SYSCALL(dup)
    1325:	b8 0a 00 00 00       	mov    $0xa,%eax
    132a:	cd 40                	int    $0x40
    132c:	c3                   	ret    

0000132d <getpid>:
SYSCALL(getpid)
    132d:	b8 0b 00 00 00       	mov    $0xb,%eax
    1332:	cd 40                	int    $0x40
    1334:	c3                   	ret    

00001335 <sbrk>:
SYSCALL(sbrk)
    1335:	b8 0c 00 00 00       	mov    $0xc,%eax
    133a:	cd 40                	int    $0x40
    133c:	c3                   	ret    

0000133d <sleep>:
SYSCALL(sleep)
    133d:	b8 0d 00 00 00       	mov    $0xd,%eax
    1342:	cd 40                	int    $0x40
    1344:	c3                   	ret    

00001345 <uptime>:
SYSCALL(uptime)
    1345:	b8 0e 00 00 00       	mov    $0xe,%eax
    134a:	cd 40                	int    $0x40
    134c:	c3                   	ret    

0000134d <shm_open>:
SYSCALL(shm_open)
    134d:	b8 16 00 00 00       	mov    $0x16,%eax
    1352:	cd 40                	int    $0x40
    1354:	c3                   	ret    

00001355 <shm_close>:
SYSCALL(shm_close)	
    1355:	b8 17 00 00 00       	mov    $0x17,%eax
    135a:	cd 40                	int    $0x40
    135c:	c3                   	ret    

0000135d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    135d:	55                   	push   %ebp
    135e:	89 e5                	mov    %esp,%ebp
    1360:	83 ec 18             	sub    $0x18,%esp
    1363:	8b 45 0c             	mov    0xc(%ebp),%eax
    1366:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1369:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1370:	00 
    1371:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1374:	89 44 24 04          	mov    %eax,0x4(%esp)
    1378:	8b 45 08             	mov    0x8(%ebp),%eax
    137b:	89 04 24             	mov    %eax,(%esp)
    137e:	e8 4a ff ff ff       	call   12cd <write>
}
    1383:	c9                   	leave  
    1384:	c3                   	ret    

00001385 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1385:	55                   	push   %ebp
    1386:	89 e5                	mov    %esp,%ebp
    1388:	56                   	push   %esi
    1389:	53                   	push   %ebx
    138a:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    138d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1394:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1398:	74 17                	je     13b1 <printint+0x2c>
    139a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    139e:	79 11                	jns    13b1 <printint+0x2c>
    neg = 1;
    13a0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13a7:	8b 45 0c             	mov    0xc(%ebp),%eax
    13aa:	f7 d8                	neg    %eax
    13ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13af:	eb 06                	jmp    13b7 <printint+0x32>
  } else {
    x = xx;
    13b1:	8b 45 0c             	mov    0xc(%ebp),%eax
    13b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    13be:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    13c1:	8d 41 01             	lea    0x1(%ecx),%eax
    13c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    13c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
    13ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13cd:	ba 00 00 00 00       	mov    $0x0,%edx
    13d2:	f7 f3                	div    %ebx
    13d4:	89 d0                	mov    %edx,%eax
    13d6:	0f b6 80 10 1b 00 00 	movzbl 0x1b10(%eax),%eax
    13dd:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    13e1:	8b 75 10             	mov    0x10(%ebp),%esi
    13e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13e7:	ba 00 00 00 00       	mov    $0x0,%edx
    13ec:	f7 f6                	div    %esi
    13ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    13f5:	75 c7                	jne    13be <printint+0x39>
  if(neg)
    13f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13fb:	74 10                	je     140d <printint+0x88>
    buf[i++] = '-';
    13fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1400:	8d 50 01             	lea    0x1(%eax),%edx
    1403:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1406:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    140b:	eb 1f                	jmp    142c <printint+0xa7>
    140d:	eb 1d                	jmp    142c <printint+0xa7>
    putc(fd, buf[i]);
    140f:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1412:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1415:	01 d0                	add    %edx,%eax
    1417:	0f b6 00             	movzbl (%eax),%eax
    141a:	0f be c0             	movsbl %al,%eax
    141d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1421:	8b 45 08             	mov    0x8(%ebp),%eax
    1424:	89 04 24             	mov    %eax,(%esp)
    1427:	e8 31 ff ff ff       	call   135d <putc>
  while(--i >= 0)
    142c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1430:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1434:	79 d9                	jns    140f <printint+0x8a>
}
    1436:	83 c4 30             	add    $0x30,%esp
    1439:	5b                   	pop    %ebx
    143a:	5e                   	pop    %esi
    143b:	5d                   	pop    %ebp
    143c:	c3                   	ret    

0000143d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    143d:	55                   	push   %ebp
    143e:	89 e5                	mov    %esp,%ebp
    1440:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1443:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    144a:	8d 45 0c             	lea    0xc(%ebp),%eax
    144d:	83 c0 04             	add    $0x4,%eax
    1450:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1453:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    145a:	e9 7c 01 00 00       	jmp    15db <printf+0x19e>
    c = fmt[i] & 0xff;
    145f:	8b 55 0c             	mov    0xc(%ebp),%edx
    1462:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1465:	01 d0                	add    %edx,%eax
    1467:	0f b6 00             	movzbl (%eax),%eax
    146a:	0f be c0             	movsbl %al,%eax
    146d:	25 ff 00 00 00       	and    $0xff,%eax
    1472:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1475:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1479:	75 2c                	jne    14a7 <printf+0x6a>
      if(c == '%'){
    147b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    147f:	75 0c                	jne    148d <printf+0x50>
        state = '%';
    1481:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1488:	e9 4a 01 00 00       	jmp    15d7 <printf+0x19a>
      } else {
        putc(fd, c);
    148d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1490:	0f be c0             	movsbl %al,%eax
    1493:	89 44 24 04          	mov    %eax,0x4(%esp)
    1497:	8b 45 08             	mov    0x8(%ebp),%eax
    149a:	89 04 24             	mov    %eax,(%esp)
    149d:	e8 bb fe ff ff       	call   135d <putc>
    14a2:	e9 30 01 00 00       	jmp    15d7 <printf+0x19a>
      }
    } else if(state == '%'){
    14a7:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14ab:	0f 85 26 01 00 00    	jne    15d7 <printf+0x19a>
      if(c == 'd'){
    14b1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14b5:	75 2d                	jne    14e4 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    14b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14ba:	8b 00                	mov    (%eax),%eax
    14bc:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    14c3:	00 
    14c4:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    14cb:	00 
    14cc:	89 44 24 04          	mov    %eax,0x4(%esp)
    14d0:	8b 45 08             	mov    0x8(%ebp),%eax
    14d3:	89 04 24             	mov    %eax,(%esp)
    14d6:	e8 aa fe ff ff       	call   1385 <printint>
        ap++;
    14db:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14df:	e9 ec 00 00 00       	jmp    15d0 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    14e4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    14e8:	74 06                	je     14f0 <printf+0xb3>
    14ea:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    14ee:	75 2d                	jne    151d <printf+0xe0>
        printint(fd, *ap, 16, 0);
    14f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14f3:	8b 00                	mov    (%eax),%eax
    14f5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    14fc:	00 
    14fd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1504:	00 
    1505:	89 44 24 04          	mov    %eax,0x4(%esp)
    1509:	8b 45 08             	mov    0x8(%ebp),%eax
    150c:	89 04 24             	mov    %eax,(%esp)
    150f:	e8 71 fe ff ff       	call   1385 <printint>
        ap++;
    1514:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1518:	e9 b3 00 00 00       	jmp    15d0 <printf+0x193>
      } else if(c == 's'){
    151d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1521:	75 45                	jne    1568 <printf+0x12b>
        s = (char*)*ap;
    1523:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1526:	8b 00                	mov    (%eax),%eax
    1528:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    152b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    152f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1533:	75 09                	jne    153e <printf+0x101>
          s = "(null)";
    1535:	c7 45 f4 60 18 00 00 	movl   $0x1860,-0xc(%ebp)
        while(*s != 0){
    153c:	eb 1e                	jmp    155c <printf+0x11f>
    153e:	eb 1c                	jmp    155c <printf+0x11f>
          putc(fd, *s);
    1540:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1543:	0f b6 00             	movzbl (%eax),%eax
    1546:	0f be c0             	movsbl %al,%eax
    1549:	89 44 24 04          	mov    %eax,0x4(%esp)
    154d:	8b 45 08             	mov    0x8(%ebp),%eax
    1550:	89 04 24             	mov    %eax,(%esp)
    1553:	e8 05 fe ff ff       	call   135d <putc>
          s++;
    1558:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
    155c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    155f:	0f b6 00             	movzbl (%eax),%eax
    1562:	84 c0                	test   %al,%al
    1564:	75 da                	jne    1540 <printf+0x103>
    1566:	eb 68                	jmp    15d0 <printf+0x193>
        }
      } else if(c == 'c'){
    1568:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    156c:	75 1d                	jne    158b <printf+0x14e>
        putc(fd, *ap);
    156e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1571:	8b 00                	mov    (%eax),%eax
    1573:	0f be c0             	movsbl %al,%eax
    1576:	89 44 24 04          	mov    %eax,0x4(%esp)
    157a:	8b 45 08             	mov    0x8(%ebp),%eax
    157d:	89 04 24             	mov    %eax,(%esp)
    1580:	e8 d8 fd ff ff       	call   135d <putc>
        ap++;
    1585:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1589:	eb 45                	jmp    15d0 <printf+0x193>
      } else if(c == '%'){
    158b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    158f:	75 17                	jne    15a8 <printf+0x16b>
        putc(fd, c);
    1591:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1594:	0f be c0             	movsbl %al,%eax
    1597:	89 44 24 04          	mov    %eax,0x4(%esp)
    159b:	8b 45 08             	mov    0x8(%ebp),%eax
    159e:	89 04 24             	mov    %eax,(%esp)
    15a1:	e8 b7 fd ff ff       	call   135d <putc>
    15a6:	eb 28                	jmp    15d0 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15a8:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    15af:	00 
    15b0:	8b 45 08             	mov    0x8(%ebp),%eax
    15b3:	89 04 24             	mov    %eax,(%esp)
    15b6:	e8 a2 fd ff ff       	call   135d <putc>
        putc(fd, c);
    15bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15be:	0f be c0             	movsbl %al,%eax
    15c1:	89 44 24 04          	mov    %eax,0x4(%esp)
    15c5:	8b 45 08             	mov    0x8(%ebp),%eax
    15c8:	89 04 24             	mov    %eax,(%esp)
    15cb:	e8 8d fd ff ff       	call   135d <putc>
      }
      state = 0;
    15d0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    15d7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    15db:	8b 55 0c             	mov    0xc(%ebp),%edx
    15de:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15e1:	01 d0                	add    %edx,%eax
    15e3:	0f b6 00             	movzbl (%eax),%eax
    15e6:	84 c0                	test   %al,%al
    15e8:	0f 85 71 fe ff ff    	jne    145f <printf+0x22>
    }
  }
}
    15ee:	c9                   	leave  
    15ef:	c3                   	ret    

000015f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    15f0:	55                   	push   %ebp
    15f1:	89 e5                	mov    %esp,%ebp
    15f3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    15f6:	8b 45 08             	mov    0x8(%ebp),%eax
    15f9:	83 e8 08             	sub    $0x8,%eax
    15fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15ff:	a1 2c 1b 00 00       	mov    0x1b2c,%eax
    1604:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1607:	eb 24                	jmp    162d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1609:	8b 45 fc             	mov    -0x4(%ebp),%eax
    160c:	8b 00                	mov    (%eax),%eax
    160e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1611:	77 12                	ja     1625 <free+0x35>
    1613:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1616:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1619:	77 24                	ja     163f <free+0x4f>
    161b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    161e:	8b 00                	mov    (%eax),%eax
    1620:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1623:	77 1a                	ja     163f <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1625:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1628:	8b 00                	mov    (%eax),%eax
    162a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    162d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1630:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1633:	76 d4                	jbe    1609 <free+0x19>
    1635:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1638:	8b 00                	mov    (%eax),%eax
    163a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    163d:	76 ca                	jbe    1609 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    163f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1642:	8b 40 04             	mov    0x4(%eax),%eax
    1645:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    164c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    164f:	01 c2                	add    %eax,%edx
    1651:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1654:	8b 00                	mov    (%eax),%eax
    1656:	39 c2                	cmp    %eax,%edx
    1658:	75 24                	jne    167e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    165a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    165d:	8b 50 04             	mov    0x4(%eax),%edx
    1660:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1663:	8b 00                	mov    (%eax),%eax
    1665:	8b 40 04             	mov    0x4(%eax),%eax
    1668:	01 c2                	add    %eax,%edx
    166a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    166d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1670:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1673:	8b 00                	mov    (%eax),%eax
    1675:	8b 10                	mov    (%eax),%edx
    1677:	8b 45 f8             	mov    -0x8(%ebp),%eax
    167a:	89 10                	mov    %edx,(%eax)
    167c:	eb 0a                	jmp    1688 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    167e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1681:	8b 10                	mov    (%eax),%edx
    1683:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1686:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1688:	8b 45 fc             	mov    -0x4(%ebp),%eax
    168b:	8b 40 04             	mov    0x4(%eax),%eax
    168e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1695:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1698:	01 d0                	add    %edx,%eax
    169a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    169d:	75 20                	jne    16bf <free+0xcf>
    p->s.size += bp->s.size;
    169f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a2:	8b 50 04             	mov    0x4(%eax),%edx
    16a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16a8:	8b 40 04             	mov    0x4(%eax),%eax
    16ab:	01 c2                	add    %eax,%edx
    16ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16b6:	8b 10                	mov    (%eax),%edx
    16b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16bb:	89 10                	mov    %edx,(%eax)
    16bd:	eb 08                	jmp    16c7 <free+0xd7>
  } else
    p->s.ptr = bp;
    16bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c2:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16c5:	89 10                	mov    %edx,(%eax)
  freep = p;
    16c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ca:	a3 2c 1b 00 00       	mov    %eax,0x1b2c
}
    16cf:	c9                   	leave  
    16d0:	c3                   	ret    

000016d1 <morecore>:

static Header*
morecore(uint nu)
{
    16d1:	55                   	push   %ebp
    16d2:	89 e5                	mov    %esp,%ebp
    16d4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    16d7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    16de:	77 07                	ja     16e7 <morecore+0x16>
    nu = 4096;
    16e0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    16e7:	8b 45 08             	mov    0x8(%ebp),%eax
    16ea:	c1 e0 03             	shl    $0x3,%eax
    16ed:	89 04 24             	mov    %eax,(%esp)
    16f0:	e8 40 fc ff ff       	call   1335 <sbrk>
    16f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    16f8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    16fc:	75 07                	jne    1705 <morecore+0x34>
    return 0;
    16fe:	b8 00 00 00 00       	mov    $0x0,%eax
    1703:	eb 22                	jmp    1727 <morecore+0x56>
  hp = (Header*)p;
    1705:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1708:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    170b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    170e:	8b 55 08             	mov    0x8(%ebp),%edx
    1711:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1714:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1717:	83 c0 08             	add    $0x8,%eax
    171a:	89 04 24             	mov    %eax,(%esp)
    171d:	e8 ce fe ff ff       	call   15f0 <free>
  return freep;
    1722:	a1 2c 1b 00 00       	mov    0x1b2c,%eax
}
    1727:	c9                   	leave  
    1728:	c3                   	ret    

00001729 <malloc>:

void*
malloc(uint nbytes)
{
    1729:	55                   	push   %ebp
    172a:	89 e5                	mov    %esp,%ebp
    172c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    172f:	8b 45 08             	mov    0x8(%ebp),%eax
    1732:	83 c0 07             	add    $0x7,%eax
    1735:	c1 e8 03             	shr    $0x3,%eax
    1738:	83 c0 01             	add    $0x1,%eax
    173b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    173e:	a1 2c 1b 00 00       	mov    0x1b2c,%eax
    1743:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1746:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    174a:	75 23                	jne    176f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    174c:	c7 45 f0 24 1b 00 00 	movl   $0x1b24,-0x10(%ebp)
    1753:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1756:	a3 2c 1b 00 00       	mov    %eax,0x1b2c
    175b:	a1 2c 1b 00 00       	mov    0x1b2c,%eax
    1760:	a3 24 1b 00 00       	mov    %eax,0x1b24
    base.s.size = 0;
    1765:	c7 05 28 1b 00 00 00 	movl   $0x0,0x1b28
    176c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    176f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1772:	8b 00                	mov    (%eax),%eax
    1774:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1777:	8b 45 f4             	mov    -0xc(%ebp),%eax
    177a:	8b 40 04             	mov    0x4(%eax),%eax
    177d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1780:	72 4d                	jb     17cf <malloc+0xa6>
      if(p->s.size == nunits)
    1782:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1785:	8b 40 04             	mov    0x4(%eax),%eax
    1788:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    178b:	75 0c                	jne    1799 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    178d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1790:	8b 10                	mov    (%eax),%edx
    1792:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1795:	89 10                	mov    %edx,(%eax)
    1797:	eb 26                	jmp    17bf <malloc+0x96>
      else {
        p->s.size -= nunits;
    1799:	8b 45 f4             	mov    -0xc(%ebp),%eax
    179c:	8b 40 04             	mov    0x4(%eax),%eax
    179f:	2b 45 ec             	sub    -0x14(%ebp),%eax
    17a2:	89 c2                	mov    %eax,%edx
    17a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17a7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    17aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ad:	8b 40 04             	mov    0x4(%eax),%eax
    17b0:	c1 e0 03             	shl    $0x3,%eax
    17b3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17bc:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    17bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17c2:	a3 2c 1b 00 00       	mov    %eax,0x1b2c
      return (void*)(p + 1);
    17c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ca:	83 c0 08             	add    $0x8,%eax
    17cd:	eb 38                	jmp    1807 <malloc+0xde>
    }
    if(p == freep)
    17cf:	a1 2c 1b 00 00       	mov    0x1b2c,%eax
    17d4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    17d7:	75 1b                	jne    17f4 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    17d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    17dc:	89 04 24             	mov    %eax,(%esp)
    17df:	e8 ed fe ff ff       	call   16d1 <morecore>
    17e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    17e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17eb:	75 07                	jne    17f4 <malloc+0xcb>
        return 0;
    17ed:	b8 00 00 00 00       	mov    $0x0,%eax
    17f2:	eb 13                	jmp    1807 <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    17fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17fd:	8b 00                	mov    (%eax),%eax
    17ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
    1802:	e9 70 ff ff ff       	jmp    1777 <malloc+0x4e>
}
    1807:	c9                   	leave  
    1808:	c3                   	ret    

00001809 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    1809:	55                   	push   %ebp
    180a:	89 e5                	mov    %esp,%ebp
    180c:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    180f:	8b 55 08             	mov    0x8(%ebp),%edx
    1812:	8b 45 0c             	mov    0xc(%ebp),%eax
    1815:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1818:	f0 87 02             	lock xchg %eax,(%edx)
    181b:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    181e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1821:	c9                   	leave  
    1822:	c3                   	ret    

00001823 <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    1823:	55                   	push   %ebp
    1824:	89 e5                	mov    %esp,%ebp
    1826:	83 ec 08             	sub    $0x8,%esp
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    1829:	90                   	nop
    182a:	8b 45 08             	mov    0x8(%ebp),%eax
    182d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1834:	00 
    1835:	89 04 24             	mov    %eax,(%esp)
    1838:	e8 cc ff ff ff       	call   1809 <xchg>
    183d:	85 c0                	test   %eax,%eax
    183f:	75 e9                	jne    182a <uacquire+0x7>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    1841:	0f ae f0             	mfence 
}
    1844:	c9                   	leave  
    1845:	c3                   	ret    

00001846 <urelease>:

void urelease (struct uspinlock *lk) {
    1846:	55                   	push   %ebp
    1847:	89 e5                	mov    %esp,%ebp
  __sync_synchronize();
    1849:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    184c:	8b 45 08             	mov    0x8(%ebp),%eax
    184f:	8b 55 08             	mov    0x8(%ebp),%edx
    1852:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1858:	5d                   	pop    %ebp
    1859:	c3                   	ret    
