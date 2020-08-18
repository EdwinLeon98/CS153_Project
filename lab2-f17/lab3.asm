
_lab3:     file format elf32-i386


Disassembly of section .text:

00001000 <recurse>:
// Prevent this function from being optimized, which might give it closed form
#pragma GCC push_options
#pragma GCC optimize ("O0")
static int
recurse(int n)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 18             	sub    $0x18,%esp
  if(n == 0)
    1006:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    100a:	75 07                	jne    1013 <recurse+0x13>
    return 0;
    100c:	b8 00 00 00 00       	mov    $0x0,%eax
    1011:	eb 13                	jmp    1026 <recurse+0x26>
  return n + recurse(n - 1);
    1013:	8b 45 08             	mov    0x8(%ebp),%eax
    1016:	83 e8 01             	sub    $0x1,%eax
    1019:	89 04 24             	mov    %eax,(%esp)
    101c:	e8 df ff ff ff       	call   1000 <recurse>
    1021:	8b 55 08             	mov    0x8(%ebp),%edx
    1024:	01 d0                	add    %edx,%eax
}
    1026:	c9                   	leave  
    1027:	c3                   	ret    

00001028 <main>:
#pragma GCC pop_options

int
main(int argc, char *argv[])
{
    1028:	55                   	push   %ebp
    1029:	89 e5                	mov    %esp,%ebp
    102b:	83 e4 f0             	and    $0xfffffff0,%esp
    102e:	83 ec 20             	sub    $0x20,%esp
  int n, m;

  if(argc != 2){
    1031:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
    1035:	74 22                	je     1059 <main+0x31>
    printf(1, "Usage: %s levels\n", argv[0]);
    1037:	8b 45 0c             	mov    0xc(%ebp),%eax
    103a:	8b 00                	mov    (%eax),%eax
    103c:	89 44 24 08          	mov    %eax,0x8(%esp)
    1040:	c7 44 24 04 cf 18 00 	movl   $0x18cf,0x4(%esp)
    1047:	00 
    1048:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    104f:	e8 5e 04 00 00       	call   14b2 <printf>
    exit();
    1054:	e8 c9 02 00 00       	call   1322 <exit>
  }

  n = atoi(argv[1]);
    1059:	8b 45 0c             	mov    0xc(%ebp),%eax
    105c:	83 c0 04             	add    $0x4,%eax
    105f:	8b 00                	mov    (%eax),%eax
    1061:	89 04 24             	mov    %eax,(%esp)
    1064:	e8 27 02 00 00       	call   1290 <atoi>
    1069:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  printf(1, "Lab 3: Recursing %d levels\n", n);
    106d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1071:	89 44 24 08          	mov    %eax,0x8(%esp)
    1075:	c7 44 24 04 e1 18 00 	movl   $0x18e1,0x4(%esp)
    107c:	00 
    107d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1084:	e8 29 04 00 00       	call   14b2 <printf>
  m = recurse(n);
    1089:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    108d:	89 04 24             	mov    %eax,(%esp)
    1090:	e8 6b ff ff ff       	call   1000 <recurse>
    1095:	89 44 24 18          	mov    %eax,0x18(%esp)
  printf(1, "Lab 3: Yielded a value of %d\n", m);
    1099:	8b 44 24 18          	mov    0x18(%esp),%eax
    109d:	89 44 24 08          	mov    %eax,0x8(%esp)
    10a1:	c7 44 24 04 fd 18 00 	movl   $0x18fd,0x4(%esp)
    10a8:	00 
    10a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10b0:	e8 fd 03 00 00       	call   14b2 <printf>
  exit();
    10b5:	e8 68 02 00 00       	call   1322 <exit>

000010ba <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    10ba:	55                   	push   %ebp
    10bb:	89 e5                	mov    %esp,%ebp
    10bd:	57                   	push   %edi
    10be:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    10bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
    10c2:	8b 55 10             	mov    0x10(%ebp),%edx
    10c5:	8b 45 0c             	mov    0xc(%ebp),%eax
    10c8:	89 cb                	mov    %ecx,%ebx
    10ca:	89 df                	mov    %ebx,%edi
    10cc:	89 d1                	mov    %edx,%ecx
    10ce:	fc                   	cld    
    10cf:	f3 aa                	rep stos %al,%es:(%edi)
    10d1:	89 ca                	mov    %ecx,%edx
    10d3:	89 fb                	mov    %edi,%ebx
    10d5:	89 5d 08             	mov    %ebx,0x8(%ebp)
    10d8:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10db:	5b                   	pop    %ebx
    10dc:	5f                   	pop    %edi
    10dd:	5d                   	pop    %ebp
    10de:	c3                   	ret    

000010df <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10df:	55                   	push   %ebp
    10e0:	89 e5                	mov    %esp,%ebp
    10e2:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    10e5:	8b 45 08             	mov    0x8(%ebp),%eax
    10e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    10eb:	90                   	nop
    10ec:	8b 45 08             	mov    0x8(%ebp),%eax
    10ef:	8d 50 01             	lea    0x1(%eax),%edx
    10f2:	89 55 08             	mov    %edx,0x8(%ebp)
    10f5:	8b 55 0c             	mov    0xc(%ebp),%edx
    10f8:	8d 4a 01             	lea    0x1(%edx),%ecx
    10fb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    10fe:	0f b6 12             	movzbl (%edx),%edx
    1101:	88 10                	mov    %dl,(%eax)
    1103:	0f b6 00             	movzbl (%eax),%eax
    1106:	84 c0                	test   %al,%al
    1108:	75 e2                	jne    10ec <strcpy+0xd>
    ;
  return os;
    110a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    110d:	c9                   	leave  
    110e:	c3                   	ret    

0000110f <strcmp>:

int
strcmp(const char *p, const char *q)
{
    110f:	55                   	push   %ebp
    1110:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1112:	eb 08                	jmp    111c <strcmp+0xd>
    p++, q++;
    1114:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1118:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
    111c:	8b 45 08             	mov    0x8(%ebp),%eax
    111f:	0f b6 00             	movzbl (%eax),%eax
    1122:	84 c0                	test   %al,%al
    1124:	74 10                	je     1136 <strcmp+0x27>
    1126:	8b 45 08             	mov    0x8(%ebp),%eax
    1129:	0f b6 10             	movzbl (%eax),%edx
    112c:	8b 45 0c             	mov    0xc(%ebp),%eax
    112f:	0f b6 00             	movzbl (%eax),%eax
    1132:	38 c2                	cmp    %al,%dl
    1134:	74 de                	je     1114 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
    1136:	8b 45 08             	mov    0x8(%ebp),%eax
    1139:	0f b6 00             	movzbl (%eax),%eax
    113c:	0f b6 d0             	movzbl %al,%edx
    113f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1142:	0f b6 00             	movzbl (%eax),%eax
    1145:	0f b6 c0             	movzbl %al,%eax
    1148:	29 c2                	sub    %eax,%edx
    114a:	89 d0                	mov    %edx,%eax
}
    114c:	5d                   	pop    %ebp
    114d:	c3                   	ret    

0000114e <strlen>:

uint
strlen(char *s)
{
    114e:	55                   	push   %ebp
    114f:	89 e5                	mov    %esp,%ebp
    1151:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1154:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    115b:	eb 04                	jmp    1161 <strlen+0x13>
    115d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1161:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1164:	8b 45 08             	mov    0x8(%ebp),%eax
    1167:	01 d0                	add    %edx,%eax
    1169:	0f b6 00             	movzbl (%eax),%eax
    116c:	84 c0                	test   %al,%al
    116e:	75 ed                	jne    115d <strlen+0xf>
    ;
  return n;
    1170:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1173:	c9                   	leave  
    1174:	c3                   	ret    

00001175 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1175:	55                   	push   %ebp
    1176:	89 e5                	mov    %esp,%ebp
    1178:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    117b:	8b 45 10             	mov    0x10(%ebp),%eax
    117e:	89 44 24 08          	mov    %eax,0x8(%esp)
    1182:	8b 45 0c             	mov    0xc(%ebp),%eax
    1185:	89 44 24 04          	mov    %eax,0x4(%esp)
    1189:	8b 45 08             	mov    0x8(%ebp),%eax
    118c:	89 04 24             	mov    %eax,(%esp)
    118f:	e8 26 ff ff ff       	call   10ba <stosb>
  return dst;
    1194:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1197:	c9                   	leave  
    1198:	c3                   	ret    

00001199 <strchr>:

char*
strchr(const char *s, char c)
{
    1199:	55                   	push   %ebp
    119a:	89 e5                	mov    %esp,%ebp
    119c:	83 ec 04             	sub    $0x4,%esp
    119f:	8b 45 0c             	mov    0xc(%ebp),%eax
    11a2:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    11a5:	eb 14                	jmp    11bb <strchr+0x22>
    if(*s == c)
    11a7:	8b 45 08             	mov    0x8(%ebp),%eax
    11aa:	0f b6 00             	movzbl (%eax),%eax
    11ad:	3a 45 fc             	cmp    -0x4(%ebp),%al
    11b0:	75 05                	jne    11b7 <strchr+0x1e>
      return (char*)s;
    11b2:	8b 45 08             	mov    0x8(%ebp),%eax
    11b5:	eb 13                	jmp    11ca <strchr+0x31>
  for(; *s; s++)
    11b7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    11bb:	8b 45 08             	mov    0x8(%ebp),%eax
    11be:	0f b6 00             	movzbl (%eax),%eax
    11c1:	84 c0                	test   %al,%al
    11c3:	75 e2                	jne    11a7 <strchr+0xe>
  return 0;
    11c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
    11ca:	c9                   	leave  
    11cb:	c3                   	ret    

000011cc <gets>:

char*
gets(char *buf, int max)
{
    11cc:	55                   	push   %ebp
    11cd:	89 e5                	mov    %esp,%ebp
    11cf:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11d9:	eb 4c                	jmp    1227 <gets+0x5b>
    cc = read(0, &c, 1);
    11db:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    11e2:	00 
    11e3:	8d 45 ef             	lea    -0x11(%ebp),%eax
    11e6:	89 44 24 04          	mov    %eax,0x4(%esp)
    11ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    11f1:	e8 44 01 00 00       	call   133a <read>
    11f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    11f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11fd:	7f 02                	jg     1201 <gets+0x35>
      break;
    11ff:	eb 31                	jmp    1232 <gets+0x66>
    buf[i++] = c;
    1201:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1204:	8d 50 01             	lea    0x1(%eax),%edx
    1207:	89 55 f4             	mov    %edx,-0xc(%ebp)
    120a:	89 c2                	mov    %eax,%edx
    120c:	8b 45 08             	mov    0x8(%ebp),%eax
    120f:	01 c2                	add    %eax,%edx
    1211:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1215:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1217:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    121b:	3c 0a                	cmp    $0xa,%al
    121d:	74 13                	je     1232 <gets+0x66>
    121f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1223:	3c 0d                	cmp    $0xd,%al
    1225:	74 0b                	je     1232 <gets+0x66>
  for(i=0; i+1 < max; ){
    1227:	8b 45 f4             	mov    -0xc(%ebp),%eax
    122a:	83 c0 01             	add    $0x1,%eax
    122d:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1230:	7c a9                	jl     11db <gets+0xf>
      break;
  }
  buf[i] = '\0';
    1232:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1235:	8b 45 08             	mov    0x8(%ebp),%eax
    1238:	01 d0                	add    %edx,%eax
    123a:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    123d:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1240:	c9                   	leave  
    1241:	c3                   	ret    

00001242 <stat>:

int
stat(char *n, struct stat *st)
{
    1242:	55                   	push   %ebp
    1243:	89 e5                	mov    %esp,%ebp
    1245:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1248:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    124f:	00 
    1250:	8b 45 08             	mov    0x8(%ebp),%eax
    1253:	89 04 24             	mov    %eax,(%esp)
    1256:	e8 07 01 00 00       	call   1362 <open>
    125b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    125e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1262:	79 07                	jns    126b <stat+0x29>
    return -1;
    1264:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1269:	eb 23                	jmp    128e <stat+0x4c>
  r = fstat(fd, st);
    126b:	8b 45 0c             	mov    0xc(%ebp),%eax
    126e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1272:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1275:	89 04 24             	mov    %eax,(%esp)
    1278:	e8 fd 00 00 00       	call   137a <fstat>
    127d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1280:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1283:	89 04 24             	mov    %eax,(%esp)
    1286:	e8 bf 00 00 00       	call   134a <close>
  return r;
    128b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    128e:	c9                   	leave  
    128f:	c3                   	ret    

00001290 <atoi>:

int
atoi(const char *s)
{
    1290:	55                   	push   %ebp
    1291:	89 e5                	mov    %esp,%ebp
    1293:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1296:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    129d:	eb 25                	jmp    12c4 <atoi+0x34>
    n = n*10 + *s++ - '0';
    129f:	8b 55 fc             	mov    -0x4(%ebp),%edx
    12a2:	89 d0                	mov    %edx,%eax
    12a4:	c1 e0 02             	shl    $0x2,%eax
    12a7:	01 d0                	add    %edx,%eax
    12a9:	01 c0                	add    %eax,%eax
    12ab:	89 c1                	mov    %eax,%ecx
    12ad:	8b 45 08             	mov    0x8(%ebp),%eax
    12b0:	8d 50 01             	lea    0x1(%eax),%edx
    12b3:	89 55 08             	mov    %edx,0x8(%ebp)
    12b6:	0f b6 00             	movzbl (%eax),%eax
    12b9:	0f be c0             	movsbl %al,%eax
    12bc:	01 c8                	add    %ecx,%eax
    12be:	83 e8 30             	sub    $0x30,%eax
    12c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    12c4:	8b 45 08             	mov    0x8(%ebp),%eax
    12c7:	0f b6 00             	movzbl (%eax),%eax
    12ca:	3c 2f                	cmp    $0x2f,%al
    12cc:	7e 0a                	jle    12d8 <atoi+0x48>
    12ce:	8b 45 08             	mov    0x8(%ebp),%eax
    12d1:	0f b6 00             	movzbl (%eax),%eax
    12d4:	3c 39                	cmp    $0x39,%al
    12d6:	7e c7                	jle    129f <atoi+0xf>
  return n;
    12d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    12db:	c9                   	leave  
    12dc:	c3                   	ret    

000012dd <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    12dd:	55                   	push   %ebp
    12de:	89 e5                	mov    %esp,%ebp
    12e0:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    12e3:	8b 45 08             	mov    0x8(%ebp),%eax
    12e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    12e9:	8b 45 0c             	mov    0xc(%ebp),%eax
    12ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    12ef:	eb 17                	jmp    1308 <memmove+0x2b>
    *dst++ = *src++;
    12f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12f4:	8d 50 01             	lea    0x1(%eax),%edx
    12f7:	89 55 fc             	mov    %edx,-0x4(%ebp)
    12fa:	8b 55 f8             	mov    -0x8(%ebp),%edx
    12fd:	8d 4a 01             	lea    0x1(%edx),%ecx
    1300:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1303:	0f b6 12             	movzbl (%edx),%edx
    1306:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
    1308:	8b 45 10             	mov    0x10(%ebp),%eax
    130b:	8d 50 ff             	lea    -0x1(%eax),%edx
    130e:	89 55 10             	mov    %edx,0x10(%ebp)
    1311:	85 c0                	test   %eax,%eax
    1313:	7f dc                	jg     12f1 <memmove+0x14>
  return vdst;
    1315:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1318:	c9                   	leave  
    1319:	c3                   	ret    

0000131a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    131a:	b8 01 00 00 00       	mov    $0x1,%eax
    131f:	cd 40                	int    $0x40
    1321:	c3                   	ret    

00001322 <exit>:
SYSCALL(exit)
    1322:	b8 02 00 00 00       	mov    $0x2,%eax
    1327:	cd 40                	int    $0x40
    1329:	c3                   	ret    

0000132a <wait>:
SYSCALL(wait)
    132a:	b8 03 00 00 00       	mov    $0x3,%eax
    132f:	cd 40                	int    $0x40
    1331:	c3                   	ret    

00001332 <pipe>:
SYSCALL(pipe)
    1332:	b8 04 00 00 00       	mov    $0x4,%eax
    1337:	cd 40                	int    $0x40
    1339:	c3                   	ret    

0000133a <read>:
SYSCALL(read)
    133a:	b8 05 00 00 00       	mov    $0x5,%eax
    133f:	cd 40                	int    $0x40
    1341:	c3                   	ret    

00001342 <write>:
SYSCALL(write)
    1342:	b8 10 00 00 00       	mov    $0x10,%eax
    1347:	cd 40                	int    $0x40
    1349:	c3                   	ret    

0000134a <close>:
SYSCALL(close)
    134a:	b8 15 00 00 00       	mov    $0x15,%eax
    134f:	cd 40                	int    $0x40
    1351:	c3                   	ret    

00001352 <kill>:
SYSCALL(kill)
    1352:	b8 06 00 00 00       	mov    $0x6,%eax
    1357:	cd 40                	int    $0x40
    1359:	c3                   	ret    

0000135a <exec>:
SYSCALL(exec)
    135a:	b8 07 00 00 00       	mov    $0x7,%eax
    135f:	cd 40                	int    $0x40
    1361:	c3                   	ret    

00001362 <open>:
SYSCALL(open)
    1362:	b8 0f 00 00 00       	mov    $0xf,%eax
    1367:	cd 40                	int    $0x40
    1369:	c3                   	ret    

0000136a <mknod>:
SYSCALL(mknod)
    136a:	b8 11 00 00 00       	mov    $0x11,%eax
    136f:	cd 40                	int    $0x40
    1371:	c3                   	ret    

00001372 <unlink>:
SYSCALL(unlink)
    1372:	b8 12 00 00 00       	mov    $0x12,%eax
    1377:	cd 40                	int    $0x40
    1379:	c3                   	ret    

0000137a <fstat>:
SYSCALL(fstat)
    137a:	b8 08 00 00 00       	mov    $0x8,%eax
    137f:	cd 40                	int    $0x40
    1381:	c3                   	ret    

00001382 <link>:
SYSCALL(link)
    1382:	b8 13 00 00 00       	mov    $0x13,%eax
    1387:	cd 40                	int    $0x40
    1389:	c3                   	ret    

0000138a <mkdir>:
SYSCALL(mkdir)
    138a:	b8 14 00 00 00       	mov    $0x14,%eax
    138f:	cd 40                	int    $0x40
    1391:	c3                   	ret    

00001392 <chdir>:
SYSCALL(chdir)
    1392:	b8 09 00 00 00       	mov    $0x9,%eax
    1397:	cd 40                	int    $0x40
    1399:	c3                   	ret    

0000139a <dup>:
SYSCALL(dup)
    139a:	b8 0a 00 00 00       	mov    $0xa,%eax
    139f:	cd 40                	int    $0x40
    13a1:	c3                   	ret    

000013a2 <getpid>:
SYSCALL(getpid)
    13a2:	b8 0b 00 00 00       	mov    $0xb,%eax
    13a7:	cd 40                	int    $0x40
    13a9:	c3                   	ret    

000013aa <sbrk>:
SYSCALL(sbrk)
    13aa:	b8 0c 00 00 00       	mov    $0xc,%eax
    13af:	cd 40                	int    $0x40
    13b1:	c3                   	ret    

000013b2 <sleep>:
SYSCALL(sleep)
    13b2:	b8 0d 00 00 00       	mov    $0xd,%eax
    13b7:	cd 40                	int    $0x40
    13b9:	c3                   	ret    

000013ba <uptime>:
SYSCALL(uptime)
    13ba:	b8 0e 00 00 00       	mov    $0xe,%eax
    13bf:	cd 40                	int    $0x40
    13c1:	c3                   	ret    

000013c2 <shm_open>:
SYSCALL(shm_open)
    13c2:	b8 16 00 00 00       	mov    $0x16,%eax
    13c7:	cd 40                	int    $0x40
    13c9:	c3                   	ret    

000013ca <shm_close>:
SYSCALL(shm_close)	
    13ca:	b8 17 00 00 00       	mov    $0x17,%eax
    13cf:	cd 40                	int    $0x40
    13d1:	c3                   	ret    

000013d2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    13d2:	55                   	push   %ebp
    13d3:	89 e5                	mov    %esp,%ebp
    13d5:	83 ec 18             	sub    $0x18,%esp
    13d8:	8b 45 0c             	mov    0xc(%ebp),%eax
    13db:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    13de:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    13e5:	00 
    13e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
    13e9:	89 44 24 04          	mov    %eax,0x4(%esp)
    13ed:	8b 45 08             	mov    0x8(%ebp),%eax
    13f0:	89 04 24             	mov    %eax,(%esp)
    13f3:	e8 4a ff ff ff       	call   1342 <write>
}
    13f8:	c9                   	leave  
    13f9:	c3                   	ret    

000013fa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13fa:	55                   	push   %ebp
    13fb:	89 e5                	mov    %esp,%ebp
    13fd:	56                   	push   %esi
    13fe:	53                   	push   %ebx
    13ff:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1402:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1409:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    140d:	74 17                	je     1426 <printint+0x2c>
    140f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1413:	79 11                	jns    1426 <printint+0x2c>
    neg = 1;
    1415:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    141c:	8b 45 0c             	mov    0xc(%ebp),%eax
    141f:	f7 d8                	neg    %eax
    1421:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1424:	eb 06                	jmp    142c <printint+0x32>
  } else {
    x = xx;
    1426:	8b 45 0c             	mov    0xc(%ebp),%eax
    1429:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    142c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1433:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1436:	8d 41 01             	lea    0x1(%ecx),%eax
    1439:	89 45 f4             	mov    %eax,-0xc(%ebp)
    143c:	8b 5d 10             	mov    0x10(%ebp),%ebx
    143f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1442:	ba 00 00 00 00       	mov    $0x0,%edx
    1447:	f7 f3                	div    %ebx
    1449:	89 d0                	mov    %edx,%eax
    144b:	0f b6 80 e8 1b 00 00 	movzbl 0x1be8(%eax),%eax
    1452:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1456:	8b 75 10             	mov    0x10(%ebp),%esi
    1459:	8b 45 ec             	mov    -0x14(%ebp),%eax
    145c:	ba 00 00 00 00       	mov    $0x0,%edx
    1461:	f7 f6                	div    %esi
    1463:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1466:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    146a:	75 c7                	jne    1433 <printint+0x39>
  if(neg)
    146c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1470:	74 10                	je     1482 <printint+0x88>
    buf[i++] = '-';
    1472:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1475:	8d 50 01             	lea    0x1(%eax),%edx
    1478:	89 55 f4             	mov    %edx,-0xc(%ebp)
    147b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1480:	eb 1f                	jmp    14a1 <printint+0xa7>
    1482:	eb 1d                	jmp    14a1 <printint+0xa7>
    putc(fd, buf[i]);
    1484:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1487:	8b 45 f4             	mov    -0xc(%ebp),%eax
    148a:	01 d0                	add    %edx,%eax
    148c:	0f b6 00             	movzbl (%eax),%eax
    148f:	0f be c0             	movsbl %al,%eax
    1492:	89 44 24 04          	mov    %eax,0x4(%esp)
    1496:	8b 45 08             	mov    0x8(%ebp),%eax
    1499:	89 04 24             	mov    %eax,(%esp)
    149c:	e8 31 ff ff ff       	call   13d2 <putc>
  while(--i >= 0)
    14a1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    14a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14a9:	79 d9                	jns    1484 <printint+0x8a>
}
    14ab:	83 c4 30             	add    $0x30,%esp
    14ae:	5b                   	pop    %ebx
    14af:	5e                   	pop    %esi
    14b0:	5d                   	pop    %ebp
    14b1:	c3                   	ret    

000014b2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    14b2:	55                   	push   %ebp
    14b3:	89 e5                	mov    %esp,%ebp
    14b5:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    14b8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    14bf:	8d 45 0c             	lea    0xc(%ebp),%eax
    14c2:	83 c0 04             	add    $0x4,%eax
    14c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    14c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    14cf:	e9 7c 01 00 00       	jmp    1650 <printf+0x19e>
    c = fmt[i] & 0xff;
    14d4:	8b 55 0c             	mov    0xc(%ebp),%edx
    14d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    14da:	01 d0                	add    %edx,%eax
    14dc:	0f b6 00             	movzbl (%eax),%eax
    14df:	0f be c0             	movsbl %al,%eax
    14e2:	25 ff 00 00 00       	and    $0xff,%eax
    14e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    14ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14ee:	75 2c                	jne    151c <printf+0x6a>
      if(c == '%'){
    14f0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    14f4:	75 0c                	jne    1502 <printf+0x50>
        state = '%';
    14f6:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    14fd:	e9 4a 01 00 00       	jmp    164c <printf+0x19a>
      } else {
        putc(fd, c);
    1502:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1505:	0f be c0             	movsbl %al,%eax
    1508:	89 44 24 04          	mov    %eax,0x4(%esp)
    150c:	8b 45 08             	mov    0x8(%ebp),%eax
    150f:	89 04 24             	mov    %eax,(%esp)
    1512:	e8 bb fe ff ff       	call   13d2 <putc>
    1517:	e9 30 01 00 00       	jmp    164c <printf+0x19a>
      }
    } else if(state == '%'){
    151c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1520:	0f 85 26 01 00 00    	jne    164c <printf+0x19a>
      if(c == 'd'){
    1526:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    152a:	75 2d                	jne    1559 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    152c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    152f:	8b 00                	mov    (%eax),%eax
    1531:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1538:	00 
    1539:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1540:	00 
    1541:	89 44 24 04          	mov    %eax,0x4(%esp)
    1545:	8b 45 08             	mov    0x8(%ebp),%eax
    1548:	89 04 24             	mov    %eax,(%esp)
    154b:	e8 aa fe ff ff       	call   13fa <printint>
        ap++;
    1550:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1554:	e9 ec 00 00 00       	jmp    1645 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    1559:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    155d:	74 06                	je     1565 <printf+0xb3>
    155f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1563:	75 2d                	jne    1592 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1565:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1568:	8b 00                	mov    (%eax),%eax
    156a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1571:	00 
    1572:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1579:	00 
    157a:	89 44 24 04          	mov    %eax,0x4(%esp)
    157e:	8b 45 08             	mov    0x8(%ebp),%eax
    1581:	89 04 24             	mov    %eax,(%esp)
    1584:	e8 71 fe ff ff       	call   13fa <printint>
        ap++;
    1589:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    158d:	e9 b3 00 00 00       	jmp    1645 <printf+0x193>
      } else if(c == 's'){
    1592:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1596:	75 45                	jne    15dd <printf+0x12b>
        s = (char*)*ap;
    1598:	8b 45 e8             	mov    -0x18(%ebp),%eax
    159b:	8b 00                	mov    (%eax),%eax
    159d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    15a0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    15a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15a8:	75 09                	jne    15b3 <printf+0x101>
          s = "(null)";
    15aa:	c7 45 f4 1b 19 00 00 	movl   $0x191b,-0xc(%ebp)
        while(*s != 0){
    15b1:	eb 1e                	jmp    15d1 <printf+0x11f>
    15b3:	eb 1c                	jmp    15d1 <printf+0x11f>
          putc(fd, *s);
    15b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15b8:	0f b6 00             	movzbl (%eax),%eax
    15bb:	0f be c0             	movsbl %al,%eax
    15be:	89 44 24 04          	mov    %eax,0x4(%esp)
    15c2:	8b 45 08             	mov    0x8(%ebp),%eax
    15c5:	89 04 24             	mov    %eax,(%esp)
    15c8:	e8 05 fe ff ff       	call   13d2 <putc>
          s++;
    15cd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
    15d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15d4:	0f b6 00             	movzbl (%eax),%eax
    15d7:	84 c0                	test   %al,%al
    15d9:	75 da                	jne    15b5 <printf+0x103>
    15db:	eb 68                	jmp    1645 <printf+0x193>
        }
      } else if(c == 'c'){
    15dd:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    15e1:	75 1d                	jne    1600 <printf+0x14e>
        putc(fd, *ap);
    15e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15e6:	8b 00                	mov    (%eax),%eax
    15e8:	0f be c0             	movsbl %al,%eax
    15eb:	89 44 24 04          	mov    %eax,0x4(%esp)
    15ef:	8b 45 08             	mov    0x8(%ebp),%eax
    15f2:	89 04 24             	mov    %eax,(%esp)
    15f5:	e8 d8 fd ff ff       	call   13d2 <putc>
        ap++;
    15fa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15fe:	eb 45                	jmp    1645 <printf+0x193>
      } else if(c == '%'){
    1600:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1604:	75 17                	jne    161d <printf+0x16b>
        putc(fd, c);
    1606:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1609:	0f be c0             	movsbl %al,%eax
    160c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1610:	8b 45 08             	mov    0x8(%ebp),%eax
    1613:	89 04 24             	mov    %eax,(%esp)
    1616:	e8 b7 fd ff ff       	call   13d2 <putc>
    161b:	eb 28                	jmp    1645 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    161d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1624:	00 
    1625:	8b 45 08             	mov    0x8(%ebp),%eax
    1628:	89 04 24             	mov    %eax,(%esp)
    162b:	e8 a2 fd ff ff       	call   13d2 <putc>
        putc(fd, c);
    1630:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1633:	0f be c0             	movsbl %al,%eax
    1636:	89 44 24 04          	mov    %eax,0x4(%esp)
    163a:	8b 45 08             	mov    0x8(%ebp),%eax
    163d:	89 04 24             	mov    %eax,(%esp)
    1640:	e8 8d fd ff ff       	call   13d2 <putc>
      }
      state = 0;
    1645:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    164c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1650:	8b 55 0c             	mov    0xc(%ebp),%edx
    1653:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1656:	01 d0                	add    %edx,%eax
    1658:	0f b6 00             	movzbl (%eax),%eax
    165b:	84 c0                	test   %al,%al
    165d:	0f 85 71 fe ff ff    	jne    14d4 <printf+0x22>
    }
  }
}
    1663:	c9                   	leave  
    1664:	c3                   	ret    

00001665 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1665:	55                   	push   %ebp
    1666:	89 e5                	mov    %esp,%ebp
    1668:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    166b:	8b 45 08             	mov    0x8(%ebp),%eax
    166e:	83 e8 08             	sub    $0x8,%eax
    1671:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1674:	a1 04 1c 00 00       	mov    0x1c04,%eax
    1679:	89 45 fc             	mov    %eax,-0x4(%ebp)
    167c:	eb 24                	jmp    16a2 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    167e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1681:	8b 00                	mov    (%eax),%eax
    1683:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1686:	77 12                	ja     169a <free+0x35>
    1688:	8b 45 f8             	mov    -0x8(%ebp),%eax
    168b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    168e:	77 24                	ja     16b4 <free+0x4f>
    1690:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1693:	8b 00                	mov    (%eax),%eax
    1695:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1698:	77 1a                	ja     16b4 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    169a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    169d:	8b 00                	mov    (%eax),%eax
    169f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16a5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16a8:	76 d4                	jbe    167e <free+0x19>
    16aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ad:	8b 00                	mov    (%eax),%eax
    16af:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16b2:	76 ca                	jbe    167e <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    16b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16b7:	8b 40 04             	mov    0x4(%eax),%eax
    16ba:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16c4:	01 c2                	add    %eax,%edx
    16c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c9:	8b 00                	mov    (%eax),%eax
    16cb:	39 c2                	cmp    %eax,%edx
    16cd:	75 24                	jne    16f3 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    16cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16d2:	8b 50 04             	mov    0x4(%eax),%edx
    16d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d8:	8b 00                	mov    (%eax),%eax
    16da:	8b 40 04             	mov    0x4(%eax),%eax
    16dd:	01 c2                	add    %eax,%edx
    16df:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16e2:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    16e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e8:	8b 00                	mov    (%eax),%eax
    16ea:	8b 10                	mov    (%eax),%edx
    16ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16ef:	89 10                	mov    %edx,(%eax)
    16f1:	eb 0a                	jmp    16fd <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    16f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16f6:	8b 10                	mov    (%eax),%edx
    16f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16fb:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    16fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1700:	8b 40 04             	mov    0x4(%eax),%eax
    1703:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    170a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    170d:	01 d0                	add    %edx,%eax
    170f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1712:	75 20                	jne    1734 <free+0xcf>
    p->s.size += bp->s.size;
    1714:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1717:	8b 50 04             	mov    0x4(%eax),%edx
    171a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    171d:	8b 40 04             	mov    0x4(%eax),%eax
    1720:	01 c2                	add    %eax,%edx
    1722:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1725:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1728:	8b 45 f8             	mov    -0x8(%ebp),%eax
    172b:	8b 10                	mov    (%eax),%edx
    172d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1730:	89 10                	mov    %edx,(%eax)
    1732:	eb 08                	jmp    173c <free+0xd7>
  } else
    p->s.ptr = bp;
    1734:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1737:	8b 55 f8             	mov    -0x8(%ebp),%edx
    173a:	89 10                	mov    %edx,(%eax)
  freep = p;
    173c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    173f:	a3 04 1c 00 00       	mov    %eax,0x1c04
}
    1744:	c9                   	leave  
    1745:	c3                   	ret    

