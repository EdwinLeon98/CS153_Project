
_wc:     file format elf32-i386


Disassembly of section .text:

00001000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 48             	sub    $0x48,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
    1006:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    100d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1010:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1013:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1016:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
    1019:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1020:	eb 68                	jmp    108a <wc+0x8a>
    for(i=0; i<n; i++){
    1022:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1029:	eb 57                	jmp    1082 <wc+0x82>
      c++;
    102b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
    102f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1032:	05 40 1d 00 00       	add    $0x1d40,%eax
    1037:	0f b6 00             	movzbl (%eax),%eax
    103a:	3c 0a                	cmp    $0xa,%al
    103c:	75 04                	jne    1042 <wc+0x42>
        l++;
    103e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
    1042:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1045:	05 40 1d 00 00       	add    $0x1d40,%eax
    104a:	0f b6 00             	movzbl (%eax),%eax
    104d:	0f be c0             	movsbl %al,%eax
    1050:	89 44 24 04          	mov    %eax,0x4(%esp)
    1054:	c7 04 24 ee 19 00 00 	movl   $0x19ee,(%esp)
    105b:	e8 58 02 00 00       	call   12b8 <strchr>
    1060:	85 c0                	test   %eax,%eax
    1062:	74 09                	je     106d <wc+0x6d>
        inword = 0;
    1064:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    106b:	eb 11                	jmp    107e <wc+0x7e>
      else if(!inword){
    106d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    1071:	75 0b                	jne    107e <wc+0x7e>
        w++;
    1073:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
    1077:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    for(i=0; i<n; i++){
    107e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1082:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1085:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    1088:	7c a1                	jl     102b <wc+0x2b>
  while((n = read(fd, buf, sizeof(buf))) > 0){
    108a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    1091:	00 
    1092:	c7 44 24 04 40 1d 00 	movl   $0x1d40,0x4(%esp)
    1099:	00 
    109a:	8b 45 08             	mov    0x8(%ebp),%eax
    109d:	89 04 24             	mov    %eax,(%esp)
    10a0:	e8 b4 03 00 00       	call   1459 <read>
    10a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    10a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    10ac:	0f 8f 70 ff ff ff    	jg     1022 <wc+0x22>
      }
    }
  }
  if(n < 0){
    10b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    10b6:	79 19                	jns    10d1 <wc+0xd1>
    printf(1, "wc: read error\n");
    10b8:	c7 44 24 04 f4 19 00 	movl   $0x19f4,0x4(%esp)
    10bf:	00 
    10c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10c7:	e8 05 05 00 00       	call   15d1 <printf>
    exit();
    10cc:	e8 70 03 00 00       	call   1441 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
    10d1:	8b 45 0c             	mov    0xc(%ebp),%eax
    10d4:	89 44 24 14          	mov    %eax,0x14(%esp)
    10d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10db:	89 44 24 10          	mov    %eax,0x10(%esp)
    10df:	8b 45 ec             	mov    -0x14(%ebp),%eax
    10e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
    10e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10e9:	89 44 24 08          	mov    %eax,0x8(%esp)
    10ed:	c7 44 24 04 04 1a 00 	movl   $0x1a04,0x4(%esp)
    10f4:	00 
    10f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10fc:	e8 d0 04 00 00       	call   15d1 <printf>
}
    1101:	c9                   	leave  
    1102:	c3                   	ret    

00001103 <main>:

int
main(int argc, char *argv[])
{
    1103:	55                   	push   %ebp
    1104:	89 e5                	mov    %esp,%ebp
    1106:	83 e4 f0             	and    $0xfffffff0,%esp
    1109:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
    110c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
    1110:	7f 19                	jg     112b <main+0x28>
    wc(0, "");
    1112:	c7 44 24 04 11 1a 00 	movl   $0x1a11,0x4(%esp)
    1119:	00 
    111a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1121:	e8 da fe ff ff       	call   1000 <wc>
    exit();
    1126:	e8 16 03 00 00       	call   1441 <exit>
  }

  for(i = 1; i < argc; i++){
    112b:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    1132:	00 
    1133:	e9 8f 00 00 00       	jmp    11c7 <main+0xc4>
    if((fd = open(argv[i], 0)) < 0){
    1138:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    113c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1143:	8b 45 0c             	mov    0xc(%ebp),%eax
    1146:	01 d0                	add    %edx,%eax
    1148:	8b 00                	mov    (%eax),%eax
    114a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1151:	00 
    1152:	89 04 24             	mov    %eax,(%esp)
    1155:	e8 27 03 00 00       	call   1481 <open>
    115a:	89 44 24 18          	mov    %eax,0x18(%esp)
    115e:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
    1163:	79 2f                	jns    1194 <main+0x91>
      printf(1, "wc: cannot open %s\n", argv[i]);
    1165:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1169:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1170:	8b 45 0c             	mov    0xc(%ebp),%eax
    1173:	01 d0                	add    %edx,%eax
    1175:	8b 00                	mov    (%eax),%eax
    1177:	89 44 24 08          	mov    %eax,0x8(%esp)
    117b:	c7 44 24 04 12 1a 00 	movl   $0x1a12,0x4(%esp)
    1182:	00 
    1183:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    118a:	e8 42 04 00 00       	call   15d1 <printf>
      exit();
    118f:	e8 ad 02 00 00       	call   1441 <exit>
    }
    wc(fd, argv[i]);
    1194:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1198:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    119f:	8b 45 0c             	mov    0xc(%ebp),%eax
    11a2:	01 d0                	add    %edx,%eax
    11a4:	8b 00                	mov    (%eax),%eax
    11a6:	89 44 24 04          	mov    %eax,0x4(%esp)
    11aa:	8b 44 24 18          	mov    0x18(%esp),%eax
    11ae:	89 04 24             	mov    %eax,(%esp)
    11b1:	e8 4a fe ff ff       	call   1000 <wc>
    close(fd);
    11b6:	8b 44 24 18          	mov    0x18(%esp),%eax
    11ba:	89 04 24             	mov    %eax,(%esp)
    11bd:	e8 a7 02 00 00       	call   1469 <close>
  for(i = 1; i < argc; i++){
    11c2:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
    11c7:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    11cb:	3b 45 08             	cmp    0x8(%ebp),%eax
    11ce:	0f 8c 64 ff ff ff    	jl     1138 <main+0x35>
  }
  exit();
    11d4:	e8 68 02 00 00       	call   1441 <exit>

000011d9 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    11d9:	55                   	push   %ebp
    11da:	89 e5                	mov    %esp,%ebp
    11dc:	57                   	push   %edi
    11dd:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    11de:	8b 4d 08             	mov    0x8(%ebp),%ecx
    11e1:	8b 55 10             	mov    0x10(%ebp),%edx
    11e4:	8b 45 0c             	mov    0xc(%ebp),%eax
    11e7:	89 cb                	mov    %ecx,%ebx
    11e9:	89 df                	mov    %ebx,%edi
    11eb:	89 d1                	mov    %edx,%ecx
    11ed:	fc                   	cld    
    11ee:	f3 aa                	rep stos %al,%es:(%edi)
    11f0:	89 ca                	mov    %ecx,%edx
    11f2:	89 fb                	mov    %edi,%ebx
    11f4:	89 5d 08             	mov    %ebx,0x8(%ebp)
    11f7:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    11fa:	5b                   	pop    %ebx
    11fb:	5f                   	pop    %edi
    11fc:	5d                   	pop    %ebp
    11fd:	c3                   	ret    

000011fe <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    11fe:	55                   	push   %ebp
    11ff:	89 e5                	mov    %esp,%ebp
    1201:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1204:	8b 45 08             	mov    0x8(%ebp),%eax
    1207:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    120a:	90                   	nop
    120b:	8b 45 08             	mov    0x8(%ebp),%eax
    120e:	8d 50 01             	lea    0x1(%eax),%edx
    1211:	89 55 08             	mov    %edx,0x8(%ebp)
    1214:	8b 55 0c             	mov    0xc(%ebp),%edx
    1217:	8d 4a 01             	lea    0x1(%edx),%ecx
    121a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    121d:	0f b6 12             	movzbl (%edx),%edx
    1220:	88 10                	mov    %dl,(%eax)
    1222:	0f b6 00             	movzbl (%eax),%eax
    1225:	84 c0                	test   %al,%al
    1227:	75 e2                	jne    120b <strcpy+0xd>
    ;
  return os;
    1229:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    122c:	c9                   	leave  
    122d:	c3                   	ret    

0000122e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    122e:	55                   	push   %ebp
    122f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1231:	eb 08                	jmp    123b <strcmp+0xd>
    p++, q++;
    1233:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1237:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
    123b:	8b 45 08             	mov    0x8(%ebp),%eax
    123e:	0f b6 00             	movzbl (%eax),%eax
    1241:	84 c0                	test   %al,%al
    1243:	74 10                	je     1255 <strcmp+0x27>
    1245:	8b 45 08             	mov    0x8(%ebp),%eax
    1248:	0f b6 10             	movzbl (%eax),%edx
    124b:	8b 45 0c             	mov    0xc(%ebp),%eax
    124e:	0f b6 00             	movzbl (%eax),%eax
    1251:	38 c2                	cmp    %al,%dl
    1253:	74 de                	je     1233 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
    1255:	8b 45 08             	mov    0x8(%ebp),%eax
    1258:	0f b6 00             	movzbl (%eax),%eax
    125b:	0f b6 d0             	movzbl %al,%edx
    125e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1261:	0f b6 00             	movzbl (%eax),%eax
    1264:	0f b6 c0             	movzbl %al,%eax
    1267:	29 c2                	sub    %eax,%edx
    1269:	89 d0                	mov    %edx,%eax
}
    126b:	5d                   	pop    %ebp
    126c:	c3                   	ret    

0000126d <strlen>:

uint
strlen(char *s)
{
    126d:	55                   	push   %ebp
    126e:	89 e5                	mov    %esp,%ebp
    1270:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1273:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    127a:	eb 04                	jmp    1280 <strlen+0x13>
    127c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1280:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1283:	8b 45 08             	mov    0x8(%ebp),%eax
    1286:	01 d0                	add    %edx,%eax
    1288:	0f b6 00             	movzbl (%eax),%eax
    128b:	84 c0                	test   %al,%al
    128d:	75 ed                	jne    127c <strlen+0xf>
    ;
  return n;
    128f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1292:	c9                   	leave  
    1293:	c3                   	ret    

00001294 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1294:	55                   	push   %ebp
    1295:	89 e5                	mov    %esp,%ebp
    1297:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    129a:	8b 45 10             	mov    0x10(%ebp),%eax
    129d:	89 44 24 08          	mov    %eax,0x8(%esp)
    12a1:	8b 45 0c             	mov    0xc(%ebp),%eax
    12a4:	89 44 24 04          	mov    %eax,0x4(%esp)
    12a8:	8b 45 08             	mov    0x8(%ebp),%eax
    12ab:	89 04 24             	mov    %eax,(%esp)
    12ae:	e8 26 ff ff ff       	call   11d9 <stosb>
  return dst;
    12b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12b6:	c9                   	leave  
    12b7:	c3                   	ret    

000012b8 <strchr>:

char*
strchr(const char *s, char c)
{
    12b8:	55                   	push   %ebp
    12b9:	89 e5                	mov    %esp,%ebp
    12bb:	83 ec 04             	sub    $0x4,%esp
    12be:	8b 45 0c             	mov    0xc(%ebp),%eax
    12c1:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    12c4:	eb 14                	jmp    12da <strchr+0x22>
    if(*s == c)
    12c6:	8b 45 08             	mov    0x8(%ebp),%eax
    12c9:	0f b6 00             	movzbl (%eax),%eax
    12cc:	3a 45 fc             	cmp    -0x4(%ebp),%al
    12cf:	75 05                	jne    12d6 <strchr+0x1e>
      return (char*)s;
    12d1:	8b 45 08             	mov    0x8(%ebp),%eax
    12d4:	eb 13                	jmp    12e9 <strchr+0x31>
  for(; *s; s++)
    12d6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    12da:	8b 45 08             	mov    0x8(%ebp),%eax
    12dd:	0f b6 00             	movzbl (%eax),%eax
    12e0:	84 c0                	test   %al,%al
    12e2:	75 e2                	jne    12c6 <strchr+0xe>
  return 0;
    12e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
    12e9:	c9                   	leave  
    12ea:	c3                   	ret    

000012eb <gets>:

char*
gets(char *buf, int max)
{
    12eb:	55                   	push   %ebp
    12ec:	89 e5                	mov    %esp,%ebp
    12ee:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    12f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    12f8:	eb 4c                	jmp    1346 <gets+0x5b>
    cc = read(0, &c, 1);
    12fa:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1301:	00 
    1302:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1305:	89 44 24 04          	mov    %eax,0x4(%esp)
    1309:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1310:	e8 44 01 00 00       	call   1459 <read>
    1315:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1318:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    131c:	7f 02                	jg     1320 <gets+0x35>
      break;
    131e:	eb 31                	jmp    1351 <gets+0x66>
    buf[i++] = c;
    1320:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1323:	8d 50 01             	lea    0x1(%eax),%edx
    1326:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1329:	89 c2                	mov    %eax,%edx
    132b:	8b 45 08             	mov    0x8(%ebp),%eax
    132e:	01 c2                	add    %eax,%edx
    1330:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1334:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1336:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    133a:	3c 0a                	cmp    $0xa,%al
    133c:	74 13                	je     1351 <gets+0x66>
    133e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1342:	3c 0d                	cmp    $0xd,%al
    1344:	74 0b                	je     1351 <gets+0x66>
  for(i=0; i+1 < max; ){
    1346:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1349:	83 c0 01             	add    $0x1,%eax
    134c:	3b 45 0c             	cmp    0xc(%ebp),%eax
    134f:	7c a9                	jl     12fa <gets+0xf>
      break;
  }
  buf[i] = '\0';
    1351:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1354:	8b 45 08             	mov    0x8(%ebp),%eax
    1357:	01 d0                	add    %edx,%eax
    1359:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    135c:	8b 45 08             	mov    0x8(%ebp),%eax
}
    135f:	c9                   	leave  
    1360:	c3                   	ret    

00001361 <stat>:

int
stat(char *n, struct stat *st)
{
    1361:	55                   	push   %ebp
    1362:	89 e5                	mov    %esp,%ebp
    1364:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1367:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    136e:	00 
    136f:	8b 45 08             	mov    0x8(%ebp),%eax
    1372:	89 04 24             	mov    %eax,(%esp)
    1375:	e8 07 01 00 00       	call   1481 <open>
    137a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    137d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1381:	79 07                	jns    138a <stat+0x29>
    return -1;
    1383:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1388:	eb 23                	jmp    13ad <stat+0x4c>
  r = fstat(fd, st);
    138a:	8b 45 0c             	mov    0xc(%ebp),%eax
    138d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1391:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1394:	89 04 24             	mov    %eax,(%esp)
    1397:	e8 fd 00 00 00       	call   1499 <fstat>
    139c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    139f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13a2:	89 04 24             	mov    %eax,(%esp)
    13a5:	e8 bf 00 00 00       	call   1469 <close>
  return r;
    13aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    13ad:	c9                   	leave  
    13ae:	c3                   	ret    

000013af <atoi>:

int
atoi(const char *s)
{
    13af:	55                   	push   %ebp
    13b0:	89 e5                	mov    %esp,%ebp
    13b2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    13b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    13bc:	eb 25                	jmp    13e3 <atoi+0x34>
    n = n*10 + *s++ - '0';
    13be:	8b 55 fc             	mov    -0x4(%ebp),%edx
    13c1:	89 d0                	mov    %edx,%eax
    13c3:	c1 e0 02             	shl    $0x2,%eax
    13c6:	01 d0                	add    %edx,%eax
    13c8:	01 c0                	add    %eax,%eax
    13ca:	89 c1                	mov    %eax,%ecx
    13cc:	8b 45 08             	mov    0x8(%ebp),%eax
    13cf:	8d 50 01             	lea    0x1(%eax),%edx
    13d2:	89 55 08             	mov    %edx,0x8(%ebp)
    13d5:	0f b6 00             	movzbl (%eax),%eax
    13d8:	0f be c0             	movsbl %al,%eax
    13db:	01 c8                	add    %ecx,%eax
    13dd:	83 e8 30             	sub    $0x30,%eax
    13e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    13e3:	8b 45 08             	mov    0x8(%ebp),%eax
    13e6:	0f b6 00             	movzbl (%eax),%eax
    13e9:	3c 2f                	cmp    $0x2f,%al
    13eb:	7e 0a                	jle    13f7 <atoi+0x48>
    13ed:	8b 45 08             	mov    0x8(%ebp),%eax
    13f0:	0f b6 00             	movzbl (%eax),%eax
    13f3:	3c 39                	cmp    $0x39,%al
    13f5:	7e c7                	jle    13be <atoi+0xf>
  return n;
    13f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    13fa:	c9                   	leave  
    13fb:	c3                   	ret    

000013fc <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    13fc:	55                   	push   %ebp
    13fd:	89 e5                	mov    %esp,%ebp
    13ff:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    1402:	8b 45 08             	mov    0x8(%ebp),%eax
    1405:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1408:	8b 45 0c             	mov    0xc(%ebp),%eax
    140b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    140e:	eb 17                	jmp    1427 <memmove+0x2b>
    *dst++ = *src++;
    1410:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1413:	8d 50 01             	lea    0x1(%eax),%edx
    1416:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1419:	8b 55 f8             	mov    -0x8(%ebp),%edx
    141c:	8d 4a 01             	lea    0x1(%edx),%ecx
    141f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1422:	0f b6 12             	movzbl (%edx),%edx
    1425:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
    1427:	8b 45 10             	mov    0x10(%ebp),%eax
    142a:	8d 50 ff             	lea    -0x1(%eax),%edx
    142d:	89 55 10             	mov    %edx,0x10(%ebp)
    1430:	85 c0                	test   %eax,%eax
    1432:	7f dc                	jg     1410 <memmove+0x14>
  return vdst;
    1434:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1437:	c9                   	leave  
    1438:	c3                   	ret    

00001439 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1439:	b8 01 00 00 00       	mov    $0x1,%eax
    143e:	cd 40                	int    $0x40
    1440:	c3                   	ret    

00001441 <exit>:
SYSCALL(exit)
    1441:	b8 02 00 00 00       	mov    $0x2,%eax
    1446:	cd 40                	int    $0x40
    1448:	c3                   	ret    

00001449 <wait>:
SYSCALL(wait)
    1449:	b8 03 00 00 00       	mov    $0x3,%eax
    144e:	cd 40                	int    $0x40
    1450:	c3                   	ret    

00001451 <pipe>:
SYSCALL(pipe)
    1451:	b8 04 00 00 00       	mov    $0x4,%eax
    1456:	cd 40                	int    $0x40
    1458:	c3                   	ret    

00001459 <read>:
SYSCALL(read)
    1459:	b8 05 00 00 00       	mov    $0x5,%eax
    145e:	cd 40                	int    $0x40
    1460:	c3                   	ret    

00001461 <write>:
SYSCALL(write)
    1461:	b8 10 00 00 00       	mov    $0x10,%eax
    1466:	cd 40                	int    $0x40
    1468:	c3                   	ret    

00001469 <close>:
SYSCALL(close)
    1469:	b8 15 00 00 00       	mov    $0x15,%eax
    146e:	cd 40                	int    $0x40
    1470:	c3                   	ret    

00001471 <kill>:
SYSCALL(kill)
    1471:	b8 06 00 00 00       	mov    $0x6,%eax
    1476:	cd 40                	int    $0x40
    1478:	c3                   	ret    

00001479 <exec>:
SYSCALL(exec)
    1479:	b8 07 00 00 00       	mov    $0x7,%eax
    147e:	cd 40                	int    $0x40
    1480:	c3                   	ret    

00001481 <open>:
SYSCALL(open)
    1481:	b8 0f 00 00 00       	mov    $0xf,%eax
    1486:	cd 40                	int    $0x40
    1488:	c3                   	ret    

00001489 <mknod>:
SYSCALL(mknod)
    1489:	b8 11 00 00 00       	mov    $0x11,%eax
    148e:	cd 40                	int    $0x40
    1490:	c3                   	ret    

00001491 <unlink>:
SYSCALL(unlink)
    1491:	b8 12 00 00 00       	mov    $0x12,%eax
    1496:	cd 40                	int    $0x40
    1498:	c3                   	ret    

00001499 <fstat>:
SYSCALL(fstat)
    1499:	b8 08 00 00 00       	mov    $0x8,%eax
    149e:	cd 40                	int    $0x40
    14a0:	c3                   	ret    

000014a1 <link>:
SYSCALL(link)
    14a1:	b8 13 00 00 00       	mov    $0x13,%eax
    14a6:	cd 40                	int    $0x40
    14a8:	c3                   	ret    

000014a9 <mkdir>:
SYSCALL(mkdir)
    14a9:	b8 14 00 00 00       	mov    $0x14,%eax
    14ae:	cd 40                	int    $0x40
    14b0:	c3                   	ret    

000014b1 <chdir>:
SYSCALL(chdir)
    14b1:	b8 09 00 00 00       	mov    $0x9,%eax
    14b6:	cd 40                	int    $0x40
    14b8:	c3                   	ret    

000014b9 <dup>:
SYSCALL(dup)
    14b9:	b8 0a 00 00 00       	mov    $0xa,%eax
    14be:	cd 40                	int    $0x40
    14c0:	c3                   	ret    

000014c1 <getpid>:
SYSCALL(getpid)
    14c1:	b8 0b 00 00 00       	mov    $0xb,%eax
    14c6:	cd 40                	int    $0x40
    14c8:	c3                   	ret    

000014c9 <sbrk>:
SYSCALL(sbrk)
    14c9:	b8 0c 00 00 00       	mov    $0xc,%eax
    14ce:	cd 40                	int    $0x40
    14d0:	c3                   	ret    

000014d1 <sleep>:
SYSCALL(sleep)
    14d1:	b8 0d 00 00 00       	mov    $0xd,%eax
    14d6:	cd 40                	int    $0x40
    14d8:	c3                   	ret    

000014d9 <uptime>:
SYSCALL(uptime)
    14d9:	b8 0e 00 00 00       	mov    $0xe,%eax
    14de:	cd 40                	int    $0x40
    14e0:	c3                   	ret    

000014e1 <shm_open>:
SYSCALL(shm_open)
    14e1:	b8 16 00 00 00       	mov    $0x16,%eax
    14e6:	cd 40                	int    $0x40
    14e8:	c3                   	ret    

000014e9 <shm_close>:
SYSCALL(shm_close)	
    14e9:	b8 17 00 00 00       	mov    $0x17,%eax
    14ee:	cd 40                	int    $0x40
    14f0:	c3                   	ret    

000014f1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    14f1:	55                   	push   %ebp
    14f2:	89 e5                	mov    %esp,%ebp
    14f4:	83 ec 18             	sub    $0x18,%esp
    14f7:	8b 45 0c             	mov    0xc(%ebp),%eax
    14fa:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    14fd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1504:	00 
    1505:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1508:	89 44 24 04          	mov    %eax,0x4(%esp)
    150c:	8b 45 08             	mov    0x8(%ebp),%eax
    150f:	89 04 24             	mov    %eax,(%esp)
    1512:	e8 4a ff ff ff       	call   1461 <write>
}
    1517:	c9                   	leave  
    1518:	c3                   	ret    

00001519 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1519:	55                   	push   %ebp
    151a:	89 e5                	mov    %esp,%ebp
    151c:	56                   	push   %esi
    151d:	53                   	push   %ebx
    151e:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1521:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1528:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    152c:	74 17                	je     1545 <printint+0x2c>
    152e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1532:	79 11                	jns    1545 <printint+0x2c>
    neg = 1;
    1534:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    153b:	8b 45 0c             	mov    0xc(%ebp),%eax
    153e:	f7 d8                	neg    %eax
    1540:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1543:	eb 06                	jmp    154b <printint+0x32>
  } else {
    x = xx;
    1545:	8b 45 0c             	mov    0xc(%ebp),%eax
    1548:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    154b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1552:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1555:	8d 41 01             	lea    0x1(%ecx),%eax
    1558:	89 45 f4             	mov    %eax,-0xc(%ebp)
    155b:	8b 5d 10             	mov    0x10(%ebp),%ebx
    155e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1561:	ba 00 00 00 00       	mov    $0x0,%edx
    1566:	f7 f3                	div    %ebx
    1568:	89 d0                	mov    %edx,%eax
    156a:	0f b6 80 f4 1c 00 00 	movzbl 0x1cf4(%eax),%eax
    1571:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1575:	8b 75 10             	mov    0x10(%ebp),%esi
    1578:	8b 45 ec             	mov    -0x14(%ebp),%eax
    157b:	ba 00 00 00 00       	mov    $0x0,%edx
    1580:	f7 f6                	div    %esi
    1582:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1585:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1589:	75 c7                	jne    1552 <printint+0x39>
  if(neg)
    158b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    158f:	74 10                	je     15a1 <printint+0x88>
    buf[i++] = '-';
    1591:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1594:	8d 50 01             	lea    0x1(%eax),%edx
    1597:	89 55 f4             	mov    %edx,-0xc(%ebp)
    159a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    159f:	eb 1f                	jmp    15c0 <printint+0xa7>
    15a1:	eb 1d                	jmp    15c0 <printint+0xa7>
    putc(fd, buf[i]);
    15a3:	8d 55 dc             	lea    -0x24(%ebp),%edx
    15a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15a9:	01 d0                	add    %edx,%eax
    15ab:	0f b6 00             	movzbl (%eax),%eax
    15ae:	0f be c0             	movsbl %al,%eax
    15b1:	89 44 24 04          	mov    %eax,0x4(%esp)
    15b5:	8b 45 08             	mov    0x8(%ebp),%eax
    15b8:	89 04 24             	mov    %eax,(%esp)
    15bb:	e8 31 ff ff ff       	call   14f1 <putc>
  while(--i >= 0)
    15c0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    15c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15c8:	79 d9                	jns    15a3 <printint+0x8a>
}
    15ca:	83 c4 30             	add    $0x30,%esp
    15cd:	5b                   	pop    %ebx
    15ce:	5e                   	pop    %esi
    15cf:	5d                   	pop    %ebp
    15d0:	c3                   	ret    

000015d1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    15d1:	55                   	push   %ebp
    15d2:	89 e5                	mov    %esp,%ebp
    15d4:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    15d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    15de:	8d 45 0c             	lea    0xc(%ebp),%eax
    15e1:	83 c0 04             	add    $0x4,%eax
    15e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    15e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    15ee:	e9 7c 01 00 00       	jmp    176f <printf+0x19e>
    c = fmt[i] & 0xff;
    15f3:	8b 55 0c             	mov    0xc(%ebp),%edx
    15f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15f9:	01 d0                	add    %edx,%eax
    15fb:	0f b6 00             	movzbl (%eax),%eax
    15fe:	0f be c0             	movsbl %al,%eax
    1601:	25 ff 00 00 00       	and    $0xff,%eax
    1606:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1609:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    160d:	75 2c                	jne    163b <printf+0x6a>
      if(c == '%'){
    160f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1613:	75 0c                	jne    1621 <printf+0x50>
        state = '%';
    1615:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    161c:	e9 4a 01 00 00       	jmp    176b <printf+0x19a>
      } else {
        putc(fd, c);
    1621:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1624:	0f be c0             	movsbl %al,%eax
    1627:	89 44 24 04          	mov    %eax,0x4(%esp)
    162b:	8b 45 08             	mov    0x8(%ebp),%eax
    162e:	89 04 24             	mov    %eax,(%esp)
    1631:	e8 bb fe ff ff       	call   14f1 <putc>
    1636:	e9 30 01 00 00       	jmp    176b <printf+0x19a>
      }
    } else if(state == '%'){
    163b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    163f:	0f 85 26 01 00 00    	jne    176b <printf+0x19a>
      if(c == 'd'){
    1645:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1649:	75 2d                	jne    1678 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    164b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    164e:	8b 00                	mov    (%eax),%eax
    1650:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1657:	00 
    1658:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    165f:	00 
    1660:	89 44 24 04          	mov    %eax,0x4(%esp)
    1664:	8b 45 08             	mov    0x8(%ebp),%eax
    1667:	89 04 24             	mov    %eax,(%esp)
    166a:	e8 aa fe ff ff       	call   1519 <printint>
        ap++;
    166f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1673:	e9 ec 00 00 00       	jmp    1764 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    1678:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    167c:	74 06                	je     1684 <printf+0xb3>
    167e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1682:	75 2d                	jne    16b1 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1684:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1687:	8b 00                	mov    (%eax),%eax
    1689:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1690:	00 
    1691:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1698:	00 
    1699:	89 44 24 04          	mov    %eax,0x4(%esp)
    169d:	8b 45 08             	mov    0x8(%ebp),%eax
    16a0:	89 04 24             	mov    %eax,(%esp)
    16a3:	e8 71 fe ff ff       	call   1519 <printint>
        ap++;
    16a8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    16ac:	e9 b3 00 00 00       	jmp    1764 <printf+0x193>
      } else if(c == 's'){
    16b1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    16b5:	75 45                	jne    16fc <printf+0x12b>
        s = (char*)*ap;
    16b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16ba:	8b 00                	mov    (%eax),%eax
    16bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    16bf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    16c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    16c7:	75 09                	jne    16d2 <printf+0x101>
          s = "(null)";
    16c9:	c7 45 f4 26 1a 00 00 	movl   $0x1a26,-0xc(%ebp)
        while(*s != 0){
    16d0:	eb 1e                	jmp    16f0 <printf+0x11f>
    16d2:	eb 1c                	jmp    16f0 <printf+0x11f>
          putc(fd, *s);
    16d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16d7:	0f b6 00             	movzbl (%eax),%eax
    16da:	0f be c0             	movsbl %al,%eax
    16dd:	89 44 24 04          	mov    %eax,0x4(%esp)
    16e1:	8b 45 08             	mov    0x8(%ebp),%eax
    16e4:	89 04 24             	mov    %eax,(%esp)
    16e7:	e8 05 fe ff ff       	call   14f1 <putc>
          s++;
    16ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
    16f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16f3:	0f b6 00             	movzbl (%eax),%eax
    16f6:	84 c0                	test   %al,%al
    16f8:	75 da                	jne    16d4 <printf+0x103>
    16fa:	eb 68                	jmp    1764 <printf+0x193>
        }
      } else if(c == 'c'){
    16fc:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1700:	75 1d                	jne    171f <printf+0x14e>
        putc(fd, *ap);
    1702:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1705:	8b 00                	mov    (%eax),%eax
    1707:	0f be c0             	movsbl %al,%eax
    170a:	89 44 24 04          	mov    %eax,0x4(%esp)
    170e:	8b 45 08             	mov    0x8(%ebp),%eax
    1711:	89 04 24             	mov    %eax,(%esp)
    1714:	e8 d8 fd ff ff       	call   14f1 <putc>
        ap++;
    1719:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    171d:	eb 45                	jmp    1764 <printf+0x193>
      } else if(c == '%'){
    171f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1723:	75 17                	jne    173c <printf+0x16b>
        putc(fd, c);
    1725:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1728:	0f be c0             	movsbl %al,%eax
    172b:	89 44 24 04          	mov    %eax,0x4(%esp)
    172f:	8b 45 08             	mov    0x8(%ebp),%eax
    1732:	89 04 24             	mov    %eax,(%esp)
    1735:	e8 b7 fd ff ff       	call   14f1 <putc>
    173a:	eb 28                	jmp    1764 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    173c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1743:	00 
    1744:	8b 45 08             	mov    0x8(%ebp),%eax
    1747:	89 04 24             	mov    %eax,(%esp)
    174a:	e8 a2 fd ff ff       	call   14f1 <putc>
        putc(fd, c);
    174f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1752:	0f be c0             	movsbl %al,%eax
    1755:	89 44 24 04          	mov    %eax,0x4(%esp)
    1759:	8b 45 08             	mov    0x8(%ebp),%eax
    175c:	89 04 24             	mov    %eax,(%esp)
    175f:	e8 8d fd ff ff       	call   14f1 <putc>
      }
      state = 0;
    1764:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    176b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    176f:	8b 55 0c             	mov    0xc(%ebp),%edx
    1772:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1775:	01 d0                	add    %edx,%eax
    1777:	0f b6 00             	movzbl (%eax),%eax
    177a:	84 c0                	test   %al,%al
    177c:	0f 85 71 fe ff ff    	jne    15f3 <printf+0x22>
    }
  }
}
    1782:	c9                   	leave  
    1783:	c3                   	ret    

