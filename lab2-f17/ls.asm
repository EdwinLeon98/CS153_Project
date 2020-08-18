
_ls:     file format elf32-i386


Disassembly of section .text:

00001000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	53                   	push   %ebx
    1004:	83 ec 24             	sub    $0x24,%esp
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    1007:	8b 45 08             	mov    0x8(%ebp),%eax
    100a:	89 04 24             	mov    %eax,(%esp)
    100d:	e8 dd 03 00 00       	call   13ef <strlen>
    1012:	8b 55 08             	mov    0x8(%ebp),%edx
    1015:	01 d0                	add    %edx,%eax
    1017:	89 45 f4             	mov    %eax,-0xc(%ebp)
    101a:	eb 04                	jmp    1020 <fmtname+0x20>
    101c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1020:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1023:	3b 45 08             	cmp    0x8(%ebp),%eax
    1026:	72 0a                	jb     1032 <fmtname+0x32>
    1028:	8b 45 f4             	mov    -0xc(%ebp),%eax
    102b:	0f b6 00             	movzbl (%eax),%eax
    102e:	3c 2f                	cmp    $0x2f,%al
    1030:	75 ea                	jne    101c <fmtname+0x1c>
    ;
  p++;
    1032:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    1036:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1039:	89 04 24             	mov    %eax,(%esp)
    103c:	e8 ae 03 00 00       	call   13ef <strlen>
    1041:	83 f8 0d             	cmp    $0xd,%eax
    1044:	76 05                	jbe    104b <fmtname+0x4b>
    return p;
    1046:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1049:	eb 5f                	jmp    10aa <fmtname+0xaa>
  memmove(buf, p, strlen(p));
    104b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    104e:	89 04 24             	mov    %eax,(%esp)
    1051:	e8 99 03 00 00       	call   13ef <strlen>
    1056:	89 44 24 08          	mov    %eax,0x8(%esp)
    105a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    105d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1061:	c7 04 24 d0 1e 00 00 	movl   $0x1ed0,(%esp)
    1068:	e8 11 05 00 00       	call   157e <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
    106d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1070:	89 04 24             	mov    %eax,(%esp)
    1073:	e8 77 03 00 00       	call   13ef <strlen>
    1078:	ba 0e 00 00 00       	mov    $0xe,%edx
    107d:	89 d3                	mov    %edx,%ebx
    107f:	29 c3                	sub    %eax,%ebx
    1081:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1084:	89 04 24             	mov    %eax,(%esp)
    1087:	e8 63 03 00 00       	call   13ef <strlen>
    108c:	05 d0 1e 00 00       	add    $0x1ed0,%eax
    1091:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    1095:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
    109c:	00 
    109d:	89 04 24             	mov    %eax,(%esp)
    10a0:	e8 71 03 00 00       	call   1416 <memset>
  return buf;
    10a5:	b8 d0 1e 00 00       	mov    $0x1ed0,%eax
}
    10aa:	83 c4 24             	add    $0x24,%esp
    10ad:	5b                   	pop    %ebx
    10ae:	5d                   	pop    %ebp
    10af:	c3                   	ret    

000010b0 <ls>:

