
_shm_cnt:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
   struct uspinlock lock;
   int cnt;
};

int main(int argc, char *argv[])
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 30             	sub    $0x30,%esp
int pid;
int i=0;
    1009:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
    1010:	00 
struct shm_cnt *counter;
  pid=fork();
    1011:	e8 8b 03 00 00       	call   13a1 <fork>
    1016:	89 44 24 28          	mov    %eax,0x28(%esp)
  sleep(1);
    101a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1021:	e8 13 04 00 00       	call   1439 <sleep>

//shm_open: first process will create the page, the second will just attach to the same page
//we get the virtual address of the page returned into counter
//which we can now use but will be shared between the two processes
  
shm_open(1,(char **)&counter);
    1026:	8d 44 24 24          	lea    0x24(%esp),%eax
    102a:	89 44 24 04          	mov    %eax,0x4(%esp)
    102e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1035:	e8 0f 04 00 00       	call   1449 <shm_open>
 
//  printf(1,"%s returned successfully from shm_open with counter %x\n", pid? "Child": "Parent", counter); 
  for(i = 0; i < 10000; i++)
    103a:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
    1041:	00 
    1042:	e9 8f 00 00 00       	jmp    10d6 <main+0xd6>
    {
     uacquire(&(counter->lock));
    1047:	8b 44 24 24          	mov    0x24(%esp),%eax
    104b:	89 04 24             	mov    %eax,(%esp)
    104e:	e8 cc 08 00 00       	call   191f <uacquire>
     counter->cnt++;
    1053:	8b 44 24 24          	mov    0x24(%esp),%eax
    1057:	8b 50 04             	mov    0x4(%eax),%edx
    105a:	83 c2 01             	add    $0x1,%edx
    105d:	89 50 04             	mov    %edx,0x4(%eax)
     urelease(&(counter->lock));
    1060:	8b 44 24 24          	mov    0x24(%esp),%eax
    1064:	89 04 24             	mov    %eax,(%esp)
    1067:	e8 d6 08 00 00       	call   1942 <urelease>

//print something because we are curious and to give a chance to switch process
     if(i%1000 == 0)
    106c:	8b 4c 24 2c          	mov    0x2c(%esp),%ecx
    1070:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    1075:	89 c8                	mov    %ecx,%eax
    1077:	f7 ea                	imul   %edx
    1079:	c1 fa 06             	sar    $0x6,%edx
    107c:	89 c8                	mov    %ecx,%eax
    107e:	c1 f8 1f             	sar    $0x1f,%eax
    1081:	29 c2                	sub    %eax,%edx
    1083:	89 d0                	mov    %edx,%eax
    1085:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
    108b:	29 c1                	sub    %eax,%ecx
    108d:	89 c8                	mov    %ecx,%eax
    108f:	85 c0                	test   %eax,%eax
    1091:	75 3e                	jne    10d1 <main+0xd1>
       printf(1,"Counter in %s is %d at address %x\n",pid? "Parent" : "Child", counter->cnt, counter);
    1093:	8b 4c 24 24          	mov    0x24(%esp),%ecx
    1097:	8b 44 24 24          	mov    0x24(%esp),%eax
    109b:	8b 50 04             	mov    0x4(%eax),%edx
    109e:	83 7c 24 28 00       	cmpl   $0x0,0x28(%esp)
    10a3:	74 07                	je     10ac <main+0xac>
    10a5:	b8 58 19 00 00       	mov    $0x1958,%eax
    10aa:	eb 05                	jmp    10b1 <main+0xb1>
    10ac:	b8 5f 19 00 00       	mov    $0x195f,%eax
    10b1:	89 4c 24 10          	mov    %ecx,0x10(%esp)
    10b5:	89 54 24 0c          	mov    %edx,0xc(%esp)
    10b9:	89 44 24 08          	mov    %eax,0x8(%esp)
    10bd:	c7 44 24 04 68 19 00 	movl   $0x1968,0x4(%esp)
    10c4:	00 
    10c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10cc:	e8 68 04 00 00       	call   1539 <printf>
  for(i = 0; i < 10000; i++)
    10d1:	83 44 24 2c 01       	addl   $0x1,0x2c(%esp)
    10d6:	81 7c 24 2c 0f 27 00 	cmpl   $0x270f,0x2c(%esp)
    10dd:	00 
    10de:	0f 8e 63 ff ff ff    	jle    1047 <main+0x47>
}
  
  if(pid)
    10e4:	83 7c 24 28 00       	cmpl   $0x0,0x28(%esp)
    10e9:	74 26                	je     1111 <main+0x111>
     {
       printf(1,"Counter in parent is %d\n",counter->cnt);
    10eb:	8b 44 24 24          	mov    0x24(%esp),%eax
    10ef:	8b 40 04             	mov    0x4(%eax),%eax
    10f2:	89 44 24 08          	mov    %eax,0x8(%esp)
    10f6:	c7 44 24 04 8b 19 00 	movl   $0x198b,0x4(%esp)
    10fd:	00 
    10fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1105:	e8 2f 04 00 00       	call   1539 <printf>
    wait();
    110a:	e8 a2 02 00 00       	call   13b1 <wait>
    110f:	eb 1f                	jmp    1130 <main+0x130>
    } else
    printf(1,"Counter in child is %d\n\n",counter->cnt);
    1111:	8b 44 24 24          	mov    0x24(%esp),%eax
    1115:	8b 40 04             	mov    0x4(%eax),%eax
    1118:	89 44 24 08          	mov    %eax,0x8(%esp)
    111c:	c7 44 24 04 a4 19 00 	movl   $0x19a4,0x4(%esp)
    1123:	00 
    1124:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    112b:	e8 09 04 00 00       	call   1539 <printf>