00001784 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1784:	55                   	push   %ebp
    1785:	89 e5                	mov    %esp,%ebp
    1787:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    178a:	8b 45 08             	mov    0x8(%ebp),%eax
    178d:	83 e8 08             	sub    $0x8,%eax
    1790:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1793:	a1 28 1d 00 00       	mov    0x1d28,%eax
    1798:	89 45 fc             	mov    %eax,-0x4(%ebp)
    179b:	eb 24                	jmp    17c1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    179d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17a0:	8b 00                	mov    (%eax),%eax
    17a2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    17a5:	77 12                	ja     17b9 <free+0x35>
    17a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17aa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    17ad:	77 24                	ja     17d3 <free+0x4f>
    17af:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17b2:	8b 00                	mov    (%eax),%eax
    17b4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17b7:	77 1a                	ja     17d3 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    17b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17bc:	8b 00                	mov    (%eax),%eax
    17be:	89 45 fc             	mov    %eax,-0x4(%ebp)
    17c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17c4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    17c7:	76 d4                	jbe    179d <free+0x19>
    17c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17cc:	8b 00                	mov    (%eax),%eax
    17ce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17d1:	76 ca                	jbe    179d <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    17d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17d6:	8b 40 04             	mov    0x4(%eax),%eax
    17d9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    17e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17e3:	01 c2                	add    %eax,%edx
    17e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17e8:	8b 00                	mov    (%eax),%eax
    17ea:	39 c2                	cmp    %eax,%edx
    17ec:	75 24                	jne    1812 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    17ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17f1:	8b 50 04             	mov    0x4(%eax),%edx
    17f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17f7:	8b 00                	mov    (%eax),%eax
    17f9:	8b 40 04             	mov    0x4(%eax),%eax
    17fc:	01 c2                	add    %eax,%edx
    17fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1801:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1804:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1807:	8b 00                	mov    (%eax),%eax
    1809:	8b 10                	mov    (%eax),%edx
    180b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    180e:	89 10                	mov    %edx,(%eax)
    1810:	eb 0a                	jmp    181c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1812:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1815:	8b 10                	mov    (%eax),%edx
    1817:	8b 45 f8             	mov    -0x8(%ebp),%eax
    181a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    181c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    181f:	8b 40 04             	mov    0x4(%eax),%eax
    1822:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1829:	8b 45 fc             	mov    -0x4(%ebp),%eax
    182c:	01 d0                	add    %edx,%eax
    182e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1831:	75 20                	jne    1853 <free+0xcf>
    p->s.size += bp->s.size;
    1833:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1836:	8b 50 04             	mov    0x4(%eax),%edx
    1839:	8b 45 f8             	mov    -0x8(%ebp),%eax
    183c:	8b 40 04             	mov    0x4(%eax),%eax
    183f:	01 c2                	add    %eax,%edx
    1841:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1844:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1847:	8b 45 f8             	mov    -0x8(%ebp),%eax
    184a:	8b 10                	mov    (%eax),%edx
    184c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    184f:	89 10                	mov    %edx,(%eax)
    1851:	eb 08                	jmp    185b <free+0xd7>
  } else
    p->s.ptr = bp;
    1853:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1856:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1859:	89 10                	mov    %edx,(%eax)
  freep = p;
    185b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    185e:	a3 28 1d 00 00       	mov    %eax,0x1d28
}
    1863:	c9                   	leave  
    1864:	c3                   	ret    