void
ls(char *path)
{
    10b0:	55                   	push   %ebp
    10b1:	89 e5                	mov    %esp,%ebp
    10b3:	57                   	push   %edi
    10b4:	56                   	push   %esi
    10b5:	53                   	push   %ebx
    10b6:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
    10bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    10c3:	00 
    10c4:	8b 45 08             	mov    0x8(%ebp),%eax
    10c7:	89 04 24             	mov    %eax,(%esp)
    10ca:	e8 34 05 00 00       	call   1603 <open>
    10cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    10d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    10d6:	79 20                	jns    10f8 <ls+0x48>
    printf(2, "ls: cannot open %s\n", path);
    10d8:	8b 45 08             	mov    0x8(%ebp),%eax
    10db:	89 44 24 08          	mov    %eax,0x8(%esp)
    10df:	c7 44 24 04 70 1b 00 	movl   $0x1b70,0x4(%esp)
    10e6:	00 
    10e7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    10ee:	e8 60 06 00 00       	call   1753 <printf>
    return;
    10f3:	e9 01 02 00 00       	jmp    12f9 <ls+0x249>
  }

  if(fstat(fd, &st) < 0){
    10f8:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
    10fe:	89 44 24 04          	mov    %eax,0x4(%esp)
    1102:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1105:	89 04 24             	mov    %eax,(%esp)
    1108:	e8 0e 05 00 00       	call   161b <fstat>
    110d:	85 c0                	test   %eax,%eax
    110f:	79 2b                	jns    113c <ls+0x8c>
    printf(2, "ls: cannot stat %s\n", path);
    1111:	8b 45 08             	mov    0x8(%ebp),%eax
    1114:	89 44 24 08          	mov    %eax,0x8(%esp)
    1118:	c7 44 24 04 84 1b 00 	movl   $0x1b84,0x4(%esp)
    111f:	00 
    1120:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1127:	e8 27 06 00 00       	call   1753 <printf>
    close(fd);
    112c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    112f:	89 04 24             	mov    %eax,(%esp)
    1132:	e8 b4 04 00 00       	call   15eb <close>
    return;
    1137:	e9 bd 01 00 00       	jmp    12f9 <ls+0x249>
  }

  switch(st.type){
    113c:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
    1143:	98                   	cwtl   
    1144:	83 f8 01             	cmp    $0x1,%eax
    1147:	74 53                	je     119c <ls+0xec>
    1149:	83 f8 02             	cmp    $0x2,%eax
    114c:	0f 85 9c 01 00 00    	jne    12ee <ls+0x23e>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    1152:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
    1158:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
    115e:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
    1165:	0f bf d8             	movswl %ax,%ebx
    1168:	8b 45 08             	mov    0x8(%ebp),%eax
    116b:	89 04 24             	mov    %eax,(%esp)
    116e:	e8 8d fe ff ff       	call   1000 <fmtname>
    1173:	89 7c 24 14          	mov    %edi,0x14(%esp)
    1177:	89 74 24 10          	mov    %esi,0x10(%esp)
    117b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    117f:	89 44 24 08          	mov    %eax,0x8(%esp)
    1183:	c7 44 24 04 98 1b 00 	movl   $0x1b98,0x4(%esp)
    118a:	00 
    118b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1192:	e8 bc 05 00 00       	call   1753 <printf>
    break;
    1197:	e9 52 01 00 00       	jmp    12ee <ls+0x23e>

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
    119c:	8b 45 08             	mov    0x8(%ebp),%eax
    119f:	89 04 24             	mov    %eax,(%esp)
    11a2:	e8 48 02 00 00       	call   13ef <strlen>
    11a7:	83 c0 10             	add    $0x10,%eax
    11aa:	3d 00 02 00 00       	cmp    $0x200,%eax
    11af:	76 19                	jbe    11ca <ls+0x11a>
      printf(1, "ls: path too long\n");
    11b1:	c7 44 24 04 a5 1b 00 	movl   $0x1ba5,0x4(%esp)
    11b8:	00 
    11b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11c0:	e8 8e 05 00 00       	call   1753 <printf>
      break;
    11c5:	e9 24 01 00 00       	jmp    12ee <ls+0x23e>
    }
    strcpy(buf, path);
    11ca:	8b 45 08             	mov    0x8(%ebp),%eax
    11cd:	89 44 24 04          	mov    %eax,0x4(%esp)
    11d1:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
    11d7:	89 04 24             	mov    %eax,(%esp)
    11da:	e8 a1 01 00 00       	call   1380 <strcpy>
    p = buf+strlen(buf);
    11df:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
    11e5:	89 04 24             	mov    %eax,(%esp)
    11e8:	e8 02 02 00 00       	call   13ef <strlen>
    11ed:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
    11f3:	01 d0                	add    %edx,%eax
    11f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
    11f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
    11fb:	8d 50 01             	lea    0x1(%eax),%edx
    11fe:	89 55 e0             	mov    %edx,-0x20(%ebp)
    1201:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
    1204:	e9 be 00 00 00       	jmp    12c7 <ls+0x217>
      if(de.inum == 0)
    1209:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
    1210:	66 85 c0             	test   %ax,%ax
    1213:	75 05                	jne    121a <ls+0x16a>
        continue;
    1215:	e9 ad 00 00 00       	jmp    12c7 <ls+0x217>
      memmove(p, de.name, DIRSIZ);
    121a:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
    1221:	00 
    1222:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
    1228:	83 c0 02             	add    $0x2,%eax
    122b:	89 44 24 04          	mov    %eax,0x4(%esp)
    122f:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1232:	89 04 24             	mov    %eax,(%esp)
    1235:	e8 44 03 00 00       	call   157e <memmove>
      p[DIRSIZ] = 0;
    123a:	8b 45 e0             	mov    -0x20(%ebp),%eax
    123d:	83 c0 0e             	add    $0xe,%eax
    1240:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
    1243:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
    1249:	89 44 24 04          	mov    %eax,0x4(%esp)
    124d:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
    1253:	89 04 24             	mov    %eax,(%esp)
    1256:	e8 88 02 00 00       	call   14e3 <stat>
    125b:	85 c0                	test   %eax,%eax
    125d:	79 20                	jns    127f <ls+0x1cf>
        printf(1, "ls: cannot stat %s\n", buf);
    125f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
    1265:	89 44 24 08          	mov    %eax,0x8(%esp)
    1269:	c7 44 24 04 84 1b 00 	movl   $0x1b84,0x4(%esp)
    1270:	00 
    1271:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1278:	e8 d6 04 00 00       	call   1753 <printf>
        continue;
    127d:	eb 48                	jmp    12c7 <ls+0x217>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    127f:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
    1285:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
    128b:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
    1292:	0f bf d8             	movswl %ax,%ebx
    1295:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
    129b:	89 04 24             	mov    %eax,(%esp)
    129e:	e8 5d fd ff ff       	call   1000 <fmtname>
    12a3:	89 7c 24 14          	mov    %edi,0x14(%esp)
    12a7:	89 74 24 10          	mov    %esi,0x10(%esp)
    12ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    12af:	89 44 24 08          	mov    %eax,0x8(%esp)
    12b3:	c7 44 24 04 98 1b 00 	movl   $0x1b98,0x4(%esp)
    12ba:	00 
    12bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12c2:	e8 8c 04 00 00       	call   1753 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
    12c7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    12ce:	00 
    12cf:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
    12d5:	89 44 24 04          	mov    %eax,0x4(%esp)
    12d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    12dc:	89 04 24             	mov    %eax,(%esp)
    12df:	e8 f7 02 00 00       	call   15db <read>
    12e4:	83 f8 10             	cmp    $0x10,%eax
    12e7:	0f 84 1c ff ff ff    	je     1209 <ls+0x159>
    }
    break;
    12ed:	90                   	nop
  }
  close(fd);
    12ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    12f1:	89 04 24             	mov    %eax,(%esp)
    12f4:	e8 f2 02 00 00       	call   15eb <close>
}
    12f9:	81 c4 5c 02 00 00    	add    $0x25c,%esp
    12ff:	5b                   	pop    %ebx
    1300:	5e                   	pop    %esi
    1301:	5f                   	pop    %edi
    1302:	5d                   	pop    %ebp
    1303:	c3                   	ret    

00001304 <main>:

int
main(int argc, char *argv[])
{
    1304:	55                   	push   %ebp
    1305:	89 e5                	mov    %esp,%ebp
    1307:	83 e4 f0             	and    $0xfffffff0,%esp
    130a:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
    130d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
    1311:	7f 11                	jg     1324 <main+0x20>
    ls(".");
    1313:	c7 04 24 b8 1b 00 00 	movl   $0x1bb8,(%esp)
    131a:	e8 91 fd ff ff       	call   10b0 <ls>
    exit();
    131f:	e8 9f 02 00 00       	call   15c3 <exit>
  }
  for(i=1; i<argc; i++)
    1324:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    132b:	00 
    132c:	eb 1f                	jmp    134d <main+0x49>
    ls(argv[i]);
    132e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1339:	8b 45 0c             	mov    0xc(%ebp),%eax
    133c:	01 d0                	add    %edx,%eax
    133e:	8b 00                	mov    (%eax),%eax
    1340:	89 04 24             	mov    %eax,(%esp)
    1343:	e8 68 fd ff ff       	call   10b0 <ls>
  for(i=1; i<argc; i++)
    1348:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
    134d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1351:	3b 45 08             	cmp    0x8(%ebp),%eax
    1354:	7c d8                	jl     132e <main+0x2a>
  exit();
    1356:	e8 68 02 00 00       	call   15c3 <exit>