//shm_close: first process will just detach, next one will free up the shm_table entry (but for now not the page)
   shm_close(1);
    1130:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1137:	e8 15 03 00 00       	call   1451 <shm_close>
   exit();
    113c:	e8 68 02 00 00       	call   13a9 <exit>

00001141 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1141:	55                   	push   %ebp
    1142:	89 e5                	mov    %esp,%ebp
    1144:	57                   	push   %edi
    1145:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1146:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1149:	8b 55 10             	mov    0x10(%ebp),%edx
    114c:	8b 45 0c             	mov    0xc(%ebp),%eax
    114f:	89 cb                	mov    %ecx,%ebx
    1151:	89 df                	mov    %ebx,%edi
    1153:	89 d1                	mov    %edx,%ecx
    1155:	fc                   	cld    
    1156:	f3 aa                	rep stos %al,%es:(%edi)
    1158:	89 ca                	mov    %ecx,%edx
    115a:	89 fb                	mov    %edi,%ebx
    115c:	89 5d 08             	mov    %ebx,0x8(%ebp)
    115f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1162:	5b                   	pop    %ebx
    1163:	5f                   	pop    %edi
    1164:	5d                   	pop    %ebp
    1165:	c3                   	ret    

00001166 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1166:	55                   	push   %ebp
    1167:	89 e5                	mov    %esp,%ebp
    1169:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    116c:	8b 45 08             	mov    0x8(%ebp),%eax
    116f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1172:	90                   	nop
    1173:	8b 45 08             	mov    0x8(%ebp),%eax
    1176:	8d 50 01             	lea    0x1(%eax),%edx
    1179:	89 55 08             	mov    %edx,0x8(%ebp)
    117c:	8b 55 0c             	mov    0xc(%ebp),%edx
    117f:	8d 4a 01             	lea    0x1(%edx),%ecx
    1182:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1185:	0f b6 12             	movzbl (%edx),%edx
    1188:	88 10                	mov    %dl,(%eax)
    118a:	0f b6 00             	movzbl (%eax),%eax
    118d:	84 c0                	test   %al,%al
    118f:	75 e2                	jne    1173 <strcpy+0xd>
    ;
  return os;
    1191:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1194:	c9                   	leave  
    1195:	c3                   	ret    

00001196 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1196:	55                   	push   %ebp
    1197:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1199:	eb 08                	jmp    11a3 <strcmp+0xd>
    p++, q++;
    119b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    119f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
    11a3:	8b 45 08             	mov    0x8(%ebp),%eax
    11a6:	0f b6 00             	movzbl (%eax),%eax
    11a9:	84 c0                	test   %al,%al
    11ab:	74 10                	je     11bd <strcmp+0x27>
    11ad:	8b 45 08             	mov    0x8(%ebp),%eax
    11b0:	0f b6 10             	movzbl (%eax),%edx
    11b3:	8b 45 0c             	mov    0xc(%ebp),%eax
    11b6:	0f b6 00             	movzbl (%eax),%eax
    11b9:	38 c2                	cmp    %al,%dl
    11bb:	74 de                	je     119b <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
    11bd:	8b 45 08             	mov    0x8(%ebp),%eax
    11c0:	0f b6 00             	movzbl (%eax),%eax
    11c3:	0f b6 d0             	movzbl %al,%edx
    11c6:	8b 45 0c             	mov    0xc(%ebp),%eax
    11c9:	0f b6 00             	movzbl (%eax),%eax
    11cc:	0f b6 c0             	movzbl %al,%eax
    11cf:	29 c2                	sub    %eax,%edx
    11d1:	89 d0                	mov    %edx,%eax
}
    11d3:	5d                   	pop    %ebp
    11d4:	c3                   	ret    

000011d5 <strlen>:

uint
strlen(char *s)
{
    11d5:	55                   	push   %ebp
    11d6:	89 e5                	mov    %esp,%ebp
    11d8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    11db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    11e2:	eb 04                	jmp    11e8 <strlen+0x13>
    11e4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    11e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11eb:	8b 45 08             	mov    0x8(%ebp),%eax
    11ee:	01 d0                	add    %edx,%eax
    11f0:	0f b6 00             	movzbl (%eax),%eax
    11f3:	84 c0                	test   %al,%al
    11f5:	75 ed                	jne    11e4 <strlen+0xf>
    ;
  return n;
    11f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11fa:	c9                   	leave  
    11fb:	c3                   	ret    

000011fc <memset>:

void*
memset(void *dst, int c, uint n)
{
    11fc:	55                   	push   %ebp
    11fd:	89 e5                	mov    %esp,%ebp
    11ff:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1202:	8b 45 10             	mov    0x10(%ebp),%eax
    1205:	89 44 24 08          	mov    %eax,0x8(%esp)
    1209:	8b 45 0c             	mov    0xc(%ebp),%eax
    120c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1210:	8b 45 08             	mov    0x8(%ebp),%eax
    1213:	89 04 24             	mov    %eax,(%esp)
    1216:	e8 26 ff ff ff       	call   1141 <stosb>
  return dst;
    121b:	8b 45 08             	mov    0x8(%ebp),%eax
}
    121e:	c9                   	leave  
    121f:	c3                   	ret    

00001220 <strchr>:

char*
strchr(const char *s, char c)
{
    1220:	55                   	push   %ebp
    1221:	89 e5                	mov    %esp,%ebp
    1223:	83 ec 04             	sub    $0x4,%esp
    1226:	8b 45 0c             	mov    0xc(%ebp),%eax
    1229:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    122c:	eb 14                	jmp    1242 <strchr+0x22>
    if(*s == c)
    122e:	8b 45 08             	mov    0x8(%ebp),%eax
    1231:	0f b6 00             	movzbl (%eax),%eax
    1234:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1237:	75 05                	jne    123e <strchr+0x1e>
      return (char*)s;
    1239:	8b 45 08             	mov    0x8(%ebp),%eax
    123c:	eb 13                	jmp    1251 <strchr+0x31>
  for(; *s; s++)
    123e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1242:	8b 45 08             	mov    0x8(%ebp),%eax
    1245:	0f b6 00             	movzbl (%eax),%eax
    1248:	84 c0                	test   %al,%al
    124a:	75 e2                	jne    122e <strchr+0xe>
  return 0;
    124c:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1251:	c9                   	leave  
    1252:	c3                   	ret    

00001253 <gets>:

char*
gets(char *buf, int max)
{
    1253:	55                   	push   %ebp
    1254:	89 e5                	mov    %esp,%ebp
    1256:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1259:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1260:	eb 4c                	jmp    12ae <gets+0x5b>
    cc = read(0, &c, 1);
    1262:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1269:	00 
    126a:	8d 45 ef             	lea    -0x11(%ebp),%eax
    126d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1271:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1278:	e8 44 01 00 00       	call   13c1 <read>
    127d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1280:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1284:	7f 02                	jg     1288 <gets+0x35>
      break;
    1286:	eb 31                	jmp    12b9 <gets+0x66>
    buf[i++] = c;
    1288:	8b 45 f4             	mov    -0xc(%ebp),%eax
    128b:	8d 50 01             	lea    0x1(%eax),%edx
    128e:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1291:	89 c2                	mov    %eax,%edx
    1293:	8b 45 08             	mov    0x8(%ebp),%eax
    1296:	01 c2                	add    %eax,%edx
    1298:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    129c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    129e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    12a2:	3c 0a                	cmp    $0xa,%al
    12a4:	74 13                	je     12b9 <gets+0x66>
    12a6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    12aa:	3c 0d                	cmp    $0xd,%al
    12ac:	74 0b                	je     12b9 <gets+0x66>
  for(i=0; i+1 < max; ){
    12ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12b1:	83 c0 01             	add    $0x1,%eax
    12b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
    12b7:	7c a9                	jl     1262 <gets+0xf>
      break;
  }
  buf[i] = '\0';
    12b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
    12bc:	8b 45 08             	mov    0x8(%ebp),%eax
    12bf:	01 d0                	add    %edx,%eax
    12c1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    12c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12c7:	c9                   	leave  
    12c8:	c3                   	ret    

000012c9 <stat>:

int
stat(char *n, struct stat *st)
{
    12c9:	55                   	push   %ebp
    12ca:	89 e5                	mov    %esp,%ebp
    12cc:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12cf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    12d6:	00 
    12d7:	8b 45 08             	mov    0x8(%ebp),%eax
    12da:	89 04 24             	mov    %eax,(%esp)
    12dd:	e8 07 01 00 00       	call   13e9 <open>
    12e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    12e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12e9:	79 07                	jns    12f2 <stat+0x29>
    return -1;
    12eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12f0:	eb 23                	jmp    1315 <stat+0x4c>
  r = fstat(fd, st);
    12f2:	8b 45 0c             	mov    0xc(%ebp),%eax
    12f5:	89 44 24 04          	mov    %eax,0x4(%esp)
    12f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12fc:	89 04 24             	mov    %eax,(%esp)
    12ff:	e8 fd 00 00 00       	call   1401 <fstat>
    1304:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1307:	8b 45 f4             	mov    -0xc(%ebp),%eax
    130a:	89 04 24             	mov    %eax,(%esp)
    130d:	e8 bf 00 00 00       	call   13d1 <close>
  return r;
    1312:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1315:	c9                   	leave  
    1316:	c3                   	ret    

00001317 <atoi>:

int
atoi(const char *s)
{
    1317:	55                   	push   %ebp
    1318:	89 e5                	mov    %esp,%ebp
    131a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    131d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1324:	eb 25                	jmp    134b <atoi+0x34>
    n = n*10 + *s++ - '0';
    1326:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1329:	89 d0                	mov    %edx,%eax
    132b:	c1 e0 02             	shl    $0x2,%eax
    132e:	01 d0                	add    %edx,%eax
    1330:	01 c0                	add    %eax,%eax
    1332:	89 c1                	mov    %eax,%ecx
    1334:	8b 45 08             	mov    0x8(%ebp),%eax
    1337:	8d 50 01             	lea    0x1(%eax),%edx
    133a:	89 55 08             	mov    %edx,0x8(%ebp)
    133d:	0f b6 00             	movzbl (%eax),%eax
    1340:	0f be c0             	movsbl %al,%eax
    1343:	01 c8                	add    %ecx,%eax
    1345:	83 e8 30             	sub    $0x30,%eax
    1348:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    134b:	8b 45 08             	mov    0x8(%ebp),%eax
    134e:	0f b6 00             	movzbl (%eax),%eax
    1351:	3c 2f                	cmp    $0x2f,%al
    1353:	7e 0a                	jle    135f <atoi+0x48>
    1355:	8b 45 08             	mov    0x8(%ebp),%eax
    1358:	0f b6 00             	movzbl (%eax),%eax
    135b:	3c 39                	cmp    $0x39,%al
    135d:	7e c7                	jle    1326 <atoi+0xf>
  return n;
    135f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1362:	c9                   	leave  
    1363:	c3                   	ret    

00001364 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1364:	55                   	push   %ebp
    1365:	89 e5                	mov    %esp,%ebp
    1367:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    136a:	8b 45 08             	mov    0x8(%ebp),%eax
    136d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1370:	8b 45 0c             	mov    0xc(%ebp),%eax
    1373:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1376:	eb 17                	jmp    138f <memmove+0x2b>
    *dst++ = *src++;
    1378:	8b 45 fc             	mov    -0x4(%ebp),%eax
    137b:	8d 50 01             	lea    0x1(%eax),%edx
    137e:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1381:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1384:	8d 4a 01             	lea    0x1(%edx),%ecx
    1387:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    138a:	0f b6 12             	movzbl (%edx),%edx
    138d:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
    138f:	8b 45 10             	mov    0x10(%ebp),%eax
    1392:	8d 50 ff             	lea    -0x1(%eax),%edx
    1395:	89 55 10             	mov    %edx,0x10(%ebp)
    1398:	85 c0                	test   %eax,%eax
    139a:	7f dc                	jg     1378 <memmove+0x14>
  return vdst;
    139c:	8b 45 08             	mov    0x8(%ebp),%eax
}
    139f:	c9                   	leave  
    13a0:	c3                   	ret    

000013a1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    13a1:	b8 01 00 00 00       	mov    $0x1,%eax
    13a6:	cd 40                	int    $0x40
    13a8:	c3                   	ret    

000013a9 <exit>:
SYSCALL(exit)
    13a9:	b8 02 00 00 00       	mov    $0x2,%eax
    13ae:	cd 40                	int    $0x40
    13b0:	c3                   	ret    

000013b1 <wait>:
SYSCALL(wait)
    13b1:	b8 03 00 00 00       	mov    $0x3,%eax
    13b6:	cd 40                	int    $0x40
    13b8:	c3                   	ret    

000013b9 <pipe>:
SYSCALL(pipe)
    13b9:	b8 04 00 00 00       	mov    $0x4,%eax
    13be:	cd 40                	int    $0x40
    13c0:	c3                   	ret    

000013c1 <read>:
SYSCALL(read)
    13c1:	b8 05 00 00 00       	mov    $0x5,%eax
    13c6:	cd 40                	int    $0x40
    13c8:	c3                   	ret    

000013c9 <write>:
SYSCALL(write)
    13c9:	b8 10 00 00 00       	mov    $0x10,%eax
    13ce:	cd 40                	int    $0x40
    13d0:	c3                   	ret    

000013d1 <close>:
SYSCALL(close)
    13d1:	b8 15 00 00 00       	mov    $0x15,%eax
    13d6:	cd 40                	int    $0x40
    13d8:	c3                   	ret    

000013d9 <kill>:
SYSCALL(kill)
    13d9:	b8 06 00 00 00       	mov    $0x6,%eax
    13de:	cd 40                	int    $0x40
    13e0:	c3                   	ret    

000013e1 <exec>:
SYSCALL(exec)
    13e1:	b8 07 00 00 00       	mov    $0x7,%eax
    13e6:	cd 40                	int    $0x40
    13e8:	c3                   	ret    

000013e9 <open>:
SYSCALL(open)
    13e9:	b8 0f 00 00 00       	mov    $0xf,%eax
    13ee:	cd 40                	int    $0x40
    13f0:	c3                   	ret    

000013f1 <mknod>:
SYSCALL(mknod)
    13f1:	b8 11 00 00 00       	mov    $0x11,%eax
    13f6:	cd 40                	int    $0x40
    13f8:	c3                   	ret    

000013f9 <unlink>:
SYSCALL(unlink)
    13f9:	b8 12 00 00 00       	mov    $0x12,%eax
    13fe:	cd 40                	int    $0x40
    1400:	c3                   	ret    

00001401 <fstat>:
SYSCALL(fstat)
    1401:	b8 08 00 00 00       	mov    $0x8,%eax
    1406:	cd 40                	int    $0x40
    1408:	c3                   	ret    

00001409 <link>:
SYSCALL(link)
    1409:	b8 13 00 00 00       	mov    $0x13,%eax
    140e:	cd 40                	int    $0x40
    1410:	c3                   	ret    

00001411 <mkdir>:
SYSCALL(mkdir)
    1411:	b8 14 00 00 00       	mov    $0x14,%eax
    1416:	cd 40                	int    $0x40
    1418:	c3                   	ret    

00001419 <chdir>:
SYSCALL(chdir)
    1419:	b8 09 00 00 00       	mov    $0x9,%eax
    141e:	cd 40                	int    $0x40
    1420:	c3                   	ret    

00001421 <dup>:
SYSCALL(dup)
    1421:	b8 0a 00 00 00       	mov    $0xa,%eax
    1426:	cd 40                	int    $0x40
    1428:	c3                   	ret    

00001429 <getpid>:
SYSCALL(getpid)
    1429:	b8 0b 00 00 00       	mov    $0xb,%eax
    142e:	cd 40                	int    $0x40
    1430:	c3                   	ret    

00001431 <sbrk>:
SYSCALL(sbrk)
    1431:	b8 0c 00 00 00       	mov    $0xc,%eax
    1436:	cd 40                	int    $0x40
    1438:	c3                   	ret    

00001439 <sleep>:
SYSCALL(sleep)
    1439:	b8 0d 00 00 00       	mov    $0xd,%eax
    143e:	cd 40                	int    $0x40
    1440:	c3                   	ret    

00001441 <uptime>:
SYSCALL(uptime)
    1441:	b8 0e 00 00 00       	mov    $0xe,%eax
    1446:	cd 40                	int    $0x40
    1448:	c3                   	ret    

00001449 <shm_open>:
SYSCALL(shm_open)
    1449:	b8 16 00 00 00       	mov    $0x16,%eax
    144e:	cd 40                	int    $0x40
    1450:	c3                   	ret    

00001451 <shm_close>:
SYSCALL(shm_close)	
    1451:	b8 17 00 00 00       	mov    $0x17,%eax
    1456:	cd 40                	int    $0x40
    1458:	c3                   	ret    

00001459 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1459:	55                   	push   %ebp
    145a:	89 e5                	mov    %esp,%ebp
    145c:	83 ec 18             	sub    $0x18,%esp
    145f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1462:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1465:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    146c:	00 
    146d:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1470:	89 44 24 04          	mov    %eax,0x4(%esp)
    1474:	8b 45 08             	mov    0x8(%ebp),%eax
    1477:	89 04 24             	mov    %eax,(%esp)
    147a:	e8 4a ff ff ff       	call   13c9 <write>
}
    147f:	c9                   	leave  
    1480:	c3                   	ret    

00001481 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1481:	55                   	push   %ebp
    1482:	89 e5                	mov    %esp,%ebp
    1484:	56                   	push   %esi
    1485:	53                   	push   %ebx
    1486:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1489:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1490:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1494:	74 17                	je     14ad <printint+0x2c>
    1496:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    149a:	79 11                	jns    14ad <printint+0x2c>
    neg = 1;
    149c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    14a3:	8b 45 0c             	mov    0xc(%ebp),%eax
    14a6:	f7 d8                	neg    %eax
    14a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14ab:	eb 06                	jmp    14b3 <printint+0x32>
  } else {
    x = xx;
    14ad:	8b 45 0c             	mov    0xc(%ebp),%eax
    14b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    14b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    14ba:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    14bd:	8d 41 01             	lea    0x1(%ecx),%eax
    14c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    14c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
    14c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14c9:	ba 00 00 00 00       	mov    $0x0,%edx
    14ce:	f7 f3                	div    %ebx
    14d0:	89 d0                	mov    %edx,%eax
    14d2:	0f b6 80 68 1c 00 00 	movzbl 0x1c68(%eax),%eax
    14d9:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    14dd:	8b 75 10             	mov    0x10(%ebp),%esi
    14e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14e3:	ba 00 00 00 00       	mov    $0x0,%edx
    14e8:	f7 f6                	div    %esi
    14ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14f1:	75 c7                	jne    14ba <printint+0x39>
  if(neg)
    14f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    14f7:	74 10                	je     1509 <printint+0x88>
    buf[i++] = '-';
    14f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14fc:	8d 50 01             	lea    0x1(%eax),%edx
    14ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1502:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1507:	eb 1f                	jmp    1528 <printint+0xa7>
    1509:	eb 1d                	jmp    1528 <printint+0xa7>
    putc(fd, buf[i]);
    150b:	8d 55 dc             	lea    -0x24(%ebp),%edx
    150e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1511:	01 d0                	add    %edx,%eax
    1513:	0f b6 00             	movzbl (%eax),%eax
    1516:	0f be c0             	movsbl %al,%eax
    1519:	89 44 24 04          	mov    %eax,0x4(%esp)
    151d:	8b 45 08             	mov    0x8(%ebp),%eax
    1520:	89 04 24             	mov    %eax,(%esp)
    1523:	e8 31 ff ff ff       	call   1459 <putc>
  while(--i >= 0)
    1528:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    152c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1530:	79 d9                	jns    150b <printint+0x8a>
}
    1532:	83 c4 30             	add    $0x30,%esp
    1535:	5b                   	pop    %ebx
    1536:	5e                   	pop    %esi
    1537:	5d                   	pop    %ebp
    1538:	c3                   	ret    

00001539 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1539:	55                   	push   %ebp
    153a:	89 e5                	mov    %esp,%ebp
    153c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    153f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1546:	8d 45 0c             	lea    0xc(%ebp),%eax
    1549:	83 c0 04             	add    $0x4,%eax
    154c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    154f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1556:	e9 7c 01 00 00       	jmp    16d7 <printf+0x19e>
    c = fmt[i] & 0xff;
    155b:	8b 55 0c             	mov    0xc(%ebp),%edx
    155e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1561:	01 d0                	add    %edx,%eax
    1563:	0f b6 00             	movzbl (%eax),%eax
    1566:	0f be c0             	movsbl %al,%eax
    1569:	25 ff 00 00 00       	and    $0xff,%eax
    156e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1571:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1575:	75 2c                	jne    15a3 <printf+0x6a>
      if(c == '%'){
    1577:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    157b:	75 0c                	jne    1589 <printf+0x50>
        state = '%';
    157d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1584:	e9 4a 01 00 00       	jmp    16d3 <printf+0x19a>
      } else {
        putc(fd, c);
    1589:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    158c:	0f be c0             	movsbl %al,%eax
    158f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1593:	8b 45 08             	mov    0x8(%ebp),%eax
    1596:	89 04 24             	mov    %eax,(%esp)
    1599:	e8 bb fe ff ff       	call   1459 <putc>
    159e:	e9 30 01 00 00       	jmp    16d3 <printf+0x19a>
      }
    } else if(state == '%'){
    15a3:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    15a7:	0f 85 26 01 00 00    	jne    16d3 <printf+0x19a>
      if(c == 'd'){
    15ad:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    15b1:	75 2d                	jne    15e0 <printf+0xa7>
        printint(fd, *ap, 10, 1);
    15b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15b6:	8b 00                	mov    (%eax),%eax
    15b8:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    15bf:	00 
    15c0:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    15c7:	00 
    15c8:	89 44 24 04          	mov    %eax,0x4(%esp)
    15cc:	8b 45 08             	mov    0x8(%ebp),%eax
    15cf:	89 04 24             	mov    %eax,(%esp)
    15d2:	e8 aa fe ff ff       	call   1481 <printint>
        ap++;
    15d7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15db:	e9 ec 00 00 00       	jmp    16cc <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    15e0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    15e4:	74 06                	je     15ec <printf+0xb3>
    15e6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    15ea:	75 2d                	jne    1619 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    15ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15ef:	8b 00                	mov    (%eax),%eax
    15f1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    15f8:	00 
    15f9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1600:	00 
    1601:	89 44 24 04          	mov    %eax,0x4(%esp)
    1605:	8b 45 08             	mov    0x8(%ebp),%eax
    1608:	89 04 24             	mov    %eax,(%esp)
    160b:	e8 71 fe ff ff       	call   1481 <printint>
        ap++;
    1610:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1614:	e9 b3 00 00 00       	jmp    16cc <printf+0x193>
      } else if(c == 's'){
    1619:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    161d:	75 45                	jne    1664 <printf+0x12b>
        s = (char*)*ap;
    161f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1622:	8b 00                	mov    (%eax),%eax
    1624:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1627:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    162b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    162f:	75 09                	jne    163a <printf+0x101>
          s = "(null)";
    1631:	c7 45 f4 bd 19 00 00 	movl   $0x19bd,-0xc(%ebp)
        while(*s != 0){
    1638:	eb 1e                	jmp    1658 <printf+0x11f>
    163a:	eb 1c                	jmp    1658 <printf+0x11f>
          putc(fd, *s);
    163c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    163f:	0f b6 00             	movzbl (%eax),%eax
    1642:	0f be c0             	movsbl %al,%eax
    1645:	89 44 24 04          	mov    %eax,0x4(%esp)
    1649:	8b 45 08             	mov    0x8(%ebp),%eax
    164c:	89 04 24             	mov    %eax,(%esp)
    164f:	e8 05 fe ff ff       	call   1459 <putc>
          s++;
    1654:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
    1658:	8b 45 f4             	mov    -0xc(%ebp),%eax
    165b:	0f b6 00             	movzbl (%eax),%eax
    165e:	84 c0                	test   %al,%al
    1660:	75 da                	jne    163c <printf+0x103>
    1662:	eb 68                	jmp    16cc <printf+0x193>
        }
      } else if(c == 'c'){
    1664:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1668:	75 1d                	jne    1687 <printf+0x14e>
        putc(fd, *ap);
    166a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    166d:	8b 00                	mov    (%eax),%eax
    166f:	0f be c0             	movsbl %al,%eax
    1672:	89 44 24 04          	mov    %eax,0x4(%esp)
    1676:	8b 45 08             	mov    0x8(%ebp),%eax
    1679:	89 04 24             	mov    %eax,(%esp)
    167c:	e8 d8 fd ff ff       	call   1459 <putc>
        ap++;
    1681:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1685:	eb 45                	jmp    16cc <printf+0x193>
      } else if(c == '%'){
    1687:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    168b:	75 17                	jne    16a4 <printf+0x16b>
        putc(fd, c);
    168d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1690:	0f be c0             	movsbl %al,%eax
    1693:	89 44 24 04          	mov    %eax,0x4(%esp)
    1697:	8b 45 08             	mov    0x8(%ebp),%eax
    169a:	89 04 24             	mov    %eax,(%esp)
    169d:	e8 b7 fd ff ff       	call   1459 <putc>
    16a2:	eb 28                	jmp    16cc <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    16a4:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    16ab:	00 
    16ac:	8b 45 08             	mov    0x8(%ebp),%eax
    16af:	89 04 24             	mov    %eax,(%esp)
    16b2:	e8 a2 fd ff ff       	call   1459 <putc>
        putc(fd, c);
    16b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    16ba:	0f be c0             	movsbl %al,%eax
    16bd:	89 44 24 04          	mov    %eax,0x4(%esp)
    16c1:	8b 45 08             	mov    0x8(%ebp),%eax
    16c4:	89 04 24             	mov    %eax,(%esp)
    16c7:	e8 8d fd ff ff       	call   1459 <putc>
      }
      state = 0;
    16cc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    16d3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    16d7:	8b 55 0c             	mov    0xc(%ebp),%edx
    16da:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16dd:	01 d0                	add    %edx,%eax
    16df:	0f b6 00             	movzbl (%eax),%eax
    16e2:	84 c0                	test   %al,%al
    16e4:	0f 85 71 fe ff ff    	jne    155b <printf+0x22>
    }
  }
}
    16ea:	c9                   	leave  
    16eb:	c3                   	ret    

