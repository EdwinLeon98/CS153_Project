
_forktest:     file format elf32-i386


Disassembly of section .text:

00001000 <printf>:

#define N  1000

void
printf(int fd, char *s, ...)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 18             	sub    $0x18,%esp
  write(fd, s, strlen(s));
    1006:	8b 45 0c             	mov    0xc(%ebp),%eax
    1009:	89 04 24             	mov    %eax,(%esp)
    100c:	e8 98 01 00 00       	call   11a9 <strlen>
    1011:	89 44 24 08          	mov    %eax,0x8(%esp)
    1015:	8b 45 0c             	mov    0xc(%ebp),%eax
    1018:	89 44 24 04          	mov    %eax,0x4(%esp)
    101c:	8b 45 08             	mov    0x8(%ebp),%eax
    101f:	89 04 24             	mov    %eax,(%esp)
    1022:	e8 76 03 00 00       	call   139d <write>
}
    1027:	c9                   	leave  
    1028:	c3                   	ret    

00001029 <forktest>:

void
forktest(void)
{
    1029:	55                   	push   %ebp
    102a:	89 e5                	mov    %esp,%ebp
    102c:	83 ec 28             	sub    $0x28,%esp
  int n, pid;

  printf(1, "fork test\n");
    102f:	c7 44 24 04 30 14 00 	movl   $0x1430,0x4(%esp)
    1036:	00 
    1037:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    103e:	e8 bd ff ff ff       	call   1000 <printf>

  for(n=0; n<N; n++){
    1043:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    104a:	eb 1f                	jmp    106b <forktest+0x42>
    pid = fork();
    104c:	e8 24 03 00 00       	call   1375 <fork>
    1051:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    1054:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1058:	79 02                	jns    105c <forktest+0x33>
      break;
    105a:	eb 18                	jmp    1074 <forktest+0x4b>
    if(pid == 0)
    105c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1060:	75 05                	jne    1067 <forktest+0x3e>
      exit();
    1062:	e8 16 03 00 00       	call   137d <exit>
  for(n=0; n<N; n++){
    1067:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    106b:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    1072:	7e d8                	jle    104c <forktest+0x23>
  }

  if(n == N){
    1074:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
    107b:	75 21                	jne    109e <forktest+0x75>
    printf(1, "fork claimed to work N times!\n", N);
    107d:	c7 44 24 08 e8 03 00 	movl   $0x3e8,0x8(%esp)
    1084:	00 
    1085:	c7 44 24 04 3c 14 00 	movl   $0x143c,0x4(%esp)
    108c:	00 
    108d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1094:	e8 67 ff ff ff       	call   1000 <printf>
    exit();
    1099:	e8 df 02 00 00       	call   137d <exit>
  }

  for(; n > 0; n--){
    109e:	eb 26                	jmp    10c6 <forktest+0x9d>
    if(wait() < 0){
    10a0:	e8 e0 02 00 00       	call   1385 <wait>
    10a5:	85 c0                	test   %eax,%eax
    10a7:	79 19                	jns    10c2 <forktest+0x99>
      printf(1, "wait stopped early\n");
    10a9:	c7 44 24 04 5b 14 00 	movl   $0x145b,0x4(%esp)
    10b0:	00 
    10b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10b8:	e8 43 ff ff ff       	call   1000 <printf>
      exit();
    10bd:	e8 bb 02 00 00       	call   137d <exit>
  for(; n > 0; n--){
    10c2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    10c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10ca:	7f d4                	jg     10a0 <forktest+0x77>
    }
  }

  if(wait() != -1){
    10cc:	e8 b4 02 00 00       	call   1385 <wait>
    10d1:	83 f8 ff             	cmp    $0xffffffff,%eax
    10d4:	74 19                	je     10ef <forktest+0xc6>
    printf(1, "wait got too many\n");
    10d6:	c7 44 24 04 6f 14 00 	movl   $0x146f,0x4(%esp)
    10dd:	00 
    10de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10e5:	e8 16 ff ff ff       	call   1000 <printf>
    exit();
    10ea:	e8 8e 02 00 00       	call   137d <exit>
  }

  printf(1, "fork test OK\n");
    10ef:	c7 44 24 04 82 14 00 	movl   $0x1482,0x4(%esp)
    10f6:	00 
    10f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10fe:	e8 fd fe ff ff       	call   1000 <printf>
}
    1103:	c9                   	leave  
    1104:	c3                   	ret    

00001105 <main>:

int
main(void)
{
    1105:	55                   	push   %ebp
    1106:	89 e5                	mov    %esp,%ebp
    1108:	83 e4 f0             	and    $0xfffffff0,%esp
  forktest();
    110b:	e8 19 ff ff ff       	call   1029 <forktest>
  exit();
    1110:	e8 68 02 00 00       	call   137d <exit>

00001115 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1115:	55                   	push   %ebp
    1116:	89 e5                	mov    %esp,%ebp
    1118:	57                   	push   %edi
    1119:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    111a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    111d:	8b 55 10             	mov    0x10(%ebp),%edx
    1120:	8b 45 0c             	mov    0xc(%ebp),%eax
    1123:	89 cb                	mov    %ecx,%ebx
    1125:	89 df                	mov    %ebx,%edi
    1127:	89 d1                	mov    %edx,%ecx
    1129:	fc                   	cld    
    112a:	f3 aa                	rep stos %al,%es:(%edi)
    112c:	89 ca                	mov    %ecx,%edx
    112e:	89 fb                	mov    %edi,%ebx
    1130:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1133:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1136:	5b                   	pop    %ebx
    1137:	5f                   	pop    %edi
    1138:	5d                   	pop    %ebp
    1139:	c3                   	ret    

0000113a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    113a:	55                   	push   %ebp
    113b:	89 e5                	mov    %esp,%ebp
    113d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1140:	8b 45 08             	mov    0x8(%ebp),%eax
    1143:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1146:	90                   	nop
    1147:	8b 45 08             	mov    0x8(%ebp),%eax
    114a:	8d 50 01             	lea    0x1(%eax),%edx
    114d:	89 55 08             	mov    %edx,0x8(%ebp)
    1150:	8b 55 0c             	mov    0xc(%ebp),%edx
    1153:	8d 4a 01             	lea    0x1(%edx),%ecx
    1156:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1159:	0f b6 12             	movzbl (%edx),%edx
    115c:	88 10                	mov    %dl,(%eax)
    115e:	0f b6 00             	movzbl (%eax),%eax
    1161:	84 c0                	test   %al,%al
    1163:	75 e2                	jne    1147 <strcpy+0xd>
    ;
  return os;
    1165:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1168:	c9                   	leave  
    1169:	c3                   	ret    

0000116a <strcmp>:

int
strcmp(const char *p, const char *q)
{
    116a:	55                   	push   %ebp
    116b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    116d:	eb 08                	jmp    1177 <strcmp+0xd>
    p++, q++;
    116f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1173:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
    1177:	8b 45 08             	mov    0x8(%ebp),%eax
    117a:	0f b6 00             	movzbl (%eax),%eax
    117d:	84 c0                	test   %al,%al
    117f:	74 10                	je     1191 <strcmp+0x27>
    1181:	8b 45 08             	mov    0x8(%ebp),%eax
    1184:	0f b6 10             	movzbl (%eax),%edx
    1187:	8b 45 0c             	mov    0xc(%ebp),%eax
    118a:	0f b6 00             	movzbl (%eax),%eax
    118d:	38 c2                	cmp    %al,%dl
    118f:	74 de                	je     116f <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
    1191:	8b 45 08             	mov    0x8(%ebp),%eax
    1194:	0f b6 00             	movzbl (%eax),%eax
    1197:	0f b6 d0             	movzbl %al,%edx
    119a:	8b 45 0c             	mov    0xc(%ebp),%eax
    119d:	0f b6 00             	movzbl (%eax),%eax
    11a0:	0f b6 c0             	movzbl %al,%eax
    11a3:	29 c2                	sub    %eax,%edx
    11a5:	89 d0                	mov    %edx,%eax
}
    11a7:	5d                   	pop    %ebp
    11a8:	c3                   	ret    

000011a9 <strlen>:

uint
strlen(char *s)
{
    11a9:	55                   	push   %ebp
    11aa:	89 e5                	mov    %esp,%ebp
    11ac:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    11af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    11b6:	eb 04                	jmp    11bc <strlen+0x13>
    11b8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    11bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11bf:	8b 45 08             	mov    0x8(%ebp),%eax
    11c2:	01 d0                	add    %edx,%eax
    11c4:	0f b6 00             	movzbl (%eax),%eax
    11c7:	84 c0                	test   %al,%al
    11c9:	75 ed                	jne    11b8 <strlen+0xf>
    ;
  return n;
    11cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11ce:	c9                   	leave  
    11cf:	c3                   	ret    

000011d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11d0:	55                   	push   %ebp
    11d1:	89 e5                	mov    %esp,%ebp
    11d3:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    11d6:	8b 45 10             	mov    0x10(%ebp),%eax
    11d9:	89 44 24 08          	mov    %eax,0x8(%esp)
    11dd:	8b 45 0c             	mov    0xc(%ebp),%eax
    11e0:	89 44 24 04          	mov    %eax,0x4(%esp)
    11e4:	8b 45 08             	mov    0x8(%ebp),%eax
    11e7:	89 04 24             	mov    %eax,(%esp)
    11ea:	e8 26 ff ff ff       	call   1115 <stosb>
  return dst;
    11ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11f2:	c9                   	leave  
    11f3:	c3                   	ret    

000011f4 <strchr>:

char*
strchr(const char *s, char c)
{
    11f4:	55                   	push   %ebp
    11f5:	89 e5                	mov    %esp,%ebp
    11f7:	83 ec 04             	sub    $0x4,%esp
    11fa:	8b 45 0c             	mov    0xc(%ebp),%eax
    11fd:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1200:	eb 14                	jmp    1216 <strchr+0x22>
    if(*s == c)
    1202:	8b 45 08             	mov    0x8(%ebp),%eax
    1205:	0f b6 00             	movzbl (%eax),%eax
    1208:	3a 45 fc             	cmp    -0x4(%ebp),%al
    120b:	75 05                	jne    1212 <strchr+0x1e>
      return (char*)s;
    120d:	8b 45 08             	mov    0x8(%ebp),%eax
    1210:	eb 13                	jmp    1225 <strchr+0x31>
  for(; *s; s++)
    1212:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1216:	8b 45 08             	mov    0x8(%ebp),%eax
    1219:	0f b6 00             	movzbl (%eax),%eax
    121c:	84 c0                	test   %al,%al
    121e:	75 e2                	jne    1202 <strchr+0xe>
  return 0;
    1220:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1225:	c9                   	leave  
    1226:	c3                   	ret    

00001227 <gets>:

char*
gets(char *buf, int max)
{
    1227:	55                   	push   %ebp
    1228:	89 e5                	mov    %esp,%ebp
    122a:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    122d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1234:	eb 4c                	jmp    1282 <gets+0x5b>
    cc = read(0, &c, 1);
    1236:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    123d:	00 
    123e:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1241:	89 44 24 04          	mov    %eax,0x4(%esp)
    1245:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    124c:	e8 44 01 00 00       	call   1395 <read>
    1251:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1254:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1258:	7f 02                	jg     125c <gets+0x35>
      break;
    125a:	eb 31                	jmp    128d <gets+0x66>
    buf[i++] = c;
    125c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    125f:	8d 50 01             	lea    0x1(%eax),%edx
    1262:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1265:	89 c2                	mov    %eax,%edx
    1267:	8b 45 08             	mov    0x8(%ebp),%eax
    126a:	01 c2                	add    %eax,%edx
    126c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1270:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1272:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1276:	3c 0a                	cmp    $0xa,%al
    1278:	74 13                	je     128d <gets+0x66>
    127a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    127e:	3c 0d                	cmp    $0xd,%al
    1280:	74 0b                	je     128d <gets+0x66>
  for(i=0; i+1 < max; ){
    1282:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1285:	83 c0 01             	add    $0x1,%eax
    1288:	3b 45 0c             	cmp    0xc(%ebp),%eax
    128b:	7c a9                	jl     1236 <gets+0xf>
      break;
  }
  buf[i] = '\0';
    128d:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1290:	8b 45 08             	mov    0x8(%ebp),%eax
    1293:	01 d0                	add    %edx,%eax
    1295:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1298:	8b 45 08             	mov    0x8(%ebp),%eax
}
    129b:	c9                   	leave  
    129c:	c3                   	ret    

0000129d <stat>:

int
stat(char *n, struct stat *st)
{
    129d:	55                   	push   %ebp
    129e:	89 e5                	mov    %esp,%ebp
    12a0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    12aa:	00 
    12ab:	8b 45 08             	mov    0x8(%ebp),%eax
    12ae:	89 04 24             	mov    %eax,(%esp)
    12b1:	e8 07 01 00 00       	call   13bd <open>
    12b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    12b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12bd:	79 07                	jns    12c6 <stat+0x29>
    return -1;
    12bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12c4:	eb 23                	jmp    12e9 <stat+0x4c>
  r = fstat(fd, st);
    12c6:	8b 45 0c             	mov    0xc(%ebp),%eax
    12c9:	89 44 24 04          	mov    %eax,0x4(%esp)
    12cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12d0:	89 04 24             	mov    %eax,(%esp)
    12d3:	e8 fd 00 00 00       	call   13d5 <fstat>
    12d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    12db:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12de:	89 04 24             	mov    %eax,(%esp)
    12e1:	e8 bf 00 00 00       	call   13a5 <close>
  return r;
    12e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    12e9:	c9                   	leave  
    12ea:	c3                   	ret    

000012eb <atoi>:

int
atoi(const char *s)
{
    12eb:	55                   	push   %ebp
    12ec:	89 e5                	mov    %esp,%ebp
    12ee:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    12f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    12f8:	eb 25                	jmp    131f <atoi+0x34>
    n = n*10 + *s++ - '0';
    12fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
    12fd:	89 d0                	mov    %edx,%eax
    12ff:	c1 e0 02             	shl    $0x2,%eax
    1302:	01 d0                	add    %edx,%eax
    1304:	01 c0                	add    %eax,%eax
    1306:	89 c1                	mov    %eax,%ecx
    1308:	8b 45 08             	mov    0x8(%ebp),%eax
    130b:	8d 50 01             	lea    0x1(%eax),%edx
    130e:	89 55 08             	mov    %edx,0x8(%ebp)
    1311:	0f b6 00             	movzbl (%eax),%eax
    1314:	0f be c0             	movsbl %al,%eax
    1317:	01 c8                	add    %ecx,%eax
    1319:	83 e8 30             	sub    $0x30,%eax
    131c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    131f:	8b 45 08             	mov    0x8(%ebp),%eax
    1322:	0f b6 00             	movzbl (%eax),%eax
    1325:	3c 2f                	cmp    $0x2f,%al
    1327:	7e 0a                	jle    1333 <atoi+0x48>
    1329:	8b 45 08             	mov    0x8(%ebp),%eax
    132c:	0f b6 00             	movzbl (%eax),%eax
    132f:	3c 39                	cmp    $0x39,%al
    1331:	7e c7                	jle    12fa <atoi+0xf>
  return n;
    1333:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1336:	c9                   	leave  
    1337:	c3                   	ret    

00001338 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1338:	55                   	push   %ebp
    1339:	89 e5                	mov    %esp,%ebp
    133b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    133e:	8b 45 08             	mov    0x8(%ebp),%eax
    1341:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1344:	8b 45 0c             	mov    0xc(%ebp),%eax
    1347:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    134a:	eb 17                	jmp    1363 <memmove+0x2b>
    *dst++ = *src++;
    134c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    134f:	8d 50 01             	lea    0x1(%eax),%edx
    1352:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1355:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1358:	8d 4a 01             	lea    0x1(%edx),%ecx
    135b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    135e:	0f b6 12             	movzbl (%edx),%edx
    1361:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
    1363:	8b 45 10             	mov    0x10(%ebp),%eax
    1366:	8d 50 ff             	lea    -0x1(%eax),%edx
    1369:	89 55 10             	mov    %edx,0x10(%ebp)
    136c:	85 c0                	test   %eax,%eax
    136e:	7f dc                	jg     134c <memmove+0x14>
  return vdst;
    1370:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1373:	c9                   	leave  
    1374:	c3                   	ret    

00001375 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1375:	b8 01 00 00 00       	mov    $0x1,%eax
    137a:	cd 40                	int    $0x40
    137c:	c3                   	ret    

0000137d <exit>:
SYSCALL(exit)
    137d:	b8 02 00 00 00       	mov    $0x2,%eax
    1382:	cd 40                	int    $0x40
    1384:	c3                   	ret    

00001385 <wait>:
SYSCALL(wait)
    1385:	b8 03 00 00 00       	mov    $0x3,%eax
    138a:	cd 40                	int    $0x40
    138c:	c3                   	ret    

0000138d <pipe>:
SYSCALL(pipe)
    138d:	b8 04 00 00 00       	mov    $0x4,%eax
    1392:	cd 40                	int    $0x40
    1394:	c3                   	ret    

00001395 <read>:
SYSCALL(read)
    1395:	b8 05 00 00 00       	mov    $0x5,%eax
    139a:	cd 40                	int    $0x40
    139c:	c3                   	ret    

0000139d <write>:
SYSCALL(write)
    139d:	b8 10 00 00 00       	mov    $0x10,%eax
    13a2:	cd 40                	int    $0x40
    13a4:	c3                   	ret    

000013a5 <close>:
SYSCALL(close)
    13a5:	b8 15 00 00 00       	mov    $0x15,%eax
    13aa:	cd 40                	int    $0x40
    13ac:	c3                   	ret    

000013ad <kill>:
SYSCALL(kill)
    13ad:	b8 06 00 00 00       	mov    $0x6,%eax
    13b2:	cd 40                	int    $0x40
    13b4:	c3                   	ret    

000013b5 <exec>:
SYSCALL(exec)
    13b5:	b8 07 00 00 00       	mov    $0x7,%eax
    13ba:	cd 40                	int    $0x40
    13bc:	c3                   	ret    

000013bd <open>:
SYSCALL(open)
    13bd:	b8 0f 00 00 00       	mov    $0xf,%eax
    13c2:	cd 40                	int    $0x40
    13c4:	c3                   	ret    

000013c5 <mknod>:
SYSCALL(mknod)
    13c5:	b8 11 00 00 00       	mov    $0x11,%eax
    13ca:	cd 40                	int    $0x40
    13cc:	c3                   	ret    

000013cd <unlink>:
SYSCALL(unlink)
    13cd:	b8 12 00 00 00       	mov    $0x12,%eax
    13d2:	cd 40                	int    $0x40
    13d4:	c3                   	ret    

000013d5 <fstat>:
SYSCALL(fstat)
    13d5:	b8 08 00 00 00       	mov    $0x8,%eax
    13da:	cd 40                	int    $0x40
    13dc:	c3                   	ret    

000013dd <link>:
SYSCALL(link)
    13dd:	b8 13 00 00 00       	mov    $0x13,%eax
    13e2:	cd 40                	int    $0x40
    13e4:	c3                   	ret    

000013e5 <mkdir>:
SYSCALL(mkdir)
    13e5:	b8 14 00 00 00       	mov    $0x14,%eax
    13ea:	cd 40                	int    $0x40
    13ec:	c3                   	ret    

000013ed <chdir>:
SYSCALL(chdir)
    13ed:	b8 09 00 00 00       	mov    $0x9,%eax
    13f2:	cd 40                	int    $0x40
    13f4:	c3                   	ret    

000013f5 <dup>:
SYSCALL(dup)
    13f5:	b8 0a 00 00 00       	mov    $0xa,%eax
    13fa:	cd 40                	int    $0x40
    13fc:	c3                   	ret    

000013fd <getpid>:
SYSCALL(getpid)
    13fd:	b8 0b 00 00 00       	mov    $0xb,%eax
    1402:	cd 40                	int    $0x40
    1404:	c3                   	ret    

00001405 <sbrk>:
SYSCALL(sbrk)
    1405:	b8 0c 00 00 00       	mov    $0xc,%eax
    140a:	cd 40                	int    $0x40
    140c:	c3                   	ret    

0000140d <sleep>:
SYSCALL(sleep)
    140d:	b8 0d 00 00 00       	mov    $0xd,%eax
    1412:	cd 40                	int    $0x40
    1414:	c3                   	ret    

00001415 <uptime>:
SYSCALL(uptime)
    1415:	b8 0e 00 00 00       	mov    $0xe,%eax
    141a:	cd 40                	int    $0x40
    141c:	c3                   	ret    

0000141d <shm_open>:
SYSCALL(shm_open)
    141d:	b8 16 00 00 00       	mov    $0x16,%eax
    1422:	cd 40                	int    $0x40
    1424:	c3                   	ret    

00001425 <shm_close>:
SYSCALL(shm_close)	
    1425:	b8 17 00 00 00       	mov    $0x17,%eax
    142a:	cd 40                	int    $0x40
    142c:	c3                   	ret    