0000135b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    135b:	55                   	push   %ebp
    135c:	89 e5                	mov    %esp,%ebp
    135e:	57                   	push   %edi
    135f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1360:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1363:	8b 55 10             	mov    0x10(%ebp),%edx
    1366:	8b 45 0c             	mov    0xc(%ebp),%eax
    1369:	89 cb                	mov    %ecx,%ebx
    136b:	89 df                	mov    %ebx,%edi
    136d:	89 d1                	mov    %edx,%ecx
    136f:	fc                   	cld    
    1370:	f3 aa                	rep stos %al,%es:(%edi)
    1372:	89 ca                	mov    %ecx,%edx
    1374:	89 fb                	mov    %edi,%ebx
    1376:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1379:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    137c:	5b                   	pop    %ebx
    137d:	5f                   	pop    %edi
    137e:	5d                   	pop    %ebp
    137f:	c3                   	ret    

00001380 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1380:	55                   	push   %ebp
    1381:	89 e5                	mov    %esp,%ebp
    1383:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1386:	8b 45 08             	mov    0x8(%ebp),%eax
    1389:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    138c:	90                   	nop
    138d:	8b 45 08             	mov    0x8(%ebp),%eax
    1390:	8d 50 01             	lea    0x1(%eax),%edx
    1393:	89 55 08             	mov    %edx,0x8(%ebp)
    1396:	8b 55 0c             	mov    0xc(%ebp),%edx
    1399:	8d 4a 01             	lea    0x1(%edx),%ecx
    139c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    139f:	0f b6 12             	movzbl (%edx),%edx
    13a2:	88 10                	mov    %dl,(%eax)
    13a4:	0f b6 00             	movzbl (%eax),%eax
    13a7:	84 c0                	test   %al,%al
    13a9:	75 e2                	jne    138d <strcpy+0xd>
    ;
  return os;
    13ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    13ae:	c9                   	leave  
    13af:	c3                   	ret    

000013b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    13b0:	55                   	push   %ebp
    13b1:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    13b3:	eb 08                	jmp    13bd <strcmp+0xd>
    p++, q++;
    13b5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    13b9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
    13bd:	8b 45 08             	mov    0x8(%ebp),%eax
    13c0:	0f b6 00             	movzbl (%eax),%eax
    13c3:	84 c0                	test   %al,%al
    13c5:	74 10                	je     13d7 <strcmp+0x27>
    13c7:	8b 45 08             	mov    0x8(%ebp),%eax
    13ca:	0f b6 10             	movzbl (%eax),%edx
    13cd:	8b 45 0c             	mov    0xc(%ebp),%eax
    13d0:	0f b6 00             	movzbl (%eax),%eax
    13d3:	38 c2                	cmp    %al,%dl
    13d5:	74 de                	je     13b5 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
    13d7:	8b 45 08             	mov    0x8(%ebp),%eax
    13da:	0f b6 00             	movzbl (%eax),%eax
    13dd:	0f b6 d0             	movzbl %al,%edx
    13e0:	8b 45 0c             	mov    0xc(%ebp),%eax
    13e3:	0f b6 00             	movzbl (%eax),%eax
    13e6:	0f b6 c0             	movzbl %al,%eax
    13e9:	29 c2                	sub    %eax,%edx
    13eb:	89 d0                	mov    %edx,%eax
}
    13ed:	5d                   	pop    %ebp
    13ee:	c3                   	ret    

000013ef <strlen>:

uint
strlen(char *s)
{
    13ef:	55                   	push   %ebp
    13f0:	89 e5                	mov    %esp,%ebp
    13f2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    13f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    13fc:	eb 04                	jmp    1402 <strlen+0x13>
    13fe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1402:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1405:	8b 45 08             	mov    0x8(%ebp),%eax
    1408:	01 d0                	add    %edx,%eax
    140a:	0f b6 00             	movzbl (%eax),%eax
    140d:	84 c0                	test   %al,%al
    140f:	75 ed                	jne    13fe <strlen+0xf>
    ;
  return n;
    1411:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1414:	c9                   	leave  
    1415:	c3                   	ret    

00001416 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1416:	55                   	push   %ebp
    1417:	89 e5                	mov    %esp,%ebp
    1419:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    141c:	8b 45 10             	mov    0x10(%ebp),%eax
    141f:	89 44 24 08          	mov    %eax,0x8(%esp)
    1423:	8b 45 0c             	mov    0xc(%ebp),%eax
    1426:	89 44 24 04          	mov    %eax,0x4(%esp)
    142a:	8b 45 08             	mov    0x8(%ebp),%eax
    142d:	89 04 24             	mov    %eax,(%esp)
    1430:	e8 26 ff ff ff       	call   135b <stosb>
  return dst;
    1435:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1438:	c9                   	leave  
    1439:	c3                   	ret    

0000143a <strchr>:

char*
strchr(const char *s, char c)
{
    143a:	55                   	push   %ebp
    143b:	89 e5                	mov    %esp,%ebp
    143d:	83 ec 04             	sub    $0x4,%esp
    1440:	8b 45 0c             	mov    0xc(%ebp),%eax
    1443:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1446:	eb 14                	jmp    145c <strchr+0x22>
    if(*s == c)
    1448:	8b 45 08             	mov    0x8(%ebp),%eax
    144b:	0f b6 00             	movzbl (%eax),%eax
    144e:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1451:	75 05                	jne    1458 <strchr+0x1e>
      return (char*)s;
    1453:	8b 45 08             	mov    0x8(%ebp),%eax
    1456:	eb 13                	jmp    146b <strchr+0x31>
  for(; *s; s++)
    1458:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    145c:	8b 45 08             	mov    0x8(%ebp),%eax
    145f:	0f b6 00             	movzbl (%eax),%eax
    1462:	84 c0                	test   %al,%al
    1464:	75 e2                	jne    1448 <strchr+0xe>
  return 0;
    1466:	b8 00 00 00 00       	mov    $0x0,%eax
}
    146b:	c9                   	leave  
    146c:	c3                   	ret    

0000146d <gets>:

char*
gets(char *buf, int max)
{
    146d:	55                   	push   %ebp
    146e:	89 e5                	mov    %esp,%ebp
    1470:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1473:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    147a:	eb 4c                	jmp    14c8 <gets+0x5b>
    cc = read(0, &c, 1);
    147c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1483:	00 
    1484:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1487:	89 44 24 04          	mov    %eax,0x4(%esp)
    148b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1492:	e8 44 01 00 00       	call   15db <read>
    1497:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    149a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    149e:	7f 02                	jg     14a2 <gets+0x35>
      break;
    14a0:	eb 31                	jmp    14d3 <gets+0x66>
    buf[i++] = c;
    14a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14a5:	8d 50 01             	lea    0x1(%eax),%edx
    14a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
    14ab:	89 c2                	mov    %eax,%edx
    14ad:	8b 45 08             	mov    0x8(%ebp),%eax
    14b0:	01 c2                	add    %eax,%edx
    14b2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    14b6:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    14b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    14bc:	3c 0a                	cmp    $0xa,%al
    14be:	74 13                	je     14d3 <gets+0x66>
    14c0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    14c4:	3c 0d                	cmp    $0xd,%al
    14c6:	74 0b                	je     14d3 <gets+0x66>
  for(i=0; i+1 < max; ){
    14c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14cb:	83 c0 01             	add    $0x1,%eax
    14ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
    14d1:	7c a9                	jl     147c <gets+0xf>
      break;
  }
  buf[i] = '\0';
    14d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
    14d6:	8b 45 08             	mov    0x8(%ebp),%eax
    14d9:	01 d0                	add    %edx,%eax
    14db:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    14de:	8b 45 08             	mov    0x8(%ebp),%eax
}
    14e1:	c9                   	leave  
    14e2:	c3                   	ret    

000014e3 <stat>:

int
stat(char *n, struct stat *st)
{
    14e3:	55                   	push   %ebp
    14e4:	89 e5                	mov    %esp,%ebp
    14e6:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    14e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    14f0:	00 
    14f1:	8b 45 08             	mov    0x8(%ebp),%eax
    14f4:	89 04 24             	mov    %eax,(%esp)
    14f7:	e8 07 01 00 00       	call   1603 <open>
    14fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    14ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1503:	79 07                	jns    150c <stat+0x29>
    return -1;
    1505:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    150a:	eb 23                	jmp    152f <stat+0x4c>
  r = fstat(fd, st);
    150c:	8b 45 0c             	mov    0xc(%ebp),%eax
    150f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1513:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1516:	89 04 24             	mov    %eax,(%esp)
    1519:	e8 fd 00 00 00       	call   161b <fstat>
    151e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1521:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1524:	89 04 24             	mov    %eax,(%esp)
    1527:	e8 bf 00 00 00       	call   15eb <close>
  return r;
    152c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    152f:	c9                   	leave  
    1530:	c3                   	ret    

00001531 <atoi>:

int
atoi(const char *s)
{
    1531:	55                   	push   %ebp
    1532:	89 e5                	mov    %esp,%ebp
    1534:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1537:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    153e:	eb 25                	jmp    1565 <atoi+0x34>
    n = n*10 + *s++ - '0';
    1540:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1543:	89 d0                	mov    %edx,%eax
    1545:	c1 e0 02             	shl    $0x2,%eax
    1548:	01 d0                	add    %edx,%eax
    154a:	01 c0                	add    %eax,%eax
    154c:	89 c1                	mov    %eax,%ecx
    154e:	8b 45 08             	mov    0x8(%ebp),%eax
    1551:	8d 50 01             	lea    0x1(%eax),%edx
    1554:	89 55 08             	mov    %edx,0x8(%ebp)
    1557:	0f b6 00             	movzbl (%eax),%eax
    155a:	0f be c0             	movsbl %al,%eax
    155d:	01 c8                	add    %ecx,%eax
    155f:	83 e8 30             	sub    $0x30,%eax
    1562:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1565:	8b 45 08             	mov    0x8(%ebp),%eax
    1568:	0f b6 00             	movzbl (%eax),%eax
    156b:	3c 2f                	cmp    $0x2f,%al
    156d:	7e 0a                	jle    1579 <atoi+0x48>
    156f:	8b 45 08             	mov    0x8(%ebp),%eax
    1572:	0f b6 00             	movzbl (%eax),%eax
    1575:	3c 39                	cmp    $0x39,%al
    1577:	7e c7                	jle    1540 <atoi+0xf>
  return n;
    1579:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    157c:	c9                   	leave  
    157d:	c3                   	ret    

0000157e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    157e:	55                   	push   %ebp
    157f:	89 e5                	mov    %esp,%ebp
    1581:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    1584:	8b 45 08             	mov    0x8(%ebp),%eax
    1587:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    158a:	8b 45 0c             	mov    0xc(%ebp),%eax
    158d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1590:	eb 17                	jmp    15a9 <memmove+0x2b>
    *dst++ = *src++;
    1592:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1595:	8d 50 01             	lea    0x1(%eax),%edx
    1598:	89 55 fc             	mov    %edx,-0x4(%ebp)
    159b:	8b 55 f8             	mov    -0x8(%ebp),%edx
    159e:	8d 4a 01             	lea    0x1(%edx),%ecx
    15a1:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    15a4:	0f b6 12             	movzbl (%edx),%edx
    15a7:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
    15a9:	8b 45 10             	mov    0x10(%ebp),%eax
    15ac:	8d 50 ff             	lea    -0x1(%eax),%edx
    15af:	89 55 10             	mov    %edx,0x10(%ebp)
    15b2:	85 c0                	test   %eax,%eax
    15b4:	7f dc                	jg     1592 <memmove+0x14>
  return vdst;
    15b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
    15b9:	c9                   	leave  
    15ba:	c3                   	ret    

000015bb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    15bb:	b8 01 00 00 00       	mov    $0x1,%eax
    15c0:	cd 40                	int    $0x40
    15c2:	c3                   	ret    

000015c3 <exit>:
SYSCALL(exit)
    15c3:	b8 02 00 00 00       	mov    $0x2,%eax
    15c8:	cd 40                	int    $0x40
    15ca:	c3                   	ret    

000015cb <wait>:
SYSCALL(wait)
    15cb:	b8 03 00 00 00       	mov    $0x3,%eax
    15d0:	cd 40                	int    $0x40
    15d2:	c3                   	ret    

000015d3 <pipe>:
SYSCALL(pipe)
    15d3:	b8 04 00 00 00       	mov    $0x4,%eax
    15d8:	cd 40                	int    $0x40
    15da:	c3                   	ret    

000015db <read>:
SYSCALL(read)
    15db:	b8 05 00 00 00       	mov    $0x5,%eax
    15e0:	cd 40                	int    $0x40
    15e2:	c3                   	ret    

000015e3 <write>:
SYSCALL(write)
    15e3:	b8 10 00 00 00       	mov    $0x10,%eax
    15e8:	cd 40                	int    $0x40
    15ea:	c3                   	ret    

000015eb <close>:
SYSCALL(close)
    15eb:	b8 15 00 00 00       	mov    $0x15,%eax
    15f0:	cd 40                	int    $0x40
    15f2:	c3                   	ret    

000015f3 <kill>:
SYSCALL(kill)
    15f3:	b8 06 00 00 00       	mov    $0x6,%eax
    15f8:	cd 40                	int    $0x40
    15fa:	c3                   	ret    

000015fb <exec>:
SYSCALL(exec)
    15fb:	b8 07 00 00 00       	mov    $0x7,%eax
    1600:	cd 40                	int    $0x40
    1602:	c3                   	ret    

00001603 <open>:
SYSCALL(open)
    1603:	b8 0f 00 00 00       	mov    $0xf,%eax
    1608:	cd 40                	int    $0x40
    160a:	c3                   	ret    

0000160b <mknod>:
SYSCALL(mknod)
    160b:	b8 11 00 00 00       	mov    $0x11,%eax
    1610:	cd 40                	int    $0x40
    1612:	c3                   	ret    

00001613 <unlink>:
SYSCALL(unlink)
    1613:	b8 12 00 00 00       	mov    $0x12,%eax
    1618:	cd 40                	int    $0x40
    161a:	c3                   	ret    

0000161b <fstat>:
SYSCALL(fstat)
    161b:	b8 08 00 00 00       	mov    $0x8,%eax
    1620:	cd 40                	int    $0x40
    1622:	c3                   	ret    

00001623 <link>:
SYSCALL(link)
    1623:	b8 13 00 00 00       	mov    $0x13,%eax
    1628:	cd 40                	int    $0x40
    162a:	c3                   	ret    

0000162b <mkdir>:
SYSCALL(mkdir)
    162b:	b8 14 00 00 00       	mov    $0x14,%eax
    1630:	cd 40                	int    $0x40
    1632:	c3                   	ret    

00001633 <chdir>:
SYSCALL(chdir)
    1633:	b8 09 00 00 00       	mov    $0x9,%eax
    1638:	cd 40                	int    $0x40
    163a:	c3                   	ret    

0000163b <dup>:
SYSCALL(dup)
    163b:	b8 0a 00 00 00       	mov    $0xa,%eax
    1640:	cd 40                	int    $0x40
    1642:	c3                   	ret    

00001643 <getpid>:
SYSCALL(getpid)
    1643:	b8 0b 00 00 00       	mov    $0xb,%eax
    1648:	cd 40                	int    $0x40
    164a:	c3                   	ret    

0000164b <sbrk>:
SYSCALL(sbrk)
    164b:	b8 0c 00 00 00       	mov    $0xc,%eax
    1650:	cd 40                	int    $0x40
    1652:	c3                   	ret    

00001653 <sleep>:
SYSCALL(sleep)
    1653:	b8 0d 00 00 00       	mov    $0xd,%eax
    1658:	cd 40                	int    $0x40
    165a:	c3                   	ret    

0000165b <uptime>:
SYSCALL(uptime)
    165b:	b8 0e 00 00 00       	mov    $0xe,%eax
    1660:	cd 40                	int    $0x40
    1662:	c3                   	ret    

00001663 <shm_open>:
SYSCALL(shm_open)
    1663:	b8 16 00 00 00       	mov    $0x16,%eax
    1668:	cd 40                	int    $0x40
    166a:	c3                   	ret    

0000166b <shm_close>:
SYSCALL(shm_close)	
    166b:	b8 17 00 00 00       	mov    $0x17,%eax
    1670:	cd 40                	int    $0x40
    1672:	c3                   	ret    

00001673 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1673:	55                   	push   %ebp
    1674:	89 e5                	mov    %esp,%ebp
    1676:	83 ec 18             	sub    $0x18,%esp
    1679:	8b 45 0c             	mov    0xc(%ebp),%eax
    167c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    167f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1686:	00 
    1687:	8d 45 f4             	lea    -0xc(%ebp),%eax
    168a:	89 44 24 04          	mov    %eax,0x4(%esp)
    168e:	8b 45 08             	mov    0x8(%ebp),%eax
    1691:	89 04 24             	mov    %eax,(%esp)
    1694:	e8 4a ff ff ff       	call   15e3 <write>
}
    1699:	c9                   	leave  
    169a:	c3                   	ret    

0000169b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    169b:	55                   	push   %ebp
    169c:	89 e5                	mov    %esp,%ebp
    169e:	56                   	push   %esi
    169f:	53                   	push   %ebx
    16a0:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    16a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    16aa:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    16ae:	74 17                	je     16c7 <printint+0x2c>
    16b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    16b4:	79 11                	jns    16c7 <printint+0x2c>
    neg = 1;
    16b6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    16bd:	8b 45 0c             	mov    0xc(%ebp),%eax
    16c0:	f7 d8                	neg    %eax
    16c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    16c5:	eb 06                	jmp    16cd <printint+0x32>
  } else {
    x = xx;
    16c7:	8b 45 0c             	mov    0xc(%ebp),%eax
    16ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    16cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    16d4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    16d7:	8d 41 01             	lea    0x1(%ecx),%eax
    16da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    16dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
    16e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    16e3:	ba 00 00 00 00       	mov    $0x0,%edx
    16e8:	f7 f3                	div    %ebx
    16ea:	89 d0                	mov    %edx,%eax
    16ec:	0f b6 80 bc 1e 00 00 	movzbl 0x1ebc(%eax),%eax
    16f3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    16f7:	8b 75 10             	mov    0x10(%ebp),%esi
    16fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
    16fd:	ba 00 00 00 00       	mov    $0x0,%edx
    1702:	f7 f6                	div    %esi
    1704:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1707:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    170b:	75 c7                	jne    16d4 <printint+0x39>
  if(neg)
    170d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1711:	74 10                	je     1723 <printint+0x88>
    buf[i++] = '-';
    1713:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1716:	8d 50 01             	lea    0x1(%eax),%edx
    1719:	89 55 f4             	mov    %edx,-0xc(%ebp)
    171c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1721:	eb 1f                	jmp    1742 <printint+0xa7>
    1723:	eb 1d                	jmp    1742 <printint+0xa7>
    putc(fd, buf[i]);
    1725:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1728:	8b 45 f4             	mov    -0xc(%ebp),%eax
    172b:	01 d0                	add    %edx,%eax
    172d:	0f b6 00             	movzbl (%eax),%eax
    1730:	0f be c0             	movsbl %al,%eax
    1733:	89 44 24 04          	mov    %eax,0x4(%esp)
    1737:	8b 45 08             	mov    0x8(%ebp),%eax
    173a:	89 04 24             	mov    %eax,(%esp)
    173d:	e8 31 ff ff ff       	call   1673 <putc>
  while(--i >= 0)
    1742:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1746:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    174a:	79 d9                	jns    1725 <printint+0x8a>
}
    174c:	83 c4 30             	add    $0x30,%esp
    174f:	5b                   	pop    %ebx
    1750:	5e                   	pop    %esi
    1751:	5d                   	pop    %ebp
    1752:	c3                   	ret    

00001753 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1753:	55                   	push   %ebp
    1754:	89 e5                	mov    %esp,%ebp
    1756:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1759:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1760:	8d 45 0c             	lea    0xc(%ebp),%eax
    1763:	83 c0 04             	add    $0x4,%eax
    1766:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1769:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1770:	e9 7c 01 00 00       	jmp    18f1 <printf+0x19e>
    c = fmt[i] & 0xff;
    1775:	8b 55 0c             	mov    0xc(%ebp),%edx
    1778:	8b 45 f0             	mov    -0x10(%ebp),%eax
    177b:	01 d0                	add    %edx,%eax
    177d:	0f b6 00             	movzbl (%eax),%eax
    1780:	0f be c0             	movsbl %al,%eax
    1783:	25 ff 00 00 00       	and    $0xff,%eax
    1788:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    178b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    178f:	75 2c                	jne    17bd <printf+0x6a>
      if(c == '%'){
    1791:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1795:	75 0c                	jne    17a3 <printf+0x50>
        state = '%';
    1797:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    179e:	e9 4a 01 00 00       	jmp    18ed <printf+0x19a>
      } else {
        putc(fd, c);
    17a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    17a6:	0f be c0             	movsbl %al,%eax
    17a9:	89 44 24 04          	mov    %eax,0x4(%esp)
    17ad:	8b 45 08             	mov    0x8(%ebp),%eax
    17b0:	89 04 24             	mov    %eax,(%esp)
    17b3:	e8 bb fe ff ff       	call   1673 <putc>
    17b8:	e9 30 01 00 00       	jmp    18ed <printf+0x19a>
      }
    } else if(state == '%'){
    17bd:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    17c1:	0f 85 26 01 00 00    	jne    18ed <printf+0x19a>
      if(c == 'd'){
    17c7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    17cb:	75 2d                	jne    17fa <printf+0xa7>
        printint(fd, *ap, 10, 1);
    17cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17d0:	8b 00                	mov    (%eax),%eax
    17d2:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    17d9:	00 
    17da:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    17e1:	00 
    17e2:	89 44 24 04          	mov    %eax,0x4(%esp)
    17e6:	8b 45 08             	mov    0x8(%ebp),%eax
    17e9:	89 04 24             	mov    %eax,(%esp)
    17ec:	e8 aa fe ff ff       	call   169b <printint>
        ap++;
    17f1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    17f5:	e9 ec 00 00 00       	jmp    18e6 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
    17fa:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    17fe:	74 06                	je     1806 <printf+0xb3>
    1800:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1804:	75 2d                	jne    1833 <printf+0xe0>
        printint(fd, *ap, 16, 0);
    1806:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1809:	8b 00                	mov    (%eax),%eax
    180b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1812:	00 
    1813:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    181a:	00 
    181b:	89 44 24 04          	mov    %eax,0x4(%esp)
    181f:	8b 45 08             	mov    0x8(%ebp),%eax
    1822:	89 04 24             	mov    %eax,(%esp)
    1825:	e8 71 fe ff ff       	call   169b <printint>
        ap++;
    182a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    182e:	e9 b3 00 00 00       	jmp    18e6 <printf+0x193>
      } else if(c == 's'){
    1833:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1837:	75 45                	jne    187e <printf+0x12b>
        s = (char*)*ap;
    1839:	8b 45 e8             	mov    -0x18(%ebp),%eax
    183c:	8b 00                	mov    (%eax),%eax
    183e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1841:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1845:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1849:	75 09                	jne    1854 <printf+0x101>
          s = "(null)";
    184b:	c7 45 f4 ba 1b 00 00 	movl   $0x1bba,-0xc(%ebp)
        while(*s != 0){
    1852:	eb 1e                	jmp    1872 <printf+0x11f>
    1854:	eb 1c                	jmp    1872 <printf+0x11f>
          putc(fd, *s);
    1856:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1859:	0f b6 00             	movzbl (%eax),%eax
    185c:	0f be c0             	movsbl %al,%eax
    185f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1863:	8b 45 08             	mov    0x8(%ebp),%eax
    1866:	89 04 24             	mov    %eax,(%esp)
    1869:	e8 05 fe ff ff       	call   1673 <putc>
          s++;
    186e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
    1872:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1875:	0f b6 00             	movzbl (%eax),%eax
    1878:	84 c0                	test   %al,%al
    187a:	75 da                	jne    1856 <printf+0x103>
    187c:	eb 68                	jmp    18e6 <printf+0x193>
        }
      } else if(c == 'c'){
    187e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1882:	75 1d                	jne    18a1 <printf+0x14e>
        putc(fd, *ap);
    1884:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1887:	8b 00                	mov    (%eax),%eax
    1889:	0f be c0             	movsbl %al,%eax
    188c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1890:	8b 45 08             	mov    0x8(%ebp),%eax
    1893:	89 04 24             	mov    %eax,(%esp)
    1896:	e8 d8 fd ff ff       	call   1673 <putc>
        ap++;
    189b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    189f:	eb 45                	jmp    18e6 <printf+0x193>
      } else if(c == '%'){
    18a1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    18a5:	75 17                	jne    18be <printf+0x16b>
        putc(fd, c);
    18a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    18aa:	0f be c0             	movsbl %al,%eax
    18ad:	89 44 24 04          	mov    %eax,0x4(%esp)
    18b1:	8b 45 08             	mov    0x8(%ebp),%eax
    18b4:	89 04 24             	mov    %eax,(%esp)
    18b7:	e8 b7 fd ff ff       	call   1673 <putc>
    18bc:	eb 28                	jmp    18e6 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    18be:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    18c5:	00 
    18c6:	8b 45 08             	mov    0x8(%ebp),%eax
    18c9:	89 04 24             	mov    %eax,(%esp)
    18cc:	e8 a2 fd ff ff       	call   1673 <putc>
        putc(fd, c);
    18d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    18d4:	0f be c0             	movsbl %al,%eax
    18d7:	89 44 24 04          	mov    %eax,0x4(%esp)
    18db:	8b 45 08             	mov    0x8(%ebp),%eax
    18de:	89 04 24             	mov    %eax,(%esp)
    18e1:	e8 8d fd ff ff       	call   1673 <putc>
      }
      state = 0;
    18e6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    18ed:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    18f1:	8b 55 0c             	mov    0xc(%ebp),%edx
    18f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18f7:	01 d0                	add    %edx,%eax
    18f9:	0f b6 00             	movzbl (%eax),%eax
    18fc:	84 c0                	test   %al,%al
    18fe:	0f 85 71 fe ff ff    	jne    1775 <printf+0x22>
    }
  }
}
    1904:	c9                   	leave  
    1905:	c3                   	ret    