000016ec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16ec:	55                   	push   %ebp
    16ed:	89 e5                	mov    %esp,%ebp
    16ef:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    16f2:	8b 45 08             	mov    0x8(%ebp),%eax
    16f5:	83 e8 08             	sub    $0x8,%eax
    16f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16fb:	a1 84 1c 00 00       	mov    0x1c84,%eax
    1700:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1703:	eb 24                	jmp    1729 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1705:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1708:	8b 00                	mov    (%eax),%eax
    170a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    170d:	77 12                	ja     1721 <free+0x35>
    170f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1712:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1715:	77 24                	ja     173b <free+0x4f>
    1717:	8b 45 fc             	mov    -0x4(%ebp),%eax
    171a:	8b 00                	mov    (%eax),%eax
    171c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    171f:	77 1a                	ja     173b <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1721:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1724:	8b 00                	mov    (%eax),%eax
    1726:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1729:	8b 45 f8             	mov    -0x8(%ebp),%eax
    172c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    172f:	76 d4                	jbe    1705 <free+0x19>
    1731:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1734:	8b 00                	mov    (%eax),%eax
    1736:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1739:	76 ca                	jbe    1705 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    173b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    173e:	8b 40 04             	mov    0x4(%eax),%eax
    1741:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1748:	8b 45 f8             	mov    -0x8(%ebp),%eax
    174b:	01 c2                	add    %eax,%edx
    174d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1750:	8b 00                	mov    (%eax),%eax
    1752:	39 c2                	cmp    %eax,%edx
    1754:	75 24                	jne    177a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1756:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1759:	8b 50 04             	mov    0x4(%eax),%edx
    175c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    175f:	8b 00                	mov    (%eax),%eax
    1761:	8b 40 04             	mov    0x4(%eax),%eax
    1764:	01 c2                	add    %eax,%edx
    1766:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1769:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    176c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    176f:	8b 00                	mov    (%eax),%eax
    1771:	8b 10                	mov    (%eax),%edx
    1773:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1776:	89 10                	mov    %edx,(%eax)
    1778:	eb 0a                	jmp    1784 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    177a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    177d:	8b 10                	mov    (%eax),%edx
    177f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1782:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1784:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1787:	8b 40 04             	mov    0x4(%eax),%eax
    178a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1791:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1794:	01 d0                	add    %edx,%eax
    1796:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1799:	75 20                	jne    17bb <free+0xcf>
    p->s.size += bp->s.size;
    179b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    179e:	8b 50 04             	mov    0x4(%eax),%edx
    17a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17a4:	8b 40 04             	mov    0x4(%eax),%eax
    17a7:	01 c2                	add    %eax,%edx
    17a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17ac:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    17af:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17b2:	8b 10                	mov    (%eax),%edx
    17b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17b7:	89 10                	mov    %edx,(%eax)
    17b9:	eb 08                	jmp    17c3 <free+0xd7>
  } else
    p->s.ptr = bp;
    17bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17be:	8b 55 f8             	mov    -0x8(%ebp),%edx
    17c1:	89 10                	mov    %edx,(%eax)
  freep = p;
    17c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17c6:	a3 84 1c 00 00       	mov    %eax,0x1c84
}
    17cb:	c9                   	leave  
    17cc:	c3                   	ret    