00001865 <morecore>:

static Header*
morecore(uint nu)
{
    1865:	55                   	push   %ebp
    1866:	89 e5                	mov    %esp,%ebp
    1868:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    186b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1872:	77 07                	ja     187b <morecore+0x16>
    nu = 4096;
    1874:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    187b:	8b 45 08             	mov    0x8(%ebp),%eax
    187e:	c1 e0 03             	shl    $0x3,%eax
    1881:	89 04 24             	mov    %eax,(%esp)
    1884:	e8 40 fc ff ff       	call   14c9 <sbrk>
    1889:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    188c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1890:	75 07                	jne    1899 <morecore+0x34>
    return 0;
    1892:	b8 00 00 00 00       	mov    $0x0,%eax
    1897:	eb 22                	jmp    18bb <morecore+0x56>
  hp = (Header*)p;
    1899:	8b 45 f4             	mov    -0xc(%ebp),%eax
    189c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    189f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18a2:	8b 55 08             	mov    0x8(%ebp),%edx
    18a5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    18a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18ab:	83 c0 08             	add    $0x8,%eax
    18ae:	89 04 24             	mov    %eax,(%esp)
    18b1:	e8 ce fe ff ff       	call   1784 <free>
  return freep;
    18b6:	a1 28 1d 00 00       	mov    0x1d28,%eax
}
    18bb:	c9                   	leave  
    18bc:	c3                   	ret    