00001906 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1906:	55                   	push   %ebp
    1907:	89 e5                	mov    %esp,%ebp
    1909:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    190c:	8b 45 08             	mov    0x8(%ebp),%eax
    190f:	83 e8 08             	sub    $0x8,%eax
    1912:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1915:	a1 e8 1e 00 00       	mov    0x1ee8,%eax
    191a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    191d:	eb 24                	jmp    1943 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    191f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1922:	8b 00                	mov    (%eax),%eax
    1924:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1927:	77 12                	ja     193b <free+0x35>
    1929:	8b 45 f8             	mov    -0x8(%ebp),%eax
    192c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    192f:	77 24                	ja     1955 <free+0x4f>
    1931:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1934:	8b 00                	mov    (%eax),%eax
    1936:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1939:	77 1a                	ja     1955 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    193b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    193e:	8b 00                	mov    (%eax),%eax
    1940:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1943:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1946:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1949:	76 d4                	jbe    191f <free+0x19>
    194b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    194e:	8b 00                	mov    (%eax),%eax
    1950:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1953:	76 ca                	jbe    191f <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1955:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1958:	8b 40 04             	mov    0x4(%eax),%eax
    195b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1962:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1965:	01 c2                	add    %eax,%edx
    1967:	8b 45 fc             	mov    -0x4(%ebp),%eax
    196a:	8b 00                	mov    (%eax),%eax
    196c:	39 c2                	cmp    %eax,%edx
    196e:	75 24                	jne    1994 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1970:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1973:	8b 50 04             	mov    0x4(%eax),%edx
    1976:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1979:	8b 00                	mov    (%eax),%eax
    197b:	8b 40 04             	mov    0x4(%eax),%eax
    197e:	01 c2                	add    %eax,%edx
    1980:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1983:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1986:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1989:	8b 00                	mov    (%eax),%eax
    198b:	8b 10                	mov    (%eax),%edx
    198d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1990:	89 10                	mov    %edx,(%eax)
    1992:	eb 0a                	jmp    199e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1994:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1997:	8b 10                	mov    (%eax),%edx
    1999:	8b 45 f8             	mov    -0x8(%ebp),%eax
    199c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    199e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19a1:	8b 40 04             	mov    0x4(%eax),%eax
    19a4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    19ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19ae:	01 d0                	add    %edx,%eax
    19b0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    19b3:	75 20                	jne    19d5 <free+0xcf>
    p->s.size += bp->s.size;
    19b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19b8:	8b 50 04             	mov    0x4(%eax),%edx
    19bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19be:	8b 40 04             	mov    0x4(%eax),%eax
    19c1:	01 c2                	add    %eax,%edx
    19c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19c6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    19c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19cc:	8b 10                	mov    (%eax),%edx
    19ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19d1:	89 10                	mov    %edx,(%eax)
    19d3:	eb 08                	jmp    19dd <free+0xd7>
  } else
    p->s.ptr = bp;
    19d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19d8:	8b 55 f8             	mov    -0x8(%ebp),%edx
    19db:	89 10                	mov    %edx,(%eax)
  freep = p;
    19dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19e0:	a3 e8 1e 00 00       	mov    %eax,0x1ee8
}
    19e5:	c9                   	leave  
    19e6:	c3                   	ret    

