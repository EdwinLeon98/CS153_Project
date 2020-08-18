
_cat:     file format elf32-i386


Disassembly of section .text:

00001000 <cat>:

char buf[512];

void
cat(int fd)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
    1006:	eb 39                	jmp    1041 <cat+0x41>
    if (write(1, buf, n) != n) {
    1008:	8b 45 f4             	mov    -0xc(%ebp),%eax
    100b:	89 44 24 08          	mov    %eax,0x8(%esp)
    100f:	c7 44 24 04 a0 1c 00 	movl   $0x1ca0,0x4(%esp)
    1016:	00 
    1017:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    101e:	e8 a0 03 00 00       	call   13c3 <write>
    1023:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1026:	74 19                	je     1041 <cat+0x41>
      printf(1, "cat: write error\n");
    1028:	c7 44 24 04 50 19 00 	movl   $0x1950,0x4(%esp)
    102f:	00 
    1030:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1037:	e8 f7 04 00 00       	call   1533 <printf>
      exit();
    103c:	e8 62 03 00 00       	call   13a3 <exit>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
    1041:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    1048:	00 
    1049:	c7 44 24 04 a0 1c 00 	movl   $0x1ca0,0x4(%esp)
    1050:	00 
    1051:	8b 45 08             	mov    0x8(%ebp),%eax
    1054:	89 04 24             	mov    %eax,(%esp)
    1057:	e8 5f 03 00 00       	call   13bb <read>
    105c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    105f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1063:	7f a3                	jg     1008 <cat+0x8>
    }
  }
  if(n < 0){
    1065:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1069:	79 19                	jns    1084 <cat+0x84>
    printf(1, "cat: read error\n");
    106b:	c7 44 24 04 62 19 00 	movl   $0x1962,0x4(%esp)
    1072:	00 
    1073:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    107a:	e8 b4 04 00 00       	call   1533 <printf>
    exit();
    107f:	e8 1f 03 00 00       	call   13a3 <exit>
  }
}
    1084:	c9                   	leave  
    1085:	c3                   	ret    

00001086 <main>:

int
main(int argc, char *argv[])
{
    1086:	55                   	push   %ebp
    1087:	89 e5                	mov    %esp,%ebp
    1089:	83 e4 f0             	and    $0xfffffff0,%esp
    108c:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
    108f:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
    1093:	7f 11                	jg     10a6 <main+0x20>
    cat(0);
    1095:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    109c:	e8 5f ff ff ff       	call   1000 <cat>
    exit();
    10a1:	e8 fd 02 00 00       	call   13a3 <exit>
  }

  for(i = 1; i < argc; i++){
    10a6:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    10ad:	00 
    10ae:	eb 79                	jmp    1129 <main+0xa3>
    if((fd = open(argv[i], 0)) < 0){
    10b0:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    10b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    10bb:	8b 45 0c             	mov    0xc(%ebp),%eax
    10be:	01 d0                	add    %edx,%eax
    10c0:	8b 00                	mov    (%eax),%eax
    10c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    10c9:	00 
    10ca:	89 04 24             	mov    %eax,(%esp)
    10cd:	e8 11 03 00 00       	call   13e3 <open>
    10d2:	89 44 24 18          	mov    %eax,0x18(%esp)
    10d6:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
    10db:	79 2f                	jns    110c <main+0x86>
      printf(1, "cat: cannot open %s\n", argv[i]);
    10dd:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    10e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    10e8:	8b 45 0c             	mov    0xc(%ebp),%eax
    10eb:	01 d0                	add    %edx,%eax
    10ed:	8b 00                	mov    (%eax),%eax
    10ef:	89 44 24 08          	mov    %eax,0x8(%esp)
    10f3:	c7 44 24 04 73 19 00 	movl   $0x1973,0x4(%esp)
    10fa:	00 
    10fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1102:	e8 2c 04 00 00       	call   1533 <printf>
      exit();
    1107:	e8 97 02 00 00       	call   13a3 <exit>
    }
    cat(fd);
    110c:	8b 44 24 18          	mov    0x18(%esp),%eax
    1110:	89 04 24             	mov    %eax,(%esp)
    1113:	e8 e8 fe ff ff       	call   1000 <cat>
    close(fd);
    1118:	8b 44 24 18          	mov    0x18(%esp),%eax
    111c:	89 04 24             	mov    %eax,(%esp)
    111f:	e8 a7 02 00 00       	call   13cb <close>
  for(i = 1; i < argc; i++){
    1124:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
    1129:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    112d:	3b 45 08             	cmp    0x8(%ebp),%eax
    1130:	0f 8c 7a ff ff ff    	jl     10b0 <main+0x2a>
  }
  exit();
    1136:	e8 68 02 00 00       	call   13a3 <exit>

0000113b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    113b:	55                   	push   %ebp
    113c:	89 e5                	mov    %esp,%ebp
    113e:	57                   	push   %edi
    113f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1140:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1143:	8b 55 10             	mov    0x10(%ebp),%edx
    1146:	8b 45 0c             	mov    0xc(%ebp),%eax
    1149:	89 cb                	mov    %ecx,%ebx
    114b:	89 df                	mov    %ebx,%edi
    114d:	89 d1                	mov    %edx,%ecx
    114f:	fc                   	cld    
    1150:	f3 aa                	rep stos %al,%es:(%edi)
    1152:	89 ca                	mov    %ecx,%edx
    1154:	89 fb                	mov    %edi,%ebx
    1156:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1159:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    115c:	5b                   	pop    %ebx
    115d:	5f                   	pop    %edi
    115e:	5d                   	pop    %ebp
    115f:	c3                   	ret    

00001160 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1160:	55                   	push   %ebp
    1161:	89 e5                	mov    %esp,%ebp
    1163:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1166:	8b 45 08             	mov    0x8(%ebp),%eax
    1169:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    116c:	90                   	nop
    116d:	8b 45 08             	mov    0x8(%ebp),%eax
    1170:	8d 50 01             	lea    0x1(%eax),%edx
    1173:	89 55 08             	mov    %edx,0x8(%ebp)
    1176:	8b 55 0c             	mov    0xc(%ebp),%edx
    1179:	8d 4a 01             	lea    0x1(%edx),%ecx
    117c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    117f:	0f b6 12             	movzbl (%edx),%edx
    1182:	88 10                	mov    %dl,(%eax)
    1184:	0f b6 00             	movzbl (%eax),%eax
    1187:	84 c0                	test   %al,%al
    1189:	75 e2                	jne    116d <strcpy+0xd>
    ;
  return os;
    118b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    118e:	c9                   	leave  
    118f:	c3                   	ret    

00001190 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1190:	55                   	push   %ebp
    1191:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1193:	eb 08                	jmp    119d <strcmp+0xd>
    p++, q++;
    1195:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1199:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
    119d:	8b 45 08             	mov    0x8(%ebp),%eax
    11a0:	0f b6 00             	movzbl (%eax),%eax
    11a3:	84 c0                	test   %al,%al
    11a5:	74 10                	je     11b7 <strcmp+0x27>
    11a7:	8b 45 08             	mov    0x8(%ebp),%eax
    11aa:	0f b6 10             	movzbl (%eax),%edx
    11ad:	8b 45 0c             	mov    0xc(%ebp),%eax
    11b0:	0f b6 00             	movzbl (%eax),%eax
    11b3:	38 c2                	cmp    %al,%dl
    11b5:	74 de                	je     1195 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
    11b7:	8b 45 08             	mov    0x8(%ebp),%eax
    11ba:	0f b6 00             	movzbl (%eax),%eax
    11bd:	0f b6 d0             	movzbl %al,%edx
    11c0:	8b 45 0c             	mov    0xc(%ebp),%eax
    11c3:	0f b6 00             	movzbl (%eax),%eax
    11c6:	0f b6 c0             	movzbl %al,%eax
    11c9:	29 c2                	sub    %eax,%edx
    11cb:	89 d0                	mov    %edx,%eax
}
    11cd:	5d                   	pop    %ebp
    11ce:	c3                   	ret    

