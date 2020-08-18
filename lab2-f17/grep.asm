
_grep:     file format elf32-i386


Disassembly of section .text:

00001000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 28             	sub    $0x28,%esp
  int n, m;
  char *p, *q;

  m = 0;
    1006:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    100d:	e9 c6 00 00 00       	jmp    10d8 <grep+0xd8>
    m += n;
    1012:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1015:	01 45 f4             	add    %eax,-0xc(%ebp)
    buf[m] = '\0';
    1018:	8b 45 f4             	mov    -0xc(%ebp),%eax
    101b:	05 20 1f 00 00       	add    $0x1f20,%eax
    1020:	c6 00 00             	movb   $0x0,(%eax)
    p = buf;
    1023:	c7 45 f0 20 1f 00 00 	movl   $0x1f20,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
    102a:	eb 51                	jmp    107d <grep+0x7d>
      *q = 0;
    102c:	8b 45 e8             	mov    -0x18(%ebp),%eax
    102f:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
    1032:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1035:	89 44 24 04          	mov    %eax,0x4(%esp)
    1039:	8b 45 08             	mov    0x8(%ebp),%eax
    103c:	89 04 24             	mov    %eax,(%esp)
    103f:	e8 bc 01 00 00       	call   1200 <match>
    1044:	85 c0                	test   %eax,%eax
    1046:	74 2c                	je     1074 <grep+0x74>
        *q = '\n';
    1048:	8b 45 e8             	mov    -0x18(%ebp),%eax
    104b:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
    104e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1051:	83 c0 01             	add    $0x1,%eax
    1054:	89 c2                	mov    %eax,%edx
    1056:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1059:	29 c2                	sub    %eax,%edx
    105b:	89 d0                	mov    %edx,%eax
    105d:	89 44 24 08          	mov    %eax,0x8(%esp)
    1061:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1064:	89 44 24 04          	mov    %eax,0x4(%esp)
    1068:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    106f:	e8 74 05 00 00       	call   15e8 <write>
      }
      p = q+1;
    1074:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1077:	83 c0 01             	add    $0x1,%eax
    107a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
    107d:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
    1084:	00 
    1085:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1088:	89 04 24             	mov    %eax,(%esp)
    108b:	e8 af 03 00 00       	call   143f <strchr>
    1090:	89 45 e8             	mov    %eax,-0x18(%ebp)
    1093:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1097:	75 93                	jne    102c <grep+0x2c>
    }
    if(p == buf)
    1099:	81 7d f0 20 1f 00 00 	cmpl   $0x1f20,-0x10(%ebp)
    10a0:	75 07                	jne    10a9 <grep+0xa9>
      m = 0;
    10a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
    10a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10ad:	7e 29                	jle    10d8 <grep+0xd8>
      m -= p - buf;
    10af:	ba 20 1f 00 00       	mov    $0x1f20,%edx
    10b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10b7:	29 c2                	sub    %eax,%edx
    10b9:	89 d0                	mov    %edx,%eax
    10bb:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
    10be:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10c1:	89 44 24 08          	mov    %eax,0x8(%esp)
    10c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10c8:	89 44 24 04          	mov    %eax,0x4(%esp)
    10cc:	c7 04 24 20 1f 00 00 	movl   $0x1f20,(%esp)
    10d3:	e8 ab 04 00 00       	call   1583 <memmove>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    10d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10db:	ba ff 03 00 00       	mov    $0x3ff,%edx
    10e0:	29 c2                	sub    %eax,%edx
    10e2:	89 d0                	mov    %edx,%eax
    10e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
    10e7:	81 c2 20 1f 00 00    	add    $0x1f20,%edx
    10ed:	89 44 24 08          	mov    %eax,0x8(%esp)
    10f1:	89 54 24 04          	mov    %edx,0x4(%esp)
    10f5:	8b 45 0c             	mov    0xc(%ebp),%eax
    10f8:	89 04 24             	mov    %eax,(%esp)
    10fb:	e8 e0 04 00 00       	call   15e0 <read>
    1100:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1103:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1107:	0f 8f 05 ff ff ff    	jg     1012 <grep+0x12>
    }
  }
}
    110d:	c9                   	leave  
    110e:	c3                   	ret    

0000110f <main>:

int
main(int argc, char *argv[])
{
    110f:	55                   	push   %ebp
    1110:	89 e5                	mov    %esp,%ebp
    1112:	83 e4 f0             	and    $0xfffffff0,%esp
    1115:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;

  if(argc <= 1){
    1118:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
    111c:	7f 19                	jg     1137 <main+0x28>
    printf(2, "usage: grep pattern [file ...]\n");
    111e:	c7 44 24 04 78 1b 00 	movl   $0x1b78,0x4(%esp)
    1125:	00 
    1126:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    112d:	e8 26 06 00 00       	call   1758 <printf>
    exit();
    1132:	e8 91 04 00 00       	call   15c8 <exit>
  }
  pattern = argv[1];
    1137:	8b 45 0c             	mov    0xc(%ebp),%eax
    113a:	8b 40 04             	mov    0x4(%eax),%eax
    113d:	89 44 24 18          	mov    %eax,0x18(%esp)

  if(argc <= 2){
    1141:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
    1145:	7f 19                	jg     1160 <main+0x51>
    grep(pattern, 0);
    1147:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    114e:	00 
    114f:	8b 44 24 18          	mov    0x18(%esp),%eax
    1153:	89 04 24             	mov    %eax,(%esp)
    1156:	e8 a5 fe ff ff       	call   1000 <grep>
    exit();
    115b:	e8 68 04 00 00       	call   15c8 <exit>
  }

  for(i = 2; i < argc; i++){
    1160:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
    1167:	00 
    1168:	e9 81 00 00 00       	jmp    11ee <main+0xdf>
    if((fd = open(argv[i], 0)) < 0){
    116d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1171:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1178:	8b 45 0c             	mov    0xc(%ebp),%eax
    117b:	01 d0                	add    %edx,%eax
    117d:	8b 00                	mov    (%eax),%eax
    117f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1186:	00 
    1187:	89 04 24             	mov    %eax,(%esp)
    118a:	e8 79 04 00 00       	call   1608 <open>
    118f:	89 44 24 14          	mov    %eax,0x14(%esp)
    1193:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
    1198:	79 2f                	jns    11c9 <main+0xba>
      printf(1, "grep: cannot open %s\n", argv[i]);
    119a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    119e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    11a5:	8b 45 0c             	mov    0xc(%ebp),%eax
    11a8:	01 d0                	add    %edx,%eax
    11aa:	8b 00                	mov    (%eax),%eax
    11ac:	89 44 24 08          	mov    %eax,0x8(%esp)
    11b0:	c7 44 24 04 98 1b 00 	movl   $0x1b98,0x4(%esp)
    11b7:	00 
    11b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11bf:	e8 94 05 00 00       	call   1758 <printf>
      exit();
    11c4:	e8 ff 03 00 00       	call   15c8 <exit>
    }
    grep(pattern, fd);
    11c9:	8b 44 24 14          	mov    0x14(%esp),%eax
    11cd:	89 44 24 04          	mov    %eax,0x4(%esp)
    11d1:	8b 44 24 18          	mov    0x18(%esp),%eax
    11d5:	89 04 24             	mov    %eax,(%esp)
    11d8:	e8 23 fe ff ff       	call   1000 <grep>
    close(fd);
    11dd:	8b 44 24 14          	mov    0x14(%esp),%eax
    11e1:	89 04 24             	mov    %eax,(%esp)
    11e4:	e8 07 04 00 00       	call   15f0 <close>
  for(i = 2; i < argc; i++){
    11e9:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
    11ee:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    11f2:	3b 45 08             	cmp    0x8(%ebp),%eax
    11f5:	0f 8c 72 ff ff ff    	jl     116d <main+0x5e>
  }
  exit();
    11fb:	e8 c8 03 00 00       	call   15c8 <exit>

00001200 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
    1200:	55                   	push   %ebp
    1201:	89 e5                	mov    %esp,%ebp
    1203:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '^')
    1206:	8b 45 08             	mov    0x8(%ebp),%eax
    1209:	0f b6 00             	movzbl (%eax),%eax
    120c:	3c 5e                	cmp    $0x5e,%al
    120e:	75 17                	jne    1227 <match+0x27>
    return matchhere(re+1, text);
    1210:	8b 45 08             	mov    0x8(%ebp),%eax
    1213:	8d 50 01             	lea    0x1(%eax),%edx
    1216:	8b 45 0c             	mov    0xc(%ebp),%eax
    1219:	89 44 24 04          	mov    %eax,0x4(%esp)
    121d:	89 14 24             	mov    %edx,(%esp)
    1220:	e8 36 00 00 00       	call   125b <matchhere>
    1225:	eb 32                	jmp    1259 <match+0x59>
  do{  // must look at empty string
    if(matchhere(re, text))
    1227:	8b 45 0c             	mov    0xc(%ebp),%eax
    122a:	89 44 24 04          	mov    %eax,0x4(%esp)
    122e:	8b 45 08             	mov    0x8(%ebp),%eax
    1231:	89 04 24             	mov    %eax,(%esp)
    1234:	e8 22 00 00 00       	call   125b <matchhere>
    1239:	85 c0                	test   %eax,%eax
    123b:	74 07                	je     1244 <match+0x44>
      return 1;
    123d:	b8 01 00 00 00       	mov    $0x1,%eax
    1242:	eb 15                	jmp    1259 <match+0x59>
  }while(*text++ != '\0');
    1244:	8b 45 0c             	mov    0xc(%ebp),%eax
    1247:	8d 50 01             	lea    0x1(%eax),%edx
    124a:	89 55 0c             	mov    %edx,0xc(%ebp)
    124d:	0f b6 00             	movzbl (%eax),%eax
    1250:	84 c0                	test   %al,%al
    1252:	75 d3                	jne    1227 <match+0x27>
  return 0;
    1254:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1259:	c9                   	leave  
    125a:	c3                   	ret    

0000125b <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
    125b:	55                   	push   %ebp
    125c:	89 e5                	mov    %esp,%ebp
    125e:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '\0')
    1261:	8b 45 08             	mov    0x8(%ebp),%eax
    1264:	0f b6 00             	movzbl (%eax),%eax
    1267:	84 c0                	test   %al,%al
    1269:	75 0a                	jne    1275 <matchhere+0x1a>
    return 1;
    126b:	b8 01 00 00 00       	mov    $0x1,%eax
    1270:	e9 9b 00 00 00       	jmp    1310 <matchhere+0xb5>
  if(re[1] == '*')
    1275:	8b 45 08             	mov    0x8(%ebp),%eax
    1278:	83 c0 01             	add    $0x1,%eax
    127b:	0f b6 00             	movzbl (%eax),%eax
    127e:	3c 2a                	cmp    $0x2a,%al
    1280:	75 24                	jne    12a6 <matchhere+0x4b>
    return matchstar(re[0], re+2, text);
    1282:	8b 45 08             	mov    0x8(%ebp),%eax
    1285:	8d 48 02             	lea    0x2(%eax),%ecx
    1288:	8b 45 08             	mov    0x8(%ebp),%eax
    128b:	0f b6 00             	movzbl (%eax),%eax
    128e:	0f be c0             	movsbl %al,%eax
    1291:	8b 55 0c             	mov    0xc(%ebp),%edx
    1294:	89 54 24 08          	mov    %edx,0x8(%esp)
    1298:	89 4c 24 04          	mov    %ecx,0x4(%esp)
    129c:	89 04 24             	mov    %eax,(%esp)
    129f:	e8 6e 00 00 00       	call   1312 <matchstar>
    12a4:	eb 6a                	jmp    1310 <matchhere+0xb5>
  if(re[0] == '$' && re[1] == '\0')
    12a6:	8b 45 08             	mov    0x8(%ebp),%eax
    12a9:	0f b6 00             	movzbl (%eax),%eax
    12ac:	3c 24                	cmp    $0x24,%al
    12ae:	75 1d                	jne    12cd <matchhere+0x72>
    12b0:	8b 45 08             	mov    0x8(%ebp),%eax
    12b3:	83 c0 01             	add    $0x1,%eax
    12b6:	0f b6 00             	movzbl (%eax),%eax
    12b9:	84 c0                	test   %al,%al
    12bb:	75 10                	jne    12cd <matchhere+0x72>
    return *text == '\0';
    12bd:	8b 45 0c             	mov    0xc(%ebp),%eax
    12c0:	0f b6 00             	movzbl (%eax),%eax
    12c3:	84 c0                	test   %al,%al
    12c5:	0f 94 c0             	sete   %al
    12c8:	0f b6 c0             	movzbl %al,%eax
    12cb:	eb 43                	jmp    1310 <matchhere+0xb5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    12cd:	8b 45 0c             	mov    0xc(%ebp),%eax
    12d0:	0f b6 00             	movzbl (%eax),%eax
    12d3:	84 c0                	test   %al,%al
    12d5:	74 34                	je     130b <matchhere+0xb0>
    12d7:	8b 45 08             	mov    0x8(%ebp),%eax
    12da:	0f b6 00             	movzbl (%eax),%eax
    12dd:	3c 2e                	cmp    $0x2e,%al
    12df:	74 10                	je     12f1 <matchhere+0x96>
    12e1:	8b 45 08             	mov    0x8(%ebp),%eax
    12e4:	0f b6 10             	movzbl (%eax),%edx
    12e7:	8b 45 0c             	mov    0xc(%ebp),%eax
    12ea:	0f b6 00             	movzbl (%eax),%eax
    12ed:	38 c2                	cmp    %al,%dl
    12ef:	75 1a                	jne    130b <matchhere+0xb0>
    return matchhere(re+1, text+1);
    12f1:	8b 45 0c             	mov    0xc(%ebp),%eax
    12f4:	8d 50 01             	lea    0x1(%eax),%edx
    12f7:	8b 45 08             	mov    0x8(%ebp),%eax
    12fa:	83 c0 01             	add    $0x1,%eax
    12fd:	89 54 24 04          	mov    %edx,0x4(%esp)
    1301:	89 04 24             	mov    %eax,(%esp)
    1304:	e8 52 ff ff ff       	call   125b <matchhere>
    1309:	eb 05                	jmp    1310 <matchhere+0xb5>
  return 0;
    130b:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1310:	c9                   	leave  
    1311:	c3                   	ret    