000019e7 <morecore>:

static Header*
morecore(uint nu)
{
    19e7:	55                   	push   %ebp
    19e8:	89 e5                	mov    %esp,%ebp
    19ea:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    19ed:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    19f4:	77 07                	ja     19fd <morecore+0x16>
    nu = 4096;
    19f6:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    19fd:	8b 45 08             	mov    0x8(%ebp),%eax
    1a00:	c1 e0 03             	shl    $0x3,%eax
    1a03:	89 04 24             	mov    %eax,(%esp)
    1a06:	e8 40 fc ff ff       	call   164b <sbrk>
    1a0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1a0e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1a12:	75 07                	jne    1a1b <morecore+0x34>
    return 0;
    1a14:	b8 00 00 00 00       	mov    $0x0,%eax
    1a19:	eb 22                	jmp    1a3d <morecore+0x56>
  hp = (Header*)p;
    1a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a24:	8b 55 08             	mov    0x8(%ebp),%edx
    1a27:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a2d:	83 c0 08             	add    $0x8,%eax
    1a30:	89 04 24             	mov    %eax,(%esp)
    1a33:	e8 ce fe ff ff       	call   1906 <free>
  return freep;
    1a38:	a1 e8 1e 00 00       	mov    0x1ee8,%eax
}
    1a3d:	c9                   	leave  
    1a3e:	c3                   	ret    