000011cf <strlen>:

uint
strlen(char *s)
{
    11cf:	55                   	push   %ebp
    11d0:	89 e5                	mov    %esp,%ebp
    11d2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    11d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    11dc:	eb 04                	jmp    11e2 <strlen+0x13>
    11de:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    11e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11e5:	8b 45 08             	mov    0x8(%ebp),%eax
    11e8:	01 d0                	add    %edx,%eax
    11ea:	0f b6 00             	movzbl (%eax),%eax
    11ed:	84 c0                	test   %al,%al
    11ef:	75 ed                	jne    11de <strlen+0xf>
    ;
  return n;
    11f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11f4:	c9                   	leave  
    11f5:	c3                   	ret    

000011f6 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11f6:	55                   	push   %ebp
    11f7:	89 e5                	mov    %esp,%ebp
    11f9:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    11fc:	8b 45 10             	mov    0x10(%ebp),%eax
    11ff:	89 44 24 08          	mov    %eax,0x8(%esp)
    1203:	8b 45 0c             	mov    0xc(%ebp),%eax
    1206:	89 44 24 04          	mov    %eax,0x4(%esp)
    120a:	8b 45 08             	mov    0x8(%ebp),%eax
    120d:	89 04 24             	mov    %eax,(%esp)
    1210:	e8 26 ff ff ff       	call   113b <stosb>
  return dst;
    1215:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1218:	c9                   	leave  
    1219:	c3                   	ret    

0000121a <strchr>:

char*
strchr(const char *s, char c)
{
    121a:	55                   	push   %ebp
    121b:	89 e5                	mov    %esp,%ebp
    121d:	83 ec 04             	sub    $0x4,%esp
    1220:	8b 45 0c             	mov    0xc(%ebp),%eax
    1223:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1226:	eb 14                	jmp    123c <strchr+0x22>
    if(*s == c)
    1228:	8b 45 08             	mov    0x8(%ebp),%eax
    122b:	0f b6 00             	movzbl (%eax),%eax
    122e:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1231:	75 05                	jne    1238 <strchr+0x1e>
      return (char*)s;
    1233:	8b 45 08             	mov    0x8(%ebp),%eax
    1236:	eb 13                	jmp    124b <strchr+0x31>
  for(; *s; s++)
    1238:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    123c:	8b 45 08             	mov    0x8(%ebp),%eax
    123f:	0f b6 00             	movzbl (%eax),%eax
    1242:	84 c0                	test   %al,%al
    1244:	75 e2                	jne    1228 <strchr+0xe>
  return 0;
    1246:	b8 00 00 00 00       	mov    $0x0,%eax
}
    124b:	c9                   	leave  
    124c:	c3                   	ret    

0000124d <gets>:

char*
gets(char *buf, int max)
{
    124d:	55                   	push   %ebp
    124e:	89 e5                	mov    %esp,%ebp
    1250:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1253:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    125a:	eb 4c                	jmp    12a8 <gets+0x5b>
    cc = read(0, &c, 1);
    125c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1263:	00 
    1264:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1267:	89 44 24 04          	mov    %eax,0x4(%esp)
    126b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1272:	e8 44 01 00 00       	call   13bb <read>
    1277:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    127a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    127e:	7f 02                	jg     1282 <gets+0x35>
      break;
    1280:	eb 31                	jmp    12b3 <gets+0x66>
    buf[i++] = c;
    1282:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1285:	8d 50 01             	lea    0x1(%eax),%edx
    1288:	89 55 f4             	mov    %edx,-0xc(%ebp)
    128b:	89 c2                	mov    %eax,%edx
    128d:	8b 45 08             	mov    0x8(%ebp),%eax
    1290:	01 c2                	add    %eax,%edx
    1292:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1296:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1298:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    129c:	3c 0a                	cmp    $0xa,%al
    129e:	74 13                	je     12b3 <gets+0x66>
    12a0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    12a4:	3c 0d                	cmp    $0xd,%al
    12a6:	74 0b                	je     12b3 <gets+0x66>
  for(i=0; i+1 < max; ){
    12a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12ab:	83 c0 01             	add    $0x1,%eax
    12ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
    12b1:	7c a9                	jl     125c <gets+0xf>
      break;
  }
  buf[i] = '\0';
    12b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
    12b6:	8b 45 08             	mov    0x8(%ebp),%eax
    12b9:	01 d0                	add    %edx,%eax
    12bb:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    12be:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12c1:	c9                   	leave  
    12c2:	c3                   	ret    

000012c3 <stat>:

int
stat(char *n, struct stat *st)
{
    12c3:	55                   	push   %ebp
    12c4:	89 e5                	mov    %esp,%ebp
    12c6:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    12d0:	00 
    12d1:	8b 45 08             	mov    0x8(%ebp),%eax
    12d4:	89 04 24             	mov    %eax,(%esp)
    12d7:	e8 07 01 00 00       	call   13e3 <open>
    12dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    12df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12e3:	79 07                	jns    12ec <stat+0x29>
    return -1;
    12e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12ea:	eb 23                	jmp    130f <stat+0x4c>
  r = fstat(fd, st);
    12ec:	8b 45 0c             	mov    0xc(%ebp),%eax
    12ef:	89 44 24 04          	mov    %eax,0x4(%esp)
    12f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12f6:	89 04 24             	mov    %eax,(%esp)
    12f9:	e8 fd 00 00 00       	call   13fb <fstat>
    12fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1301:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1304:	89 04 24             	mov    %eax,(%esp)
    1307:	e8 bf 00 00 00       	call   13cb <close>
  return r;
    130c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    130f:	c9                   	leave  
    1310:	c3                   	ret    

00001311 <atoi>:

int
atoi(const char *s)
{
    1311:	55                   	push   %ebp
    1312:	89 e5                	mov    %esp,%ebp
    1314:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1317:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    131e:	eb 25                	jmp    1345 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1320:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1323:	89 d0                	mov    %edx,%eax
    1325:	c1 e0 02             	shl    $0x2,%eax
    1328:	01 d0                	add    %edx,%eax
    132a:	01 c0                	add    %eax,%eax
    132c:	89 c1                	mov    %eax,%ecx
    132e:	8b 45 08             	mov    0x8(%ebp),%eax
    1331:	8d 50 01             	lea    0x1(%eax),%edx
    1334:	89 55 08             	mov    %edx,0x8(%ebp)
    1337:	0f b6 00             	movzbl (%eax),%eax
    133a:	0f be c0             	movsbl %al,%eax
    133d:	01 c8                	add    %ecx,%eax
    133f:	83 e8 30             	sub    $0x30,%eax
    1342:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1345:	8b 45 08             	mov    0x8(%ebp),%eax
    1348:	0f b6 00             	movzbl (%eax),%eax
    134b:	3c 2f                	cmp    $0x2f,%al
    134d:	7e 0a                	jle    1359 <atoi+0x48>
    134f:	8b 45 08             	mov    0x8(%ebp),%eax
    1352:	0f b6 00             	movzbl (%eax),%eax
    1355:	3c 39                	cmp    $0x39,%al
    1357:	7e c7                	jle    1320 <atoi+0xf>
  return n;
    1359:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    135c:	c9                   	leave  
    135d:	c3                   	ret    

0000135e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    135e:	55                   	push   %ebp
    135f:	89 e5                	mov    %esp,%ebp
    1361:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    1364:	8b 45 08             	mov    0x8(%ebp),%eax
    1367:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    136a:	8b 45 0c             	mov    0xc(%ebp),%eax
    136d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1370:	eb 17                	jmp    1389 <memmove+0x2b>
    *dst++ = *src++;
    1372:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1375:	8d 50 01             	lea    0x1(%eax),%edx
    1378:	89 55 fc             	mov    %edx,-0x4(%ebp)
    137b:	8b 55 f8             	mov    -0x8(%ebp),%edx
    137e:	8d 4a 01             	lea    0x1(%edx),%ecx
    1381:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1384:	0f b6 12             	movzbl (%edx),%edx
    1387:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
    1389:	8b 45 10             	mov    0x10(%ebp),%eax
    138c:	8d 50 ff             	lea    -0x1(%eax),%edx
    138f:	89 55 10             	mov    %edx,0x10(%ebp)
    1392:	85 c0                	test   %eax,%eax
    1394:	7f dc                	jg     1372 <memmove+0x14>
  return vdst;
    1396:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1399:	c9                   	leave  
    139a:	c3                   	ret    

0000139b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    139b:	b8 01 00 00 00       	mov    $0x1,%eax
    13a0:	cd 40                	int    $0x40
    13a2:	c3                   	ret    

000013a3 <exit>:
SYSCALL(exit)
    13a3:	b8 02 00 00 00       	mov    $0x2,%eax
    13a8:	cd 40                	int    $0x40
    13aa:	c3                   	ret    

000013ab <wait>:
SYSCALL(wait)
    13ab:	b8 03 00 00 00       	mov    $0x3,%eax
    13b0:	cd 40                	int    $0x40
    13b2:	c3                   	ret    

000013b3 <pipe>:
SYSCALL(pipe)
    13b3:	b8 04 00 00 00       	mov    $0x4,%eax
    13b8:	cd 40                	int    $0x40
    13ba:	c3                   	ret    

000013bb <read>:
SYSCALL(read)
    13bb:	b8 05 00 00 00       	mov    $0x5,%eax
    13c0:	cd 40                	int    $0x40
    13c2:	c3                   	ret    

000013c3 <write>:
SYSCALL(write)
    13c3:	b8 10 00 00 00       	mov    $0x10,%eax
    13c8:	cd 40                	int    $0x40
    13ca:	c3                   	ret    

000013cb <close>:
SYSCALL(close)
    13cb:	b8 15 00 00 00       	mov    $0x15,%eax
    13d0:	cd 40                	int    $0x40
    13d2:	c3                   	ret    

000013d3 <kill>:
SYSCALL(kill)
    13d3:	b8 06 00 00 00       	mov    $0x6,%eax
    13d8:	cd 40                	int    $0x40
    13da:	c3                   	ret    

000013db <exec>:
SYSCALL(exec)
    13db:	b8 07 00 00 00       	mov    $0x7,%eax
    13e0:	cd 40                	int    $0x40
    13e2:	c3                   	ret    

000013e3 <open>:
SYSCALL(open)
    13e3:	b8 0f 00 00 00       	mov    $0xf,%eax
    13e8:	cd 40                	int    $0x40
    13ea:	c3                   	ret    

000013eb <mknod>:
SYSCALL(mknod)
    13eb:	b8 11 00 00 00       	mov    $0x11,%eax
    13f0:	cd 40                	int    $0x40
    13f2:	c3                   	ret    

000013f3 <unlink>:
SYSCALL(unlink)
    13f3:	b8 12 00 00 00       	mov    $0x12,%eax
    13f8:	cd 40                	int    $0x40
    13fa:	c3                   	ret    

000013fb <fstat>:
SYSCALL(fstat)
    13fb:	b8 08 00 00 00       	mov    $0x8,%eax
    1400:	cd 40                	int    $0x40
    1402:	c3                   	ret    

00001403 <link>:
SYSCALL(link)
    1403:	b8 13 00 00 00       	mov    $0x13,%eax
    1408:	cd 40                	int    $0x40
    140a:	c3                   	ret    

0000140b <mkdir>:
SYSCALL(mkdir)
    140b:	b8 14 00 00 00       	mov    $0x14,%eax
    1410:	cd 40                	int    $0x40
    1412:	c3                   	ret    

00001413 <chdir>:
SYSCALL(chdir)
    1413:	b8 09 00 00 00       	mov    $0x9,%eax
    1418:	cd 40                	int    $0x40
    141a:	c3                   	ret    

0000141b <dup>:
SYSCALL(dup)
    141b:	b8 0a 00 00 00       	mov    $0xa,%eax
    1420:	cd 40                	int    $0x40
    1422:	c3                   	ret    

00001423 <getpid>:
SYSCALL(getpid)
    1423:	b8 0b 00 00 00       	mov    $0xb,%eax
    1428:	cd 40                	int    $0x40
    142a:	c3                   	ret    

0000142b <sbrk>:
SYSCALL(sbrk)
    142b:	b8 0c 00 00 00       	mov    $0xc,%eax
    1430:	cd 40                	int    $0x40
    1432:	c3                   	ret    

00001433 <sleep>:
SYSCALL(sleep)
    1433:	b8 0d 00 00 00       	mov    $0xd,%eax
    1438:	cd 40                	int    $0x40
    143a:	c3                   	ret    

0000143b <uptime>:
SYSCALL(uptime)
    143b:	b8 0e 00 00 00       	mov    $0xe,%eax
    1440:	cd 40                	int    $0x40
    1442:	c3                   	ret    

00001443 <shm_open>:
SYSCALL(shm_open)
    1443:	b8 16 00 00 00       	mov    $0x16,%eax
    1448:	cd 40                	int    $0x40
    144a:	c3                   	ret    

0000144b <shm_close>:
SYSCALL(shm_close)	
    144b:	b8 17 00 00 00       	mov    $0x17,%eax
    1450:	cd 40                	int    $0x40
    1452:	c3                   	ret    

00001453 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1453:	55                   	push   %ebp
    1454:	89 e5                	mov    %esp,%ebp
    1456:	83 ec 18             	sub    $0x18,%esp
    1459:	8b 45 0c             	mov    0xc(%ebp),%eax
    145c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    145f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1466:	00 
    1467:	8d 45 f4             	lea    -0xc(%ebp),%eax
    146a:	89 44 24 04          	mov    %eax,0x4(%esp)
    146e:	8b 45 08             	mov    0x8(%ebp),%eax
    1471:	89 04 24             	mov    %eax,(%esp)
    1474:	e8 4a ff ff ff       	call   13c3 <write>
}
    1479:	c9                   	leave  
    147a:	c3                   	ret    

0000147b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    147b:	55                   	push   %ebp
    147c:	89 e5                	mov    %esp,%ebp
    147e:	56                   	push   %esi
    147f:	53                   	push   %ebx
    1480:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1483:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    148a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    148e:	74 17                	je     14a7 <printint+0x2c>
    1490:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1494:	79 11                	jns    14a7 <printint+0x2c>
    neg = 1;
    1496:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    149d:	8b 45 0c             	mov    0xc(%ebp),%eax
    14a0:	f7 d8                	neg    %eax
    14a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14a5:	eb 06                	jmp    14ad <printint+0x32>
  } else {
    x = xx;
    14a7:	8b 45 0c             	mov    0xc(%ebp),%eax
    14aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    14ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    14b4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    14b7:	8d 41 01             	lea    0x1(%ecx),%eax
    14ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    14bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
    14c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14c3:	ba 00 00 00 00       	mov    $0x0,%edx
    14c8:	f7 f3                	div    %ebx
    14ca:	89 d0                	mov    %edx,%eax
    14cc:	0f b6 80 54 1c 00 00 	movzbl 0x1c54(%eax),%eax
    14d3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    14d7:	8b 75 10             	mov    0x10(%ebp),%esi
    14da:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14dd:	ba 00 00 00 00       	mov    $0x0,%edx
    14e2:	f7 f6                	div    %esi
    14e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14eb:	75 c7                	jne    14b4 <printint+0x39>
  if(neg)
    14ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    14f1:	74 10                	je     1503 <printint+0x88>
    buf[i++] = '-';
    14f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14f6:	8d 50 01             	lea    0x1(%eax),%edx
    14f9:	89 55 f4             	mov    %edx,-0xc(%ebp)
    14fc:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1501:	eb 1f                	jmp    1522 <printint+0xa7>
    1503:	eb 1d                	jmp    1522 <printint+0xa7>
    putc(fd, buf[i]);
    1505:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1508:	8b 45 f4             	mov    -0xc(%ebp),%eax
    150b:	01 d0                	add    %edx,%eax
    150d:	0f b6 00             	movzbl (%eax),%eax
    1510:	0f be c0             	movsbl %al,%eax
    1513:	89 44 24 04          	mov    %eax,0x4(%esp)
    1517:	8b 45 08             	mov    0x8(%ebp),%eax
    151a:	89 04 24             	mov    %eax,(%esp)
    151d:	e8 31 ff ff ff       	call   1453 <putc>
  while(--i >= 0)
    1522:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1526:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    152a:	79 d9                	jns    1505 <printint+0x8a>
}
    152c:	83 c4 30             	add    $0x30,%esp
    152f:	5b                   	pop    %ebx
    1530:	5e                   	pop    %esi
    1531:	5d                   	pop    %ebp
    1532:	c3                   	ret    

00001533 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1533:	55                   	push   %ebp
    1534:	89 e5                	mov    %esp,%ebp
    1536:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1539:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1540:	8d 45 0c             	lea    0xc(%ebp),%eax
    1543:	83 c0 04             	add    $0x4,%eax
    1546:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1549:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1550:	e9 7c 01 00 00       	jmp    16d1 <printf+0x19e>
    c = fmt[i] & 0xff;
    1555:	8b 55 0c             	mov    0xc(%ebp),%edx
    1558:	8b 45 f0             	mov    -0x10(%ebp),%eax
    155b:	01 d0                	add    %edx,%eax
    155d:	0f b6 00             	movzbl (%eax),%eax
    1560:	0f be c0             	movsbl %al,%eax
    1563:	25 ff 00 00 00       	and    $0xff,%eax
    1568:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    156b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    156f:	75 2c                	jne    159d <printf+0x6a>
      if(c == '%'){
    1571:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1575:	75 0c                	jne    1583 <printf+0x50>
        state = '%';
    1577:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    157e:	e9 4a 01 00 00       	jmp    16cd <printf+0x19a>
      } else {
        putc(fd, c);
    1583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1586:	0f be c0             	movsbl %al,%eax
    1589:	89 44 24 04          	mov    %eax,0x4(%esp)
    158d:	8b 45 08             	mov    0x8(%ebp),%eax
    1590:	89 04 24             	mov    %eax,(%esp)
    1593:	e8 bb fe ff ff       	call   1453 <putc>
    1598:	e9 30 01 00 00       	jmp    16cd <printf+0x19a>
      }
    } else if(state == '%'){
    159d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    15a1:	0f 85 26 01 00 00    	jne    16cd <printf+0x19a>
      if(c == 'd'){
    15a7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    15ab:	75 2d                	jne    15da <printf+0xa7>
        printint(fd, *ap, 10, 1);
    15ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15b0:	8b 00                	mov    (%eax),%eax
    15b2:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    15b9:	00 
    15ba:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    15c1:	00 
    15c2:	89 44 24 04          	mov    %eax,0x4(%esp)
    15c6:	8b 45 08             	mov    0x8(%ebp),%eax
    15c9:	89 04 24             	mov    %eax,(%esp)
    15cc:	e8 aa fe ff ff       	call   147b <printint>
        ap++;
    15d1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15d5:	e9 ec 00 00 00       	jmp    16c6 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    15da:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    15de:	74 06                	je     15e6 <printf+0xb3>
    15e0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    15e4:	75 2d                	jne    1613 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    15e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15e9:	8b 00                	mov    (%eax),%eax
    15eb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    15f2:	00 
    15f3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    15fa:	00 
    15fb:	89 44 24 04          	mov    %eax,0x4(%esp)
    15ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1602:	89 04 24             	mov    %eax,(%esp)
    1605:	e8 71 fe ff ff       	call   147b <printint>
        ap++;
    160a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    160e:	e9 b3 00 00 00       	jmp    16c6 <printf+0x193>
      } else if(c == 's'){
    1613:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1617:	75 45                	jne    165e <printf+0x12b>
        s = (char*)*ap;
    1619:	8b 45 e8             	mov    -0x18(%ebp),%eax
    161c:	8b 00                	mov    (%eax),%eax
    161e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1621:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1625:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1629:	75 09                	jne    1634 <printf+0x101>
          s = "(null)";
    162b:	c7 45 f4 88 19 00 00 	movl   $0x1988,-0xc(%ebp)
        while(*s != 0){
    1632:	eb 1e                	jmp    1652 <printf+0x11f>
    1634:	eb 1c                	jmp    1652 <printf+0x11f>
          putc(fd, *s);
    1636:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1639:	0f b6 00             	movzbl (%eax),%eax
    163c:	0f be c0             	movsbl %al,%eax
    163f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1643:	8b 45 08             	mov    0x8(%ebp),%eax
    1646:	89 04 24             	mov    %eax,(%esp)
    1649:	e8 05 fe ff ff       	call   1453 <putc>
          s++;
    164e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
    1652:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1655:	0f b6 00             	movzbl (%eax),%eax
    1658:	84 c0                	test   %al,%al
    165a:	75 da                	jne    1636 <printf+0x103>
    165c:	eb 68                	jmp    16c6 <printf+0x193>
        }
      } else if(c == 'c'){
    165e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1662:	75 1d                	jne    1681 <printf+0x14e>
        putc(fd, *ap);
    1664:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1667:	8b 00                	mov    (%eax),%eax
    1669:	0f be c0             	movsbl %al,%eax
    166c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1670:	8b 45 08             	mov    0x8(%ebp),%eax
    1673:	89 04 24             	mov    %eax,(%esp)
    1676:	e8 d8 fd ff ff       	call   1453 <putc>
        ap++;
    167b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    167f:	eb 45                	jmp    16c6 <printf+0x193>
      } else if(c == '%'){
    1681:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1685:	75 17                	jne    169e <printf+0x16b>
        putc(fd, c);
    1687:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    168a:	0f be c0             	movsbl %al,%eax
    168d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1691:	8b 45 08             	mov    0x8(%ebp),%eax
    1694:	89 04 24             	mov    %eax,(%esp)
    1697:	e8 b7 fd ff ff       	call   1453 <putc>
    169c:	eb 28                	jmp    16c6 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    169e:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    16a5:	00 
    16a6:	8b 45 08             	mov    0x8(%ebp),%eax
    16a9:	89 04 24             	mov    %eax,(%esp)
    16ac:	e8 a2 fd ff ff       	call   1453 <putc>
        putc(fd, c);
    16b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    16b4:	0f be c0             	movsbl %al,%eax
    16b7:	89 44 24 04          	mov    %eax,0x4(%esp)
    16bb:	8b 45 08             	mov    0x8(%ebp),%eax
    16be:	89 04 24             	mov    %eax,(%esp)
    16c1:	e8 8d fd ff ff       	call   1453 <putc>
      }
      state = 0;
    16c6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    16cd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    16d1:	8b 55 0c             	mov    0xc(%ebp),%edx
    16d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16d7:	01 d0                	add    %edx,%eax
    16d9:	0f b6 00             	movzbl (%eax),%eax
    16dc:	84 c0                	test   %al,%al
    16de:	0f 85 71 fe ff ff    	jne    1555 <printf+0x22>
    }
  }
}
    16e4:	c9                   	leave  
    16e5:	c3                   	ret    