00001746 <morecore>:

static Header*
morecore(uint nu)
{
    1746:	55                   	push   %ebp
    1747:	89 e5                	mov    %esp,%ebp
    1749:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    174c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1753:	77 07                	ja     175c <morecore+0x16>
    nu = 4096;
    1755:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    175c:	8b 45 08             	mov    0x8(%ebp),%eax
    175f:	c1 e0 03             	shl    $0x3,%eax
    1762:	89 04 24             	mov    %eax,(%esp)
    1765:	e8 40 fc ff ff       	call   13aa <sbrk>
    176a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    176d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1771:	75 07                	jne    177a <morecore+0x34>
    return 0;
    1773:	b8 00 00 00 00       	mov    $0x0,%eax
    1778:	eb 22                	jmp    179c <morecore+0x56>
  hp = (Header*)p;
    177a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    177d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1780:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1783:	8b 55 08             	mov    0x8(%ebp),%edx
    1786:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1789:	8b 45 f0             	mov    -0x10(%ebp),%eax
    178c:	83 c0 08             	add    $0x8,%eax
    178f:	89 04 24             	mov    %eax,(%esp)
    1792:	e8 ce fe ff ff       	call   1665 <free>
  return freep;
    1797:	a1 04 1c 00 00       	mov    0x1c04,%eax
}
    179c:	c9                   	leave  
    179d:	c3                   	ret    