00001312 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
    1312:	55                   	push   %ebp
    1313:	89 e5                	mov    %esp,%ebp
    1315:	83 ec 18             	sub    $0x18,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
    1318:	8b 45 10             	mov    0x10(%ebp),%eax
    131b:	89 44 24 04          	mov    %eax,0x4(%esp)
    131f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1322:	89 04 24             	mov    %eax,(%esp)
    1325:	e8 31 ff ff ff       	call   125b <matchhere>
    132a:	85 c0                	test   %eax,%eax
    132c:	74 07                	je     1335 <matchstar+0x23>
      return 1;
    132e:	b8 01 00 00 00       	mov    $0x1,%eax
    1333:	eb 29                	jmp    135e <matchstar+0x4c>
  }while(*text!='\0' && (*text++==c || c=='.'));
    1335:	8b 45 10             	mov    0x10(%ebp),%eax
    1338:	0f b6 00             	movzbl (%eax),%eax
    133b:	84 c0                	test   %al,%al
    133d:	74 1a                	je     1359 <matchstar+0x47>
    133f:	8b 45 10             	mov    0x10(%ebp),%eax
    1342:	8d 50 01             	lea    0x1(%eax),%edx
    1345:	89 55 10             	mov    %edx,0x10(%ebp)
    1348:	0f b6 00             	movzbl (%eax),%eax
    134b:	0f be c0             	movsbl %al,%eax
    134e:	3b 45 08             	cmp    0x8(%ebp),%eax
    1351:	74 c5                	je     1318 <matchstar+0x6>
    1353:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
    1357:	74 bf                	je     1318 <matchstar+0x6>
  return 0;
    1359:	b8 00 00 00 00       	mov    $0x0,%eax
}
    135e:	c9                   	leave  
    135f:	c3                   	ret    

00001360 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1360:	55                   	push   %ebp
    1361:	89 e5                	mov    %esp,%ebp
    1363:	57                   	push   %edi
    1364:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1365:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1368:	8b 55 10             	mov    0x10(%ebp),%edx
    136b:	8b 45 0c             	mov    0xc(%ebp),%eax
    136e:	89 cb                	mov    %ecx,%ebx
    1370:	89 df                	mov    %ebx,%edi
    1372:	89 d1                	mov    %edx,%ecx
    1374:	fc                   	cld    
    1375:	f3 aa                	rep stos %al,%es:(%edi)
    1377:	89 ca                	mov    %ecx,%edx
    1379:	89 fb                	mov    %edi,%ebx
    137b:	89 5d 08             	mov    %ebx,0x8(%ebp)
    137e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1381:	5b                   	pop    %ebx
    1382:	5f                   	pop    %edi
    1383:	5d                   	pop    %ebp
    1384:	c3                   	ret    

00001385 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1385:	55                   	push   %ebp
    1386:	89 e5                	mov    %esp,%ebp
    1388:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    138b:	8b 45 08             	mov    0x8(%ebp),%eax
    138e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1391:	90                   	nop
    1392:	8b 45 08             	mov    0x8(%ebp),%eax
    1395:	8d 50 01             	lea    0x1(%eax),%edx
    1398:	89 55 08             	mov    %edx,0x8(%ebp)
    139b:	8b 55 0c             	mov    0xc(%ebp),%edx
    139e:	8d 4a 01             	lea    0x1(%edx),%ecx
    13a1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    13a4:	0f b6 12             	movzbl (%edx),%edx
    13a7:	88 10                	mov    %dl,(%eax)
    13a9:	0f b6 00             	movzbl (%eax),%eax
    13ac:	84 c0                	test   %al,%al
    13ae:	75 e2                	jne    1392 <strcpy+0xd>
    ;
  return os;
    13b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    13b3:	c9                   	leave  
    13b4:	c3                   	ret    

000013b5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    13b5:	55                   	push   %ebp
    13b6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    13b8:	eb 08                	jmp    13c2 <strcmp+0xd>
    p++, q++;
    13ba:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    13be:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
    13c2:	8b 45 08             	mov    0x8(%ebp),%eax
    13c5:	0f b6 00             	movzbl (%eax),%eax
    13c8:	84 c0                	test   %al,%al
    13ca:	74 10                	je     13dc <strcmp+0x27>
    13cc:	8b 45 08             	mov    0x8(%ebp),%eax
    13cf:	0f b6 10             	movzbl (%eax),%edx
    13d2:	8b 45 0c             	mov    0xc(%ebp),%eax
    13d5:	0f b6 00             	movzbl (%eax),%eax
    13d8:	38 c2                	cmp    %al,%dl
    13da:	74 de                	je     13ba <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
    13dc:	8b 45 08             	mov    0x8(%ebp),%eax
    13df:	0f b6 00             	movzbl (%eax),%eax
    13e2:	0f b6 d0             	movzbl %al,%edx
    13e5:	8b 45 0c             	mov    0xc(%ebp),%eax
    13e8:	0f b6 00             	movzbl (%eax),%eax
    13eb:	0f b6 c0             	movzbl %al,%eax
    13ee:	29 c2                	sub    %eax,%edx
    13f0:	89 d0                	mov    %edx,%eax
}
    13f2:	5d                   	pop    %ebp
    13f3:	c3                   	ret    

000013f4 <strlen>:

uint
strlen(char *s)
{
    13f4:	55                   	push   %ebp
    13f5:	89 e5                	mov    %esp,%ebp
    13f7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    13fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1401:	eb 04                	jmp    1407 <strlen+0x13>
    1403:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1407:	8b 55 fc             	mov    -0x4(%ebp),%edx
    140a:	8b 45 08             	mov    0x8(%ebp),%eax
    140d:	01 d0                	add    %edx,%eax
    140f:	0f b6 00             	movzbl (%eax),%eax
    1412:	84 c0                	test   %al,%al
    1414:	75 ed                	jne    1403 <strlen+0xf>
    ;
  return n;
    1416:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1419:	c9                   	leave  
    141a:	c3                   	ret    

0000141b <memset>:

void*
memset(void *dst, int c, uint n)
{
    141b:	55                   	push   %ebp
    141c:	89 e5                	mov    %esp,%ebp
    141e:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1421:	8b 45 10             	mov    0x10(%ebp),%eax
    1424:	89 44 24 08          	mov    %eax,0x8(%esp)
    1428:	8b 45 0c             	mov    0xc(%ebp),%eax
    142b:	89 44 24 04          	mov    %eax,0x4(%esp)
    142f:	8b 45 08             	mov    0x8(%ebp),%eax
    1432:	89 04 24             	mov    %eax,(%esp)
    1435:	e8 26 ff ff ff       	call   1360 <stosb>
  return dst;
    143a:	8b 45 08             	mov    0x8(%ebp),%eax
}
    143d:	c9                   	leave  
    143e:	c3                   	ret    

0000143f <strchr>:

char*
strchr(const char *s, char c)
{
    143f:	55                   	push   %ebp
    1440:	89 e5                	mov    %esp,%ebp
    1442:	83 ec 04             	sub    $0x4,%esp
    1445:	8b 45 0c             	mov    0xc(%ebp),%eax
    1448:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    144b:	eb 14                	jmp    1461 <strchr+0x22>
    if(*s == c)
    144d:	8b 45 08             	mov    0x8(%ebp),%eax
    1450:	0f b6 00             	movzbl (%eax),%eax
    1453:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1456:	75 05                	jne    145d <strchr+0x1e>
      return (char*)s;
    1458:	8b 45 08             	mov    0x8(%ebp),%eax
    145b:	eb 13                	jmp    1470 <strchr+0x31>
  for(; *s; s++)
    145d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1461:	8b 45 08             	mov    0x8(%ebp),%eax
    1464:	0f b6 00             	movzbl (%eax),%eax
    1467:	84 c0                	test   %al,%al
    1469:	75 e2                	jne    144d <strchr+0xe>
  return 0;
    146b:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1470:	c9                   	leave  
    1471:	c3                   	ret    

00001472 <gets>:

char*
gets(char *buf, int max)
{
    1472:	55                   	push   %ebp
    1473:	89 e5                	mov    %esp,%ebp
    1475:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1478:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    147f:	eb 4c                	jmp    14cd <gets+0x5b>
    cc = read(0, &c, 1);
    1481:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1488:	00 
    1489:	8d 45 ef             	lea    -0x11(%ebp),%eax
    148c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1490:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1497:	e8 44 01 00 00       	call   15e0 <read>
    149c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    149f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    14a3:	7f 02                	jg     14a7 <gets+0x35>
      break;
    14a5:	eb 31                	jmp    14d8 <gets+0x66>
    buf[i++] = c;
    14a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14aa:	8d 50 01             	lea    0x1(%eax),%edx
    14ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
    14b0:	89 c2                	mov    %eax,%edx
    14b2:	8b 45 08             	mov    0x8(%ebp),%eax
    14b5:	01 c2                	add    %eax,%edx
    14b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    14bb:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    14bd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    14c1:	3c 0a                	cmp    $0xa,%al
    14c3:	74 13                	je     14d8 <gets+0x66>
    14c5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    14c9:	3c 0d                	cmp    $0xd,%al
    14cb:	74 0b                	je     14d8 <gets+0x66>
  for(i=0; i+1 < max; ){
    14cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14d0:	83 c0 01             	add    $0x1,%eax
    14d3:	3b 45 0c             	cmp    0xc(%ebp),%eax
    14d6:	7c a9                	jl     1481 <gets+0xf>
      break;
  }
  buf[i] = '\0';
    14d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
    14db:	8b 45 08             	mov    0x8(%ebp),%eax
    14de:	01 d0                	add    %edx,%eax
    14e0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    14e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
    14e6:	c9                   	leave  
    14e7:	c3                   	ret    

000014e8 <stat>:

int
stat(char *n, struct stat *st)
{
    14e8:	55                   	push   %ebp
    14e9:	89 e5                	mov    %esp,%ebp
    14eb:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    14ee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    14f5:	00 
    14f6:	8b 45 08             	mov    0x8(%ebp),%eax
    14f9:	89 04 24             	mov    %eax,(%esp)
    14fc:	e8 07 01 00 00       	call   1608 <open>
    1501:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1504:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1508:	79 07                	jns    1511 <stat+0x29>
    return -1;
    150a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    150f:	eb 23                	jmp    1534 <stat+0x4c>
  r = fstat(fd, st);
    1511:	8b 45 0c             	mov    0xc(%ebp),%eax
    1514:	89 44 24 04          	mov    %eax,0x4(%esp)
    1518:	8b 45 f4             	mov    -0xc(%ebp),%eax
    151b:	89 04 24             	mov    %eax,(%esp)
    151e:	e8 fd 00 00 00       	call   1620 <fstat>
    1523:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1526:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1529:	89 04 24             	mov    %eax,(%esp)
    152c:	e8 bf 00 00 00       	call   15f0 <close>
  return r;
    1531:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1534:	c9                   	leave  
    1535:	c3                   	ret    

00001536 <atoi>:

int
atoi(const char *s)
{
    1536:	55                   	push   %ebp
    1537:	89 e5                	mov    %esp,%ebp
    1539:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    153c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1543:	eb 25                	jmp    156a <atoi+0x34>
    n = n*10 + *s++ - '0';
    1545:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1548:	89 d0                	mov    %edx,%eax
    154a:	c1 e0 02             	shl    $0x2,%eax
    154d:	01 d0                	add    %edx,%eax
    154f:	01 c0                	add    %eax,%eax
    1551:	89 c1                	mov    %eax,%ecx
    1553:	8b 45 08             	mov    0x8(%ebp),%eax
    1556:	8d 50 01             	lea    0x1(%eax),%edx
    1559:	89 55 08             	mov    %edx,0x8(%ebp)
    155c:	0f b6 00             	movzbl (%eax),%eax
    155f:	0f be c0             	movsbl %al,%eax
    1562:	01 c8                	add    %ecx,%eax
    1564:	83 e8 30             	sub    $0x30,%eax
    1567:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    156a:	8b 45 08             	mov    0x8(%ebp),%eax
    156d:	0f b6 00             	movzbl (%eax),%eax
    1570:	3c 2f                	cmp    $0x2f,%al
    1572:	7e 0a                	jle    157e <atoi+0x48>
    1574:	8b 45 08             	mov    0x8(%ebp),%eax
    1577:	0f b6 00             	movzbl (%eax),%eax
    157a:	3c 39                	cmp    $0x39,%al
    157c:	7e c7                	jle    1545 <atoi+0xf>
  return n;
    157e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1581:	c9                   	leave  
    1582:	c3                   	ret    

00001583 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1583:	55                   	push   %ebp
    1584:	89 e5                	mov    %esp,%ebp
    1586:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    1589:	8b 45 08             	mov    0x8(%ebp),%eax
    158c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    158f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1592:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1595:	eb 17                	jmp    15ae <memmove+0x2b>
    *dst++ = *src++;
    1597:	8b 45 fc             	mov    -0x4(%ebp),%eax
    159a:	8d 50 01             	lea    0x1(%eax),%edx
    159d:	89 55 fc             	mov    %edx,-0x4(%ebp)
    15a0:	8b 55 f8             	mov    -0x8(%ebp),%edx
    15a3:	8d 4a 01             	lea    0x1(%edx),%ecx
    15a6:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    15a9:	0f b6 12             	movzbl (%edx),%edx
    15ac:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
    15ae:	8b 45 10             	mov    0x10(%ebp),%eax
    15b1:	8d 50 ff             	lea    -0x1(%eax),%edx
    15b4:	89 55 10             	mov    %edx,0x10(%ebp)
    15b7:	85 c0                	test   %eax,%eax
    15b9:	7f dc                	jg     1597 <memmove+0x14>
  return vdst;
    15bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
    15be:	c9                   	leave  
    15bf:	c3                   	ret    

000015c0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    15c0:	b8 01 00 00 00       	mov    $0x1,%eax
    15c5:	cd 40                	int    $0x40
    15c7:	c3                   	ret    

000015c8 <exit>:
SYSCALL(exit)
    15c8:	b8 02 00 00 00       	mov    $0x2,%eax
    15cd:	cd 40                	int    $0x40
    15cf:	c3                   	ret    

000015d0 <wait>:
SYSCALL(wait)
    15d0:	b8 03 00 00 00       	mov    $0x3,%eax
    15d5:	cd 40                	int    $0x40
    15d7:	c3                   	ret    

000015d8 <pipe>:
SYSCALL(pipe)
    15d8:	b8 04 00 00 00       	mov    $0x4,%eax
    15dd:	cd 40                	int    $0x40
    15df:	c3                   	ret    

000015e0 <read>:
SYSCALL(read)
    15e0:	b8 05 00 00 00       	mov    $0x5,%eax
    15e5:	cd 40                	int    $0x40
    15e7:	c3                   	ret    

000015e8 <write>:
SYSCALL(write)
    15e8:	b8 10 00 00 00       	mov    $0x10,%eax
    15ed:	cd 40                	int    $0x40
    15ef:	c3                   	ret    

000015f0 <close>:
SYSCALL(close)
    15f0:	b8 15 00 00 00       	mov    $0x15,%eax
    15f5:	cd 40                	int    $0x40
    15f7:	c3                   	ret    

000015f8 <kill>:
SYSCALL(kill)
    15f8:	b8 06 00 00 00       	mov    $0x6,%eax
    15fd:	cd 40                	int    $0x40
    15ff:	c3                   	ret    

00001600 <exec>:
SYSCALL(exec)
    1600:	b8 07 00 00 00       	mov    $0x7,%eax
    1605:	cd 40                	int    $0x40
    1607:	c3                   	ret    

00001608 <open>:
SYSCALL(open)
    1608:	b8 0f 00 00 00       	mov    $0xf,%eax
    160d:	cd 40                	int    $0x40
    160f:	c3                   	ret    

00001610 <mknod>:
SYSCALL(mknod)
    1610:	b8 11 00 00 00       	mov    $0x11,%eax
    1615:	cd 40                	int    $0x40
    1617:	c3                   	ret    

00001618 <unlink>:
SYSCALL(unlink)
    1618:	b8 12 00 00 00       	mov    $0x12,%eax
    161d:	cd 40                	int    $0x40
    161f:	c3                   	ret    

00001620 <fstat>:
SYSCALL(fstat)
    1620:	b8 08 00 00 00       	mov    $0x8,%eax
    1625:	cd 40                	int    $0x40
    1627:	c3                   	ret    

00001628 <link>:
SYSCALL(link)
    1628:	b8 13 00 00 00       	mov    $0x13,%eax
    162d:	cd 40                	int    $0x40
    162f:	c3                   	ret    

00001630 <mkdir>:
SYSCALL(mkdir)
    1630:	b8 14 00 00 00       	mov    $0x14,%eax
    1635:	cd 40                	int    $0x40
    1637:	c3                   	ret    

00001638 <chdir>:
SYSCALL(chdir)
    1638:	b8 09 00 00 00       	mov    $0x9,%eax
    163d:	cd 40                	int    $0x40
    163f:	c3                   	ret    

00001640 <dup>:
SYSCALL(dup)
    1640:	b8 0a 00 00 00       	mov    $0xa,%eax
    1645:	cd 40                	int    $0x40
    1647:	c3                   	ret    

00001648 <getpid>:
SYSCALL(getpid)
    1648:	b8 0b 00 00 00       	mov    $0xb,%eax
    164d:	cd 40                	int    $0x40
    164f:	c3                   	ret    

00001650 <sbrk>:
SYSCALL(sbrk)
    1650:	b8 0c 00 00 00       	mov    $0xc,%eax
    1655:	cd 40                	int    $0x40
    1657:	c3                   	ret    

00001658 <sleep>:
SYSCALL(sleep)
    1658:	b8 0d 00 00 00       	mov    $0xd,%eax
    165d:	cd 40                	int    $0x40
    165f:	c3                   	ret    

00001660 <uptime>:
SYSCALL(uptime)
    1660:	b8 0e 00 00 00       	mov    $0xe,%eax
    1665:	cd 40                	int    $0x40
    1667:	c3                   	ret    

00001668 <shm_open>:
SYSCALL(shm_open)
    1668:	b8 16 00 00 00       	mov    $0x16,%eax
    166d:	cd 40                	int    $0x40
    166f:	c3                   	ret    

00001670 <shm_close>:
SYSCALL(shm_close)	
    1670:	b8 17 00 00 00       	mov    $0x17,%eax
    1675:	cd 40                	int    $0x40
    1677:	c3                   	ret    

00001678 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1678:	55                   	push   %ebp
    1679:	89 e5                	mov    %esp,%ebp
    167b:	83 ec 18             	sub    $0x18,%esp
    167e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1681:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1684:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    168b:	00 
    168c:	8d 45 f4             	lea    -0xc(%ebp),%eax
    168f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1693:	8b 45 08             	mov    0x8(%ebp),%eax
    1696:	89 04 24             	mov    %eax,(%esp)
    1699:	e8 4a ff ff ff       	call   15e8 <write>
}
    169e:	c9                   	leave  
    169f:	c3                   	ret    

000016a0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    16a0:	55                   	push   %ebp
    16a1:	89 e5                	mov    %esp,%ebp
    16a3:	56                   	push   %esi
    16a4:	53                   	push   %ebx
    16a5:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    16a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    16af:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    16b3:	74 17                	je     16cc <printint+0x2c>
    16b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    16b9:	79 11                	jns    16cc <printint+0x2c>
    neg = 1;
    16bb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    16c2:	8b 45 0c             	mov    0xc(%ebp),%eax
    16c5:	f7 d8                	neg    %eax
    16c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    16ca:	eb 06                	jmp    16d2 <printint+0x32>
  } else {
    x = xx;
    16cc:	8b 45 0c             	mov    0xc(%ebp),%eax
    16cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    16d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    16d9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    16dc:	8d 41 01             	lea    0x1(%ecx),%eax
    16df:	89 45 f4             	mov    %eax,-0xc(%ebp)
    16e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
    16e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    16e8:	ba 00 00 00 00       	mov    $0x0,%edx
    16ed:	f7 f3                	div    %ebx
    16ef:	89 d0                	mov    %edx,%eax
    16f1:	0f b6 80 dc 1e 00 00 	movzbl 0x1edc(%eax),%eax
    16f8:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    16fc:	8b 75 10             	mov    0x10(%ebp),%esi
    16ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1702:	ba 00 00 00 00       	mov    $0x0,%edx
    1707:	f7 f6                	div    %esi
    1709:	89 45 ec             	mov    %eax,-0x14(%ebp)
    170c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1710:	75 c7                	jne    16d9 <printint+0x39>
  if(neg)
    1712:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1716:	74 10                	je     1728 <printint+0x88>
    buf[i++] = '-';
    1718:	8b 45 f4             	mov    -0xc(%ebp),%eax
    171b:	8d 50 01             	lea    0x1(%eax),%edx
    171e:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1721:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1726:	eb 1f                	jmp    1747 <printint+0xa7>
    1728:	eb 1d                	jmp    1747 <printint+0xa7>
    putc(fd, buf[i]);
    172a:	8d 55 dc             	lea    -0x24(%ebp),%edx
    172d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1730:	01 d0                	add    %edx,%eax
    1732:	0f b6 00             	movzbl (%eax),%eax
    1735:	0f be c0             	movsbl %al,%eax
    1738:	89 44 24 04          	mov    %eax,0x4(%esp)
    173c:	8b 45 08             	mov    0x8(%ebp),%eax
    173f:	89 04 24             	mov    %eax,(%esp)
    1742:	e8 31 ff ff ff       	call   1678 <putc>
  while(--i >= 0)
    1747:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    174b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    174f:	79 d9                	jns    172a <printint+0x8a>
}
    1751:	83 c4 30             	add    $0x30,%esp
    1754:	5b                   	pop    %ebx
    1755:	5e                   	pop    %esi
    1756:	5d                   	pop    %ebp
    1757:	c3                   	ret    

00001758 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1758:	55                   	push   %ebp
    1759:	89 e5                	mov    %esp,%ebp
    175b:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    175e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1765:	8d 45 0c             	lea    0xc(%ebp),%eax
    1768:	83 c0 04             	add    $0x4,%eax
    176b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    176e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1775:	e9 7c 01 00 00       	jmp    18f6 <printf+0x19e>
    c = fmt[i] & 0xff;
    177a:	8b 55 0c             	mov    0xc(%ebp),%edx
    177d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1780:	01 d0                	add    %edx,%eax
    1782:	0f b6 00             	movzbl (%eax),%eax
    1785:	0f be c0             	movsbl %al,%eax
    1788:	25 ff 00 00 00       	and    $0xff,%eax
    178d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1790:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1794:	75 2c                	jne    17c2 <printf+0x6a>
      if(c == '%'){
    1796:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    179a:	75 0c                	jne    17a8 <printf+0x50>
        state = '%';
    179c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    17a3:	e9 4a 01 00 00       	jmp    18f2 <printf+0x19a>
      } else {
        putc(fd, c);
    17a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    17ab:	0f be c0             	movsbl %al,%eax
    17ae:	89 44 24 04          	mov    %eax,0x4(%esp)
    17b2:	8b 45 08             	mov    0x8(%ebp),%eax
    17b5:	89 04 24             	mov    %eax,(%esp)
    17b8:	e8 bb fe ff ff       	call   1678 <putc>
    17bd:	e9 30 01 00 00       	jmp    18f2 <printf+0x19a>
      }
    } else if(state == '%'){
    17c2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    17c6:	0f 85 26 01 00 00    	jne    18f2 <printf+0x19a>
      if(c == 'd'){
    17cc:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    17d0:	75 2d                	jne    17ff <printf+0xa7>
        printint(fd, *ap, 10, 1);
    17d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17d5:	8b 00                	mov    (%eax),%eax
    17d7:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    17de:	00 
    17df:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    17e6:	00 
    17e7:	89 44 24 04          	mov    %eax,0x4(%esp)
    17eb:	8b 45 08             	mov    0x8(%ebp),%eax
    17ee:	89 04 24             	mov    %eax,(%esp)
    17f1:	e8 aa fe ff ff       	call   16a0 <printint>
        ap++;
    17f6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    17fa:	e9 ec 00 00 00       	jmp    18eb <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    17ff:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1803:	74 06                	je     180b <printf+0xb3>
    1805:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1809:	75 2d                	jne    1838 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    180b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    180e:	8b 00                	mov    (%eax),%eax
    1810:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1817:	00 
    1818:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    181f:	00 
    1820:	89 44 24 04          	mov    %eax,0x4(%esp)
    1824:	8b 45 08             	mov    0x8(%ebp),%eax
    1827:	89 04 24             	mov    %eax,(%esp)
    182a:	e8 71 fe ff ff       	call   16a0 <printint>
        ap++;
    182f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1833:	e9 b3 00 00 00       	jmp    18eb <printf+0x193>
      } else if(c == 's'){
    1838:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    183c:	75 45                	jne    1883 <printf+0x12b>
        s = (char*)*ap;
    183e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1841:	8b 00                	mov    (%eax),%eax
    1843:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1846:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    184a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    184e:	75 09                	jne    1859 <printf+0x101>
          s = "(null)";
    1850:	c7 45 f4 ae 1b 00 00 	movl   $0x1bae,-0xc(%ebp)
        while(*s != 0){
    1857:	eb 1e                	jmp    1877 <printf+0x11f>
    1859:	eb 1c                	jmp    1877 <printf+0x11f>
          putc(fd, *s);
    185b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    185e:	0f b6 00             	movzbl (%eax),%eax
    1861:	0f be c0             	movsbl %al,%eax
    1864:	89 44 24 04          	mov    %eax,0x4(%esp)
    1868:	8b 45 08             	mov    0x8(%ebp),%eax
    186b:	89 04 24             	mov    %eax,(%esp)
    186e:	e8 05 fe ff ff       	call   1678 <putc>
          s++;
    1873:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
    1877:	8b 45 f4             	mov    -0xc(%ebp),%eax
    187a:	0f b6 00             	movzbl (%eax),%eax
    187d:	84 c0                	test   %al,%al
    187f:	75 da                	jne    185b <printf+0x103>
    1881:	eb 68                	jmp    18eb <printf+0x193>
        }
      } else if(c == 'c'){
    1883:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1887:	75 1d                	jne    18a6 <printf+0x14e>
        putc(fd, *ap);
    1889:	8b 45 e8             	mov    -0x18(%ebp),%eax
    188c:	8b 00                	mov    (%eax),%eax
    188e:	0f be c0             	movsbl %al,%eax
    1891:	89 44 24 04          	mov    %eax,0x4(%esp)
    1895:	8b 45 08             	mov    0x8(%ebp),%eax
    1898:	89 04 24             	mov    %eax,(%esp)
    189b:	e8 d8 fd ff ff       	call   1678 <putc>
        ap++;
    18a0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    18a4:	eb 45                	jmp    18eb <printf+0x193>
      } else if(c == '%'){
    18a6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    18aa:	75 17                	jne    18c3 <printf+0x16b>
        putc(fd, c);
    18ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    18af:	0f be c0             	movsbl %al,%eax
    18b2:	89 44 24 04          	mov    %eax,0x4(%esp)
    18b6:	8b 45 08             	mov    0x8(%ebp),%eax
    18b9:	89 04 24             	mov    %eax,(%esp)
    18bc:	e8 b7 fd ff ff       	call   1678 <putc>
    18c1:	eb 28                	jmp    18eb <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    18c3:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    18ca:	00 
    18cb:	8b 45 08             	mov    0x8(%ebp),%eax
    18ce:	89 04 24             	mov    %eax,(%esp)
    18d1:	e8 a2 fd ff ff       	call   1678 <putc>
        putc(fd, c);
    18d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    18d9:	0f be c0             	movsbl %al,%eax
    18dc:	89 44 24 04          	mov    %eax,0x4(%esp)
    18e0:	8b 45 08             	mov    0x8(%ebp),%eax
    18e3:	89 04 24             	mov    %eax,(%esp)
    18e6:	e8 8d fd ff ff       	call   1678 <putc>
      }
      state = 0;
    18eb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    18f2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    18f6:	8b 55 0c             	mov    0xc(%ebp),%edx
    18f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18fc:	01 d0                	add    %edx,%eax
    18fe:	0f b6 00             	movzbl (%eax),%eax
    1901:	84 c0                	test   %al,%al
    1903:	0f 85 71 fe ff ff    	jne    177a <printf+0x22>
    }
  }
}
    1909:	c9                   	leave  
    190a:	c3                   	ret    