000016e6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16e6:	55                   	push   %ebp
    16e7:	89 e5                	mov    %esp,%ebp
    16e9:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    16ec:	8b 45 08             	mov    0x8(%ebp),%eax
    16ef:	83 e8 08             	sub    $0x8,%eax
    16f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16f5:	a1 88 1c 00 00       	mov    0x1c88,%eax
    16fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16fd:	eb 24                	jmp    1723 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1702:	8b 00                	mov    (%eax),%eax
    1704:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1707:	77 12                	ja     171b <free+0x35>
    1709:	8b 45 f8             	mov    -0x8(%ebp),%eax
    170c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    170f:	77 24                	ja     1735 <free+0x4f>
    1711:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1714:	8b 00                	mov    (%eax),%eax
    1716:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1719:	77 1a                	ja     1735 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    171b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    171e:	8b 00                	mov    (%eax),%eax
    1720:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1723:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1726:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1729:	76 d4                	jbe    16ff <free+0x19>
    172b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    172e:	8b 00                	mov    (%eax),%eax
    1730:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1733:	76 ca                	jbe    16ff <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1735:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1738:	8b 40 04             	mov    0x4(%eax),%eax
    173b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1742:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1745:	01 c2                	add    %eax,%edx
    1747:	8b 45 fc             	mov    -0x4(%ebp),%eax
    174a:	8b 00                	mov    (%eax),%eax
    174c:	39 c2                	cmp    %eax,%edx
    174e:	75 24                	jne    1774 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1750:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1753:	8b 50 04             	mov    0x4(%eax),%edx
    1756:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1759:	8b 00                	mov    (%eax),%eax
    175b:	8b 40 04             	mov    0x4(%eax),%eax
    175e:	01 c2                	add    %eax,%edx
    1760:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1763:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1766:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1769:	8b 00                	mov    (%eax),%eax
    176b:	8b 10                	mov    (%eax),%edx
    176d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1770:	89 10                	mov    %edx,(%eax)
    1772:	eb 0a                	jmp    177e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1774:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1777:	8b 10                	mov    (%eax),%edx
    1779:	8b 45 f8             	mov    -0x8(%ebp),%eax
    177c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    177e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1781:	8b 40 04             	mov    0x4(%eax),%eax
    1784:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    178b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    178e:	01 d0                	add    %edx,%eax
    1790:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1793:	75 20                	jne    17b5 <free+0xcf>
    p->s.size += bp->s.size;
    1795:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1798:	8b 50 04             	mov    0x4(%eax),%edx
    179b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    179e:	8b 40 04             	mov    0x4(%eax),%eax
    17a1:	01 c2                	add    %eax,%edx
    17a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17a6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    17a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17ac:	8b 10                	mov    (%eax),%edx
    17ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17b1:	89 10                	mov    %edx,(%eax)
    17b3:	eb 08                	jmp    17bd <free+0xd7>
  } else
    p->s.ptr = bp;
    17b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
    17bb:	89 10                	mov    %edx,(%eax)
  freep = p;
    17bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17c0:	a3 88 1c 00 00       	mov    %eax,0x1c88
}
    17c5:	c9                   	leave  
    17c6:	c3                   	ret    