000017cd <morecore>:

static Header*
morecore(uint nu)
{
    17cd:	55                   	push   %ebp
    17ce:	89 e5                	mov    %esp,%ebp
    17d0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    17d3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    17da:	77 07                	ja     17e3 <morecore+0x16>
    nu = 4096;
    17dc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    17e3:	8b 45 08             	mov    0x8(%ebp),%eax
    17e6:	c1 e0 03             	shl    $0x3,%eax
    17e9:	89 04 24             	mov    %eax,(%esp)
    17ec:	e8 40 fc ff ff       	call   1431 <sbrk>
    17f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    17f4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    17f8:	75 07                	jne    1801 <morecore+0x34>
    return 0;
    17fa:	b8 00 00 00 00       	mov    $0x0,%eax
    17ff:	eb 22                	jmp    1823 <morecore+0x56>
  hp = (Header*)p;
    1801:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1804:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1807:	8b 45 f0             	mov    -0x10(%ebp),%eax
    180a:	8b 55 08             	mov    0x8(%ebp),%edx
    180d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1810:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1813:	83 c0 08             	add    $0x8,%eax
    1816:	89 04 24             	mov    %eax,(%esp)
    1819:	e8 ce fe ff ff       	call   16ec <free>
  return freep;
    181e:	a1 84 1c 00 00       	mov    0x1c84,%eax
}
    1823:	c9                   	leave  
    1824:	c3                   	ret    