000018bd <malloc>:

void*
malloc(uint nbytes)
{
    18bd:	55                   	push   %ebp
    18be:	89 e5                	mov    %esp,%ebp
    18c0:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    18c3:	8b 45 08             	mov    0x8(%ebp),%eax
    18c6:	83 c0 07             	add    $0x7,%eax
    18c9:	c1 e8 03             	shr    $0x3,%eax
    18cc:	83 c0 01             	add    $0x1,%eax
    18cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    18d2:	a1 28 1d 00 00       	mov    0x1d28,%eax
    18d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    18de:	75 23                	jne    1903 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    18e0:	c7 45 f0 20 1d 00 00 	movl   $0x1d20,-0x10(%ebp)
    18e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18ea:	a3 28 1d 00 00       	mov    %eax,0x1d28
    18ef:	a1 28 1d 00 00       	mov    0x1d28,%eax
    18f4:	a3 20 1d 00 00       	mov    %eax,0x1d20
    base.s.size = 0;
    18f9:	c7 05 24 1d 00 00 00 	movl   $0x0,0x1d24
    1900:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1903:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1906:	8b 00                	mov    (%eax),%eax
    1908:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    190b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    190e:	8b 40 04             	mov    0x4(%eax),%eax
    1911:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1914:	72 4d                	jb     1963 <malloc+0xa6>
      if(p->s.size == nunits)
    1916:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1919:	8b 40 04             	mov    0x4(%eax),%eax
    191c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    191f:	75 0c                	jne    192d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1921:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1924:	8b 10                	mov    (%eax),%edx
    1926:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1929:	89 10                	mov    %edx,(%eax)
    192b:	eb 26                	jmp    1953 <malloc+0x96>
      else {
        p->s.size -= nunits;
    192d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1930:	8b 40 04             	mov    0x4(%eax),%eax
    1933:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1936:	89 c2                	mov    %eax,%edx
    1938:	8b 45 f4             	mov    -0xc(%ebp),%eax
    193b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    193e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1941:	8b 40 04             	mov    0x4(%eax),%eax
    1944:	c1 e0 03             	shl    $0x3,%eax
    1947:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    194a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    194d:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1950:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1953:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1956:	a3 28 1d 00 00       	mov    %eax,0x1d28
      return (void*)(p + 1);
    195b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    195e:	83 c0 08             	add    $0x8,%eax
    1961:	eb 38                	jmp    199b <malloc+0xde>
    }
    if(p == freep)
    1963:	a1 28 1d 00 00       	mov    0x1d28,%eax
    1968:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    196b:	75 1b                	jne    1988 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    196d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1970:	89 04 24             	mov    %eax,(%esp)
    1973:	e8 ed fe ff ff       	call   1865 <morecore>
    1978:	89 45 f4             	mov    %eax,-0xc(%ebp)
    197b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    197f:	75 07                	jne    1988 <malloc+0xcb>
        return 0;
    1981:	b8 00 00 00 00       	mov    $0x0,%eax
    1986:	eb 13                	jmp    199b <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1988:	8b 45 f4             	mov    -0xc(%ebp),%eax
    198b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    198e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1991:	8b 00                	mov    (%eax),%eax
    1993:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
    1996:	e9 70 ff ff ff       	jmp    190b <malloc+0x4e>
}
    199b:	c9                   	leave  
    199c:	c3                   	ret    