0000190b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    190b:	55                   	push   %ebp
    190c:	89 e5                	mov    %esp,%ebp
    190e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1911:	8b 45 08             	mov    0x8(%ebp),%eax
    1914:	83 e8 08             	sub    $0x8,%eax
    1917:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    191a:	a1 08 1f 00 00       	mov    0x1f08,%eax
    191f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1922:	eb 24                	jmp    1948 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1924:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1927:	8b 00                	mov    (%eax),%eax
    1929:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    192c:	77 12                	ja     1940 <free+0x35>
    192e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1931:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1934:	77 24                	ja     195a <free+0x4f>
    1936:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1939:	8b 00                	mov    (%eax),%eax
    193b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    193e:	77 1a                	ja     195a <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1940:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1943:	8b 00                	mov    (%eax),%eax
    1945:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1948:	8b 45 f8             	mov    -0x8(%ebp),%eax
    194b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    194e:	76 d4                	jbe    1924 <free+0x19>
    1950:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1953:	8b 00                	mov    (%eax),%eax
    1955:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1958:	76 ca                	jbe    1924 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    195a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    195d:	8b 40 04             	mov    0x4(%eax),%eax
    1960:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1967:	8b 45 f8             	mov    -0x8(%ebp),%eax
    196a:	01 c2                	add    %eax,%edx
    196c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    196f:	8b 00                	mov    (%eax),%eax
    1971:	39 c2                	cmp    %eax,%edx
    1973:	75 24                	jne    1999 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1975:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1978:	8b 50 04             	mov    0x4(%eax),%edx
    197b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    197e:	8b 00                	mov    (%eax),%eax
    1980:	8b 40 04             	mov    0x4(%eax),%eax
    1983:	01 c2                	add    %eax,%edx
    1985:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1988:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    198b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    198e:	8b 00                	mov    (%eax),%eax
    1990:	8b 10                	mov    (%eax),%edx
    1992:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1995:	89 10                	mov    %edx,(%eax)
    1997:	eb 0a                	jmp    19a3 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1999:	8b 45 fc             	mov    -0x4(%ebp),%eax
    199c:	8b 10                	mov    (%eax),%edx
    199e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19a1:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    19a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19a6:	8b 40 04             	mov    0x4(%eax),%eax
    19a9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    19b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19b3:	01 d0                	add    %edx,%eax
    19b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    19b8:	75 20                	jne    19da <free+0xcf>
    p->s.size += bp->s.size;
    19ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19bd:	8b 50 04             	mov    0x4(%eax),%edx
    19c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19c3:	8b 40 04             	mov    0x4(%eax),%eax
    19c6:	01 c2                	add    %eax,%edx
    19c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19cb:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    19ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19d1:	8b 10                	mov    (%eax),%edx
    19d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19d6:	89 10                	mov    %edx,(%eax)
    19d8:	eb 08                	jmp    19e2 <free+0xd7>
  } else
    p->s.ptr = bp;
    19da:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19dd:	8b 55 f8             	mov    -0x8(%ebp),%edx
    19e0:	89 10                	mov    %edx,(%eax)
  freep = p;
    19e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19e5:	a3 08 1f 00 00       	mov    %eax,0x1f08
}
    19ea:	c9                   	leave  
    19eb:	c3                   	ret    