00001825 <malloc>:

void*
malloc(uint nbytes)
{
    1825:	55                   	push   %ebp
    1826:	89 e5                	mov    %esp,%ebp
    1828:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    182b:	8b 45 08             	mov    0x8(%ebp),%eax
    182e:	83 c0 07             	add    $0x7,%eax
    1831:	c1 e8 03             	shr    $0x3,%eax
    1834:	83 c0 01             	add    $0x1,%eax
    1837:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    183a:	a1 84 1c 00 00       	mov    0x1c84,%eax
    183f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1842:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1846:	75 23                	jne    186b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1848:	c7 45 f0 7c 1c 00 00 	movl   $0x1c7c,-0x10(%ebp)
    184f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1852:	a3 84 1c 00 00       	mov    %eax,0x1c84
    1857:	a1 84 1c 00 00       	mov    0x1c84,%eax
    185c:	a3 7c 1c 00 00       	mov    %eax,0x1c7c
    base.s.size = 0;
    1861:	c7 05 80 1c 00 00 00 	movl   $0x0,0x1c80
    1868:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    186b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    186e:	8b 00                	mov    (%eax),%eax
    1870:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1873:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1876:	8b 40 04             	mov    0x4(%eax),%eax
    1879:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    187c:	72 4d                	jb     18cb <malloc+0xa6>
      if(p->s.size == nunits)
    187e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1881:	8b 40 04             	mov    0x4(%eax),%eax
    1884:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1887:	75 0c                	jne    1895 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1889:	8b 45 f4             	mov    -0xc(%ebp),%eax
    188c:	8b 10                	mov    (%eax),%edx
    188e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1891:	89 10                	mov    %edx,(%eax)
    1893:	eb 26                	jmp    18bb <malloc+0x96>
      else {
        p->s.size -= nunits;
    1895:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1898:	8b 40 04             	mov    0x4(%eax),%eax
    189b:	2b 45 ec             	sub    -0x14(%ebp),%eax
    189e:	89 c2                	mov    %eax,%edx
    18a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18a3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    18a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18a9:	8b 40 04             	mov    0x4(%eax),%eax
    18ac:	c1 e0 03             	shl    $0x3,%eax
    18af:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    18b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
    18b8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    18bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18be:	a3 84 1c 00 00       	mov    %eax,0x1c84
      return (void*)(p + 1);
    18c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18c6:	83 c0 08             	add    $0x8,%eax
    18c9:	eb 38                	jmp    1903 <malloc+0xde>
    }
    if(p == freep)
    18cb:	a1 84 1c 00 00       	mov    0x1c84,%eax
    18d0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    18d3:	75 1b                	jne    18f0 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    18d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    18d8:	89 04 24             	mov    %eax,(%esp)
    18db:	e8 ed fe ff ff       	call   17cd <morecore>
    18e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    18e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18e7:	75 07                	jne    18f0 <malloc+0xcb>
        return 0;
    18e9:	b8 00 00 00 00       	mov    $0x0,%eax
    18ee:	eb 13                	jmp    1903 <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18f9:	8b 00                	mov    (%eax),%eax
    18fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
    18fe:	e9 70 ff ff ff       	jmp    1873 <malloc+0x4e>
}
    1903:	c9                   	leave  
    1904:	c3                   	ret    