0000179e <malloc>:

void*
malloc(uint nbytes)
{
    179e:	55                   	push   %ebp
    179f:	89 e5                	mov    %esp,%ebp
    17a1:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    17a4:	8b 45 08             	mov    0x8(%ebp),%eax
    17a7:	83 c0 07             	add    $0x7,%eax
    17aa:	c1 e8 03             	shr    $0x3,%eax
    17ad:	83 c0 01             	add    $0x1,%eax
    17b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    17b3:	a1 04 1c 00 00       	mov    0x1c04,%eax
    17b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    17bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    17bf:	75 23                	jne    17e4 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    17c1:	c7 45 f0 fc 1b 00 00 	movl   $0x1bfc,-0x10(%ebp)
    17c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17cb:	a3 04 1c 00 00       	mov    %eax,0x1c04
    17d0:	a1 04 1c 00 00       	mov    0x1c04,%eax
    17d5:	a3 fc 1b 00 00       	mov    %eax,0x1bfc
    base.s.size = 0;
    17da:	c7 05 00 1c 00 00 00 	movl   $0x0,0x1c00
    17e1:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17e7:	8b 00                	mov    (%eax),%eax
    17e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    17ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ef:	8b 40 04             	mov    0x4(%eax),%eax
    17f2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17f5:	72 4d                	jb     1844 <malloc+0xa6>
      if(p->s.size == nunits)
    17f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17fa:	8b 40 04             	mov    0x4(%eax),%eax
    17fd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1800:	75 0c                	jne    180e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1802:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1805:	8b 10                	mov    (%eax),%edx
    1807:	8b 45 f0             	mov    -0x10(%ebp),%eax
    180a:	89 10                	mov    %edx,(%eax)
    180c:	eb 26                	jmp    1834 <malloc+0x96>
      else {
        p->s.size -= nunits;
    180e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1811:	8b 40 04             	mov    0x4(%eax),%eax
    1814:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1817:	89 c2                	mov    %eax,%edx
    1819:	8b 45 f4             	mov    -0xc(%ebp),%eax
    181c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    181f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1822:	8b 40 04             	mov    0x4(%eax),%eax
    1825:	c1 e0 03             	shl    $0x3,%eax
    1828:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    182b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    182e:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1831:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1834:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1837:	a3 04 1c 00 00       	mov    %eax,0x1c04
      return (void*)(p + 1);
    183c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    183f:	83 c0 08             	add    $0x8,%eax
    1842:	eb 38                	jmp    187c <malloc+0xde>
    }
    if(p == freep)
    1844:	a1 04 1c 00 00       	mov    0x1c04,%eax
    1849:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    184c:	75 1b                	jne    1869 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    184e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1851:	89 04 24             	mov    %eax,(%esp)
    1854:	e8 ed fe ff ff       	call   1746 <morecore>
    1859:	89 45 f4             	mov    %eax,-0xc(%ebp)
    185c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1860:	75 07                	jne    1869 <malloc+0xcb>
        return 0;
    1862:	b8 00 00 00 00       	mov    $0x0,%eax
    1867:	eb 13                	jmp    187c <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1869:	8b 45 f4             	mov    -0xc(%ebp),%eax
    186c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    186f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1872:	8b 00                	mov    (%eax),%eax
    1874:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
    1877:	e9 70 ff ff ff       	jmp    17ec <malloc+0x4e>
}
    187c:	c9                   	leave  
    187d:	c3                   	ret    