0000199d <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    199d:	55                   	push   %ebp
    199e:	89 e5                	mov    %esp,%ebp
    19a0:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    19a3:	8b 55 08             	mov    0x8(%ebp),%edx
    19a6:	8b 45 0c             	mov    0xc(%ebp),%eax
    19a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
    19ac:	f0 87 02             	lock xchg %eax,(%edx)
    19af:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    19b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    19b5:	c9                   	leave  
    19b6:	c3                   	ret    

000019b7 <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    19b7:	55                   	push   %ebp
    19b8:	89 e5                	mov    %esp,%ebp
    19ba:	83 ec 08             	sub    $0x8,%esp
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    19bd:	90                   	nop
    19be:	8b 45 08             	mov    0x8(%ebp),%eax
    19c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    19c8:	00 
    19c9:	89 04 24             	mov    %eax,(%esp)
    19cc:	e8 cc ff ff ff       	call   199d <xchg>
    19d1:	85 c0                	test   %eax,%eax
    19d3:	75 e9                	jne    19be <uacquire+0x7>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    19d5:	0f ae f0             	mfence 
}
    19d8:	c9                   	leave  
    19d9:	c3                   	ret    

000019da <urelease>:

void urelease (struct uspinlock *lk) {
    19da:	55                   	push   %ebp
    19db:	89 e5                	mov    %esp,%ebp
  __sync_synchronize();
    19dd:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    19e0:	8b 45 08             	mov    0x8(%ebp),%eax
    19e3:	8b 55 08             	mov    0x8(%ebp),%edx
    19e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    19ec:	5d                   	pop    %ebp
    19ed:	c3                   	ret    