00001905 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    1905:	55                   	push   %ebp
    1906:	89 e5                	mov    %esp,%ebp
    1908:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    190b:	8b 55 08             	mov    0x8(%ebp),%edx
    190e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1911:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1914:	f0 87 02             	lock xchg %eax,(%edx)
    1917:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    191a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    191d:	c9                   	leave  
    191e:	c3                   	ret    

0000191f <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    191f:	55                   	push   %ebp
    1920:	89 e5                	mov    %esp,%ebp
    1922:	83 ec 08             	sub    $0x8,%esp
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    1925:	90                   	nop
    1926:	8b 45 08             	mov    0x8(%ebp),%eax
    1929:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1930:	00 
    1931:	89 04 24             	mov    %eax,(%esp)
    1934:	e8 cc ff ff ff       	call   1905 <xchg>
    1939:	85 c0                	test   %eax,%eax
    193b:	75 e9                	jne    1926 <uacquire+0x7>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    193d:	0f ae f0             	mfence 
}
    1940:	c9                   	leave  
    1941:	c3                   	ret    

00001942 <urelease>:

void urelease (struct uspinlock *lk) {
    1942:	55                   	push   %ebp
    1943:	89 e5                	mov    %esp,%ebp
  __sync_synchronize();
    1945:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    1948:	8b 45 08             	mov    0x8(%ebp),%eax
    194b:	8b 55 08             	mov    0x8(%ebp),%edx
    194e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1954:	5d                   	pop    %ebp
    1955:	c3                   	ret    