000019ec <morecore>:

static Header*
morecore(uint nu)
{
    19ec:	55                   	push   %ebp
    19ed:	89 e5                	mov    %esp,%ebp
    19ef:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    19f2:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    19f9:	77 07                	ja     1a02 <morecore+0x16>
    nu = 4096;
    19fb:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1a02:	8b 45 08             	mov    0x8(%ebp),%eax
    1a05:	c1 e0 03             	shl    $0x3,%eax
    1a08:	89 04 24             	mov    %eax,(%esp)
    1a0b:	e8 40 fc ff ff       	call   1650 <sbrk>
    1a10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1a13:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1a17:	75 07                	jne    1a20 <morecore+0x34>
    return 0;
    1a19:	b8 00 00 00 00       	mov    $0x0,%eax
    1a1e:	eb 22                	jmp    1a42 <morecore+0x56>
  hp = (Header*)p;
    1a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a29:	8b 55 08             	mov    0x8(%ebp),%edx
    1a2c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a32:	83 c0 08             	add    $0x8,%eax
    1a35:	89 04 24             	mov    %eax,(%esp)
    1a38:	e8 ce fe ff ff       	call   190b <free>
  return freep;
    1a3d:	a1 08 1f 00 00       	mov    0x1f08,%eax
}
    1a42:	c9                   	leave  
    1a43:	c3                   	ret    