000017c7 <morecore>:

static Header*
morecore(uint nu)
{
    17c7:	55                   	push   %ebp
    17c8:	89 e5                	mov    %esp,%ebp
    17ca:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    17cd:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    17d4:	77 07                	ja     17dd <morecore+0x16>
    nu = 4096;
    17d6:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    17dd:	8b 45 08             	mov    0x8(%ebp),%eax
    17e0:	c1 e0 03             	shl    $0x3,%eax
    17e3:	89 04 24             	mov    %eax,(%esp)
    17e6:	e8 40 fc ff ff       	call   142b <sbrk>
    17eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    17ee:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    17f2:	75 07                	jne    17fb <morecore+0x34>
    return 0;
    17f4:	b8 00 00 00 00       	mov    $0x0,%eax
    17f9:	eb 22                	jmp    181d <morecore+0x56>
  hp = (Header*)p;
    17fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1801:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1804:	8b 55 08             	mov    0x8(%ebp),%edx
    1807:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    180a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    180d:	83 c0 08             	add    $0x8,%eax
    1810:	89 04 24             	mov    %eax,(%esp)
    1813:	e8 ce fe ff ff       	call   16e6 <free>
  return freep;
    1818:	a1 88 1c 00 00       	mov    0x1c88,%eax
}
    181d:	c9                   	leave  
    181e:	c3                   	ret    