00001a3f <malloc>:

void*
malloc(uint nbytes)
{
    1a3f:	55                   	push   %ebp
    1a40:	89 e5                	mov    %esp,%ebp
    1a42:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1a45:	8b 45 08             	mov    0x8(%ebp),%eax
    1a48:	83 c0 07             	add    $0x7,%eax
    1a4b:	c1 e8 03             	shr    $0x3,%eax
    1a4e:	83 c0 01             	add    $0x1,%eax
    1a51:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1a54:	a1 e8 1e 00 00       	mov    0x1ee8,%eax
    1a59:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1a5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1a60:	75 23                	jne    1a85 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1a62:	c7 45 f0 e0 1e 00 00 	movl   $0x1ee0,-0x10(%ebp)
    1a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a6c:	a3 e8 1e 00 00       	mov    %eax,0x1ee8
    1a71:	a1 e8 1e 00 00       	mov    0x1ee8,%eax
    1a76:	a3 e0 1e 00 00       	mov    %eax,0x1ee0
    base.s.size = 0;
    1a7b:	c7 05 e4 1e 00 00 00 	movl   $0x0,0x1ee4
    1a82:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a88:	8b 00                	mov    (%eax),%eax
    1a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a90:	8b 40 04             	mov    0x4(%eax),%eax
    1a93:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1a96:	72 4d                	jb     1ae5 <malloc+0xa6>
      if(p->s.size == nunits)
    1a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a9b:	8b 40 04             	mov    0x4(%eax),%eax
    1a9e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1aa1:	75 0c                	jne    1aaf <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aa6:	8b 10                	mov    (%eax),%edx
    1aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1aab:	89 10                	mov    %edx,(%eax)
    1aad:	eb 26                	jmp    1ad5 <malloc+0x96>
      else {
        p->s.size -= nunits;
    1aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ab2:	8b 40 04             	mov    0x4(%eax),%eax
    1ab5:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1ab8:	89 c2                	mov    %eax,%edx
    1aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1abd:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ac3:	8b 40 04             	mov    0x4(%eax),%eax
    1ac6:	c1 e0 03             	shl    $0x3,%eax
    1ac9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1acf:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1ad2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ad8:	a3 e8 1e 00 00       	mov    %eax,0x1ee8
      return (void*)(p + 1);
    1add:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ae0:	83 c0 08             	add    $0x8,%eax
    1ae3:	eb 38                	jmp    1b1d <malloc+0xde>
    }
    if(p == freep)
    1ae5:	a1 e8 1e 00 00       	mov    0x1ee8,%eax
    1aea:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1aed:	75 1b                	jne    1b0a <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1aef:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1af2:	89 04 24             	mov    %eax,(%esp)
    1af5:	e8 ed fe ff ff       	call   19e7 <morecore>
    1afa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1afd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1b01:	75 07                	jne    1b0a <malloc+0xcb>
        return 0;
    1b03:	b8 00 00 00 00       	mov    $0x0,%eax
    1b08:	eb 13                	jmp    1b1d <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b13:	8b 00                	mov    (%eax),%eax
    1b15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
    1b18:	e9 70 ff ff ff       	jmp    1a8d <malloc+0x4e>
}
    1b1d:	c9                   	leave  
    1b1e:	c3                   	ret    