00001a44 <malloc>:

void*
malloc(uint nbytes)
{
    1a44:	55                   	push   %ebp
    1a45:	89 e5                	mov    %esp,%ebp
    1a47:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1a4a:	8b 45 08             	mov    0x8(%ebp),%eax
    1a4d:	83 c0 07             	add    $0x7,%eax
    1a50:	c1 e8 03             	shr    $0x3,%eax
    1a53:	83 c0 01             	add    $0x1,%eax
    1a56:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1a59:	a1 08 1f 00 00       	mov    0x1f08,%eax
    1a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1a61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1a65:	75 23                	jne    1a8a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1a67:	c7 45 f0 00 1f 00 00 	movl   $0x1f00,-0x10(%ebp)
    1a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a71:	a3 08 1f 00 00       	mov    %eax,0x1f08
    1a76:	a1 08 1f 00 00       	mov    0x1f08,%eax
    1a7b:	a3 00 1f 00 00       	mov    %eax,0x1f00
    base.s.size = 0;
    1a80:	c7 05 04 1f 00 00 00 	movl   $0x0,0x1f04
    1a87:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1a8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a8d:	8b 00                	mov    (%eax),%eax
    1a8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a95:	8b 40 04             	mov    0x4(%eax),%eax
    1a98:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1a9b:	72 4d                	jb     1aea <malloc+0xa6>
      if(p->s.size == nunits)
    1a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aa0:	8b 40 04             	mov    0x4(%eax),%eax
    1aa3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1aa6:	75 0c                	jne    1ab4 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aab:	8b 10                	mov    (%eax),%edx
    1aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ab0:	89 10                	mov    %edx,(%eax)
    1ab2:	eb 26                	jmp    1ada <malloc+0x96>
      else {
        p->s.size -= nunits;
    1ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ab7:	8b 40 04             	mov    0x4(%eax),%eax
    1aba:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1abd:	89 c2                	mov    %eax,%edx
    1abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ac2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ac8:	8b 40 04             	mov    0x4(%eax),%eax
    1acb:	c1 e0 03             	shl    $0x3,%eax
    1ace:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ad4:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1ad7:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1add:	a3 08 1f 00 00       	mov    %eax,0x1f08
      return (void*)(p + 1);
    1ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ae5:	83 c0 08             	add    $0x8,%eax
    1ae8:	eb 38                	jmp    1b22 <malloc+0xde>
    }
    if(p == freep)
    1aea:	a1 08 1f 00 00       	mov    0x1f08,%eax
    1aef:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1af2:	75 1b                	jne    1b0f <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1af4:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1af7:	89 04 24             	mov    %eax,(%esp)
    1afa:	e8 ed fe ff ff       	call   19ec <morecore>
    1aff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1b02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1b06:	75 07                	jne    1b0f <malloc+0xcb>
        return 0;
    1b08:	b8 00 00 00 00       	mov    $0x0,%eax
    1b0d:	eb 13                	jmp    1b22 <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b12:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b18:	8b 00                	mov    (%eax),%eax
    1b1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
    1b1d:	e9 70 ff ff ff       	jmp    1a92 <malloc+0x4e>
}
    1b22:	c9                   	leave  
    1b23:	c3                   	ret    