0000181f <malloc>:

void*
malloc(uint nbytes)
{
    181f:	55                   	push   %ebp
    1820:	89 e5                	mov    %esp,%ebp
    1822:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1825:	8b 45 08             	mov    0x8(%ebp),%eax
    1828:	83 c0 07             	add    $0x7,%eax
    182b:	c1 e8 03             	shr    $0x3,%eax
    182e:	83 c0 01             	add    $0x1,%eax
    1831:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1834:	a1 88 1c 00 00       	mov    0x1c88,%eax
    1839:	89 45 f0             	mov    %eax,-0x10(%ebp)
    183c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1840:	75 23                	jne    1865 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1842:	c7 45 f0 80 1c 00 00 	movl   $0x1c80,-0x10(%ebp)
    1849:	8b 45 f0             	mov    -0x10(%ebp),%eax
    184c:	a3 88 1c 00 00       	mov    %eax,0x1c88
    1851:	a1 88 1c 00 00       	mov    0x1c88,%eax
    1856:	a3 80 1c 00 00       	mov    %eax,0x1c80
    base.s.size = 0;
    185b:	c7 05 84 1c 00 00 00 	movl   $0x0,0x1c84
    1862:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1865:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1868:	8b 00                	mov    (%eax),%eax
    186a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    186d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1870:	8b 40 04             	mov    0x4(%eax),%eax
    1873:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1876:	72 4d                	jb     18c5 <malloc+0xa6>
      if(p->s.size == nunits)
    1878:	8b 45 f4             	mov    -0xc(%ebp),%eax
    187b:	8b 40 04             	mov    0x4(%eax),%eax
    187e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1881:	75 0c                	jne    188f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1883:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1886:	8b 10                	mov    (%eax),%edx
    1888:	8b 45 f0             	mov    -0x10(%ebp),%eax
    188b:	89 10                	mov    %edx,(%eax)
    188d:	eb 26                	jmp    18b5 <malloc+0x96>
      else {
        p->s.size -= nunits;
    188f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1892:	8b 40 04             	mov    0x4(%eax),%eax
    1895:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1898:	89 c2                	mov    %eax,%edx
    189a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    189d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    18a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18a3:	8b 40 04             	mov    0x4(%eax),%eax
    18a6:	c1 e0 03             	shl    $0x3,%eax
    18a9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    18ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18af:	8b 55 ec             	mov    -0x14(%ebp),%edx
    18b2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    18b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18b8:	a3 88 1c 00 00       	mov    %eax,0x1c88
      return (void*)(p + 1);
    18bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18c0:	83 c0 08             	add    $0x8,%eax
    18c3:	eb 38                	jmp    18fd <malloc+0xde>
    }
    if(p == freep)
    18c5:	a1 88 1c 00 00       	mov    0x1c88,%eax
    18ca:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    18cd:	75 1b                	jne    18ea <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    18cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
    18d2:	89 04 24             	mov    %eax,(%esp)
    18d5:	e8 ed fe ff ff       	call   17c7 <morecore>
    18da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    18dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18e1:	75 07                	jne    18ea <malloc+0xcb>
        return 0;
    18e3:	b8 00 00 00 00       	mov    $0x0,%eax
    18e8:	eb 13                	jmp    18fd <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18f3:	8b 00                	mov    (%eax),%eax
    18f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
    18f8:	e9 70 ff ff ff       	jmp    186d <malloc+0x4e>
}
    18fd:	c9                   	leave  
    18fe:	c3                   	ret    