00001b1f <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
    1b1f:	55                   	push   %ebp
    1b20:	89 e5                	mov    %esp,%ebp
    1b22:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
    1b25:	8b 55 08             	mov    0x8(%ebp),%edx
    1b28:	8b 45 0c             	mov    0xc(%ebp),%eax
    1b2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1b2e:	f0 87 02             	lock xchg %eax,(%edx)
    1b31:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
    1b34:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1b37:	c9                   	leave  
    1b38:	c3                   	ret    

00001b39 <uacquire>:
#include "uspinlock.h"
#include "x86.h"

void
uacquire(struct uspinlock *lk)
{
    1b39:	55                   	push   %ebp
    1b3a:	89 e5                	mov    %esp,%ebp
    1b3c:	83 ec 08             	sub    $0x8,%esp
  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
    1b3f:	90                   	nop
    1b40:	8b 45 08             	mov    0x8(%ebp),%eax
    1b43:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1b4a:	00 
    1b4b:	89 04 24             	mov    %eax,(%esp)
    1b4e:	e8 cc ff ff ff       	call   1b1f <xchg>
    1b53:	85 c0                	test   %eax,%eax
    1b55:	75 e9                	jne    1b40 <uacquire+0x7>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
    1b57:	0f ae f0             	mfence 
}
    1b5a:	c9                   	leave  
    1b5b:	c3                   	ret    

00001b5c <urelease>:

void urelease (struct uspinlock *lk) {
    1b5c:	55                   	push   %ebp
    1b5d:	89 e5                	mov    %esp,%ebp
  __sync_synchronize();
    1b5f:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
    1b62:	8b 45 08             	mov    0x8(%ebp),%eax
    1b65:	8b 55 08             	mov    0x8(%ebp),%edx
    1b68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
    1b6e:	5d                   	pop    %ebp
    1b6f:	c3                   	ret    