00001b24 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    1b24:	55                   	push   %ebp
    1b25:	89 e5                	mov    %esp,%ebp
    1b27:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1b2a:	8b 55 08             	mov    0x8(%ebp),%edx
    1b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1b30:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1b33:	f0 87 02             	lock xchg %eax,(%edx)
    1b36:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1b39:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1b3c:	c9                   	leave  
    1b3d:	c3                   	ret    

00001b3e <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    1b3e:	55                   	push   %ebp
    1b3f:	89 e5                	mov    %esp,%ebp
    1b41:	83 ec 08             	sub    $0x8,%esp
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    1b44:	90                   	nop
    1b45:	8b 45 08             	mov    0x8(%ebp),%eax
    1b48:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1b4f:	00 
    1b50:	89 04 24             	mov    %eax,(%esp)
    1b53:	e8 cc ff ff ff       	call   1b24 <xchg>
    1b58:	85 c0                	test   %eax,%eax
    1b5a:	75 e9                	jne    1b45 <uacquire+0x7>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    1b5c:	0f ae f0             	mfence 
}
    1b5f:	c9                   	leave  
    1b60:	c3                   	ret    

00001b61 <urelease>:

void urelease (struct uspinlock *lk) {
    1b61:	55                   	push   %ebp
    1b62:	89 e5                	mov    %esp,%ebp
  __sync_synchronize();
    1b64:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    1b67:	8b 45 08             	mov    0x8(%ebp),%eax
    1b6a:	8b 55 08             	mov    0x8(%ebp),%edx
    1b6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1b73:	5d                   	pop    %ebp
    1b74:	c3                   	ret    