000018ff <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    18ff:	55                   	push   %ebp
    1900:	89 e5                	mov    %esp,%ebp
    1902:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1905:	8b 55 08             	mov    0x8(%ebp),%edx
    1908:	8b 45 0c             	mov    0xc(%ebp),%eax
    190b:	8b 4d 08             	mov    0x8(%ebp),%ecx
    190e:	f0 87 02             	lock xchg %eax,(%edx)
    1911:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1914:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1917:	c9                   	leave  
    1918:	c3                   	ret    

00001919 <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    1919:	55                   	push   %ebp
    191a:	89 e5                	mov    %esp,%ebp
    191c:	83 ec 08             	sub    $0x8,%esp
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    191f:	90                   	nop
    1920:	8b 45 08             	mov    0x8(%ebp),%eax
    1923:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    192a:	00 
    192b:	89 04 24             	mov    %eax,(%esp)
    192e:	e8 cc ff ff ff       	call   18ff <xchg>
    1933:	85 c0                	test   %eax,%eax
    1935:	75 e9                	jne    1920 <uacquire+0x7>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    1937:	0f ae f0             	mfence 
}
    193a:	c9                   	leave  
    193b:	c3                   	ret    

0000193c <urelease>:

void urelease (struct uspinlock *lk) {
    193c:	55                   	push   %ebp
    193d:	89 e5                	mov    %esp,%ebp
  __sync_synchronize();
    193f:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    1942:	8b 45 08             	mov    0x8(%ebp),%eax
    1945:	8b 55 08             	mov    0x8(%ebp),%edx
    1948:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    194e:	5d                   	pop    %ebp
    194f:	c3                   	ret    