0000187e <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    187e:	55                   	push   %ebp
    187f:	89 e5                	mov    %esp,%ebp
    1881:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1884:	8b 55 08             	mov    0x8(%ebp),%edx
    1887:	8b 45 0c             	mov    0xc(%ebp),%eax
    188a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    188d:	f0 87 02             	lock xchg %eax,(%edx)
    1890:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1893:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1896:	c9                   	leave  
    1897:	c3                   	ret    

00001898 <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    1898:	55                   	push   %ebp
    1899:	89 e5                	mov    %esp,%ebp
    189b:	83 ec 08             	sub    $0x8,%esp
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    189e:	90                   	nop
    189f:	8b 45 08             	mov    0x8(%ebp),%eax
    18a2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    18a9:	00 
    18aa:	89 04 24             	mov    %eax,(%esp)
    18ad:	e8 cc ff ff ff       	call   187e <xchg>
    18b2:	85 c0                	test   %eax,%eax
    18b4:	75 e9                	jne    189f <uacquire+0x7>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    18b6:	0f ae f0             	mfence 
}
    18b9:	c9                   	leave  
    18ba:	c3                   	ret    

000018bb <urelease>:

void urelease (struct uspinlock *lk) {
    18bb:	55                   	push   %ebp
    18bc:	89 e5                	mov    %esp,%ebp
  __sync_synchronize();
    18be:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    18c1:	8b 45 08             	mov    0x8(%ebp),%eax
    18c4:	8b 55 08             	mov    0x8(%ebp),%edx
    18c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    18cd:	5d                   	pop    %ebp
    18ce:	c3                   	ret    
