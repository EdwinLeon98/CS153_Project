
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 30 c6 10 80       	mov    $0x8010c630,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 4b 37 10 80       	mov    $0x8010374b,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 1c 83 10 	movl   $0x8010831c,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80100049:	e8 e8 4c 00 00       	call   80104d36 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 8c 0d 11 80 3c 	movl   $0x80110d3c,0x80110d8c
80100055:	0d 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 90 0d 11 80 3c 	movl   $0x80110d3c,0x80110d90
8010005f:	0d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 74 c6 10 80 	movl   $0x8010c674,-0xc(%ebp)
80100069:	eb 46                	jmp    801000b1 <binit+0x7d>
    b->next = bcache.head.next;
8010006b:	8b 15 90 0d 11 80    	mov    0x80110d90,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 50 3c 0d 11 80 	movl   $0x80110d3c,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	83 c0 0c             	add    $0xc,%eax
80100087:	c7 44 24 04 23 83 10 	movl   $0x80108323,0x4(%esp)
8010008e:	80 
8010008f:	89 04 24             	mov    %eax,(%esp)
80100092:	e8 63 4b 00 00       	call   80104bfa <initsleeplock>
    bcache.head.next->prev = b;
80100097:	a1 90 0d 11 80       	mov    0x80110d90,%eax
8010009c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010009f:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a5:	a3 90 0d 11 80       	mov    %eax,0x80110d90
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000b1:	81 7d f4 3c 0d 11 80 	cmpl   $0x80110d3c,-0xc(%ebp)
801000b8:	72 b1                	jb     8010006b <binit+0x37>
  }
}
801000ba:	c9                   	leave  
801000bb:	c3                   	ret    

801000bc <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000bc:	55                   	push   %ebp
801000bd:	89 e5                	mov    %esp,%ebp
801000bf:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000c2:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
801000c9:	e8 89 4c 00 00       	call   80104d57 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ce:	a1 90 0d 11 80       	mov    0x80110d90,%eax
801000d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d6:	eb 50                	jmp    80100128 <bget+0x6c>
    if(b->dev == dev && b->blockno == blockno){
801000d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000db:	8b 40 04             	mov    0x4(%eax),%eax
801000de:	3b 45 08             	cmp    0x8(%ebp),%eax
801000e1:	75 3c                	jne    8010011f <bget+0x63>
801000e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e6:	8b 40 08             	mov    0x8(%eax),%eax
801000e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000ec:	75 31                	jne    8010011f <bget+0x63>
      b->refcnt++;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 40 4c             	mov    0x4c(%eax),%eax
801000f4:	8d 50 01             	lea    0x1(%eax),%edx
801000f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fa:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
801000fd:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80100104:	e8 b6 4c 00 00       	call   80104dbf <release>
      acquiresleep(&b->lock);
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	83 c0 0c             	add    $0xc,%eax
8010010f:	89 04 24             	mov    %eax,(%esp)
80100112:	e8 1d 4b 00 00       	call   80104c34 <acquiresleep>
      return b;
80100117:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011a:	e9 94 00 00 00       	jmp    801001b3 <bget+0xf7>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100122:	8b 40 54             	mov    0x54(%eax),%eax
80100125:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100128:	81 7d f4 3c 0d 11 80 	cmpl   $0x80110d3c,-0xc(%ebp)
8010012f:	75 a7                	jne    801000d8 <bget+0x1c>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100131:	a1 8c 0d 11 80       	mov    0x80110d8c,%eax
80100136:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100139:	eb 63                	jmp    8010019e <bget+0xe2>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010013e:	8b 40 4c             	mov    0x4c(%eax),%eax
80100141:	85 c0                	test   %eax,%eax
80100143:	75 50                	jne    80100195 <bget+0xd9>
80100145:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100148:	8b 00                	mov    (%eax),%eax
8010014a:	83 e0 04             	and    $0x4,%eax
8010014d:	85 c0                	test   %eax,%eax
8010014f:	75 44                	jne    80100195 <bget+0xd9>
      b->dev = dev;
80100151:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100154:	8b 55 08             	mov    0x8(%ebp),%edx
80100157:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 0c             	mov    0xc(%ebp),%edx
80100160:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
80100176:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
8010017d:	e8 3d 4c 00 00       	call   80104dbf <release>
      acquiresleep(&b->lock);
80100182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100185:	83 c0 0c             	add    $0xc,%eax
80100188:	89 04 24             	mov    %eax,(%esp)
8010018b:	e8 a4 4a 00 00       	call   80104c34 <acquiresleep>
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1e                	jmp    801001b3 <bget+0xf7>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 50             	mov    0x50(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 3c 0d 11 80 	cmpl   $0x80110d3c,-0xc(%ebp)
801001a5:	75 94                	jne    8010013b <bget+0x7f>
    }
  }
  panic("bget: no buffers");
801001a7:	c7 04 24 2a 83 10 80 	movl   $0x8010832a,(%esp)
801001ae:	e8 af 03 00 00       	call   80100562 <panic>
}
801001b3:	c9                   	leave  
801001b4:	c3                   	ret    

801001b5 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b5:	55                   	push   %ebp
801001b6:	89 e5                	mov    %esp,%ebp
801001b8:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801001be:	89 44 24 04          	mov    %eax,0x4(%esp)
801001c2:	8b 45 08             	mov    0x8(%ebp),%eax
801001c5:	89 04 24             	mov    %eax,(%esp)
801001c8:	e8 ef fe ff ff       	call   801000bc <bget>
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0b                	jne    801001e7 <bread+0x32>
    iderw(b);
801001dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001df:	89 04 24             	mov    %eax,(%esp)
801001e2:	e8 7b 26 00 00       	call   80102862 <iderw>
  }
  return b;
801001e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ea:	c9                   	leave  
801001eb:	c3                   	ret    

801001ec <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001ec:	55                   	push   %ebp
801001ed:	89 e5                	mov    %esp,%ebp
801001ef:	83 ec 18             	sub    $0x18,%esp
  if(!holdingsleep(&b->lock))
801001f2:	8b 45 08             	mov    0x8(%ebp),%eax
801001f5:	83 c0 0c             	add    $0xc,%eax
801001f8:	89 04 24             	mov    %eax,(%esp)
801001fb:	e8 d1 4a 00 00       	call   80104cd1 <holdingsleep>
80100200:	85 c0                	test   %eax,%eax
80100202:	75 0c                	jne    80100210 <bwrite+0x24>
    panic("bwrite");
80100204:	c7 04 24 3b 83 10 80 	movl   $0x8010833b,(%esp)
8010020b:	e8 52 03 00 00       	call   80100562 <panic>
  b->flags |= B_DIRTY;
80100210:	8b 45 08             	mov    0x8(%ebp),%eax
80100213:	8b 00                	mov    (%eax),%eax
80100215:	83 c8 04             	or     $0x4,%eax
80100218:	89 c2                	mov    %eax,%edx
8010021a:	8b 45 08             	mov    0x8(%ebp),%eax
8010021d:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021f:	8b 45 08             	mov    0x8(%ebp),%eax
80100222:	89 04 24             	mov    %eax,(%esp)
80100225:	e8 38 26 00 00       	call   80102862 <iderw>
}
8010022a:	c9                   	leave  
8010022b:	c3                   	ret    

8010022c <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022c:	55                   	push   %ebp
8010022d:	89 e5                	mov    %esp,%ebp
8010022f:	83 ec 18             	sub    $0x18,%esp
  if(!holdingsleep(&b->lock))
80100232:	8b 45 08             	mov    0x8(%ebp),%eax
80100235:	83 c0 0c             	add    $0xc,%eax
80100238:	89 04 24             	mov    %eax,(%esp)
8010023b:	e8 91 4a 00 00       	call   80104cd1 <holdingsleep>
80100240:	85 c0                	test   %eax,%eax
80100242:	75 0c                	jne    80100250 <brelse+0x24>
    panic("brelse");
80100244:	c7 04 24 42 83 10 80 	movl   $0x80108342,(%esp)
8010024b:	e8 12 03 00 00       	call   80100562 <panic>

  releasesleep(&b->lock);
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	83 c0 0c             	add    $0xc,%eax
80100256:	89 04 24             	mov    %eax,(%esp)
80100259:	e8 31 4a 00 00       	call   80104c8f <releasesleep>

  acquire(&bcache.lock);
8010025e:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80100265:	e8 ed 4a 00 00       	call   80104d57 <acquire>
  b->refcnt--;
8010026a:	8b 45 08             	mov    0x8(%ebp),%eax
8010026d:	8b 40 4c             	mov    0x4c(%eax),%eax
80100270:	8d 50 ff             	lea    -0x1(%eax),%edx
80100273:	8b 45 08             	mov    0x8(%ebp),%eax
80100276:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
80100279:	8b 45 08             	mov    0x8(%ebp),%eax
8010027c:	8b 40 4c             	mov    0x4c(%eax),%eax
8010027f:	85 c0                	test   %eax,%eax
80100281:	75 47                	jne    801002ca <brelse+0x9e>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100283:	8b 45 08             	mov    0x8(%ebp),%eax
80100286:	8b 40 54             	mov    0x54(%eax),%eax
80100289:	8b 55 08             	mov    0x8(%ebp),%edx
8010028c:	8b 52 50             	mov    0x50(%edx),%edx
8010028f:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	8b 40 50             	mov    0x50(%eax),%eax
80100298:	8b 55 08             	mov    0x8(%ebp),%edx
8010029b:	8b 52 54             	mov    0x54(%edx),%edx
8010029e:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
801002a1:	8b 15 90 0d 11 80    	mov    0x80110d90,%edx
801002a7:	8b 45 08             	mov    0x8(%ebp),%eax
801002aa:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801002ad:	8b 45 08             	mov    0x8(%ebp),%eax
801002b0:	c7 40 50 3c 0d 11 80 	movl   $0x80110d3c,0x50(%eax)
    bcache.head.next->prev = b;
801002b7:	a1 90 0d 11 80       	mov    0x80110d90,%eax
801002bc:	8b 55 08             	mov    0x8(%ebp),%edx
801002bf:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801002c2:	8b 45 08             	mov    0x8(%ebp),%eax
801002c5:	a3 90 0d 11 80       	mov    %eax,0x80110d90
  }
  
  release(&bcache.lock);
801002ca:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
801002d1:	e8 e9 4a 00 00       	call   80104dbf <release>
}
801002d6:	c9                   	leave  
801002d7:	c3                   	ret    

801002d8 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d8:	55                   	push   %ebp
801002d9:	89 e5                	mov    %esp,%ebp
801002db:	83 ec 14             	sub    $0x14,%esp
801002de:	8b 45 08             	mov    0x8(%ebp),%eax
801002e1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e9:	89 c2                	mov    %eax,%edx
801002eb:	ec                   	in     (%dx),%al
801002ec:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002ef:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002f3:	c9                   	leave  
801002f4:	c3                   	ret    

801002f5 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f5:	55                   	push   %ebp
801002f6:	89 e5                	mov    %esp,%ebp
801002f8:	83 ec 08             	sub    $0x8,%esp
801002fb:	8b 55 08             	mov    0x8(%ebp),%edx
801002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80100301:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100305:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100308:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010030c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80100310:	ee                   	out    %al,(%dx)
}
80100311:	c9                   	leave  
80100312:	c3                   	ret    

80100313 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100313:	55                   	push   %ebp
80100314:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100316:	fa                   	cli    
}
80100317:	5d                   	pop    %ebp
80100318:	c3                   	ret    

80100319 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100319:	55                   	push   %ebp
8010031a:	89 e5                	mov    %esp,%ebp
8010031c:	56                   	push   %esi
8010031d:	53                   	push   %ebx
8010031e:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100321:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100325:	74 1c                	je     80100343 <printint+0x2a>
80100327:	8b 45 08             	mov    0x8(%ebp),%eax
8010032a:	c1 e8 1f             	shr    $0x1f,%eax
8010032d:	0f b6 c0             	movzbl %al,%eax
80100330:	89 45 10             	mov    %eax,0x10(%ebp)
80100333:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100337:	74 0a                	je     80100343 <printint+0x2a>
    x = -xx;
80100339:	8b 45 08             	mov    0x8(%ebp),%eax
8010033c:	f7 d8                	neg    %eax
8010033e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100341:	eb 06                	jmp    80100349 <printint+0x30>
  else
    x = xx;
80100343:	8b 45 08             	mov    0x8(%ebp),%eax
80100346:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100349:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100350:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100353:	8d 41 01             	lea    0x1(%ecx),%eax
80100356:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100359:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010035c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035f:	ba 00 00 00 00       	mov    $0x0,%edx
80100364:	f7 f3                	div    %ebx
80100366:	89 d0                	mov    %edx,%eax
80100368:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
8010036f:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100373:	8b 75 0c             	mov    0xc(%ebp),%esi
80100376:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100379:	ba 00 00 00 00       	mov    $0x0,%edx
8010037e:	f7 f6                	div    %esi
80100380:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100383:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100387:	75 c7                	jne    80100350 <printint+0x37>

  if(sign)
80100389:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038d:	74 10                	je     8010039f <printint+0x86>
    buf[i++] = '-';
8010038f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100392:	8d 50 01             	lea    0x1(%eax),%edx
80100395:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100398:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039d:	eb 18                	jmp    801003b7 <printint+0x9e>
8010039f:	eb 16                	jmp    801003b7 <printint+0x9e>
    consputc(buf[i]);
801003a1:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a7:	01 d0                	add    %edx,%eax
801003a9:	0f b6 00             	movzbl (%eax),%eax
801003ac:	0f be c0             	movsbl %al,%eax
801003af:	89 04 24             	mov    %eax,(%esp)
801003b2:	e8 d5 03 00 00       	call   8010078c <consputc>
  while(--i >= 0)
801003b7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003bf:	79 e0                	jns    801003a1 <printint+0x88>
}
801003c1:	83 c4 30             	add    $0x30,%esp
801003c4:	5b                   	pop    %ebx
801003c5:	5e                   	pop    %esi
801003c6:	5d                   	pop    %ebp
801003c7:	c3                   	ret    

801003c8 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c8:	55                   	push   %ebp
801003c9:	89 e5                	mov    %esp,%ebp
801003cb:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003ce:	a1 d4 b5 10 80       	mov    0x8010b5d4,%eax
801003d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003da:	74 0c                	je     801003e8 <cprintf+0x20>
    acquire(&cons.lock);
801003dc:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
801003e3:	e8 6f 49 00 00       	call   80104d57 <acquire>

  if (fmt == 0)
801003e8:	8b 45 08             	mov    0x8(%ebp),%eax
801003eb:	85 c0                	test   %eax,%eax
801003ed:	75 0c                	jne    801003fb <cprintf+0x33>
    panic("null fmt");
801003ef:	c7 04 24 49 83 10 80 	movl   $0x80108349,(%esp)
801003f6:	e8 67 01 00 00       	call   80100562 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fb:	8d 45 0c             	lea    0xc(%ebp),%eax
801003fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100401:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100408:	e9 21 01 00 00       	jmp    8010052e <cprintf+0x166>
    if(c != '%'){
8010040d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100411:	74 10                	je     80100423 <cprintf+0x5b>
      consputc(c);
80100413:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100416:	89 04 24             	mov    %eax,(%esp)
80100419:	e8 6e 03 00 00       	call   8010078c <consputc>
      continue;
8010041e:	e9 07 01 00 00       	jmp    8010052a <cprintf+0x162>
    }
    c = fmt[++i] & 0xff;
80100423:	8b 55 08             	mov    0x8(%ebp),%edx
80100426:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010042a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010042d:	01 d0                	add    %edx,%eax
8010042f:	0f b6 00             	movzbl (%eax),%eax
80100432:	0f be c0             	movsbl %al,%eax
80100435:	25 ff 00 00 00       	and    $0xff,%eax
8010043a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
8010043d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100441:	75 05                	jne    80100448 <cprintf+0x80>
      break;
80100443:	e9 06 01 00 00       	jmp    8010054e <cprintf+0x186>
    switch(c){
80100448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010044b:	83 f8 70             	cmp    $0x70,%eax
8010044e:	74 4f                	je     8010049f <cprintf+0xd7>
80100450:	83 f8 70             	cmp    $0x70,%eax
80100453:	7f 13                	jg     80100468 <cprintf+0xa0>
80100455:	83 f8 25             	cmp    $0x25,%eax
80100458:	0f 84 a6 00 00 00    	je     80100504 <cprintf+0x13c>
8010045e:	83 f8 64             	cmp    $0x64,%eax
80100461:	74 14                	je     80100477 <cprintf+0xaf>
80100463:	e9 aa 00 00 00       	jmp    80100512 <cprintf+0x14a>
80100468:	83 f8 73             	cmp    $0x73,%eax
8010046b:	74 57                	je     801004c4 <cprintf+0xfc>
8010046d:	83 f8 78             	cmp    $0x78,%eax
80100470:	74 2d                	je     8010049f <cprintf+0xd7>
80100472:	e9 9b 00 00 00       	jmp    80100512 <cprintf+0x14a>
    case 'd':
      printint(*argp++, 10, 1);
80100477:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047a:	8d 50 04             	lea    0x4(%eax),%edx
8010047d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100480:	8b 00                	mov    (%eax),%eax
80100482:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100489:	00 
8010048a:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100491:	00 
80100492:	89 04 24             	mov    %eax,(%esp)
80100495:	e8 7f fe ff ff       	call   80100319 <printint>
      break;
8010049a:	e9 8b 00 00 00       	jmp    8010052a <cprintf+0x162>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010049f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004a2:	8d 50 04             	lea    0x4(%eax),%edx
801004a5:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a8:	8b 00                	mov    (%eax),%eax
801004aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801004b1:	00 
801004b2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801004b9:	00 
801004ba:	89 04 24             	mov    %eax,(%esp)
801004bd:	e8 57 fe ff ff       	call   80100319 <printint>
      break;
801004c2:	eb 66                	jmp    8010052a <cprintf+0x162>
    case 's':
      if((s = (char*)*argp++) == 0)
801004c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004c7:	8d 50 04             	lea    0x4(%eax),%edx
801004ca:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004cd:	8b 00                	mov    (%eax),%eax
801004cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004d6:	75 09                	jne    801004e1 <cprintf+0x119>
        s = "(null)";
801004d8:	c7 45 ec 52 83 10 80 	movl   $0x80108352,-0x14(%ebp)
      for(; *s; s++)
801004df:	eb 17                	jmp    801004f8 <cprintf+0x130>
801004e1:	eb 15                	jmp    801004f8 <cprintf+0x130>
        consputc(*s);
801004e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004e6:	0f b6 00             	movzbl (%eax),%eax
801004e9:	0f be c0             	movsbl %al,%eax
801004ec:	89 04 24             	mov    %eax,(%esp)
801004ef:	e8 98 02 00 00       	call   8010078c <consputc>
      for(; *s; s++)
801004f4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004fb:	0f b6 00             	movzbl (%eax),%eax
801004fe:	84 c0                	test   %al,%al
80100500:	75 e1                	jne    801004e3 <cprintf+0x11b>
      break;
80100502:	eb 26                	jmp    8010052a <cprintf+0x162>
    case '%':
      consputc('%');
80100504:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
8010050b:	e8 7c 02 00 00       	call   8010078c <consputc>
      break;
80100510:	eb 18                	jmp    8010052a <cprintf+0x162>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100512:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
80100519:	e8 6e 02 00 00       	call   8010078c <consputc>
      consputc(c);
8010051e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100521:	89 04 24             	mov    %eax,(%esp)
80100524:	e8 63 02 00 00       	call   8010078c <consputc>
      break;
80100529:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010052a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010052e:	8b 55 08             	mov    0x8(%ebp),%edx
80100531:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100534:	01 d0                	add    %edx,%eax
80100536:	0f b6 00             	movzbl (%eax),%eax
80100539:	0f be c0             	movsbl %al,%eax
8010053c:	25 ff 00 00 00       	and    $0xff,%eax
80100541:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100544:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100548:	0f 85 bf fe ff ff    	jne    8010040d <cprintf+0x45>
    }
  }

  if(locking)
8010054e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100552:	74 0c                	je     80100560 <cprintf+0x198>
    release(&cons.lock);
80100554:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
8010055b:	e8 5f 48 00 00       	call   80104dbf <release>
}
80100560:	c9                   	leave  
80100561:	c3                   	ret    

80100562 <panic>:

void
panic(char *s)
{
80100562:	55                   	push   %ebp
80100563:	89 e5                	mov    %esp,%ebp
80100565:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];

  cli();
80100568:	e8 a6 fd ff ff       	call   80100313 <cli>
  cons.locking = 0;
8010056d:	c7 05 d4 b5 10 80 00 	movl   $0x0,0x8010b5d4
80100574:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100577:	e8 8a 29 00 00       	call   80102f06 <lapicid>
8010057c:	89 44 24 04          	mov    %eax,0x4(%esp)
80100580:	c7 04 24 59 83 10 80 	movl   $0x80108359,(%esp)
80100587:	e8 3c fe ff ff       	call   801003c8 <cprintf>
  cprintf(s);
8010058c:	8b 45 08             	mov    0x8(%ebp),%eax
8010058f:	89 04 24             	mov    %eax,(%esp)
80100592:	e8 31 fe ff ff       	call   801003c8 <cprintf>
  cprintf("\n");
80100597:	c7 04 24 6d 83 10 80 	movl   $0x8010836d,(%esp)
8010059e:	e8 25 fe ff ff       	call   801003c8 <cprintf>
  getcallerpcs(&s, pcs);
801005a3:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801005aa:	8d 45 08             	lea    0x8(%ebp),%eax
801005ad:	89 04 24             	mov    %eax,(%esp)
801005b0:	e8 55 48 00 00       	call   80104e0a <getcallerpcs>
  for(i=0; i<10; i++)
801005b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005bc:	eb 1b                	jmp    801005d9 <panic+0x77>
    cprintf(" %p", pcs[i]);
801005be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005c1:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801005c9:	c7 04 24 6f 83 10 80 	movl   $0x8010836f,(%esp)
801005d0:	e8 f3 fd ff ff       	call   801003c8 <cprintf>
  for(i=0; i<10; i++)
801005d5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005d9:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005dd:	7e df                	jle    801005be <panic+0x5c>
  panicked = 1; // freeze other CPU
801005df:	c7 05 80 b5 10 80 01 	movl   $0x1,0x8010b580
801005e6:	00 00 00 
  for(;;)
    ;
801005e9:	eb fe                	jmp    801005e9 <panic+0x87>

801005eb <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005eb:	55                   	push   %ebp
801005ec:	89 e5                	mov    %esp,%ebp
801005ee:	83 ec 28             	sub    $0x28,%esp
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005f1:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005f8:	00 
801005f9:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100600:	e8 f0 fc ff ff       	call   801002f5 <outb>
  pos = inb(CRTPORT+1) << 8;
80100605:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010060c:	e8 c7 fc ff ff       	call   801002d8 <inb>
80100611:	0f b6 c0             	movzbl %al,%eax
80100614:	c1 e0 08             	shl    $0x8,%eax
80100617:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010061a:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100621:	00 
80100622:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100629:	e8 c7 fc ff ff       	call   801002f5 <outb>
  pos |= inb(CRTPORT+1);
8010062e:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100635:	e8 9e fc ff ff       	call   801002d8 <inb>
8010063a:	0f b6 c0             	movzbl %al,%eax
8010063d:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100640:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100644:	75 30                	jne    80100676 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100646:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100649:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010064e:	89 c8                	mov    %ecx,%eax
80100650:	f7 ea                	imul   %edx
80100652:	c1 fa 05             	sar    $0x5,%edx
80100655:	89 c8                	mov    %ecx,%eax
80100657:	c1 f8 1f             	sar    $0x1f,%eax
8010065a:	29 c2                	sub    %eax,%edx
8010065c:	89 d0                	mov    %edx,%eax
8010065e:	c1 e0 02             	shl    $0x2,%eax
80100661:	01 d0                	add    %edx,%eax
80100663:	c1 e0 04             	shl    $0x4,%eax
80100666:	29 c1                	sub    %eax,%ecx
80100668:	89 ca                	mov    %ecx,%edx
8010066a:	b8 50 00 00 00       	mov    $0x50,%eax
8010066f:	29 d0                	sub    %edx,%eax
80100671:	01 45 f4             	add    %eax,-0xc(%ebp)
80100674:	eb 35                	jmp    801006ab <cgaputc+0xc0>
  else if(c == BACKSPACE){
80100676:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010067d:	75 0c                	jne    8010068b <cgaputc+0xa0>
    if(pos > 0) --pos;
8010067f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100683:	7e 26                	jle    801006ab <cgaputc+0xc0>
80100685:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100689:	eb 20                	jmp    801006ab <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010068b:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
80100691:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100694:	8d 50 01             	lea    0x1(%eax),%edx
80100697:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010069a:	01 c0                	add    %eax,%eax
8010069c:	8d 14 01             	lea    (%ecx,%eax,1),%edx
8010069f:	8b 45 08             	mov    0x8(%ebp),%eax
801006a2:	0f b6 c0             	movzbl %al,%eax
801006a5:	80 cc 07             	or     $0x7,%ah
801006a8:	66 89 02             	mov    %ax,(%edx)

  if(pos < 0 || pos > 25*80)
801006ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006af:	78 09                	js     801006ba <cgaputc+0xcf>
801006b1:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006b8:	7e 0c                	jle    801006c6 <cgaputc+0xdb>
    panic("pos under/overflow");
801006ba:	c7 04 24 73 83 10 80 	movl   $0x80108373,(%esp)
801006c1:	e8 9c fe ff ff       	call   80100562 <panic>

  if((pos/80) >= 24){  // Scroll up.
801006c6:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006cd:	7e 53                	jle    80100722 <cgaputc+0x137>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006cf:	a1 00 90 10 80       	mov    0x80109000,%eax
801006d4:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006da:	a1 00 90 10 80       	mov    0x80109000,%eax
801006df:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006e6:	00 
801006e7:	89 54 24 04          	mov    %edx,0x4(%esp)
801006eb:	89 04 24             	mov    %eax,(%esp)
801006ee:	e8 95 49 00 00       	call   80105088 <memmove>
    pos -= 80;
801006f3:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006f7:	b8 80 07 00 00       	mov    $0x780,%eax
801006fc:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006ff:	8d 14 00             	lea    (%eax,%eax,1),%edx
80100702:	a1 00 90 10 80       	mov    0x80109000,%eax
80100707:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010070a:	01 c9                	add    %ecx,%ecx
8010070c:	01 c8                	add    %ecx,%eax
8010070e:	89 54 24 08          	mov    %edx,0x8(%esp)
80100712:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100719:	00 
8010071a:	89 04 24             	mov    %eax,(%esp)
8010071d:	e8 97 48 00 00       	call   80104fb9 <memset>
  }

  outb(CRTPORT, 14);
80100722:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
80100729:	00 
8010072a:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100731:	e8 bf fb ff ff       	call   801002f5 <outb>
  outb(CRTPORT+1, pos>>8);
80100736:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100739:	c1 f8 08             	sar    $0x8,%eax
8010073c:	0f b6 c0             	movzbl %al,%eax
8010073f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100743:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010074a:	e8 a6 fb ff ff       	call   801002f5 <outb>
  outb(CRTPORT, 15);
8010074f:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100756:	00 
80100757:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010075e:	e8 92 fb ff ff       	call   801002f5 <outb>
  outb(CRTPORT+1, pos);
80100763:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100766:	0f b6 c0             	movzbl %al,%eax
80100769:	89 44 24 04          	mov    %eax,0x4(%esp)
8010076d:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100774:	e8 7c fb ff ff       	call   801002f5 <outb>
  crt[pos] = ' ' | 0x0700;
80100779:	a1 00 90 10 80       	mov    0x80109000,%eax
8010077e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100781:	01 d2                	add    %edx,%edx
80100783:	01 d0                	add    %edx,%eax
80100785:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010078a:	c9                   	leave  
8010078b:	c3                   	ret    

8010078c <consputc>:

void
consputc(int c)
{
8010078c:	55                   	push   %ebp
8010078d:	89 e5                	mov    %esp,%ebp
8010078f:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100792:	a1 80 b5 10 80       	mov    0x8010b580,%eax
80100797:	85 c0                	test   %eax,%eax
80100799:	74 07                	je     801007a2 <consputc+0x16>
    cli();
8010079b:	e8 73 fb ff ff       	call   80100313 <cli>
    for(;;)
      ;
801007a0:	eb fe                	jmp    801007a0 <consputc+0x14>
  }

  if(c == BACKSPACE){
801007a2:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007a9:	75 26                	jne    801007d1 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007ab:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007b2:	e8 21 61 00 00       	call   801068d8 <uartputc>
801007b7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801007be:	e8 15 61 00 00       	call   801068d8 <uartputc>
801007c3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007ca:	e8 09 61 00 00       	call   801068d8 <uartputc>
801007cf:	eb 0b                	jmp    801007dc <consputc+0x50>
  } else
    uartputc(c);
801007d1:	8b 45 08             	mov    0x8(%ebp),%eax
801007d4:	89 04 24             	mov    %eax,(%esp)
801007d7:	e8 fc 60 00 00       	call   801068d8 <uartputc>
  cgaputc(c);
801007dc:	8b 45 08             	mov    0x8(%ebp),%eax
801007df:	89 04 24             	mov    %eax,(%esp)
801007e2:	e8 04 fe ff ff       	call   801005eb <cgaputc>
}
801007e7:	c9                   	leave  
801007e8:	c3                   	ret    

801007e9 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007e9:	55                   	push   %ebp
801007ea:	89 e5                	mov    %esp,%ebp
801007ec:	83 ec 28             	sub    $0x28,%esp
  int c, doprocdump = 0;
801007ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
801007f6:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
801007fd:	e8 55 45 00 00       	call   80104d57 <acquire>
  while((c = getc()) >= 0){
80100802:	e9 39 01 00 00       	jmp    80100940 <consoleintr+0x157>
    switch(c){
80100807:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010080a:	83 f8 10             	cmp    $0x10,%eax
8010080d:	74 1e                	je     8010082d <consoleintr+0x44>
8010080f:	83 f8 10             	cmp    $0x10,%eax
80100812:	7f 0a                	jg     8010081e <consoleintr+0x35>
80100814:	83 f8 08             	cmp    $0x8,%eax
80100817:	74 66                	je     8010087f <consoleintr+0x96>
80100819:	e9 93 00 00 00       	jmp    801008b1 <consoleintr+0xc8>
8010081e:	83 f8 15             	cmp    $0x15,%eax
80100821:	74 31                	je     80100854 <consoleintr+0x6b>
80100823:	83 f8 7f             	cmp    $0x7f,%eax
80100826:	74 57                	je     8010087f <consoleintr+0x96>
80100828:	e9 84 00 00 00       	jmp    801008b1 <consoleintr+0xc8>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
8010082d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100834:	e9 07 01 00 00       	jmp    80100940 <consoleintr+0x157>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100839:	a1 28 10 11 80       	mov    0x80111028,%eax
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 28 10 11 80       	mov    %eax,0x80111028
        consputc(BACKSPACE);
80100846:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010084d:	e8 3a ff ff ff       	call   8010078c <consputc>
80100852:	eb 01                	jmp    80100855 <consoleintr+0x6c>
      while(input.e != input.w &&
80100854:	90                   	nop
80100855:	8b 15 28 10 11 80    	mov    0x80111028,%edx
8010085b:	a1 24 10 11 80       	mov    0x80111024,%eax
80100860:	39 c2                	cmp    %eax,%edx
80100862:	74 16                	je     8010087a <consoleintr+0x91>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100864:	a1 28 10 11 80       	mov    0x80111028,%eax
80100869:	83 e8 01             	sub    $0x1,%eax
8010086c:	83 e0 7f             	and    $0x7f,%eax
8010086f:	0f b6 80 a0 0f 11 80 	movzbl -0x7feef060(%eax),%eax
      while(input.e != input.w &&
80100876:	3c 0a                	cmp    $0xa,%al
80100878:	75 bf                	jne    80100839 <consoleintr+0x50>
      }
      break;
8010087a:	e9 c1 00 00 00       	jmp    80100940 <consoleintr+0x157>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010087f:	8b 15 28 10 11 80    	mov    0x80111028,%edx
80100885:	a1 24 10 11 80       	mov    0x80111024,%eax
8010088a:	39 c2                	cmp    %eax,%edx
8010088c:	74 1e                	je     801008ac <consoleintr+0xc3>
        input.e--;
8010088e:	a1 28 10 11 80       	mov    0x80111028,%eax
80100893:	83 e8 01             	sub    $0x1,%eax
80100896:	a3 28 10 11 80       	mov    %eax,0x80111028
        consputc(BACKSPACE);
8010089b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
801008a2:	e8 e5 fe ff ff       	call   8010078c <consputc>
      }
      break;
801008a7:	e9 94 00 00 00       	jmp    80100940 <consoleintr+0x157>
801008ac:	e9 8f 00 00 00       	jmp    80100940 <consoleintr+0x157>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801008b5:	0f 84 84 00 00 00    	je     8010093f <consoleintr+0x156>
801008bb:	8b 15 28 10 11 80    	mov    0x80111028,%edx
801008c1:	a1 20 10 11 80       	mov    0x80111020,%eax
801008c6:	29 c2                	sub    %eax,%edx
801008c8:	89 d0                	mov    %edx,%eax
801008ca:	83 f8 7f             	cmp    $0x7f,%eax
801008cd:	77 70                	ja     8010093f <consoleintr+0x156>
        c = (c == '\r') ? '\n' : c;
801008cf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801008d3:	74 05                	je     801008da <consoleintr+0xf1>
801008d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008d8:	eb 05                	jmp    801008df <consoleintr+0xf6>
801008da:	b8 0a 00 00 00       	mov    $0xa,%eax
801008df:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008e2:	a1 28 10 11 80       	mov    0x80111028,%eax
801008e7:	8d 50 01             	lea    0x1(%eax),%edx
801008ea:	89 15 28 10 11 80    	mov    %edx,0x80111028
801008f0:	83 e0 7f             	and    $0x7f,%eax
801008f3:	89 c2                	mov    %eax,%edx
801008f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008f8:	88 82 a0 0f 11 80    	mov    %al,-0x7feef060(%edx)
        consputc(c);
801008fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100901:	89 04 24             	mov    %eax,(%esp)
80100904:	e8 83 fe ff ff       	call   8010078c <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100909:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
8010090d:	74 18                	je     80100927 <consoleintr+0x13e>
8010090f:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100913:	74 12                	je     80100927 <consoleintr+0x13e>
80100915:	a1 28 10 11 80       	mov    0x80111028,%eax
8010091a:	8b 15 20 10 11 80    	mov    0x80111020,%edx
80100920:	83 ea 80             	sub    $0xffffff80,%edx
80100923:	39 d0                	cmp    %edx,%eax
80100925:	75 18                	jne    8010093f <consoleintr+0x156>
          input.w = input.e;
80100927:	a1 28 10 11 80       	mov    0x80111028,%eax
8010092c:	a3 24 10 11 80       	mov    %eax,0x80111024
          wakeup(&input.r);
80100931:	c7 04 24 20 10 11 80 	movl   $0x80111020,(%esp)
80100938:	e8 23 41 00 00       	call   80104a60 <wakeup>
        }
      }
      break;
8010093d:	eb 00                	jmp    8010093f <consoleintr+0x156>
8010093f:	90                   	nop
  while((c = getc()) >= 0){
80100940:	8b 45 08             	mov    0x8(%ebp),%eax
80100943:	ff d0                	call   *%eax
80100945:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100948:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010094c:	0f 89 b5 fe ff ff    	jns    80100807 <consoleintr+0x1e>
    }
  }
  release(&cons.lock);
80100952:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100959:	e8 61 44 00 00       	call   80104dbf <release>
  if(doprocdump) {
8010095e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100962:	74 05                	je     80100969 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
80100964:	e8 9a 41 00 00       	call   80104b03 <procdump>
  }
}
80100969:	c9                   	leave  
8010096a:	c3                   	ret    

8010096b <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010096b:	55                   	push   %ebp
8010096c:	89 e5                	mov    %esp,%ebp
8010096e:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100971:	8b 45 08             	mov    0x8(%ebp),%eax
80100974:	89 04 24             	mov    %eax,(%esp)
80100977:	e8 c5 10 00 00       	call   80101a41 <iunlock>
  target = n;
8010097c:	8b 45 10             	mov    0x10(%ebp),%eax
8010097f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100982:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100989:	e8 c9 43 00 00       	call   80104d57 <acquire>
  while(n > 0){
8010098e:	e9 a9 00 00 00       	jmp    80100a3c <consoleread+0xd1>
    while(input.r == input.w){
80100993:	eb 41                	jmp    801009d6 <consoleread+0x6b>
      if(myproc()->killed){
80100995:	e8 a3 37 00 00       	call   8010413d <myproc>
8010099a:	8b 40 24             	mov    0x24(%eax),%eax
8010099d:	85 c0                	test   %eax,%eax
8010099f:	74 21                	je     801009c2 <consoleread+0x57>
        release(&cons.lock);
801009a1:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
801009a8:	e8 12 44 00 00       	call   80104dbf <release>
        ilock(ip);
801009ad:	8b 45 08             	mov    0x8(%ebp),%eax
801009b0:	89 04 24             	mov    %eax,(%esp)
801009b3:	e8 7c 0f 00 00       	call   80101934 <ilock>
        return -1;
801009b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009bd:	e9 a5 00 00 00       	jmp    80100a67 <consoleread+0xfc>
      }
      sleep(&input.r, &cons.lock);
801009c2:	c7 44 24 04 a0 b5 10 	movl   $0x8010b5a0,0x4(%esp)
801009c9:	80 
801009ca:	c7 04 24 20 10 11 80 	movl   $0x80111020,(%esp)
801009d1:	e8 b6 3f 00 00       	call   8010498c <sleep>
    while(input.r == input.w){
801009d6:	8b 15 20 10 11 80    	mov    0x80111020,%edx
801009dc:	a1 24 10 11 80       	mov    0x80111024,%eax
801009e1:	39 c2                	cmp    %eax,%edx
801009e3:	74 b0                	je     80100995 <consoleread+0x2a>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009e5:	a1 20 10 11 80       	mov    0x80111020,%eax
801009ea:	8d 50 01             	lea    0x1(%eax),%edx
801009ed:	89 15 20 10 11 80    	mov    %edx,0x80111020
801009f3:	83 e0 7f             	and    $0x7f,%eax
801009f6:	0f b6 80 a0 0f 11 80 	movzbl -0x7feef060(%eax),%eax
801009fd:	0f be c0             	movsbl %al,%eax
80100a00:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a03:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a07:	75 19                	jne    80100a22 <consoleread+0xb7>
      if(n < target){
80100a09:	8b 45 10             	mov    0x10(%ebp),%eax
80100a0c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a0f:	73 0f                	jae    80100a20 <consoleread+0xb5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a11:	a1 20 10 11 80       	mov    0x80111020,%eax
80100a16:	83 e8 01             	sub    $0x1,%eax
80100a19:	a3 20 10 11 80       	mov    %eax,0x80111020
      }
      break;
80100a1e:	eb 26                	jmp    80100a46 <consoleread+0xdb>
80100a20:	eb 24                	jmp    80100a46 <consoleread+0xdb>
    }
    *dst++ = c;
80100a22:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a25:	8d 50 01             	lea    0x1(%eax),%edx
80100a28:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a2e:	88 10                	mov    %dl,(%eax)
    --n;
80100a30:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a34:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a38:	75 02                	jne    80100a3c <consoleread+0xd1>
      break;
80100a3a:	eb 0a                	jmp    80100a46 <consoleread+0xdb>
  while(n > 0){
80100a3c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a40:	0f 8f 4d ff ff ff    	jg     80100993 <consoleread+0x28>
  }
  release(&cons.lock);
80100a46:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100a4d:	e8 6d 43 00 00       	call   80104dbf <release>
  ilock(ip);
80100a52:	8b 45 08             	mov    0x8(%ebp),%eax
80100a55:	89 04 24             	mov    %eax,(%esp)
80100a58:	e8 d7 0e 00 00       	call   80101934 <ilock>

  return target - n;
80100a5d:	8b 45 10             	mov    0x10(%ebp),%eax
80100a60:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a63:	29 c2                	sub    %eax,%edx
80100a65:	89 d0                	mov    %edx,%eax
}
80100a67:	c9                   	leave  
80100a68:	c3                   	ret    

80100a69 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a69:	55                   	push   %ebp
80100a6a:	89 e5                	mov    %esp,%ebp
80100a6c:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100a72:	89 04 24             	mov    %eax,(%esp)
80100a75:	e8 c7 0f 00 00       	call   80101a41 <iunlock>
  acquire(&cons.lock);
80100a7a:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100a81:	e8 d1 42 00 00       	call   80104d57 <acquire>
  for(i = 0; i < n; i++)
80100a86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a8d:	eb 1d                	jmp    80100aac <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a92:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a95:	01 d0                	add    %edx,%eax
80100a97:	0f b6 00             	movzbl (%eax),%eax
80100a9a:	0f be c0             	movsbl %al,%eax
80100a9d:	0f b6 c0             	movzbl %al,%eax
80100aa0:	89 04 24             	mov    %eax,(%esp)
80100aa3:	e8 e4 fc ff ff       	call   8010078c <consputc>
  for(i = 0; i < n; i++)
80100aa8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100aaf:	3b 45 10             	cmp    0x10(%ebp),%eax
80100ab2:	7c db                	jl     80100a8f <consolewrite+0x26>
  release(&cons.lock);
80100ab4:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100abb:	e8 ff 42 00 00       	call   80104dbf <release>
  ilock(ip);
80100ac0:	8b 45 08             	mov    0x8(%ebp),%eax
80100ac3:	89 04 24             	mov    %eax,(%esp)
80100ac6:	e8 69 0e 00 00       	call   80101934 <ilock>

  return n;
80100acb:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100ace:	c9                   	leave  
80100acf:	c3                   	ret    

80100ad0 <consoleinit>:

void
consoleinit(void)
{
80100ad0:	55                   	push   %ebp
80100ad1:	89 e5                	mov    %esp,%ebp
80100ad3:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100ad6:	c7 44 24 04 86 83 10 	movl   $0x80108386,0x4(%esp)
80100add:	80 
80100ade:	c7 04 24 a0 b5 10 80 	movl   $0x8010b5a0,(%esp)
80100ae5:	e8 4c 42 00 00       	call   80104d36 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100aea:	c7 05 ec 19 11 80 69 	movl   $0x80100a69,0x801119ec
80100af1:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100af4:	c7 05 e8 19 11 80 6b 	movl   $0x8010096b,0x801119e8
80100afb:	09 10 80 
  cons.locking = 1;
80100afe:	c7 05 d4 b5 10 80 01 	movl   $0x1,0x8010b5d4
80100b05:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100b08:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100b0f:	00 
80100b10:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100b17:	e8 fa 1e 00 00       	call   80102a16 <ioapicenable>
}
80100b1c:	c9                   	leave  
80100b1d:	c3                   	ret    

80100b1e <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b1e:	55                   	push   %ebp
80100b1f:	89 e5                	mov    %esp,%ebp
80100b21:	81 ec 38 01 00 00    	sub    $0x138,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b27:	e8 11 36 00 00       	call   8010413d <myproc>
80100b2c:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100b2f:	e8 2a 29 00 00       	call   8010345e <begin_op>

  if((ip = namei(path)) == 0){
80100b34:	8b 45 08             	mov    0x8(%ebp),%eax
80100b37:	89 04 24             	mov    %eax,(%esp)
80100b3a:	e8 2f 19 00 00       	call   8010246e <namei>
80100b3f:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b42:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b46:	75 1b                	jne    80100b63 <exec+0x45>
    end_op();
80100b48:	e8 95 29 00 00       	call   801034e2 <end_op>
    cprintf("exec: fail\n");
80100b4d:	c7 04 24 8e 83 10 80 	movl   $0x8010838e,(%esp)
80100b54:	e8 6f f8 ff ff       	call   801003c8 <cprintf>
    return -1;
80100b59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b5e:	e9 db 03 00 00       	jmp    80100f3e <exec+0x420>
  }
  ilock(ip);
80100b63:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b66:	89 04 24             	mov    %eax,(%esp)
80100b69:	e8 c6 0d 00 00       	call   80101934 <ilock>
  pgdir = 0;
80100b6e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b75:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b7c:	00 
80100b7d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b84:	00 
80100b85:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b8f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b92:	89 04 24             	mov    %eax,(%esp)
80100b95:	e8 37 12 00 00       	call   80101dd1 <readi>
80100b9a:	83 f8 34             	cmp    $0x34,%eax
80100b9d:	74 05                	je     80100ba4 <exec+0x86>
    goto bad;
80100b9f:	e9 6e 03 00 00       	jmp    80100f12 <exec+0x3f4>
  if(elf.magic != ELF_MAGIC)
80100ba4:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100baa:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100baf:	74 05                	je     80100bb6 <exec+0x98>
    goto bad;
80100bb1:	e9 5c 03 00 00       	jmp    80100f12 <exec+0x3f4>

  if((pgdir = setupkvm()) == 0)
80100bb6:	e8 1a 6d 00 00       	call   801078d5 <setupkvm>
80100bbb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100bbe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100bc2:	75 05                	jne    80100bc9 <exec+0xab>
    goto bad;
80100bc4:	e9 49 03 00 00       	jmp    80100f12 <exec+0x3f4>

  // Load program into memory.
  sz = 0;
80100bc9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bd0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100bd7:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100bdd:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100be0:	e9 fc 00 00 00       	jmp    80100ce1 <exec+0x1c3>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100be5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100be8:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bef:	00 
80100bf0:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bf4:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bfe:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c01:	89 04 24             	mov    %eax,(%esp)
80100c04:	e8 c8 11 00 00       	call   80101dd1 <readi>
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	74 05                	je     80100c13 <exec+0xf5>
      goto bad;
80100c0e:	e9 ff 02 00 00       	jmp    80100f12 <exec+0x3f4>
    if(ph.type != ELF_PROG_LOAD)
80100c13:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100c19:	83 f8 01             	cmp    $0x1,%eax
80100c1c:	74 05                	je     80100c23 <exec+0x105>
      continue;
80100c1e:	e9 b1 00 00 00       	jmp    80100cd4 <exec+0x1b6>
    if(ph.memsz < ph.filesz)
80100c23:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c29:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100c2f:	39 c2                	cmp    %eax,%edx
80100c31:	73 05                	jae    80100c38 <exec+0x11a>
      goto bad;
80100c33:	e9 da 02 00 00       	jmp    80100f12 <exec+0x3f4>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100c38:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c3e:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c44:	01 c2                	add    %eax,%edx
80100c46:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c4c:	39 c2                	cmp    %eax,%edx
80100c4e:	73 05                	jae    80100c55 <exec+0x137>
      goto bad;
80100c50:	e9 bd 02 00 00       	jmp    80100f12 <exec+0x3f4>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c55:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c5b:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c61:	01 d0                	add    %edx,%eax
80100c63:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c67:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c6e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c71:	89 04 24             	mov    %eax,(%esp)
80100c74:	e8 32 70 00 00       	call   80107cab <allocuvm>
80100c79:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c7c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c80:	75 05                	jne    80100c87 <exec+0x169>
      goto bad;
80100c82:	e9 8b 02 00 00       	jmp    80100f12 <exec+0x3f4>
    if(ph.vaddr % PGSIZE != 0)
80100c87:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c8d:	25 ff 0f 00 00       	and    $0xfff,%eax
80100c92:	85 c0                	test   %eax,%eax
80100c94:	74 05                	je     80100c9b <exec+0x17d>
      goto bad;
80100c96:	e9 77 02 00 00       	jmp    80100f12 <exec+0x3f4>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c9b:	8b 8d f8 fe ff ff    	mov    -0x108(%ebp),%ecx
80100ca1:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100ca7:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cad:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100cb1:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100cb5:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100cb8:	89 54 24 08          	mov    %edx,0x8(%esp)
80100cbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cc0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cc3:	89 04 24             	mov    %eax,(%esp)
80100cc6:	e8 fd 6e 00 00       	call   80107bc8 <loaduvm>
80100ccb:	85 c0                	test   %eax,%eax
80100ccd:	79 05                	jns    80100cd4 <exec+0x1b6>
      goto bad;
80100ccf:	e9 3e 02 00 00       	jmp    80100f12 <exec+0x3f4>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cd4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100cd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cdb:	83 c0 20             	add    $0x20,%eax
80100cde:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ce1:	0f b7 85 34 ff ff ff 	movzwl -0xcc(%ebp),%eax
80100ce8:	0f b7 c0             	movzwl %ax,%eax
80100ceb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100cee:	0f 8f f1 fe ff ff    	jg     80100be5 <exec+0xc7>
  }
  iunlockput(ip);
80100cf4:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100cf7:	89 04 24             	mov    %eax,(%esp)
80100cfa:	e8 37 0e 00 00       	call   80101b36 <iunlockput>
  end_op();
80100cff:	e8 de 27 00 00       	call   801034e2 <end_op>
  ip = 0;
80100d04:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
 // sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, STACK, PGROUNDUP(STACK))) == 0)
80100d0b:	c7 44 24 08 00 00 00 	movl   $0x80000000,0x8(%esp)
80100d12:	80 
80100d13:	c7 44 24 04 ff ff ff 	movl   $0x7fffffff,0x4(%esp)
80100d1a:	7f 
80100d1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d1e:	89 04 24             	mov    %eax,(%esp)
80100d21:	e8 85 6f 00 00       	call   80107cab <allocuvm>
80100d26:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d29:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d2d:	75 05                	jne    80100d34 <exec+0x216>
    goto bad;
80100d2f:	e9 de 01 00 00       	jmp    80100f12 <exec+0x3f4>
 // clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = STACK;
80100d34:	c7 45 dc ff ff ff 7f 	movl   $0x7fffffff,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d3b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d42:	e9 9a 00 00 00       	jmp    80100de1 <exec+0x2c3>
    if(argc >= MAXARG)
80100d47:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d4b:	76 05                	jbe    80100d52 <exec+0x234>
      goto bad;
80100d4d:	e9 c0 01 00 00       	jmp    80100f12 <exec+0x3f4>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d55:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d5f:	01 d0                	add    %edx,%eax
80100d61:	8b 00                	mov    (%eax),%eax
80100d63:	89 04 24             	mov    %eax,(%esp)
80100d66:	e8 b8 44 00 00       	call   80105223 <strlen>
80100d6b:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100d6e:	29 c2                	sub    %eax,%edx
80100d70:	89 d0                	mov    %edx,%eax
80100d72:	83 e8 01             	sub    $0x1,%eax
80100d75:	83 e0 fc             	and    $0xfffffffc,%eax
80100d78:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d7e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d85:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d88:	01 d0                	add    %edx,%eax
80100d8a:	8b 00                	mov    (%eax),%eax
80100d8c:	89 04 24             	mov    %eax,(%esp)
80100d8f:	e8 8f 44 00 00       	call   80105223 <strlen>
80100d94:	83 c0 01             	add    $0x1,%eax
80100d97:	89 c2                	mov    %eax,%edx
80100d99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d9c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100da3:	8b 45 0c             	mov    0xc(%ebp),%eax
80100da6:	01 c8                	add    %ecx,%eax
80100da8:	8b 00                	mov    (%eax),%eax
80100daa:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100dae:	89 44 24 08          	mov    %eax,0x8(%esp)
80100db2:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100db5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100db9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100dbc:	89 04 24             	mov    %eax,(%esp)
80100dbf:	e8 0d 74 00 00       	call   801081d1 <copyout>
80100dc4:	85 c0                	test   %eax,%eax
80100dc6:	79 05                	jns    80100dcd <exec+0x2af>
      goto bad;
80100dc8:	e9 45 01 00 00       	jmp    80100f12 <exec+0x3f4>
    ustack[3+argc] = sp;
80100dcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd0:	8d 50 03             	lea    0x3(%eax),%edx
80100dd3:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dd6:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100ddd:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100de1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100deb:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dee:	01 d0                	add    %edx,%eax
80100df0:	8b 00                	mov    (%eax),%eax
80100df2:	85 c0                	test   %eax,%eax
80100df4:	0f 85 4d ff ff ff    	jne    80100d47 <exec+0x229>
  }
  ustack[3+argc] = 0;
80100dfa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dfd:	83 c0 03             	add    $0x3,%eax
80100e00:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100e07:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e0b:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100e12:	ff ff ff 
  ustack[1] = argc;
80100e15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e18:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e21:	83 c0 01             	add    $0x1,%eax
80100e24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e2e:	29 d0                	sub    %edx,%eax
80100e30:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100e36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e39:	83 c0 04             	add    $0x4,%eax
80100e3c:	c1 e0 02             	shl    $0x2,%eax
80100e3f:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e45:	83 c0 04             	add    $0x4,%eax
80100e48:	c1 e0 02             	shl    $0x2,%eax
80100e4b:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e4f:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100e55:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e59:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e60:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e63:	89 04 24             	mov    %eax,(%esp)
80100e66:	e8 66 73 00 00       	call   801081d1 <copyout>
80100e6b:	85 c0                	test   %eax,%eax
80100e6d:	79 05                	jns    80100e74 <exec+0x356>
    goto bad;
80100e6f:	e9 9e 00 00 00       	jmp    80100f12 <exec+0x3f4>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e74:	8b 45 08             	mov    0x8(%ebp),%eax
80100e77:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e80:	eb 17                	jmp    80100e99 <exec+0x37b>
    if(*s == '/')
80100e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e85:	0f b6 00             	movzbl (%eax),%eax
80100e88:	3c 2f                	cmp    $0x2f,%al
80100e8a:	75 09                	jne    80100e95 <exec+0x377>
      last = s+1;
80100e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e8f:	83 c0 01             	add    $0x1,%eax
80100e92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(last=s=path; *s; s++)
80100e95:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e9c:	0f b6 00             	movzbl (%eax),%eax
80100e9f:	84 c0                	test   %al,%al
80100ea1:	75 df                	jne    80100e82 <exec+0x364>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100ea3:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ea6:	8d 50 6c             	lea    0x6c(%eax),%edx
80100ea9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100eb0:	00 
80100eb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100eb4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100eb8:	89 14 24             	mov    %edx,(%esp)
80100ebb:	e8 19 43 00 00       	call   801051d9 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100ec0:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ec3:	8b 40 04             	mov    0x4(%eax),%eax
80100ec6:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
80100ec9:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ecc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100ecf:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100ed2:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ed5:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ed8:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100eda:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100edd:	8b 40 18             	mov    0x18(%eax),%eax
80100ee0:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100ee6:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100ee9:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100eec:	8b 40 18             	mov    0x18(%eax),%eax
80100eef:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ef2:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80100ef5:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ef8:	89 04 24             	mov    %eax,(%esp)
80100efb:	e8 af 6a 00 00       	call   801079af <switchuvm>
  freevm(oldpgdir);
80100f00:	8b 45 cc             	mov    -0x34(%ebp),%eax
80100f03:	89 04 24             	mov    %eax,(%esp)
80100f06:	e8 7c 6f 00 00       	call   80107e87 <freevm>
  return 0;
80100f0b:	b8 00 00 00 00       	mov    $0x0,%eax
80100f10:	eb 2c                	jmp    80100f3e <exec+0x420>

 bad:
  if(pgdir)
80100f12:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f16:	74 0b                	je     80100f23 <exec+0x405>
    freevm(pgdir);
80100f18:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f1b:	89 04 24             	mov    %eax,(%esp)
80100f1e:	e8 64 6f 00 00       	call   80107e87 <freevm>
  if(ip){
80100f23:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f27:	74 10                	je     80100f39 <exec+0x41b>
    iunlockput(ip);
80100f29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100f2c:	89 04 24             	mov    %eax,(%esp)
80100f2f:	e8 02 0c 00 00       	call   80101b36 <iunlockput>
    end_op();
80100f34:	e8 a9 25 00 00       	call   801034e2 <end_op>
  }
  return -1;
80100f39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f3e:	c9                   	leave  
80100f3f:	c3                   	ret    

80100f40 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f46:	c7 44 24 04 9a 83 10 	movl   $0x8010839a,0x4(%esp)
80100f4d:	80 
80100f4e:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
80100f55:	e8 dc 3d 00 00       	call   80104d36 <initlock>
}
80100f5a:	c9                   	leave  
80100f5b:	c3                   	ret    

80100f5c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f5c:	55                   	push   %ebp
80100f5d:	89 e5                	mov    %esp,%ebp
80100f5f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f62:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
80100f69:	e8 e9 3d 00 00       	call   80104d57 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f6e:	c7 45 f4 74 10 11 80 	movl   $0x80111074,-0xc(%ebp)
80100f75:	eb 29                	jmp    80100fa0 <filealloc+0x44>
    if(f->ref == 0){
80100f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f7a:	8b 40 04             	mov    0x4(%eax),%eax
80100f7d:	85 c0                	test   %eax,%eax
80100f7f:	75 1b                	jne    80100f9c <filealloc+0x40>
      f->ref = 1;
80100f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f84:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f8b:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
80100f92:	e8 28 3e 00 00       	call   80104dbf <release>
      return f;
80100f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f9a:	eb 1e                	jmp    80100fba <filealloc+0x5e>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f9c:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100fa0:	81 7d f4 d4 19 11 80 	cmpl   $0x801119d4,-0xc(%ebp)
80100fa7:	72 ce                	jb     80100f77 <filealloc+0x1b>
    }
  }
  release(&ftable.lock);
80100fa9:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
80100fb0:	e8 0a 3e 00 00       	call   80104dbf <release>
  return 0;
80100fb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100fba:	c9                   	leave  
80100fbb:	c3                   	ret    

80100fbc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fbc:	55                   	push   %ebp
80100fbd:	89 e5                	mov    %esp,%ebp
80100fbf:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100fc2:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
80100fc9:	e8 89 3d 00 00       	call   80104d57 <acquire>
  if(f->ref < 1)
80100fce:	8b 45 08             	mov    0x8(%ebp),%eax
80100fd1:	8b 40 04             	mov    0x4(%eax),%eax
80100fd4:	85 c0                	test   %eax,%eax
80100fd6:	7f 0c                	jg     80100fe4 <filedup+0x28>
    panic("filedup");
80100fd8:	c7 04 24 a1 83 10 80 	movl   $0x801083a1,(%esp)
80100fdf:	e8 7e f5 ff ff       	call   80100562 <panic>
  f->ref++;
80100fe4:	8b 45 08             	mov    0x8(%ebp),%eax
80100fe7:	8b 40 04             	mov    0x4(%eax),%eax
80100fea:	8d 50 01             	lea    0x1(%eax),%edx
80100fed:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff0:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100ff3:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
80100ffa:	e8 c0 3d 00 00       	call   80104dbf <release>
  return f;
80100fff:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101002:	c9                   	leave  
80101003:	c3                   	ret    

80101004 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101004:	55                   	push   %ebp
80101005:	89 e5                	mov    %esp,%ebp
80101007:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
8010100a:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
80101011:	e8 41 3d 00 00       	call   80104d57 <acquire>
  if(f->ref < 1)
80101016:	8b 45 08             	mov    0x8(%ebp),%eax
80101019:	8b 40 04             	mov    0x4(%eax),%eax
8010101c:	85 c0                	test   %eax,%eax
8010101e:	7f 0c                	jg     8010102c <fileclose+0x28>
    panic("fileclose");
80101020:	c7 04 24 a9 83 10 80 	movl   $0x801083a9,(%esp)
80101027:	e8 36 f5 ff ff       	call   80100562 <panic>
  if(--f->ref > 0){
8010102c:	8b 45 08             	mov    0x8(%ebp),%eax
8010102f:	8b 40 04             	mov    0x4(%eax),%eax
80101032:	8d 50 ff             	lea    -0x1(%eax),%edx
80101035:	8b 45 08             	mov    0x8(%ebp),%eax
80101038:	89 50 04             	mov    %edx,0x4(%eax)
8010103b:	8b 45 08             	mov    0x8(%ebp),%eax
8010103e:	8b 40 04             	mov    0x4(%eax),%eax
80101041:	85 c0                	test   %eax,%eax
80101043:	7e 11                	jle    80101056 <fileclose+0x52>
    release(&ftable.lock);
80101045:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
8010104c:	e8 6e 3d 00 00       	call   80104dbf <release>
80101051:	e9 82 00 00 00       	jmp    801010d8 <fileclose+0xd4>
    return;
  }
  ff = *f;
80101056:	8b 45 08             	mov    0x8(%ebp),%eax
80101059:	8b 10                	mov    (%eax),%edx
8010105b:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010105e:	8b 50 04             	mov    0x4(%eax),%edx
80101061:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101064:	8b 50 08             	mov    0x8(%eax),%edx
80101067:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010106a:	8b 50 0c             	mov    0xc(%eax),%edx
8010106d:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101070:	8b 50 10             	mov    0x10(%eax),%edx
80101073:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101076:	8b 40 14             	mov    0x14(%eax),%eax
80101079:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
8010107c:	8b 45 08             	mov    0x8(%ebp),%eax
8010107f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101086:	8b 45 08             	mov    0x8(%ebp),%eax
80101089:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010108f:	c7 04 24 40 10 11 80 	movl   $0x80111040,(%esp)
80101096:	e8 24 3d 00 00       	call   80104dbf <release>

  if(ff.type == FD_PIPE)
8010109b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010109e:	83 f8 01             	cmp    $0x1,%eax
801010a1:	75 18                	jne    801010bb <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
801010a3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801010a7:	0f be d0             	movsbl %al,%edx
801010aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801010ad:	89 54 24 04          	mov    %edx,0x4(%esp)
801010b1:	89 04 24             	mov    %eax,(%esp)
801010b4:	e8 4b 2d 00 00       	call   80103e04 <pipeclose>
801010b9:	eb 1d                	jmp    801010d8 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
801010bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010be:	83 f8 02             	cmp    $0x2,%eax
801010c1:	75 15                	jne    801010d8 <fileclose+0xd4>
    begin_op();
801010c3:	e8 96 23 00 00       	call   8010345e <begin_op>
    iput(ff.ip);
801010c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010cb:	89 04 24             	mov    %eax,(%esp)
801010ce:	e8 b2 09 00 00       	call   80101a85 <iput>
    end_op();
801010d3:	e8 0a 24 00 00       	call   801034e2 <end_op>
  }
}
801010d8:	c9                   	leave  
801010d9:	c3                   	ret    

801010da <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010da:	55                   	push   %ebp
801010db:	89 e5                	mov    %esp,%ebp
801010dd:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010e0:	8b 45 08             	mov    0x8(%ebp),%eax
801010e3:	8b 00                	mov    (%eax),%eax
801010e5:	83 f8 02             	cmp    $0x2,%eax
801010e8:	75 38                	jne    80101122 <filestat+0x48>
    ilock(f->ip);
801010ea:	8b 45 08             	mov    0x8(%ebp),%eax
801010ed:	8b 40 10             	mov    0x10(%eax),%eax
801010f0:	89 04 24             	mov    %eax,(%esp)
801010f3:	e8 3c 08 00 00       	call   80101934 <ilock>
    stati(f->ip, st);
801010f8:	8b 45 08             	mov    0x8(%ebp),%eax
801010fb:	8b 40 10             	mov    0x10(%eax),%eax
801010fe:	8b 55 0c             	mov    0xc(%ebp),%edx
80101101:	89 54 24 04          	mov    %edx,0x4(%esp)
80101105:	89 04 24             	mov    %eax,(%esp)
80101108:	e8 7f 0c 00 00       	call   80101d8c <stati>
    iunlock(f->ip);
8010110d:	8b 45 08             	mov    0x8(%ebp),%eax
80101110:	8b 40 10             	mov    0x10(%eax),%eax
80101113:	89 04 24             	mov    %eax,(%esp)
80101116:	e8 26 09 00 00       	call   80101a41 <iunlock>
    return 0;
8010111b:	b8 00 00 00 00       	mov    $0x0,%eax
80101120:	eb 05                	jmp    80101127 <filestat+0x4d>
  }
  return -1;
80101122:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101127:	c9                   	leave  
80101128:	c3                   	ret    

80101129 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101129:	55                   	push   %ebp
8010112a:	89 e5                	mov    %esp,%ebp
8010112c:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
8010112f:	8b 45 08             	mov    0x8(%ebp),%eax
80101132:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101136:	84 c0                	test   %al,%al
80101138:	75 0a                	jne    80101144 <fileread+0x1b>
    return -1;
8010113a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010113f:	e9 9f 00 00 00       	jmp    801011e3 <fileread+0xba>
  if(f->type == FD_PIPE)
80101144:	8b 45 08             	mov    0x8(%ebp),%eax
80101147:	8b 00                	mov    (%eax),%eax
80101149:	83 f8 01             	cmp    $0x1,%eax
8010114c:	75 1e                	jne    8010116c <fileread+0x43>
    return piperead(f->pipe, addr, n);
8010114e:	8b 45 08             	mov    0x8(%ebp),%eax
80101151:	8b 40 0c             	mov    0xc(%eax),%eax
80101154:	8b 55 10             	mov    0x10(%ebp),%edx
80101157:	89 54 24 08          	mov    %edx,0x8(%esp)
8010115b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010115e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101162:	89 04 24             	mov    %eax,(%esp)
80101165:	e8 1a 2e 00 00       	call   80103f84 <piperead>
8010116a:	eb 77                	jmp    801011e3 <fileread+0xba>
  if(f->type == FD_INODE){
8010116c:	8b 45 08             	mov    0x8(%ebp),%eax
8010116f:	8b 00                	mov    (%eax),%eax
80101171:	83 f8 02             	cmp    $0x2,%eax
80101174:	75 61                	jne    801011d7 <fileread+0xae>
    ilock(f->ip);
80101176:	8b 45 08             	mov    0x8(%ebp),%eax
80101179:	8b 40 10             	mov    0x10(%eax),%eax
8010117c:	89 04 24             	mov    %eax,(%esp)
8010117f:	e8 b0 07 00 00       	call   80101934 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101184:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101187:	8b 45 08             	mov    0x8(%ebp),%eax
8010118a:	8b 50 14             	mov    0x14(%eax),%edx
8010118d:	8b 45 08             	mov    0x8(%ebp),%eax
80101190:	8b 40 10             	mov    0x10(%eax),%eax
80101193:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101197:	89 54 24 08          	mov    %edx,0x8(%esp)
8010119b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010119e:	89 54 24 04          	mov    %edx,0x4(%esp)
801011a2:	89 04 24             	mov    %eax,(%esp)
801011a5:	e8 27 0c 00 00       	call   80101dd1 <readi>
801011aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
801011ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801011b1:	7e 11                	jle    801011c4 <fileread+0x9b>
      f->off += r;
801011b3:	8b 45 08             	mov    0x8(%ebp),%eax
801011b6:	8b 50 14             	mov    0x14(%eax),%edx
801011b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011bc:	01 c2                	add    %eax,%edx
801011be:	8b 45 08             	mov    0x8(%ebp),%eax
801011c1:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011c4:	8b 45 08             	mov    0x8(%ebp),%eax
801011c7:	8b 40 10             	mov    0x10(%eax),%eax
801011ca:	89 04 24             	mov    %eax,(%esp)
801011cd:	e8 6f 08 00 00       	call   80101a41 <iunlock>
    return r;
801011d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011d5:	eb 0c                	jmp    801011e3 <fileread+0xba>
  }
  panic("fileread");
801011d7:	c7 04 24 b3 83 10 80 	movl   $0x801083b3,(%esp)
801011de:	e8 7f f3 ff ff       	call   80100562 <panic>
}
801011e3:	c9                   	leave  
801011e4:	c3                   	ret    

801011e5 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011e5:	55                   	push   %ebp
801011e6:	89 e5                	mov    %esp,%ebp
801011e8:	53                   	push   %ebx
801011e9:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011ec:	8b 45 08             	mov    0x8(%ebp),%eax
801011ef:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011f3:	84 c0                	test   %al,%al
801011f5:	75 0a                	jne    80101201 <filewrite+0x1c>
    return -1;
801011f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011fc:	e9 20 01 00 00       	jmp    80101321 <filewrite+0x13c>
  if(f->type == FD_PIPE)
80101201:	8b 45 08             	mov    0x8(%ebp),%eax
80101204:	8b 00                	mov    (%eax),%eax
80101206:	83 f8 01             	cmp    $0x1,%eax
80101209:	75 21                	jne    8010122c <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
8010120b:	8b 45 08             	mov    0x8(%ebp),%eax
8010120e:	8b 40 0c             	mov    0xc(%eax),%eax
80101211:	8b 55 10             	mov    0x10(%ebp),%edx
80101214:	89 54 24 08          	mov    %edx,0x8(%esp)
80101218:	8b 55 0c             	mov    0xc(%ebp),%edx
8010121b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010121f:	89 04 24             	mov    %eax,(%esp)
80101222:	e8 6f 2c 00 00       	call   80103e96 <pipewrite>
80101227:	e9 f5 00 00 00       	jmp    80101321 <filewrite+0x13c>
  if(f->type == FD_INODE){
8010122c:	8b 45 08             	mov    0x8(%ebp),%eax
8010122f:	8b 00                	mov    (%eax),%eax
80101231:	83 f8 02             	cmp    $0x2,%eax
80101234:	0f 85 db 00 00 00    	jne    80101315 <filewrite+0x130>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
8010123a:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
80101241:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101248:	e9 a8 00 00 00       	jmp    801012f5 <filewrite+0x110>
      int n1 = n - i;
8010124d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101250:	8b 55 10             	mov    0x10(%ebp),%edx
80101253:	29 c2                	sub    %eax,%edx
80101255:	89 d0                	mov    %edx,%eax
80101257:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010125a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010125d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101260:	7e 06                	jle    80101268 <filewrite+0x83>
        n1 = max;
80101262:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101265:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101268:	e8 f1 21 00 00       	call   8010345e <begin_op>
      ilock(f->ip);
8010126d:	8b 45 08             	mov    0x8(%ebp),%eax
80101270:	8b 40 10             	mov    0x10(%eax),%eax
80101273:	89 04 24             	mov    %eax,(%esp)
80101276:	e8 b9 06 00 00       	call   80101934 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010127b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010127e:	8b 45 08             	mov    0x8(%ebp),%eax
80101281:	8b 50 14             	mov    0x14(%eax),%edx
80101284:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101287:	8b 45 0c             	mov    0xc(%ebp),%eax
8010128a:	01 c3                	add    %eax,%ebx
8010128c:	8b 45 08             	mov    0x8(%ebp),%eax
8010128f:	8b 40 10             	mov    0x10(%eax),%eax
80101292:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101296:	89 54 24 08          	mov    %edx,0x8(%esp)
8010129a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010129e:	89 04 24             	mov    %eax,(%esp)
801012a1:	e8 8f 0c 00 00       	call   80101f35 <writei>
801012a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
801012a9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012ad:	7e 11                	jle    801012c0 <filewrite+0xdb>
        f->off += r;
801012af:	8b 45 08             	mov    0x8(%ebp),%eax
801012b2:	8b 50 14             	mov    0x14(%eax),%edx
801012b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012b8:	01 c2                	add    %eax,%edx
801012ba:	8b 45 08             	mov    0x8(%ebp),%eax
801012bd:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012c0:	8b 45 08             	mov    0x8(%ebp),%eax
801012c3:	8b 40 10             	mov    0x10(%eax),%eax
801012c6:	89 04 24             	mov    %eax,(%esp)
801012c9:	e8 73 07 00 00       	call   80101a41 <iunlock>
      end_op();
801012ce:	e8 0f 22 00 00       	call   801034e2 <end_op>

      if(r < 0)
801012d3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012d7:	79 02                	jns    801012db <filewrite+0xf6>
        break;
801012d9:	eb 26                	jmp    80101301 <filewrite+0x11c>
      if(r != n1)
801012db:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012de:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012e1:	74 0c                	je     801012ef <filewrite+0x10a>
        panic("short filewrite");
801012e3:	c7 04 24 bc 83 10 80 	movl   $0x801083bc,(%esp)
801012ea:	e8 73 f2 ff ff       	call   80100562 <panic>
      i += r;
801012ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012f2:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
801012f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012f8:	3b 45 10             	cmp    0x10(%ebp),%eax
801012fb:	0f 8c 4c ff ff ff    	jl     8010124d <filewrite+0x68>
    }
    return i == n ? n : -1;
80101301:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101304:	3b 45 10             	cmp    0x10(%ebp),%eax
80101307:	75 05                	jne    8010130e <filewrite+0x129>
80101309:	8b 45 10             	mov    0x10(%ebp),%eax
8010130c:	eb 05                	jmp    80101313 <filewrite+0x12e>
8010130e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101313:	eb 0c                	jmp    80101321 <filewrite+0x13c>
  }
  panic("filewrite");
80101315:	c7 04 24 cc 83 10 80 	movl   $0x801083cc,(%esp)
8010131c:	e8 41 f2 ff ff       	call   80100562 <panic>
}
80101321:	83 c4 24             	add    $0x24,%esp
80101324:	5b                   	pop    %ebx
80101325:	5d                   	pop    %ebp
80101326:	c3                   	ret    

80101327 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101327:	55                   	push   %ebp
80101328:	89 e5                	mov    %esp,%ebp
8010132a:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, 1);
8010132d:	8b 45 08             	mov    0x8(%ebp),%eax
80101330:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101337:	00 
80101338:	89 04 24             	mov    %eax,(%esp)
8010133b:	e8 75 ee ff ff       	call   801001b5 <bread>
80101340:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101343:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101346:	83 c0 5c             	add    $0x5c,%eax
80101349:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101350:	00 
80101351:	89 44 24 04          	mov    %eax,0x4(%esp)
80101355:	8b 45 0c             	mov    0xc(%ebp),%eax
80101358:	89 04 24             	mov    %eax,(%esp)
8010135b:	e8 28 3d 00 00       	call   80105088 <memmove>
  brelse(bp);
80101360:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101363:	89 04 24             	mov    %eax,(%esp)
80101366:	e8 c1 ee ff ff       	call   8010022c <brelse>
}
8010136b:	c9                   	leave  
8010136c:	c3                   	ret    

8010136d <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010136d:	55                   	push   %ebp
8010136e:	89 e5                	mov    %esp,%ebp
80101370:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, bno);
80101373:	8b 55 0c             	mov    0xc(%ebp),%edx
80101376:	8b 45 08             	mov    0x8(%ebp),%eax
80101379:	89 54 24 04          	mov    %edx,0x4(%esp)
8010137d:	89 04 24             	mov    %eax,(%esp)
80101380:	e8 30 ee ff ff       	call   801001b5 <bread>
80101385:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101388:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010138b:	83 c0 5c             	add    $0x5c,%eax
8010138e:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101395:	00 
80101396:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010139d:	00 
8010139e:	89 04 24             	mov    %eax,(%esp)
801013a1:	e8 13 3c 00 00       	call   80104fb9 <memset>
  log_write(bp);
801013a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013a9:	89 04 24             	mov    %eax,(%esp)
801013ac:	e8 b8 22 00 00       	call   80103669 <log_write>
  brelse(bp);
801013b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013b4:	89 04 24             	mov    %eax,(%esp)
801013b7:	e8 70 ee ff ff       	call   8010022c <brelse>
}
801013bc:	c9                   	leave  
801013bd:	c3                   	ret    

801013be <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013be:	55                   	push   %ebp
801013bf:	89 e5                	mov    %esp,%ebp
801013c1:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801013c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801013cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013d2:	e9 07 01 00 00       	jmp    801014de <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
801013d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013da:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013e0:	85 c0                	test   %eax,%eax
801013e2:	0f 48 c2             	cmovs  %edx,%eax
801013e5:	c1 f8 0c             	sar    $0xc,%eax
801013e8:	89 c2                	mov    %eax,%edx
801013ea:	a1 58 1a 11 80       	mov    0x80111a58,%eax
801013ef:	01 d0                	add    %edx,%eax
801013f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801013f5:	8b 45 08             	mov    0x8(%ebp),%eax
801013f8:	89 04 24             	mov    %eax,(%esp)
801013fb:	e8 b5 ed ff ff       	call   801001b5 <bread>
80101400:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101403:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010140a:	e9 9d 00 00 00       	jmp    801014ac <balloc+0xee>
      m = 1 << (bi % 8);
8010140f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101412:	99                   	cltd   
80101413:	c1 ea 1d             	shr    $0x1d,%edx
80101416:	01 d0                	add    %edx,%eax
80101418:	83 e0 07             	and    $0x7,%eax
8010141b:	29 d0                	sub    %edx,%eax
8010141d:	ba 01 00 00 00       	mov    $0x1,%edx
80101422:	89 c1                	mov    %eax,%ecx
80101424:	d3 e2                	shl    %cl,%edx
80101426:	89 d0                	mov    %edx,%eax
80101428:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010142b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010142e:	8d 50 07             	lea    0x7(%eax),%edx
80101431:	85 c0                	test   %eax,%eax
80101433:	0f 48 c2             	cmovs  %edx,%eax
80101436:	c1 f8 03             	sar    $0x3,%eax
80101439:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010143c:	0f b6 44 02 5c       	movzbl 0x5c(%edx,%eax,1),%eax
80101441:	0f b6 c0             	movzbl %al,%eax
80101444:	23 45 e8             	and    -0x18(%ebp),%eax
80101447:	85 c0                	test   %eax,%eax
80101449:	75 5d                	jne    801014a8 <balloc+0xea>
        bp->data[bi/8] |= m;  // Mark block in use.
8010144b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010144e:	8d 50 07             	lea    0x7(%eax),%edx
80101451:	85 c0                	test   %eax,%eax
80101453:	0f 48 c2             	cmovs  %edx,%eax
80101456:	c1 f8 03             	sar    $0x3,%eax
80101459:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010145c:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
80101461:	89 d1                	mov    %edx,%ecx
80101463:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101466:	09 ca                	or     %ecx,%edx
80101468:	89 d1                	mov    %edx,%ecx
8010146a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010146d:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
80101471:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101474:	89 04 24             	mov    %eax,(%esp)
80101477:	e8 ed 21 00 00       	call   80103669 <log_write>
        brelse(bp);
8010147c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010147f:	89 04 24             	mov    %eax,(%esp)
80101482:	e8 a5 ed ff ff       	call   8010022c <brelse>
        bzero(dev, b + bi);
80101487:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010148a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010148d:	01 c2                	add    %eax,%edx
8010148f:	8b 45 08             	mov    0x8(%ebp),%eax
80101492:	89 54 24 04          	mov    %edx,0x4(%esp)
80101496:	89 04 24             	mov    %eax,(%esp)
80101499:	e8 cf fe ff ff       	call   8010136d <bzero>
        return b + bi;
8010149e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014a4:	01 d0                	add    %edx,%eax
801014a6:	eb 52                	jmp    801014fa <balloc+0x13c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014a8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801014ac:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014b3:	7f 17                	jg     801014cc <balloc+0x10e>
801014b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014bb:	01 d0                	add    %edx,%eax
801014bd:	89 c2                	mov    %eax,%edx
801014bf:	a1 40 1a 11 80       	mov    0x80111a40,%eax
801014c4:	39 c2                	cmp    %eax,%edx
801014c6:	0f 82 43 ff ff ff    	jb     8010140f <balloc+0x51>
      }
    }
    brelse(bp);
801014cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014cf:	89 04 24             	mov    %eax,(%esp)
801014d2:	e8 55 ed ff ff       	call   8010022c <brelse>
  for(b = 0; b < sb.size; b += BPB){
801014d7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801014de:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014e1:	a1 40 1a 11 80       	mov    0x80111a40,%eax
801014e6:	39 c2                	cmp    %eax,%edx
801014e8:	0f 82 e9 fe ff ff    	jb     801013d7 <balloc+0x19>
  }
  panic("balloc: out of blocks");
801014ee:	c7 04 24 d8 83 10 80 	movl   $0x801083d8,(%esp)
801014f5:	e8 68 f0 ff ff       	call   80100562 <panic>
}
801014fa:	c9                   	leave  
801014fb:	c3                   	ret    

801014fc <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014fc:	55                   	push   %ebp
801014fd:	89 e5                	mov    %esp,%ebp
801014ff:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101502:	c7 44 24 04 40 1a 11 	movl   $0x80111a40,0x4(%esp)
80101509:	80 
8010150a:	8b 45 08             	mov    0x8(%ebp),%eax
8010150d:	89 04 24             	mov    %eax,(%esp)
80101510:	e8 12 fe ff ff       	call   80101327 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101515:	8b 45 0c             	mov    0xc(%ebp),%eax
80101518:	c1 e8 0c             	shr    $0xc,%eax
8010151b:	89 c2                	mov    %eax,%edx
8010151d:	a1 58 1a 11 80       	mov    0x80111a58,%eax
80101522:	01 c2                	add    %eax,%edx
80101524:	8b 45 08             	mov    0x8(%ebp),%eax
80101527:	89 54 24 04          	mov    %edx,0x4(%esp)
8010152b:	89 04 24             	mov    %eax,(%esp)
8010152e:	e8 82 ec ff ff       	call   801001b5 <bread>
80101533:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101536:	8b 45 0c             	mov    0xc(%ebp),%eax
80101539:	25 ff 0f 00 00       	and    $0xfff,%eax
8010153e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101541:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101544:	99                   	cltd   
80101545:	c1 ea 1d             	shr    $0x1d,%edx
80101548:	01 d0                	add    %edx,%eax
8010154a:	83 e0 07             	and    $0x7,%eax
8010154d:	29 d0                	sub    %edx,%eax
8010154f:	ba 01 00 00 00       	mov    $0x1,%edx
80101554:	89 c1                	mov    %eax,%ecx
80101556:	d3 e2                	shl    %cl,%edx
80101558:	89 d0                	mov    %edx,%eax
8010155a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010155d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101560:	8d 50 07             	lea    0x7(%eax),%edx
80101563:	85 c0                	test   %eax,%eax
80101565:	0f 48 c2             	cmovs  %edx,%eax
80101568:	c1 f8 03             	sar    $0x3,%eax
8010156b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010156e:	0f b6 44 02 5c       	movzbl 0x5c(%edx,%eax,1),%eax
80101573:	0f b6 c0             	movzbl %al,%eax
80101576:	23 45 ec             	and    -0x14(%ebp),%eax
80101579:	85 c0                	test   %eax,%eax
8010157b:	75 0c                	jne    80101589 <bfree+0x8d>
    panic("freeing free block");
8010157d:	c7 04 24 ee 83 10 80 	movl   $0x801083ee,(%esp)
80101584:	e8 d9 ef ff ff       	call   80100562 <panic>
  bp->data[bi/8] &= ~m;
80101589:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010158c:	8d 50 07             	lea    0x7(%eax),%edx
8010158f:	85 c0                	test   %eax,%eax
80101591:	0f 48 c2             	cmovs  %edx,%eax
80101594:	c1 f8 03             	sar    $0x3,%eax
80101597:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010159a:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
8010159f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801015a2:	f7 d1                	not    %ecx
801015a4:	21 ca                	and    %ecx,%edx
801015a6:	89 d1                	mov    %edx,%ecx
801015a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015ab:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
801015af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015b2:	89 04 24             	mov    %eax,(%esp)
801015b5:	e8 af 20 00 00       	call   80103669 <log_write>
  brelse(bp);
801015ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015bd:	89 04 24             	mov    %eax,(%esp)
801015c0:	e8 67 ec ff ff       	call   8010022c <brelse>
}
801015c5:	c9                   	leave  
801015c6:	c3                   	ret    

801015c7 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801015c7:	55                   	push   %ebp
801015c8:	89 e5                	mov    %esp,%ebp
801015ca:	57                   	push   %edi
801015cb:	56                   	push   %esi
801015cc:	53                   	push   %ebx
801015cd:	83 ec 4c             	sub    $0x4c,%esp
  int i = 0;
801015d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
801015d7:	c7 44 24 04 01 84 10 	movl   $0x80108401,0x4(%esp)
801015de:	80 
801015df:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
801015e6:	e8 4b 37 00 00       	call   80104d36 <initlock>
  for(i = 0; i < NINODE; i++) {
801015eb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801015f2:	eb 2c                	jmp    80101620 <iinit+0x59>
    initsleeplock(&icache.inode[i].lock, "inode");
801015f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015f7:	89 d0                	mov    %edx,%eax
801015f9:	c1 e0 03             	shl    $0x3,%eax
801015fc:	01 d0                	add    %edx,%eax
801015fe:	c1 e0 04             	shl    $0x4,%eax
80101601:	83 c0 30             	add    $0x30,%eax
80101604:	05 60 1a 11 80       	add    $0x80111a60,%eax
80101609:	83 c0 10             	add    $0x10,%eax
8010160c:	c7 44 24 04 08 84 10 	movl   $0x80108408,0x4(%esp)
80101613:	80 
80101614:	89 04 24             	mov    %eax,(%esp)
80101617:	e8 de 35 00 00       	call   80104bfa <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010161c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80101620:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
80101624:	7e ce                	jle    801015f4 <iinit+0x2d>
  }

  readsb(dev, &sb);
80101626:	c7 44 24 04 40 1a 11 	movl   $0x80111a40,0x4(%esp)
8010162d:	80 
8010162e:	8b 45 08             	mov    0x8(%ebp),%eax
80101631:	89 04 24             	mov    %eax,(%esp)
80101634:	e8 ee fc ff ff       	call   80101327 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101639:	a1 58 1a 11 80       	mov    0x80111a58,%eax
8010163e:	8b 3d 54 1a 11 80    	mov    0x80111a54,%edi
80101644:	8b 35 50 1a 11 80    	mov    0x80111a50,%esi
8010164a:	8b 1d 4c 1a 11 80    	mov    0x80111a4c,%ebx
80101650:	8b 0d 48 1a 11 80    	mov    0x80111a48,%ecx
80101656:	8b 15 44 1a 11 80    	mov    0x80111a44,%edx
8010165c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010165f:	8b 15 40 1a 11 80    	mov    0x80111a40,%edx
80101665:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101669:	89 7c 24 18          	mov    %edi,0x18(%esp)
8010166d:	89 74 24 14          	mov    %esi,0x14(%esp)
80101671:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80101675:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101679:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010167c:	89 44 24 08          	mov    %eax,0x8(%esp)
80101680:	89 d0                	mov    %edx,%eax
80101682:	89 44 24 04          	mov    %eax,0x4(%esp)
80101686:	c7 04 24 10 84 10 80 	movl   $0x80108410,(%esp)
8010168d:	e8 36 ed ff ff       	call   801003c8 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101692:	83 c4 4c             	add    $0x4c,%esp
80101695:	5b                   	pop    %ebx
80101696:	5e                   	pop    %esi
80101697:	5f                   	pop    %edi
80101698:	5d                   	pop    %ebp
80101699:	c3                   	ret    

8010169a <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
8010169a:	55                   	push   %ebp
8010169b:	89 e5                	mov    %esp,%ebp
8010169d:	83 ec 28             	sub    $0x28,%esp
801016a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801016a3:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801016a7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801016ae:	e9 9e 00 00 00       	jmp    80101751 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
801016b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016b6:	c1 e8 03             	shr    $0x3,%eax
801016b9:	89 c2                	mov    %eax,%edx
801016bb:	a1 54 1a 11 80       	mov    0x80111a54,%eax
801016c0:	01 d0                	add    %edx,%eax
801016c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801016c6:	8b 45 08             	mov    0x8(%ebp),%eax
801016c9:	89 04 24             	mov    %eax,(%esp)
801016cc:	e8 e4 ea ff ff       	call   801001b5 <bread>
801016d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801016d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016d7:	8d 50 5c             	lea    0x5c(%eax),%edx
801016da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016dd:	83 e0 07             	and    $0x7,%eax
801016e0:	c1 e0 06             	shl    $0x6,%eax
801016e3:	01 d0                	add    %edx,%eax
801016e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801016e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801016eb:	0f b7 00             	movzwl (%eax),%eax
801016ee:	66 85 c0             	test   %ax,%ax
801016f1:	75 4f                	jne    80101742 <ialloc+0xa8>
      memset(dip, 0, sizeof(*dip));
801016f3:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801016fa:	00 
801016fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101702:	00 
80101703:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101706:	89 04 24             	mov    %eax,(%esp)
80101709:	e8 ab 38 00 00       	call   80104fb9 <memset>
      dip->type = type;
8010170e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101711:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
80101715:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101718:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010171b:	89 04 24             	mov    %eax,(%esp)
8010171e:	e8 46 1f 00 00       	call   80103669 <log_write>
      brelse(bp);
80101723:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101726:	89 04 24             	mov    %eax,(%esp)
80101729:	e8 fe ea ff ff       	call   8010022c <brelse>
      return iget(dev, inum);
8010172e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101731:	89 44 24 04          	mov    %eax,0x4(%esp)
80101735:	8b 45 08             	mov    0x8(%ebp),%eax
80101738:	89 04 24             	mov    %eax,(%esp)
8010173b:	e8 ed 00 00 00       	call   8010182d <iget>
80101740:	eb 2b                	jmp    8010176d <ialloc+0xd3>
    }
    brelse(bp);
80101742:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101745:	89 04 24             	mov    %eax,(%esp)
80101748:	e8 df ea ff ff       	call   8010022c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010174d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101751:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101754:	a1 48 1a 11 80       	mov    0x80111a48,%eax
80101759:	39 c2                	cmp    %eax,%edx
8010175b:	0f 82 52 ff ff ff    	jb     801016b3 <ialloc+0x19>
  }
  panic("ialloc: no inodes");
80101761:	c7 04 24 63 84 10 80 	movl   $0x80108463,(%esp)
80101768:	e8 f5 ed ff ff       	call   80100562 <panic>
}
8010176d:	c9                   	leave  
8010176e:	c3                   	ret    

8010176f <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
8010176f:	55                   	push   %ebp
80101770:	89 e5                	mov    %esp,%ebp
80101772:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101775:	8b 45 08             	mov    0x8(%ebp),%eax
80101778:	8b 40 04             	mov    0x4(%eax),%eax
8010177b:	c1 e8 03             	shr    $0x3,%eax
8010177e:	89 c2                	mov    %eax,%edx
80101780:	a1 54 1a 11 80       	mov    0x80111a54,%eax
80101785:	01 c2                	add    %eax,%edx
80101787:	8b 45 08             	mov    0x8(%ebp),%eax
8010178a:	8b 00                	mov    (%eax),%eax
8010178c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101790:	89 04 24             	mov    %eax,(%esp)
80101793:	e8 1d ea ff ff       	call   801001b5 <bread>
80101798:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010179b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010179e:	8d 50 5c             	lea    0x5c(%eax),%edx
801017a1:	8b 45 08             	mov    0x8(%ebp),%eax
801017a4:	8b 40 04             	mov    0x4(%eax),%eax
801017a7:	83 e0 07             	and    $0x7,%eax
801017aa:	c1 e0 06             	shl    $0x6,%eax
801017ad:	01 d0                	add    %edx,%eax
801017af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801017b2:	8b 45 08             	mov    0x8(%ebp),%eax
801017b5:	0f b7 50 50          	movzwl 0x50(%eax),%edx
801017b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017bc:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801017bf:	8b 45 08             	mov    0x8(%ebp),%eax
801017c2:	0f b7 50 52          	movzwl 0x52(%eax),%edx
801017c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017c9:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801017cd:	8b 45 08             	mov    0x8(%ebp),%eax
801017d0:	0f b7 50 54          	movzwl 0x54(%eax),%edx
801017d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017d7:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801017db:	8b 45 08             	mov    0x8(%ebp),%eax
801017de:	0f b7 50 56          	movzwl 0x56(%eax),%edx
801017e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017e5:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801017e9:	8b 45 08             	mov    0x8(%ebp),%eax
801017ec:	8b 50 58             	mov    0x58(%eax),%edx
801017ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017f2:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017f5:	8b 45 08             	mov    0x8(%ebp),%eax
801017f8:	8d 50 5c             	lea    0x5c(%eax),%edx
801017fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017fe:	83 c0 0c             	add    $0xc,%eax
80101801:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101808:	00 
80101809:	89 54 24 04          	mov    %edx,0x4(%esp)
8010180d:	89 04 24             	mov    %eax,(%esp)
80101810:	e8 73 38 00 00       	call   80105088 <memmove>
  log_write(bp);
80101815:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101818:	89 04 24             	mov    %eax,(%esp)
8010181b:	e8 49 1e 00 00       	call   80103669 <log_write>
  brelse(bp);
80101820:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101823:	89 04 24             	mov    %eax,(%esp)
80101826:	e8 01 ea ff ff       	call   8010022c <brelse>
}
8010182b:	c9                   	leave  
8010182c:	c3                   	ret    

8010182d <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010182d:	55                   	push   %ebp
8010182e:	89 e5                	mov    %esp,%ebp
80101830:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101833:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
8010183a:	e8 18 35 00 00       	call   80104d57 <acquire>

  // Is the inode already cached?
  empty = 0;
8010183f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101846:	c7 45 f4 94 1a 11 80 	movl   $0x80111a94,-0xc(%ebp)
8010184d:	eb 5c                	jmp    801018ab <iget+0x7e>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010184f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101852:	8b 40 08             	mov    0x8(%eax),%eax
80101855:	85 c0                	test   %eax,%eax
80101857:	7e 35                	jle    8010188e <iget+0x61>
80101859:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010185c:	8b 00                	mov    (%eax),%eax
8010185e:	3b 45 08             	cmp    0x8(%ebp),%eax
80101861:	75 2b                	jne    8010188e <iget+0x61>
80101863:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101866:	8b 40 04             	mov    0x4(%eax),%eax
80101869:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010186c:	75 20                	jne    8010188e <iget+0x61>
      ip->ref++;
8010186e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101871:	8b 40 08             	mov    0x8(%eax),%eax
80101874:	8d 50 01             	lea    0x1(%eax),%edx
80101877:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010187a:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
8010187d:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
80101884:	e8 36 35 00 00       	call   80104dbf <release>
      return ip;
80101889:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010188c:	eb 72                	jmp    80101900 <iget+0xd3>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010188e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101892:	75 10                	jne    801018a4 <iget+0x77>
80101894:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101897:	8b 40 08             	mov    0x8(%eax),%eax
8010189a:	85 c0                	test   %eax,%eax
8010189c:	75 06                	jne    801018a4 <iget+0x77>
      empty = ip;
8010189e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018a4:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
801018ab:	81 7d f4 b4 36 11 80 	cmpl   $0x801136b4,-0xc(%ebp)
801018b2:	72 9b                	jb     8010184f <iget+0x22>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801018b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018b8:	75 0c                	jne    801018c6 <iget+0x99>
    panic("iget: no inodes");
801018ba:	c7 04 24 75 84 10 80 	movl   $0x80108475,(%esp)
801018c1:	e8 9c ec ff ff       	call   80100562 <panic>

  ip = empty;
801018c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801018cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018cf:	8b 55 08             	mov    0x8(%ebp),%edx
801018d2:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801018d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018d7:	8b 55 0c             	mov    0xc(%ebp),%edx
801018da:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801018dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018e0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
801018e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ea:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
801018f1:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
801018f8:	e8 c2 34 00 00       	call   80104dbf <release>

  return ip;
801018fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101900:	c9                   	leave  
80101901:	c3                   	ret    

80101902 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101902:	55                   	push   %ebp
80101903:	89 e5                	mov    %esp,%ebp
80101905:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101908:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
8010190f:	e8 43 34 00 00       	call   80104d57 <acquire>
  ip->ref++;
80101914:	8b 45 08             	mov    0x8(%ebp),%eax
80101917:	8b 40 08             	mov    0x8(%eax),%eax
8010191a:	8d 50 01             	lea    0x1(%eax),%edx
8010191d:	8b 45 08             	mov    0x8(%ebp),%eax
80101920:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101923:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
8010192a:	e8 90 34 00 00       	call   80104dbf <release>
  return ip;
8010192f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101932:	c9                   	leave  
80101933:	c3                   	ret    

80101934 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101934:	55                   	push   %ebp
80101935:	89 e5                	mov    %esp,%ebp
80101937:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
8010193a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010193e:	74 0a                	je     8010194a <ilock+0x16>
80101940:	8b 45 08             	mov    0x8(%ebp),%eax
80101943:	8b 40 08             	mov    0x8(%eax),%eax
80101946:	85 c0                	test   %eax,%eax
80101948:	7f 0c                	jg     80101956 <ilock+0x22>
    panic("ilock");
8010194a:	c7 04 24 85 84 10 80 	movl   $0x80108485,(%esp)
80101951:	e8 0c ec ff ff       	call   80100562 <panic>

  acquiresleep(&ip->lock);
80101956:	8b 45 08             	mov    0x8(%ebp),%eax
80101959:	83 c0 0c             	add    $0xc,%eax
8010195c:	89 04 24             	mov    %eax,(%esp)
8010195f:	e8 d0 32 00 00       	call   80104c34 <acquiresleep>

  if(ip->valid == 0){
80101964:	8b 45 08             	mov    0x8(%ebp),%eax
80101967:	8b 40 4c             	mov    0x4c(%eax),%eax
8010196a:	85 c0                	test   %eax,%eax
8010196c:	0f 85 cd 00 00 00    	jne    80101a3f <ilock+0x10b>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101972:	8b 45 08             	mov    0x8(%ebp),%eax
80101975:	8b 40 04             	mov    0x4(%eax),%eax
80101978:	c1 e8 03             	shr    $0x3,%eax
8010197b:	89 c2                	mov    %eax,%edx
8010197d:	a1 54 1a 11 80       	mov    0x80111a54,%eax
80101982:	01 c2                	add    %eax,%edx
80101984:	8b 45 08             	mov    0x8(%ebp),%eax
80101987:	8b 00                	mov    (%eax),%eax
80101989:	89 54 24 04          	mov    %edx,0x4(%esp)
8010198d:	89 04 24             	mov    %eax,(%esp)
80101990:	e8 20 e8 ff ff       	call   801001b5 <bread>
80101995:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101998:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010199b:	8d 50 5c             	lea    0x5c(%eax),%edx
8010199e:	8b 45 08             	mov    0x8(%ebp),%eax
801019a1:	8b 40 04             	mov    0x4(%eax),%eax
801019a4:	83 e0 07             	and    $0x7,%eax
801019a7:	c1 e0 06             	shl    $0x6,%eax
801019aa:	01 d0                	add    %edx,%eax
801019ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
801019af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019b2:	0f b7 10             	movzwl (%eax),%edx
801019b5:	8b 45 08             	mov    0x8(%ebp),%eax
801019b8:	66 89 50 50          	mov    %dx,0x50(%eax)
    ip->major = dip->major;
801019bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019bf:	0f b7 50 02          	movzwl 0x2(%eax),%edx
801019c3:	8b 45 08             	mov    0x8(%ebp),%eax
801019c6:	66 89 50 52          	mov    %dx,0x52(%eax)
    ip->minor = dip->minor;
801019ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019cd:	0f b7 50 04          	movzwl 0x4(%eax),%edx
801019d1:	8b 45 08             	mov    0x8(%ebp),%eax
801019d4:	66 89 50 54          	mov    %dx,0x54(%eax)
    ip->nlink = dip->nlink;
801019d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019db:	0f b7 50 06          	movzwl 0x6(%eax),%edx
801019df:	8b 45 08             	mov    0x8(%ebp),%eax
801019e2:	66 89 50 56          	mov    %dx,0x56(%eax)
    ip->size = dip->size;
801019e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019e9:	8b 50 08             	mov    0x8(%eax),%edx
801019ec:	8b 45 08             	mov    0x8(%ebp),%eax
801019ef:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019f5:	8d 50 0c             	lea    0xc(%eax),%edx
801019f8:	8b 45 08             	mov    0x8(%ebp),%eax
801019fb:	83 c0 5c             	add    $0x5c,%eax
801019fe:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101a05:	00 
80101a06:	89 54 24 04          	mov    %edx,0x4(%esp)
80101a0a:	89 04 24             	mov    %eax,(%esp)
80101a0d:	e8 76 36 00 00       	call   80105088 <memmove>
    brelse(bp);
80101a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a15:	89 04 24             	mov    %eax,(%esp)
80101a18:	e8 0f e8 ff ff       	call   8010022c <brelse>
    ip->valid = 1;
80101a1d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a20:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101a27:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2a:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101a2e:	66 85 c0             	test   %ax,%ax
80101a31:	75 0c                	jne    80101a3f <ilock+0x10b>
      panic("ilock: no type");
80101a33:	c7 04 24 8b 84 10 80 	movl   $0x8010848b,(%esp)
80101a3a:	e8 23 eb ff ff       	call   80100562 <panic>
  }
}
80101a3f:	c9                   	leave  
80101a40:	c3                   	ret    

80101a41 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a41:	55                   	push   %ebp
80101a42:	89 e5                	mov    %esp,%ebp
80101a44:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a4b:	74 1c                	je     80101a69 <iunlock+0x28>
80101a4d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a50:	83 c0 0c             	add    $0xc,%eax
80101a53:	89 04 24             	mov    %eax,(%esp)
80101a56:	e8 76 32 00 00       	call   80104cd1 <holdingsleep>
80101a5b:	85 c0                	test   %eax,%eax
80101a5d:	74 0a                	je     80101a69 <iunlock+0x28>
80101a5f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a62:	8b 40 08             	mov    0x8(%eax),%eax
80101a65:	85 c0                	test   %eax,%eax
80101a67:	7f 0c                	jg     80101a75 <iunlock+0x34>
    panic("iunlock");
80101a69:	c7 04 24 9a 84 10 80 	movl   $0x8010849a,(%esp)
80101a70:	e8 ed ea ff ff       	call   80100562 <panic>

  releasesleep(&ip->lock);
80101a75:	8b 45 08             	mov    0x8(%ebp),%eax
80101a78:	83 c0 0c             	add    $0xc,%eax
80101a7b:	89 04 24             	mov    %eax,(%esp)
80101a7e:	e8 0c 32 00 00       	call   80104c8f <releasesleep>
}
80101a83:	c9                   	leave  
80101a84:	c3                   	ret    

80101a85 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101a85:	55                   	push   %ebp
80101a86:	89 e5                	mov    %esp,%ebp
80101a88:	83 ec 28             	sub    $0x28,%esp
  acquiresleep(&ip->lock);
80101a8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8e:	83 c0 0c             	add    $0xc,%eax
80101a91:	89 04 24             	mov    %eax,(%esp)
80101a94:	e8 9b 31 00 00       	call   80104c34 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101a99:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9c:	8b 40 4c             	mov    0x4c(%eax),%eax
80101a9f:	85 c0                	test   %eax,%eax
80101aa1:	74 5c                	je     80101aff <iput+0x7a>
80101aa3:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa6:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80101aaa:	66 85 c0             	test   %ax,%ax
80101aad:	75 50                	jne    80101aff <iput+0x7a>
    acquire(&icache.lock);
80101aaf:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
80101ab6:	e8 9c 32 00 00       	call   80104d57 <acquire>
    int r = ip->ref;
80101abb:	8b 45 08             	mov    0x8(%ebp),%eax
80101abe:	8b 40 08             	mov    0x8(%eax),%eax
80101ac1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101ac4:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
80101acb:	e8 ef 32 00 00       	call   80104dbf <release>
    if(r == 1){
80101ad0:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101ad4:	75 29                	jne    80101aff <iput+0x7a>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101ad6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad9:	89 04 24             	mov    %eax,(%esp)
80101adc:	e8 86 01 00 00       	call   80101c67 <itrunc>
      ip->type = 0;
80101ae1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae4:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101aea:	8b 45 08             	mov    0x8(%ebp),%eax
80101aed:	89 04 24             	mov    %eax,(%esp)
80101af0:	e8 7a fc ff ff       	call   8010176f <iupdate>
      ip->valid = 0;
80101af5:	8b 45 08             	mov    0x8(%ebp),%eax
80101af8:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101aff:	8b 45 08             	mov    0x8(%ebp),%eax
80101b02:	83 c0 0c             	add    $0xc,%eax
80101b05:	89 04 24             	mov    %eax,(%esp)
80101b08:	e8 82 31 00 00       	call   80104c8f <releasesleep>

  acquire(&icache.lock);
80101b0d:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
80101b14:	e8 3e 32 00 00       	call   80104d57 <acquire>
  ip->ref--;
80101b19:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1c:	8b 40 08             	mov    0x8(%eax),%eax
80101b1f:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b22:	8b 45 08             	mov    0x8(%ebp),%eax
80101b25:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b28:	c7 04 24 60 1a 11 80 	movl   $0x80111a60,(%esp)
80101b2f:	e8 8b 32 00 00       	call   80104dbf <release>
}
80101b34:	c9                   	leave  
80101b35:	c3                   	ret    

80101b36 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b36:	55                   	push   %ebp
80101b37:	89 e5                	mov    %esp,%ebp
80101b39:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101b3c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3f:	89 04 24             	mov    %eax,(%esp)
80101b42:	e8 fa fe ff ff       	call   80101a41 <iunlock>
  iput(ip);
80101b47:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4a:	89 04 24             	mov    %eax,(%esp)
80101b4d:	e8 33 ff ff ff       	call   80101a85 <iput>
}
80101b52:	c9                   	leave  
80101b53:	c3                   	ret    

80101b54 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b54:	55                   	push   %ebp
80101b55:	89 e5                	mov    %esp,%ebp
80101b57:	53                   	push   %ebx
80101b58:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b5b:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b5f:	77 3e                	ja     80101b9f <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b61:	8b 45 08             	mov    0x8(%ebp),%eax
80101b64:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b67:	83 c2 14             	add    $0x14,%edx
80101b6a:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b75:	75 20                	jne    80101b97 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b77:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7a:	8b 00                	mov    (%eax),%eax
80101b7c:	89 04 24             	mov    %eax,(%esp)
80101b7f:	e8 3a f8 ff ff       	call   801013be <balloc>
80101b84:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b87:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8a:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b8d:	8d 4a 14             	lea    0x14(%edx),%ecx
80101b90:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b93:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b9a:	e9 c2 00 00 00       	jmp    80101c61 <bmap+0x10d>
  }
  bn -= NDIRECT;
80101b9f:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101ba3:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101ba7:	0f 87 a8 00 00 00    	ja     80101c55 <bmap+0x101>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101bad:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101bb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bbd:	75 1c                	jne    80101bdb <bmap+0x87>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101bbf:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc2:	8b 00                	mov    (%eax),%eax
80101bc4:	89 04 24             	mov    %eax,(%esp)
80101bc7:	e8 f2 f7 ff ff       	call   801013be <balloc>
80101bcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bcf:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bd5:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101bdb:	8b 45 08             	mov    0x8(%ebp),%eax
80101bde:	8b 00                	mov    (%eax),%eax
80101be0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101be3:	89 54 24 04          	mov    %edx,0x4(%esp)
80101be7:	89 04 24             	mov    %eax,(%esp)
80101bea:	e8 c6 e5 ff ff       	call   801001b5 <bread>
80101bef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bf5:	83 c0 5c             	add    $0x5c,%eax
80101bf8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bfe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c05:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c08:	01 d0                	add    %edx,%eax
80101c0a:	8b 00                	mov    (%eax),%eax
80101c0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c13:	75 30                	jne    80101c45 <bmap+0xf1>
      a[bn] = addr = balloc(ip->dev);
80101c15:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c22:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101c25:	8b 45 08             	mov    0x8(%ebp),%eax
80101c28:	8b 00                	mov    (%eax),%eax
80101c2a:	89 04 24             	mov    %eax,(%esp)
80101c2d:	e8 8c f7 ff ff       	call   801013be <balloc>
80101c32:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c38:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101c3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c3d:	89 04 24             	mov    %eax,(%esp)
80101c40:	e8 24 1a 00 00       	call   80103669 <log_write>
    }
    brelse(bp);
80101c45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c48:	89 04 24             	mov    %eax,(%esp)
80101c4b:	e8 dc e5 ff ff       	call   8010022c <brelse>
    return addr;
80101c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c53:	eb 0c                	jmp    80101c61 <bmap+0x10d>
  }

  panic("bmap: out of range");
80101c55:	c7 04 24 a2 84 10 80 	movl   $0x801084a2,(%esp)
80101c5c:	e8 01 e9 ff ff       	call   80100562 <panic>
}
80101c61:	83 c4 24             	add    $0x24,%esp
80101c64:	5b                   	pop    %ebx
80101c65:	5d                   	pop    %ebp
80101c66:	c3                   	ret    

80101c67 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c67:	55                   	push   %ebp
80101c68:	89 e5                	mov    %esp,%ebp
80101c6a:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c74:	eb 44                	jmp    80101cba <itrunc+0x53>
    if(ip->addrs[i]){
80101c76:	8b 45 08             	mov    0x8(%ebp),%eax
80101c79:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c7c:	83 c2 14             	add    $0x14,%edx
80101c7f:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c83:	85 c0                	test   %eax,%eax
80101c85:	74 2f                	je     80101cb6 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c87:	8b 45 08             	mov    0x8(%ebp),%eax
80101c8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c8d:	83 c2 14             	add    $0x14,%edx
80101c90:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c94:	8b 45 08             	mov    0x8(%ebp),%eax
80101c97:	8b 00                	mov    (%eax),%eax
80101c99:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c9d:	89 04 24             	mov    %eax,(%esp)
80101ca0:	e8 57 f8 ff ff       	call   801014fc <bfree>
      ip->addrs[i] = 0;
80101ca5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cab:	83 c2 14             	add    $0x14,%edx
80101cae:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101cb5:	00 
  for(i = 0; i < NDIRECT; i++){
80101cb6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101cba:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101cbe:	7e b6                	jle    80101c76 <itrunc+0xf>
    }
  }

  if(ip->addrs[NDIRECT]){
80101cc0:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc3:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101cc9:	85 c0                	test   %eax,%eax
80101ccb:	0f 84 a4 00 00 00    	je     80101d75 <itrunc+0x10e>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101cd1:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd4:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101cda:	8b 45 08             	mov    0x8(%ebp),%eax
80101cdd:	8b 00                	mov    (%eax),%eax
80101cdf:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ce3:	89 04 24             	mov    %eax,(%esp)
80101ce6:	e8 ca e4 ff ff       	call   801001b5 <bread>
80101ceb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101cee:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cf1:	83 c0 5c             	add    $0x5c,%eax
80101cf4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101cf7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101cfe:	eb 3b                	jmp    80101d3b <itrunc+0xd4>
      if(a[j])
80101d00:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d03:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d0d:	01 d0                	add    %edx,%eax
80101d0f:	8b 00                	mov    (%eax),%eax
80101d11:	85 c0                	test   %eax,%eax
80101d13:	74 22                	je     80101d37 <itrunc+0xd0>
        bfree(ip->dev, a[j]);
80101d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d22:	01 d0                	add    %edx,%eax
80101d24:	8b 10                	mov    (%eax),%edx
80101d26:	8b 45 08             	mov    0x8(%ebp),%eax
80101d29:	8b 00                	mov    (%eax),%eax
80101d2b:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d2f:	89 04 24             	mov    %eax,(%esp)
80101d32:	e8 c5 f7 ff ff       	call   801014fc <bfree>
    for(j = 0; j < NINDIRECT; j++){
80101d37:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d3e:	83 f8 7f             	cmp    $0x7f,%eax
80101d41:	76 bd                	jbe    80101d00 <itrunc+0x99>
    }
    brelse(bp);
80101d43:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d46:	89 04 24             	mov    %eax,(%esp)
80101d49:	e8 de e4 ff ff       	call   8010022c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d51:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101d57:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5a:	8b 00                	mov    (%eax),%eax
80101d5c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d60:	89 04 24             	mov    %eax,(%esp)
80101d63:	e8 94 f7 ff ff       	call   801014fc <bfree>
    ip->addrs[NDIRECT] = 0;
80101d68:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6b:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101d72:	00 00 00 
  }

  ip->size = 0;
80101d75:	8b 45 08             	mov    0x8(%ebp),%eax
80101d78:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101d7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d82:	89 04 24             	mov    %eax,(%esp)
80101d85:	e8 e5 f9 ff ff       	call   8010176f <iupdate>
}
80101d8a:	c9                   	leave  
80101d8b:	c3                   	ret    

80101d8c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101d8c:	55                   	push   %ebp
80101d8d:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d8f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d92:	8b 00                	mov    (%eax),%eax
80101d94:	89 c2                	mov    %eax,%edx
80101d96:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d99:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9f:	8b 50 04             	mov    0x4(%eax),%edx
80101da2:	8b 45 0c             	mov    0xc(%ebp),%eax
80101da5:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101da8:	8b 45 08             	mov    0x8(%ebp),%eax
80101dab:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101daf:	8b 45 0c             	mov    0xc(%ebp),%eax
80101db2:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101db5:	8b 45 08             	mov    0x8(%ebp),%eax
80101db8:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dbf:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101dc3:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc6:	8b 50 58             	mov    0x58(%eax),%edx
80101dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dcc:	89 50 10             	mov    %edx,0x10(%eax)
}
80101dcf:	5d                   	pop    %ebp
80101dd0:	c3                   	ret    

80101dd1 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101dd1:	55                   	push   %ebp
80101dd2:	89 e5                	mov    %esp,%ebp
80101dd4:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101dd7:	8b 45 08             	mov    0x8(%ebp),%eax
80101dda:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101dde:	66 83 f8 03          	cmp    $0x3,%ax
80101de2:	75 60                	jne    80101e44 <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101de4:	8b 45 08             	mov    0x8(%ebp),%eax
80101de7:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101deb:	66 85 c0             	test   %ax,%ax
80101dee:	78 20                	js     80101e10 <readi+0x3f>
80101df0:	8b 45 08             	mov    0x8(%ebp),%eax
80101df3:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101df7:	66 83 f8 09          	cmp    $0x9,%ax
80101dfb:	7f 13                	jg     80101e10 <readi+0x3f>
80101dfd:	8b 45 08             	mov    0x8(%ebp),%eax
80101e00:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101e04:	98                   	cwtl   
80101e05:	8b 04 c5 e0 19 11 80 	mov    -0x7feee620(,%eax,8),%eax
80101e0c:	85 c0                	test   %eax,%eax
80101e0e:	75 0a                	jne    80101e1a <readi+0x49>
      return -1;
80101e10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e15:	e9 19 01 00 00       	jmp    80101f33 <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101e1a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e1d:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101e21:	98                   	cwtl   
80101e22:	8b 04 c5 e0 19 11 80 	mov    -0x7feee620(,%eax,8),%eax
80101e29:	8b 55 14             	mov    0x14(%ebp),%edx
80101e2c:	89 54 24 08          	mov    %edx,0x8(%esp)
80101e30:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e33:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e37:	8b 55 08             	mov    0x8(%ebp),%edx
80101e3a:	89 14 24             	mov    %edx,(%esp)
80101e3d:	ff d0                	call   *%eax
80101e3f:	e9 ef 00 00 00       	jmp    80101f33 <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80101e44:	8b 45 08             	mov    0x8(%ebp),%eax
80101e47:	8b 40 58             	mov    0x58(%eax),%eax
80101e4a:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e4d:	72 0d                	jb     80101e5c <readi+0x8b>
80101e4f:	8b 45 14             	mov    0x14(%ebp),%eax
80101e52:	8b 55 10             	mov    0x10(%ebp),%edx
80101e55:	01 d0                	add    %edx,%eax
80101e57:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e5a:	73 0a                	jae    80101e66 <readi+0x95>
    return -1;
80101e5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e61:	e9 cd 00 00 00       	jmp    80101f33 <readi+0x162>
  if(off + n > ip->size)
80101e66:	8b 45 14             	mov    0x14(%ebp),%eax
80101e69:	8b 55 10             	mov    0x10(%ebp),%edx
80101e6c:	01 c2                	add    %eax,%edx
80101e6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e71:	8b 40 58             	mov    0x58(%eax),%eax
80101e74:	39 c2                	cmp    %eax,%edx
80101e76:	76 0c                	jbe    80101e84 <readi+0xb3>
    n = ip->size - off;
80101e78:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7b:	8b 40 58             	mov    0x58(%eax),%eax
80101e7e:	2b 45 10             	sub    0x10(%ebp),%eax
80101e81:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e8b:	e9 94 00 00 00       	jmp    80101f24 <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e90:	8b 45 10             	mov    0x10(%ebp),%eax
80101e93:	c1 e8 09             	shr    $0x9,%eax
80101e96:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9d:	89 04 24             	mov    %eax,(%esp)
80101ea0:	e8 af fc ff ff       	call   80101b54 <bmap>
80101ea5:	8b 55 08             	mov    0x8(%ebp),%edx
80101ea8:	8b 12                	mov    (%edx),%edx
80101eaa:	89 44 24 04          	mov    %eax,0x4(%esp)
80101eae:	89 14 24             	mov    %edx,(%esp)
80101eb1:	e8 ff e2 ff ff       	call   801001b5 <bread>
80101eb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101eb9:	8b 45 10             	mov    0x10(%ebp),%eax
80101ebc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ec1:	89 c2                	mov    %eax,%edx
80101ec3:	b8 00 02 00 00       	mov    $0x200,%eax
80101ec8:	29 d0                	sub    %edx,%eax
80101eca:	89 c2                	mov    %eax,%edx
80101ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ecf:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101ed2:	29 c1                	sub    %eax,%ecx
80101ed4:	89 c8                	mov    %ecx,%eax
80101ed6:	39 c2                	cmp    %eax,%edx
80101ed8:	0f 46 c2             	cmovbe %edx,%eax
80101edb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101ede:	8b 45 10             	mov    0x10(%ebp),%eax
80101ee1:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ee6:	8d 50 50             	lea    0x50(%eax),%edx
80101ee9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101eec:	01 d0                	add    %edx,%eax
80101eee:	8d 50 0c             	lea    0xc(%eax),%edx
80101ef1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ef4:	89 44 24 08          	mov    %eax,0x8(%esp)
80101ef8:	89 54 24 04          	mov    %edx,0x4(%esp)
80101efc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eff:	89 04 24             	mov    %eax,(%esp)
80101f02:	e8 81 31 00 00       	call   80105088 <memmove>
    brelse(bp);
80101f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f0a:	89 04 24             	mov    %eax,(%esp)
80101f0d:	e8 1a e3 ff ff       	call   8010022c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f12:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f15:	01 45 f4             	add    %eax,-0xc(%ebp)
80101f18:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f1b:	01 45 10             	add    %eax,0x10(%ebp)
80101f1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f21:	01 45 0c             	add    %eax,0xc(%ebp)
80101f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f27:	3b 45 14             	cmp    0x14(%ebp),%eax
80101f2a:	0f 82 60 ff ff ff    	jb     80101e90 <readi+0xbf>
  }
  return n;
80101f30:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101f33:	c9                   	leave  
80101f34:	c3                   	ret    

80101f35 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f35:	55                   	push   %ebp
80101f36:	89 e5                	mov    %esp,%ebp
80101f38:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3e:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101f42:	66 83 f8 03          	cmp    $0x3,%ax
80101f46:	75 60                	jne    80101fa8 <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f48:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4b:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f4f:	66 85 c0             	test   %ax,%ax
80101f52:	78 20                	js     80101f74 <writei+0x3f>
80101f54:	8b 45 08             	mov    0x8(%ebp),%eax
80101f57:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f5b:	66 83 f8 09          	cmp    $0x9,%ax
80101f5f:	7f 13                	jg     80101f74 <writei+0x3f>
80101f61:	8b 45 08             	mov    0x8(%ebp),%eax
80101f64:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f68:	98                   	cwtl   
80101f69:	8b 04 c5 e4 19 11 80 	mov    -0x7feee61c(,%eax,8),%eax
80101f70:	85 c0                	test   %eax,%eax
80101f72:	75 0a                	jne    80101f7e <writei+0x49>
      return -1;
80101f74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f79:	e9 44 01 00 00       	jmp    801020c2 <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80101f7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f81:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f85:	98                   	cwtl   
80101f86:	8b 04 c5 e4 19 11 80 	mov    -0x7feee61c(,%eax,8),%eax
80101f8d:	8b 55 14             	mov    0x14(%ebp),%edx
80101f90:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f94:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f97:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f9b:	8b 55 08             	mov    0x8(%ebp),%edx
80101f9e:	89 14 24             	mov    %edx,(%esp)
80101fa1:	ff d0                	call   *%eax
80101fa3:	e9 1a 01 00 00       	jmp    801020c2 <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
80101fa8:	8b 45 08             	mov    0x8(%ebp),%eax
80101fab:	8b 40 58             	mov    0x58(%eax),%eax
80101fae:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fb1:	72 0d                	jb     80101fc0 <writei+0x8b>
80101fb3:	8b 45 14             	mov    0x14(%ebp),%eax
80101fb6:	8b 55 10             	mov    0x10(%ebp),%edx
80101fb9:	01 d0                	add    %edx,%eax
80101fbb:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fbe:	73 0a                	jae    80101fca <writei+0x95>
    return -1;
80101fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fc5:	e9 f8 00 00 00       	jmp    801020c2 <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
80101fca:	8b 45 14             	mov    0x14(%ebp),%eax
80101fcd:	8b 55 10             	mov    0x10(%ebp),%edx
80101fd0:	01 d0                	add    %edx,%eax
80101fd2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101fd7:	76 0a                	jbe    80101fe3 <writei+0xae>
    return -1;
80101fd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fde:	e9 df 00 00 00       	jmp    801020c2 <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101fe3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101fea:	e9 9f 00 00 00       	jmp    8010208e <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fef:	8b 45 10             	mov    0x10(%ebp),%eax
80101ff2:	c1 e8 09             	shr    $0x9,%eax
80101ff5:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ff9:	8b 45 08             	mov    0x8(%ebp),%eax
80101ffc:	89 04 24             	mov    %eax,(%esp)
80101fff:	e8 50 fb ff ff       	call   80101b54 <bmap>
80102004:	8b 55 08             	mov    0x8(%ebp),%edx
80102007:	8b 12                	mov    (%edx),%edx
80102009:	89 44 24 04          	mov    %eax,0x4(%esp)
8010200d:	89 14 24             	mov    %edx,(%esp)
80102010:	e8 a0 e1 ff ff       	call   801001b5 <bread>
80102015:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102018:	8b 45 10             	mov    0x10(%ebp),%eax
8010201b:	25 ff 01 00 00       	and    $0x1ff,%eax
80102020:	89 c2                	mov    %eax,%edx
80102022:	b8 00 02 00 00       	mov    $0x200,%eax
80102027:	29 d0                	sub    %edx,%eax
80102029:	89 c2                	mov    %eax,%edx
8010202b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010202e:	8b 4d 14             	mov    0x14(%ebp),%ecx
80102031:	29 c1                	sub    %eax,%ecx
80102033:	89 c8                	mov    %ecx,%eax
80102035:	39 c2                	cmp    %eax,%edx
80102037:	0f 46 c2             	cmovbe %edx,%eax
8010203a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010203d:	8b 45 10             	mov    0x10(%ebp),%eax
80102040:	25 ff 01 00 00       	and    $0x1ff,%eax
80102045:	8d 50 50             	lea    0x50(%eax),%edx
80102048:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010204b:	01 d0                	add    %edx,%eax
8010204d:	8d 50 0c             	lea    0xc(%eax),%edx
80102050:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102053:	89 44 24 08          	mov    %eax,0x8(%esp)
80102057:	8b 45 0c             	mov    0xc(%ebp),%eax
8010205a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010205e:	89 14 24             	mov    %edx,(%esp)
80102061:	e8 22 30 00 00       	call   80105088 <memmove>
    log_write(bp);
80102066:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102069:	89 04 24             	mov    %eax,(%esp)
8010206c:	e8 f8 15 00 00       	call   80103669 <log_write>
    brelse(bp);
80102071:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102074:	89 04 24             	mov    %eax,(%esp)
80102077:	e8 b0 e1 ff ff       	call   8010022c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010207c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010207f:	01 45 f4             	add    %eax,-0xc(%ebp)
80102082:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102085:	01 45 10             	add    %eax,0x10(%ebp)
80102088:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010208b:	01 45 0c             	add    %eax,0xc(%ebp)
8010208e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102091:	3b 45 14             	cmp    0x14(%ebp),%eax
80102094:	0f 82 55 ff ff ff    	jb     80101fef <writei+0xba>
  }

  if(n > 0 && off > ip->size){
8010209a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010209e:	74 1f                	je     801020bf <writei+0x18a>
801020a0:	8b 45 08             	mov    0x8(%ebp),%eax
801020a3:	8b 40 58             	mov    0x58(%eax),%eax
801020a6:	3b 45 10             	cmp    0x10(%ebp),%eax
801020a9:	73 14                	jae    801020bf <writei+0x18a>
    ip->size = off;
801020ab:	8b 45 08             	mov    0x8(%ebp),%eax
801020ae:	8b 55 10             	mov    0x10(%ebp),%edx
801020b1:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
801020b4:	8b 45 08             	mov    0x8(%ebp),%eax
801020b7:	89 04 24             	mov    %eax,(%esp)
801020ba:	e8 b0 f6 ff ff       	call   8010176f <iupdate>
  }
  return n;
801020bf:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020c2:	c9                   	leave  
801020c3:	c3                   	ret    

801020c4 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801020c4:	55                   	push   %ebp
801020c5:	89 e5                	mov    %esp,%ebp
801020c7:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
801020ca:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801020d1:	00 
801020d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801020d5:	89 44 24 04          	mov    %eax,0x4(%esp)
801020d9:	8b 45 08             	mov    0x8(%ebp),%eax
801020dc:	89 04 24             	mov    %eax,(%esp)
801020df:	e8 47 30 00 00       	call   8010512b <strncmp>
}
801020e4:	c9                   	leave  
801020e5:	c3                   	ret    

801020e6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801020e6:	55                   	push   %ebp
801020e7:	89 e5                	mov    %esp,%ebp
801020e9:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801020ec:	8b 45 08             	mov    0x8(%ebp),%eax
801020ef:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801020f3:	66 83 f8 01          	cmp    $0x1,%ax
801020f7:	74 0c                	je     80102105 <dirlookup+0x1f>
    panic("dirlookup not DIR");
801020f9:	c7 04 24 b5 84 10 80 	movl   $0x801084b5,(%esp)
80102100:	e8 5d e4 ff ff       	call   80100562 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102105:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010210c:	e9 88 00 00 00       	jmp    80102199 <dirlookup+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102111:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102118:	00 
80102119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010211c:	89 44 24 08          	mov    %eax,0x8(%esp)
80102120:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102123:	89 44 24 04          	mov    %eax,0x4(%esp)
80102127:	8b 45 08             	mov    0x8(%ebp),%eax
8010212a:	89 04 24             	mov    %eax,(%esp)
8010212d:	e8 9f fc ff ff       	call   80101dd1 <readi>
80102132:	83 f8 10             	cmp    $0x10,%eax
80102135:	74 0c                	je     80102143 <dirlookup+0x5d>
      panic("dirlookup read");
80102137:	c7 04 24 c7 84 10 80 	movl   $0x801084c7,(%esp)
8010213e:	e8 1f e4 ff ff       	call   80100562 <panic>
    if(de.inum == 0)
80102143:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102147:	66 85 c0             	test   %ax,%ax
8010214a:	75 02                	jne    8010214e <dirlookup+0x68>
      continue;
8010214c:	eb 47                	jmp    80102195 <dirlookup+0xaf>
    if(namecmp(name, de.name) == 0){
8010214e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102151:	83 c0 02             	add    $0x2,%eax
80102154:	89 44 24 04          	mov    %eax,0x4(%esp)
80102158:	8b 45 0c             	mov    0xc(%ebp),%eax
8010215b:	89 04 24             	mov    %eax,(%esp)
8010215e:	e8 61 ff ff ff       	call   801020c4 <namecmp>
80102163:	85 c0                	test   %eax,%eax
80102165:	75 2e                	jne    80102195 <dirlookup+0xaf>
      // entry matches path element
      if(poff)
80102167:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010216b:	74 08                	je     80102175 <dirlookup+0x8f>
        *poff = off;
8010216d:	8b 45 10             	mov    0x10(%ebp),%eax
80102170:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102173:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102175:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102179:	0f b7 c0             	movzwl %ax,%eax
8010217c:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
8010217f:	8b 45 08             	mov    0x8(%ebp),%eax
80102182:	8b 00                	mov    (%eax),%eax
80102184:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102187:	89 54 24 04          	mov    %edx,0x4(%esp)
8010218b:	89 04 24             	mov    %eax,(%esp)
8010218e:	e8 9a f6 ff ff       	call   8010182d <iget>
80102193:	eb 18                	jmp    801021ad <dirlookup+0xc7>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102195:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102199:	8b 45 08             	mov    0x8(%ebp),%eax
8010219c:	8b 40 58             	mov    0x58(%eax),%eax
8010219f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801021a2:	0f 87 69 ff ff ff    	ja     80102111 <dirlookup+0x2b>
    }
  }

  return 0;
801021a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801021ad:	c9                   	leave  
801021ae:	c3                   	ret    

801021af <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801021af:	55                   	push   %ebp
801021b0:	89 e5                	mov    %esp,%ebp
801021b2:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801021b5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801021bc:	00 
801021bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801021c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801021c4:	8b 45 08             	mov    0x8(%ebp),%eax
801021c7:	89 04 24             	mov    %eax,(%esp)
801021ca:	e8 17 ff ff ff       	call   801020e6 <dirlookup>
801021cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
801021d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801021d6:	74 15                	je     801021ed <dirlink+0x3e>
    iput(ip);
801021d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021db:	89 04 24             	mov    %eax,(%esp)
801021de:	e8 a2 f8 ff ff       	call   80101a85 <iput>
    return -1;
801021e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021e8:	e9 b7 00 00 00       	jmp    801022a4 <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021f4:	eb 46                	jmp    8010223c <dirlink+0x8d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021f9:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102200:	00 
80102201:	89 44 24 08          	mov    %eax,0x8(%esp)
80102205:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102208:	89 44 24 04          	mov    %eax,0x4(%esp)
8010220c:	8b 45 08             	mov    0x8(%ebp),%eax
8010220f:	89 04 24             	mov    %eax,(%esp)
80102212:	e8 ba fb ff ff       	call   80101dd1 <readi>
80102217:	83 f8 10             	cmp    $0x10,%eax
8010221a:	74 0c                	je     80102228 <dirlink+0x79>
      panic("dirlink read");
8010221c:	c7 04 24 d6 84 10 80 	movl   $0x801084d6,(%esp)
80102223:	e8 3a e3 ff ff       	call   80100562 <panic>
    if(de.inum == 0)
80102228:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010222c:	66 85 c0             	test   %ax,%ax
8010222f:	75 02                	jne    80102233 <dirlink+0x84>
      break;
80102231:	eb 16                	jmp    80102249 <dirlink+0x9a>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102233:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102236:	83 c0 10             	add    $0x10,%eax
80102239:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010223c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010223f:	8b 45 08             	mov    0x8(%ebp),%eax
80102242:	8b 40 58             	mov    0x58(%eax),%eax
80102245:	39 c2                	cmp    %eax,%edx
80102247:	72 ad                	jb     801021f6 <dirlink+0x47>
  }

  strncpy(de.name, name, DIRSIZ);
80102249:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102250:	00 
80102251:	8b 45 0c             	mov    0xc(%ebp),%eax
80102254:	89 44 24 04          	mov    %eax,0x4(%esp)
80102258:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010225b:	83 c0 02             	add    $0x2,%eax
8010225e:	89 04 24             	mov    %eax,(%esp)
80102261:	e8 1b 2f 00 00       	call   80105181 <strncpy>
  de.inum = inum;
80102266:	8b 45 10             	mov    0x10(%ebp),%eax
80102269:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010226d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102270:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102277:	00 
80102278:	89 44 24 08          	mov    %eax,0x8(%esp)
8010227c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010227f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102283:	8b 45 08             	mov    0x8(%ebp),%eax
80102286:	89 04 24             	mov    %eax,(%esp)
80102289:	e8 a7 fc ff ff       	call   80101f35 <writei>
8010228e:	83 f8 10             	cmp    $0x10,%eax
80102291:	74 0c                	je     8010229f <dirlink+0xf0>
    panic("dirlink");
80102293:	c7 04 24 e3 84 10 80 	movl   $0x801084e3,(%esp)
8010229a:	e8 c3 e2 ff ff       	call   80100562 <panic>

  return 0;
8010229f:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022a4:	c9                   	leave  
801022a5:	c3                   	ret    

801022a6 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801022a6:	55                   	push   %ebp
801022a7:	89 e5                	mov    %esp,%ebp
801022a9:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
801022ac:	eb 04                	jmp    801022b2 <skipelem+0xc>
    path++;
801022ae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
801022b2:	8b 45 08             	mov    0x8(%ebp),%eax
801022b5:	0f b6 00             	movzbl (%eax),%eax
801022b8:	3c 2f                	cmp    $0x2f,%al
801022ba:	74 f2                	je     801022ae <skipelem+0x8>
  if(*path == 0)
801022bc:	8b 45 08             	mov    0x8(%ebp),%eax
801022bf:	0f b6 00             	movzbl (%eax),%eax
801022c2:	84 c0                	test   %al,%al
801022c4:	75 0a                	jne    801022d0 <skipelem+0x2a>
    return 0;
801022c6:	b8 00 00 00 00       	mov    $0x0,%eax
801022cb:	e9 86 00 00 00       	jmp    80102356 <skipelem+0xb0>
  s = path;
801022d0:	8b 45 08             	mov    0x8(%ebp),%eax
801022d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801022d6:	eb 04                	jmp    801022dc <skipelem+0x36>
    path++;
801022d8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
801022dc:	8b 45 08             	mov    0x8(%ebp),%eax
801022df:	0f b6 00             	movzbl (%eax),%eax
801022e2:	3c 2f                	cmp    $0x2f,%al
801022e4:	74 0a                	je     801022f0 <skipelem+0x4a>
801022e6:	8b 45 08             	mov    0x8(%ebp),%eax
801022e9:	0f b6 00             	movzbl (%eax),%eax
801022ec:	84 c0                	test   %al,%al
801022ee:	75 e8                	jne    801022d8 <skipelem+0x32>
  len = path - s;
801022f0:	8b 55 08             	mov    0x8(%ebp),%edx
801022f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022f6:	29 c2                	sub    %eax,%edx
801022f8:	89 d0                	mov    %edx,%eax
801022fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801022fd:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102301:	7e 1c                	jle    8010231f <skipelem+0x79>
    memmove(name, s, DIRSIZ);
80102303:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010230a:	00 
8010230b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010230e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102312:	8b 45 0c             	mov    0xc(%ebp),%eax
80102315:	89 04 24             	mov    %eax,(%esp)
80102318:	e8 6b 2d 00 00       	call   80105088 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
8010231d:	eb 2a                	jmp    80102349 <skipelem+0xa3>
    memmove(name, s, len);
8010231f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102322:	89 44 24 08          	mov    %eax,0x8(%esp)
80102326:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102329:	89 44 24 04          	mov    %eax,0x4(%esp)
8010232d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102330:	89 04 24             	mov    %eax,(%esp)
80102333:	e8 50 2d 00 00       	call   80105088 <memmove>
    name[len] = 0;
80102338:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010233b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010233e:	01 d0                	add    %edx,%eax
80102340:	c6 00 00             	movb   $0x0,(%eax)
  while(*path == '/')
80102343:	eb 04                	jmp    80102349 <skipelem+0xa3>
    path++;
80102345:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
80102349:	8b 45 08             	mov    0x8(%ebp),%eax
8010234c:	0f b6 00             	movzbl (%eax),%eax
8010234f:	3c 2f                	cmp    $0x2f,%al
80102351:	74 f2                	je     80102345 <skipelem+0x9f>
  return path;
80102353:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102356:	c9                   	leave  
80102357:	c3                   	ret    

80102358 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102358:	55                   	push   %ebp
80102359:	89 e5                	mov    %esp,%ebp
8010235b:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010235e:	8b 45 08             	mov    0x8(%ebp),%eax
80102361:	0f b6 00             	movzbl (%eax),%eax
80102364:	3c 2f                	cmp    $0x2f,%al
80102366:	75 1c                	jne    80102384 <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
80102368:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010236f:	00 
80102370:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102377:	e8 b1 f4 ff ff       	call   8010182d <iget>
8010237c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
8010237f:	e9 ae 00 00 00       	jmp    80102432 <namex+0xda>
    ip = idup(myproc()->cwd);
80102384:	e8 b4 1d 00 00       	call   8010413d <myproc>
80102389:	8b 40 68             	mov    0x68(%eax),%eax
8010238c:	89 04 24             	mov    %eax,(%esp)
8010238f:	e8 6e f5 ff ff       	call   80101902 <idup>
80102394:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
80102397:	e9 96 00 00 00       	jmp    80102432 <namex+0xda>
    ilock(ip);
8010239c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010239f:	89 04 24             	mov    %eax,(%esp)
801023a2:	e8 8d f5 ff ff       	call   80101934 <ilock>
    if(ip->type != T_DIR){
801023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023aa:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801023ae:	66 83 f8 01          	cmp    $0x1,%ax
801023b2:	74 15                	je     801023c9 <namex+0x71>
      iunlockput(ip);
801023b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023b7:	89 04 24             	mov    %eax,(%esp)
801023ba:	e8 77 f7 ff ff       	call   80101b36 <iunlockput>
      return 0;
801023bf:	b8 00 00 00 00       	mov    $0x0,%eax
801023c4:	e9 a3 00 00 00       	jmp    8010246c <namex+0x114>
    }
    if(nameiparent && *path == '\0'){
801023c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023cd:	74 1d                	je     801023ec <namex+0x94>
801023cf:	8b 45 08             	mov    0x8(%ebp),%eax
801023d2:	0f b6 00             	movzbl (%eax),%eax
801023d5:	84 c0                	test   %al,%al
801023d7:	75 13                	jne    801023ec <namex+0x94>
      // Stop one level early.
      iunlock(ip);
801023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023dc:	89 04 24             	mov    %eax,(%esp)
801023df:	e8 5d f6 ff ff       	call   80101a41 <iunlock>
      return ip;
801023e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023e7:	e9 80 00 00 00       	jmp    8010246c <namex+0x114>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801023ec:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801023f3:	00 
801023f4:	8b 45 10             	mov    0x10(%ebp),%eax
801023f7:	89 44 24 04          	mov    %eax,0x4(%esp)
801023fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023fe:	89 04 24             	mov    %eax,(%esp)
80102401:	e8 e0 fc ff ff       	call   801020e6 <dirlookup>
80102406:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102409:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010240d:	75 12                	jne    80102421 <namex+0xc9>
      iunlockput(ip);
8010240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102412:	89 04 24             	mov    %eax,(%esp)
80102415:	e8 1c f7 ff ff       	call   80101b36 <iunlockput>
      return 0;
8010241a:	b8 00 00 00 00       	mov    $0x0,%eax
8010241f:	eb 4b                	jmp    8010246c <namex+0x114>
    }
    iunlockput(ip);
80102421:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102424:	89 04 24             	mov    %eax,(%esp)
80102427:	e8 0a f7 ff ff       	call   80101b36 <iunlockput>
    ip = next;
8010242c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010242f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
80102432:	8b 45 10             	mov    0x10(%ebp),%eax
80102435:	89 44 24 04          	mov    %eax,0x4(%esp)
80102439:	8b 45 08             	mov    0x8(%ebp),%eax
8010243c:	89 04 24             	mov    %eax,(%esp)
8010243f:	e8 62 fe ff ff       	call   801022a6 <skipelem>
80102444:	89 45 08             	mov    %eax,0x8(%ebp)
80102447:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010244b:	0f 85 4b ff ff ff    	jne    8010239c <namex+0x44>
  }
  if(nameiparent){
80102451:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102455:	74 12                	je     80102469 <namex+0x111>
    iput(ip);
80102457:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010245a:	89 04 24             	mov    %eax,(%esp)
8010245d:	e8 23 f6 ff ff       	call   80101a85 <iput>
    return 0;
80102462:	b8 00 00 00 00       	mov    $0x0,%eax
80102467:	eb 03                	jmp    8010246c <namex+0x114>
  }
  return ip;
80102469:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010246c:	c9                   	leave  
8010246d:	c3                   	ret    

8010246e <namei>:

struct inode*
namei(char *path)
{
8010246e:	55                   	push   %ebp
8010246f:	89 e5                	mov    %esp,%ebp
80102471:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102474:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102477:	89 44 24 08          	mov    %eax,0x8(%esp)
8010247b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102482:	00 
80102483:	8b 45 08             	mov    0x8(%ebp),%eax
80102486:	89 04 24             	mov    %eax,(%esp)
80102489:	e8 ca fe ff ff       	call   80102358 <namex>
}
8010248e:	c9                   	leave  
8010248f:	c3                   	ret    

80102490 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
80102496:	8b 45 0c             	mov    0xc(%ebp),%eax
80102499:	89 44 24 08          	mov    %eax,0x8(%esp)
8010249d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801024a4:	00 
801024a5:	8b 45 08             	mov    0x8(%ebp),%eax
801024a8:	89 04 24             	mov    %eax,(%esp)
801024ab:	e8 a8 fe ff ff       	call   80102358 <namex>
}
801024b0:	c9                   	leave  
801024b1:	c3                   	ret    

801024b2 <inb>:
{
801024b2:	55                   	push   %ebp
801024b3:	89 e5                	mov    %esp,%ebp
801024b5:	83 ec 14             	sub    $0x14,%esp
801024b8:	8b 45 08             	mov    0x8(%ebp),%eax
801024bb:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024bf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801024c3:	89 c2                	mov    %eax,%edx
801024c5:	ec                   	in     (%dx),%al
801024c6:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801024c9:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801024cd:	c9                   	leave  
801024ce:	c3                   	ret    

801024cf <insl>:
{
801024cf:	55                   	push   %ebp
801024d0:	89 e5                	mov    %esp,%ebp
801024d2:	57                   	push   %edi
801024d3:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801024d4:	8b 55 08             	mov    0x8(%ebp),%edx
801024d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024da:	8b 45 10             	mov    0x10(%ebp),%eax
801024dd:	89 cb                	mov    %ecx,%ebx
801024df:	89 df                	mov    %ebx,%edi
801024e1:	89 c1                	mov    %eax,%ecx
801024e3:	fc                   	cld    
801024e4:	f3 6d                	rep insl (%dx),%es:(%edi)
801024e6:	89 c8                	mov    %ecx,%eax
801024e8:	89 fb                	mov    %edi,%ebx
801024ea:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024ed:	89 45 10             	mov    %eax,0x10(%ebp)
}
801024f0:	5b                   	pop    %ebx
801024f1:	5f                   	pop    %edi
801024f2:	5d                   	pop    %ebp
801024f3:	c3                   	ret    

801024f4 <outb>:
{
801024f4:	55                   	push   %ebp
801024f5:	89 e5                	mov    %esp,%ebp
801024f7:	83 ec 08             	sub    $0x8,%esp
801024fa:	8b 55 08             	mov    0x8(%ebp),%edx
801024fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80102500:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102504:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102507:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010250b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010250f:	ee                   	out    %al,(%dx)
}
80102510:	c9                   	leave  
80102511:	c3                   	ret    

80102512 <outsl>:
{
80102512:	55                   	push   %ebp
80102513:	89 e5                	mov    %esp,%ebp
80102515:	56                   	push   %esi
80102516:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102517:	8b 55 08             	mov    0x8(%ebp),%edx
8010251a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010251d:	8b 45 10             	mov    0x10(%ebp),%eax
80102520:	89 cb                	mov    %ecx,%ebx
80102522:	89 de                	mov    %ebx,%esi
80102524:	89 c1                	mov    %eax,%ecx
80102526:	fc                   	cld    
80102527:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102529:	89 c8                	mov    %ecx,%eax
8010252b:	89 f3                	mov    %esi,%ebx
8010252d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102530:	89 45 10             	mov    %eax,0x10(%ebp)
}
80102533:	5b                   	pop    %ebx
80102534:	5e                   	pop    %esi
80102535:	5d                   	pop    %ebp
80102536:	c3                   	ret    

80102537 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102537:	55                   	push   %ebp
80102538:	89 e5                	mov    %esp,%ebp
8010253a:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010253d:	90                   	nop
8010253e:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102545:	e8 68 ff ff ff       	call   801024b2 <inb>
8010254a:	0f b6 c0             	movzbl %al,%eax
8010254d:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102550:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102553:	25 c0 00 00 00       	and    $0xc0,%eax
80102558:	83 f8 40             	cmp    $0x40,%eax
8010255b:	75 e1                	jne    8010253e <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010255d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102561:	74 11                	je     80102574 <idewait+0x3d>
80102563:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102566:	83 e0 21             	and    $0x21,%eax
80102569:	85 c0                	test   %eax,%eax
8010256b:	74 07                	je     80102574 <idewait+0x3d>
    return -1;
8010256d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102572:	eb 05                	jmp    80102579 <idewait+0x42>
  return 0;
80102574:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102579:	c9                   	leave  
8010257a:	c3                   	ret    

8010257b <ideinit>:

void
ideinit(void)
{
8010257b:	55                   	push   %ebp
8010257c:	89 e5                	mov    %esp,%ebp
8010257e:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
80102581:	c7 44 24 04 eb 84 10 	movl   $0x801084eb,0x4(%esp)
80102588:	80 
80102589:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80102590:	e8 a1 27 00 00       	call   80104d36 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102595:	a1 80 3d 11 80       	mov    0x80113d80,%eax
8010259a:	83 e8 01             	sub    $0x1,%eax
8010259d:	89 44 24 04          	mov    %eax,0x4(%esp)
801025a1:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801025a8:	e8 69 04 00 00       	call   80102a16 <ioapicenable>
  idewait(0);
801025ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025b4:	e8 7e ff ff ff       	call   80102537 <idewait>

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801025b9:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
801025c0:	00 
801025c1:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025c8:	e8 27 ff ff ff       	call   801024f4 <outb>
  for(i=0; i<1000; i++){
801025cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801025d4:	eb 20                	jmp    801025f6 <ideinit+0x7b>
    if(inb(0x1f7) != 0){
801025d6:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801025dd:	e8 d0 fe ff ff       	call   801024b2 <inb>
801025e2:	84 c0                	test   %al,%al
801025e4:	74 0c                	je     801025f2 <ideinit+0x77>
      havedisk1 = 1;
801025e6:	c7 05 18 b6 10 80 01 	movl   $0x1,0x8010b618
801025ed:	00 00 00 
      break;
801025f0:	eb 0d                	jmp    801025ff <ideinit+0x84>
  for(i=0; i<1000; i++){
801025f2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801025f6:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801025fd:	7e d7                	jle    801025d6 <ideinit+0x5b>
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801025ff:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
80102606:	00 
80102607:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010260e:	e8 e1 fe ff ff       	call   801024f4 <outb>
}
80102613:	c9                   	leave  
80102614:	c3                   	ret    

80102615 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102615:	55                   	push   %ebp
80102616:	89 e5                	mov    %esp,%ebp
80102618:	83 ec 28             	sub    $0x28,%esp
  if(b == 0)
8010261b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010261f:	75 0c                	jne    8010262d <idestart+0x18>
    panic("idestart");
80102621:	c7 04 24 ef 84 10 80 	movl   $0x801084ef,(%esp)
80102628:	e8 35 df ff ff       	call   80100562 <panic>
  if(b->blockno >= FSSIZE)
8010262d:	8b 45 08             	mov    0x8(%ebp),%eax
80102630:	8b 40 08             	mov    0x8(%eax),%eax
80102633:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80102638:	76 0c                	jbe    80102646 <idestart+0x31>
    panic("incorrect blockno");
8010263a:	c7 04 24 f8 84 10 80 	movl   $0x801084f8,(%esp)
80102641:	e8 1c df ff ff       	call   80100562 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102646:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
8010264d:	8b 45 08             	mov    0x8(%ebp),%eax
80102650:	8b 50 08             	mov    0x8(%eax),%edx
80102653:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102656:	0f af c2             	imul   %edx,%eax
80102659:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
8010265c:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102660:	75 07                	jne    80102669 <idestart+0x54>
80102662:	b8 20 00 00 00       	mov    $0x20,%eax
80102667:	eb 05                	jmp    8010266e <idestart+0x59>
80102669:	b8 c4 00 00 00       	mov    $0xc4,%eax
8010266e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
80102671:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102675:	75 07                	jne    8010267e <idestart+0x69>
80102677:	b8 30 00 00 00       	mov    $0x30,%eax
8010267c:	eb 05                	jmp    80102683 <idestart+0x6e>
8010267e:	b8 c5 00 00 00       	mov    $0xc5,%eax
80102683:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102686:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
8010268a:	7e 0c                	jle    80102698 <idestart+0x83>
8010268c:	c7 04 24 ef 84 10 80 	movl   $0x801084ef,(%esp)
80102693:	e8 ca de ff ff       	call   80100562 <panic>

  idewait(0);
80102698:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010269f:	e8 93 fe ff ff       	call   80102537 <idewait>
  outb(0x3f6, 0);  // generate interrupt
801026a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801026ab:	00 
801026ac:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
801026b3:	e8 3c fe ff ff       	call   801024f4 <outb>
  outb(0x1f2, sector_per_block);  // number of sectors
801026b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026bb:	0f b6 c0             	movzbl %al,%eax
801026be:	89 44 24 04          	mov    %eax,0x4(%esp)
801026c2:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
801026c9:	e8 26 fe ff ff       	call   801024f4 <outb>
  outb(0x1f3, sector & 0xff);
801026ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026d1:	0f b6 c0             	movzbl %al,%eax
801026d4:	89 44 24 04          	mov    %eax,0x4(%esp)
801026d8:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
801026df:	e8 10 fe ff ff       	call   801024f4 <outb>
  outb(0x1f4, (sector >> 8) & 0xff);
801026e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026e7:	c1 f8 08             	sar    $0x8,%eax
801026ea:	0f b6 c0             	movzbl %al,%eax
801026ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801026f1:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
801026f8:	e8 f7 fd ff ff       	call   801024f4 <outb>
  outb(0x1f5, (sector >> 16) & 0xff);
801026fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102700:	c1 f8 10             	sar    $0x10,%eax
80102703:	0f b6 c0             	movzbl %al,%eax
80102706:	89 44 24 04          	mov    %eax,0x4(%esp)
8010270a:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102711:	e8 de fd ff ff       	call   801024f4 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102716:	8b 45 08             	mov    0x8(%ebp),%eax
80102719:	8b 40 04             	mov    0x4(%eax),%eax
8010271c:	83 e0 01             	and    $0x1,%eax
8010271f:	c1 e0 04             	shl    $0x4,%eax
80102722:	89 c2                	mov    %eax,%edx
80102724:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102727:	c1 f8 18             	sar    $0x18,%eax
8010272a:	83 e0 0f             	and    $0xf,%eax
8010272d:	09 d0                	or     %edx,%eax
8010272f:	83 c8 e0             	or     $0xffffffe0,%eax
80102732:	0f b6 c0             	movzbl %al,%eax
80102735:	89 44 24 04          	mov    %eax,0x4(%esp)
80102739:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102740:	e8 af fd ff ff       	call   801024f4 <outb>
  if(b->flags & B_DIRTY){
80102745:	8b 45 08             	mov    0x8(%ebp),%eax
80102748:	8b 00                	mov    (%eax),%eax
8010274a:	83 e0 04             	and    $0x4,%eax
8010274d:	85 c0                	test   %eax,%eax
8010274f:	74 36                	je     80102787 <idestart+0x172>
    outb(0x1f7, write_cmd);
80102751:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102754:	0f b6 c0             	movzbl %al,%eax
80102757:	89 44 24 04          	mov    %eax,0x4(%esp)
8010275b:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102762:	e8 8d fd ff ff       	call   801024f4 <outb>
    outsl(0x1f0, b->data, BSIZE/4);
80102767:	8b 45 08             	mov    0x8(%ebp),%eax
8010276a:	83 c0 5c             	add    $0x5c,%eax
8010276d:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102774:	00 
80102775:	89 44 24 04          	mov    %eax,0x4(%esp)
80102779:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102780:	e8 8d fd ff ff       	call   80102512 <outsl>
80102785:	eb 16                	jmp    8010279d <idestart+0x188>
  } else {
    outb(0x1f7, read_cmd);
80102787:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010278a:	0f b6 c0             	movzbl %al,%eax
8010278d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102791:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102798:	e8 57 fd ff ff       	call   801024f4 <outb>
  }
}
8010279d:	c9                   	leave  
8010279e:	c3                   	ret    

8010279f <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010279f:	55                   	push   %ebp
801027a0:	89 e5                	mov    %esp,%ebp
801027a2:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801027a5:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801027ac:	e8 a6 25 00 00       	call   80104d57 <acquire>

  if((b = idequeue) == 0){
801027b1:	a1 14 b6 10 80       	mov    0x8010b614,%eax
801027b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027bd:	75 11                	jne    801027d0 <ideintr+0x31>
    release(&idelock);
801027bf:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801027c6:	e8 f4 25 00 00       	call   80104dbf <release>
    return;
801027cb:	e9 90 00 00 00       	jmp    80102860 <ideintr+0xc1>
  }
  idequeue = b->qnext;
801027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027d3:	8b 40 58             	mov    0x58(%eax),%eax
801027d6:	a3 14 b6 10 80       	mov    %eax,0x8010b614

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027de:	8b 00                	mov    (%eax),%eax
801027e0:	83 e0 04             	and    $0x4,%eax
801027e3:	85 c0                	test   %eax,%eax
801027e5:	75 2e                	jne    80102815 <ideintr+0x76>
801027e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801027ee:	e8 44 fd ff ff       	call   80102537 <idewait>
801027f3:	85 c0                	test   %eax,%eax
801027f5:	78 1e                	js     80102815 <ideintr+0x76>
    insl(0x1f0, b->data, BSIZE/4);
801027f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027fa:	83 c0 5c             	add    $0x5c,%eax
801027fd:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102804:	00 
80102805:	89 44 24 04          	mov    %eax,0x4(%esp)
80102809:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102810:	e8 ba fc ff ff       	call   801024cf <insl>

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102815:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102818:	8b 00                	mov    (%eax),%eax
8010281a:	83 c8 02             	or     $0x2,%eax
8010281d:	89 c2                	mov    %eax,%edx
8010281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102822:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102824:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102827:	8b 00                	mov    (%eax),%eax
80102829:	83 e0 fb             	and    $0xfffffffb,%eax
8010282c:	89 c2                	mov    %eax,%edx
8010282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102831:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102833:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102836:	89 04 24             	mov    %eax,(%esp)
80102839:	e8 22 22 00 00       	call   80104a60 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
8010283e:	a1 14 b6 10 80       	mov    0x8010b614,%eax
80102843:	85 c0                	test   %eax,%eax
80102845:	74 0d                	je     80102854 <ideintr+0xb5>
    idestart(idequeue);
80102847:	a1 14 b6 10 80       	mov    0x8010b614,%eax
8010284c:	89 04 24             	mov    %eax,(%esp)
8010284f:	e8 c1 fd ff ff       	call   80102615 <idestart>

  release(&idelock);
80102854:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010285b:	e8 5f 25 00 00       	call   80104dbf <release>
}
80102860:	c9                   	leave  
80102861:	c3                   	ret    

80102862 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102862:	55                   	push   %ebp
80102863:	89 e5                	mov    %esp,%ebp
80102865:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102868:	8b 45 08             	mov    0x8(%ebp),%eax
8010286b:	83 c0 0c             	add    $0xc,%eax
8010286e:	89 04 24             	mov    %eax,(%esp)
80102871:	e8 5b 24 00 00       	call   80104cd1 <holdingsleep>
80102876:	85 c0                	test   %eax,%eax
80102878:	75 0c                	jne    80102886 <iderw+0x24>
    panic("iderw: buf not locked");
8010287a:	c7 04 24 0a 85 10 80 	movl   $0x8010850a,(%esp)
80102881:	e8 dc dc ff ff       	call   80100562 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102886:	8b 45 08             	mov    0x8(%ebp),%eax
80102889:	8b 00                	mov    (%eax),%eax
8010288b:	83 e0 06             	and    $0x6,%eax
8010288e:	83 f8 02             	cmp    $0x2,%eax
80102891:	75 0c                	jne    8010289f <iderw+0x3d>
    panic("iderw: nothing to do");
80102893:	c7 04 24 20 85 10 80 	movl   $0x80108520,(%esp)
8010289a:	e8 c3 dc ff ff       	call   80100562 <panic>
  if(b->dev != 0 && !havedisk1)
8010289f:	8b 45 08             	mov    0x8(%ebp),%eax
801028a2:	8b 40 04             	mov    0x4(%eax),%eax
801028a5:	85 c0                	test   %eax,%eax
801028a7:	74 15                	je     801028be <iderw+0x5c>
801028a9:	a1 18 b6 10 80       	mov    0x8010b618,%eax
801028ae:	85 c0                	test   %eax,%eax
801028b0:	75 0c                	jne    801028be <iderw+0x5c>
    panic("iderw: ide disk 1 not present");
801028b2:	c7 04 24 35 85 10 80 	movl   $0x80108535,(%esp)
801028b9:	e8 a4 dc ff ff       	call   80100562 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801028be:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801028c5:	e8 8d 24 00 00       	call   80104d57 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
801028ca:	8b 45 08             	mov    0x8(%ebp),%eax
801028cd:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028d4:	c7 45 f4 14 b6 10 80 	movl   $0x8010b614,-0xc(%ebp)
801028db:	eb 0b                	jmp    801028e8 <iderw+0x86>
801028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028e0:	8b 00                	mov    (%eax),%eax
801028e2:	83 c0 58             	add    $0x58,%eax
801028e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028eb:	8b 00                	mov    (%eax),%eax
801028ed:	85 c0                	test   %eax,%eax
801028ef:	75 ec                	jne    801028dd <iderw+0x7b>
    ;
  *pp = b;
801028f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028f4:	8b 55 08             	mov    0x8(%ebp),%edx
801028f7:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
801028f9:	a1 14 b6 10 80       	mov    0x8010b614,%eax
801028fe:	3b 45 08             	cmp    0x8(%ebp),%eax
80102901:	75 0d                	jne    80102910 <iderw+0xae>
    idestart(b);
80102903:	8b 45 08             	mov    0x8(%ebp),%eax
80102906:	89 04 24             	mov    %eax,(%esp)
80102909:	e8 07 fd ff ff       	call   80102615 <idestart>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010290e:	eb 15                	jmp    80102925 <iderw+0xc3>
80102910:	eb 13                	jmp    80102925 <iderw+0xc3>
    sleep(b, &idelock);
80102912:	c7 44 24 04 e0 b5 10 	movl   $0x8010b5e0,0x4(%esp)
80102919:	80 
8010291a:	8b 45 08             	mov    0x8(%ebp),%eax
8010291d:	89 04 24             	mov    %eax,(%esp)
80102920:	e8 67 20 00 00       	call   8010498c <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102925:	8b 45 08             	mov    0x8(%ebp),%eax
80102928:	8b 00                	mov    (%eax),%eax
8010292a:	83 e0 06             	and    $0x6,%eax
8010292d:	83 f8 02             	cmp    $0x2,%eax
80102930:	75 e0                	jne    80102912 <iderw+0xb0>
  }


  release(&idelock);
80102932:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80102939:	e8 81 24 00 00       	call   80104dbf <release>
}
8010293e:	c9                   	leave  
8010293f:	c3                   	ret    

80102940 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102940:	55                   	push   %ebp
80102941:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102943:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102948:	8b 55 08             	mov    0x8(%ebp),%edx
8010294b:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
8010294d:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102952:	8b 40 10             	mov    0x10(%eax),%eax
}
80102955:	5d                   	pop    %ebp
80102956:	c3                   	ret    

80102957 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102957:	55                   	push   %ebp
80102958:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010295a:	a1 b4 36 11 80       	mov    0x801136b4,%eax
8010295f:	8b 55 08             	mov    0x8(%ebp),%edx
80102962:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102964:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102969:	8b 55 0c             	mov    0xc(%ebp),%edx
8010296c:	89 50 10             	mov    %edx,0x10(%eax)
}
8010296f:	5d                   	pop    %ebp
80102970:	c3                   	ret    

80102971 <ioapicinit>:

void
ioapicinit(void)
{
80102971:	55                   	push   %ebp
80102972:	89 e5                	mov    %esp,%ebp
80102974:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102977:	c7 05 b4 36 11 80 00 	movl   $0xfec00000,0x801136b4
8010297e:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102981:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102988:	e8 b3 ff ff ff       	call   80102940 <ioapicread>
8010298d:	c1 e8 10             	shr    $0x10,%eax
80102990:	25 ff 00 00 00       	and    $0xff,%eax
80102995:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102998:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010299f:	e8 9c ff ff ff       	call   80102940 <ioapicread>
801029a4:	c1 e8 18             	shr    $0x18,%eax
801029a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
801029aa:	0f b6 05 e0 37 11 80 	movzbl 0x801137e0,%eax
801029b1:	0f b6 c0             	movzbl %al,%eax
801029b4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801029b7:	74 0c                	je     801029c5 <ioapicinit+0x54>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801029b9:	c7 04 24 54 85 10 80 	movl   $0x80108554,(%esp)
801029c0:	e8 03 da ff ff       	call   801003c8 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801029cc:	eb 3e                	jmp    80102a0c <ioapicinit+0x9b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029d1:	83 c0 20             	add    $0x20,%eax
801029d4:	0d 00 00 01 00       	or     $0x10000,%eax
801029d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801029dc:	83 c2 08             	add    $0x8,%edx
801029df:	01 d2                	add    %edx,%edx
801029e1:	89 44 24 04          	mov    %eax,0x4(%esp)
801029e5:	89 14 24             	mov    %edx,(%esp)
801029e8:	e8 6a ff ff ff       	call   80102957 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
801029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029f0:	83 c0 08             	add    $0x8,%eax
801029f3:	01 c0                	add    %eax,%eax
801029f5:	83 c0 01             	add    $0x1,%eax
801029f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801029ff:	00 
80102a00:	89 04 24             	mov    %eax,(%esp)
80102a03:	e8 4f ff ff ff       	call   80102957 <ioapicwrite>
  for(i = 0; i <= maxintr; i++){
80102a08:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a0f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102a12:	7e ba                	jle    801029ce <ioapicinit+0x5d>
  }
}
80102a14:	c9                   	leave  
80102a15:	c3                   	ret    

80102a16 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a16:	55                   	push   %ebp
80102a17:	89 e5                	mov    %esp,%ebp
80102a19:	83 ec 08             	sub    $0x8,%esp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a1c:	8b 45 08             	mov    0x8(%ebp),%eax
80102a1f:	83 c0 20             	add    $0x20,%eax
80102a22:	8b 55 08             	mov    0x8(%ebp),%edx
80102a25:	83 c2 08             	add    $0x8,%edx
80102a28:	01 d2                	add    %edx,%edx
80102a2a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a2e:	89 14 24             	mov    %edx,(%esp)
80102a31:	e8 21 ff ff ff       	call   80102957 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a36:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a39:	c1 e0 18             	shl    $0x18,%eax
80102a3c:	8b 55 08             	mov    0x8(%ebp),%edx
80102a3f:	83 c2 08             	add    $0x8,%edx
80102a42:	01 d2                	add    %edx,%edx
80102a44:	83 c2 01             	add    $0x1,%edx
80102a47:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a4b:	89 14 24             	mov    %edx,(%esp)
80102a4e:	e8 04 ff ff ff       	call   80102957 <ioapicwrite>
}
80102a53:	c9                   	leave  
80102a54:	c3                   	ret    

80102a55 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102a55:	55                   	push   %ebp
80102a56:	89 e5                	mov    %esp,%ebp
80102a58:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102a5b:	c7 44 24 04 86 85 10 	movl   $0x80108586,0x4(%esp)
80102a62:	80 
80102a63:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80102a6a:	e8 c7 22 00 00       	call   80104d36 <initlock>
  kmem.use_lock = 0;
80102a6f:	c7 05 f4 36 11 80 00 	movl   $0x0,0x801136f4
80102a76:	00 00 00 
  freerange(vstart, vend);
80102a79:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a80:	8b 45 08             	mov    0x8(%ebp),%eax
80102a83:	89 04 24             	mov    %eax,(%esp)
80102a86:	e8 26 00 00 00       	call   80102ab1 <freerange>
}
80102a8b:	c9                   	leave  
80102a8c:	c3                   	ret    

80102a8d <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102a8d:	55                   	push   %ebp
80102a8e:	89 e5                	mov    %esp,%ebp
80102a90:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102a93:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a96:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a9a:	8b 45 08             	mov    0x8(%ebp),%eax
80102a9d:	89 04 24             	mov    %eax,(%esp)
80102aa0:	e8 0c 00 00 00       	call   80102ab1 <freerange>
  kmem.use_lock = 1;
80102aa5:	c7 05 f4 36 11 80 01 	movl   $0x1,0x801136f4
80102aac:	00 00 00 
}
80102aaf:	c9                   	leave  
80102ab0:	c3                   	ret    

80102ab1 <freerange>:

void
freerange(void *vstart, void *vend)
{
80102ab1:	55                   	push   %ebp
80102ab2:	89 e5                	mov    %esp,%ebp
80102ab4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102ab7:	8b 45 08             	mov    0x8(%ebp),%eax
80102aba:	05 ff 0f 00 00       	add    $0xfff,%eax
80102abf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102ac4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ac7:	eb 12                	jmp    80102adb <freerange+0x2a>
    kfree(p);
80102ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102acc:	89 04 24             	mov    %eax,(%esp)
80102acf:	e8 16 00 00 00       	call   80102aea <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ad4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ade:	05 00 10 00 00       	add    $0x1000,%eax
80102ae3:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102ae6:	76 e1                	jbe    80102ac9 <freerange+0x18>
}
80102ae8:	c9                   	leave  
80102ae9:	c3                   	ret    

80102aea <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102aea:	55                   	push   %ebp
80102aeb:	89 e5                	mov    %esp,%ebp
80102aed:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102af0:	8b 45 08             	mov    0x8(%ebp),%eax
80102af3:	25 ff 0f 00 00       	and    $0xfff,%eax
80102af8:	85 c0                	test   %eax,%eax
80102afa:	75 18                	jne    80102b14 <kfree+0x2a>
80102afc:	81 7d 08 74 69 11 80 	cmpl   $0x80116974,0x8(%ebp)
80102b03:	72 0f                	jb     80102b14 <kfree+0x2a>
80102b05:	8b 45 08             	mov    0x8(%ebp),%eax
80102b08:	05 00 00 00 80       	add    $0x80000000,%eax
80102b0d:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b12:	76 0c                	jbe    80102b20 <kfree+0x36>
    panic("kfree");
80102b14:	c7 04 24 8b 85 10 80 	movl   $0x8010858b,(%esp)
80102b1b:	e8 42 da ff ff       	call   80100562 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b20:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102b27:	00 
80102b28:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102b2f:	00 
80102b30:	8b 45 08             	mov    0x8(%ebp),%eax
80102b33:	89 04 24             	mov    %eax,(%esp)
80102b36:	e8 7e 24 00 00       	call   80104fb9 <memset>

  if(kmem.use_lock)
80102b3b:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102b40:	85 c0                	test   %eax,%eax
80102b42:	74 0c                	je     80102b50 <kfree+0x66>
    acquire(&kmem.lock);
80102b44:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80102b4b:	e8 07 22 00 00       	call   80104d57 <acquire>
  r = (struct run*)v;
80102b50:	8b 45 08             	mov    0x8(%ebp),%eax
80102b53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102b56:	8b 15 f8 36 11 80    	mov    0x801136f8,%edx
80102b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b5f:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b64:	a3 f8 36 11 80       	mov    %eax,0x801136f8
  if(kmem.use_lock)
80102b69:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102b6e:	85 c0                	test   %eax,%eax
80102b70:	74 0c                	je     80102b7e <kfree+0x94>
    release(&kmem.lock);
80102b72:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80102b79:	e8 41 22 00 00       	call   80104dbf <release>
}
80102b7e:	c9                   	leave  
80102b7f:	c3                   	ret    

80102b80 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102b86:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102b8b:	85 c0                	test   %eax,%eax
80102b8d:	74 0c                	je     80102b9b <kalloc+0x1b>
    acquire(&kmem.lock);
80102b8f:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80102b96:	e8 bc 21 00 00       	call   80104d57 <acquire>
  r = kmem.freelist;
80102b9b:	a1 f8 36 11 80       	mov    0x801136f8,%eax
80102ba0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102ba3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102ba7:	74 0a                	je     80102bb3 <kalloc+0x33>
    kmem.freelist = r->next;
80102ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bac:	8b 00                	mov    (%eax),%eax
80102bae:	a3 f8 36 11 80       	mov    %eax,0x801136f8
  if(kmem.use_lock)
80102bb3:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102bb8:	85 c0                	test   %eax,%eax
80102bba:	74 0c                	je     80102bc8 <kalloc+0x48>
    release(&kmem.lock);
80102bbc:	c7 04 24 c0 36 11 80 	movl   $0x801136c0,(%esp)
80102bc3:	e8 f7 21 00 00       	call   80104dbf <release>
  return (char*)r;
80102bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102bcb:	c9                   	leave  
80102bcc:	c3                   	ret    

80102bcd <inb>:
{
80102bcd:	55                   	push   %ebp
80102bce:	89 e5                	mov    %esp,%ebp
80102bd0:	83 ec 14             	sub    $0x14,%esp
80102bd3:	8b 45 08             	mov    0x8(%ebp),%eax
80102bd6:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bda:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102bde:	89 c2                	mov    %eax,%edx
80102be0:	ec                   	in     (%dx),%al
80102be1:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102be4:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102be8:	c9                   	leave  
80102be9:	c3                   	ret    

80102bea <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102bea:	55                   	push   %ebp
80102beb:	89 e5                	mov    %esp,%ebp
80102bed:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102bf0:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102bf7:	e8 d1 ff ff ff       	call   80102bcd <inb>
80102bfc:	0f b6 c0             	movzbl %al,%eax
80102bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c05:	83 e0 01             	and    $0x1,%eax
80102c08:	85 c0                	test   %eax,%eax
80102c0a:	75 0a                	jne    80102c16 <kbdgetc+0x2c>
    return -1;
80102c0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c11:	e9 25 01 00 00       	jmp    80102d3b <kbdgetc+0x151>
  data = inb(KBDATAP);
80102c16:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102c1d:	e8 ab ff ff ff       	call   80102bcd <inb>
80102c22:	0f b6 c0             	movzbl %al,%eax
80102c25:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102c28:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102c2f:	75 17                	jne    80102c48 <kbdgetc+0x5e>
    shift |= E0ESC;
80102c31:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102c36:	83 c8 40             	or     $0x40,%eax
80102c39:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
    return 0;
80102c3e:	b8 00 00 00 00       	mov    $0x0,%eax
80102c43:	e9 f3 00 00 00       	jmp    80102d3b <kbdgetc+0x151>
  } else if(data & 0x80){
80102c48:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c4b:	25 80 00 00 00       	and    $0x80,%eax
80102c50:	85 c0                	test   %eax,%eax
80102c52:	74 45                	je     80102c99 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102c54:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102c59:	83 e0 40             	and    $0x40,%eax
80102c5c:	85 c0                	test   %eax,%eax
80102c5e:	75 08                	jne    80102c68 <kbdgetc+0x7e>
80102c60:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c63:	83 e0 7f             	and    $0x7f,%eax
80102c66:	eb 03                	jmp    80102c6b <kbdgetc+0x81>
80102c68:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102c6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c71:	05 20 90 10 80       	add    $0x80109020,%eax
80102c76:	0f b6 00             	movzbl (%eax),%eax
80102c79:	83 c8 40             	or     $0x40,%eax
80102c7c:	0f b6 c0             	movzbl %al,%eax
80102c7f:	f7 d0                	not    %eax
80102c81:	89 c2                	mov    %eax,%edx
80102c83:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102c88:	21 d0                	and    %edx,%eax
80102c8a:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
    return 0;
80102c8f:	b8 00 00 00 00       	mov    $0x0,%eax
80102c94:	e9 a2 00 00 00       	jmp    80102d3b <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102c99:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102c9e:	83 e0 40             	and    $0x40,%eax
80102ca1:	85 c0                	test   %eax,%eax
80102ca3:	74 14                	je     80102cb9 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102ca5:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102cac:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102cb1:	83 e0 bf             	and    $0xffffffbf,%eax
80102cb4:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
  }

  shift |= shiftcode[data];
80102cb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cbc:	05 20 90 10 80       	add    $0x80109020,%eax
80102cc1:	0f b6 00             	movzbl (%eax),%eax
80102cc4:	0f b6 d0             	movzbl %al,%edx
80102cc7:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102ccc:	09 d0                	or     %edx,%eax
80102cce:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
  shift ^= togglecode[data];
80102cd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cd6:	05 20 91 10 80       	add    $0x80109120,%eax
80102cdb:	0f b6 00             	movzbl (%eax),%eax
80102cde:	0f b6 d0             	movzbl %al,%edx
80102ce1:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102ce6:	31 d0                	xor    %edx,%eax
80102ce8:	a3 1c b6 10 80       	mov    %eax,0x8010b61c
  c = charcode[shift & (CTL | SHIFT)][data];
80102ced:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102cf2:	83 e0 03             	and    $0x3,%eax
80102cf5:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102cfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cff:	01 d0                	add    %edx,%eax
80102d01:	0f b6 00             	movzbl (%eax),%eax
80102d04:	0f b6 c0             	movzbl %al,%eax
80102d07:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102d0a:	a1 1c b6 10 80       	mov    0x8010b61c,%eax
80102d0f:	83 e0 08             	and    $0x8,%eax
80102d12:	85 c0                	test   %eax,%eax
80102d14:	74 22                	je     80102d38 <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102d16:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102d1a:	76 0c                	jbe    80102d28 <kbdgetc+0x13e>
80102d1c:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102d20:	77 06                	ja     80102d28 <kbdgetc+0x13e>
      c += 'A' - 'a';
80102d22:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102d26:	eb 10                	jmp    80102d38 <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102d28:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102d2c:	76 0a                	jbe    80102d38 <kbdgetc+0x14e>
80102d2e:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102d32:	77 04                	ja     80102d38 <kbdgetc+0x14e>
      c += 'a' - 'A';
80102d34:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102d38:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d3b:	c9                   	leave  
80102d3c:	c3                   	ret    

80102d3d <kbdintr>:

void
kbdintr(void)
{
80102d3d:	55                   	push   %ebp
80102d3e:	89 e5                	mov    %esp,%ebp
80102d40:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102d43:	c7 04 24 ea 2b 10 80 	movl   $0x80102bea,(%esp)
80102d4a:	e8 9a da ff ff       	call   801007e9 <consoleintr>
}
80102d4f:	c9                   	leave  
80102d50:	c3                   	ret    

80102d51 <inb>:
{
80102d51:	55                   	push   %ebp
80102d52:	89 e5                	mov    %esp,%ebp
80102d54:	83 ec 14             	sub    $0x14,%esp
80102d57:	8b 45 08             	mov    0x8(%ebp),%eax
80102d5a:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d5e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102d62:	89 c2                	mov    %eax,%edx
80102d64:	ec                   	in     (%dx),%al
80102d65:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102d68:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102d6c:	c9                   	leave  
80102d6d:	c3                   	ret    

80102d6e <outb>:
{
80102d6e:	55                   	push   %ebp
80102d6f:	89 e5                	mov    %esp,%ebp
80102d71:	83 ec 08             	sub    $0x8,%esp
80102d74:	8b 55 08             	mov    0x8(%ebp),%edx
80102d77:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d7a:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102d7e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d81:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102d85:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102d89:	ee                   	out    %al,(%dx)
}
80102d8a:	c9                   	leave  
80102d8b:	c3                   	ret    

80102d8c <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80102d8c:	55                   	push   %ebp
80102d8d:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102d8f:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102d94:	8b 55 08             	mov    0x8(%ebp),%edx
80102d97:	c1 e2 02             	shl    $0x2,%edx
80102d9a:	01 c2                	add    %eax,%edx
80102d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d9f:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102da1:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102da6:	83 c0 20             	add    $0x20,%eax
80102da9:	8b 00                	mov    (%eax),%eax
}
80102dab:	5d                   	pop    %ebp
80102dac:	c3                   	ret    

80102dad <lapicinit>:

void
lapicinit(void)
{
80102dad:	55                   	push   %ebp
80102dae:	89 e5                	mov    %esp,%ebp
80102db0:	83 ec 08             	sub    $0x8,%esp
  if(!lapic)
80102db3:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102db8:	85 c0                	test   %eax,%eax
80102dba:	75 05                	jne    80102dc1 <lapicinit+0x14>
    return;
80102dbc:	e9 43 01 00 00       	jmp    80102f04 <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102dc1:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102dc8:	00 
80102dc9:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102dd0:	e8 b7 ff ff ff       	call   80102d8c <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102dd5:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102ddc:	00 
80102ddd:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102de4:	e8 a3 ff ff ff       	call   80102d8c <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102de9:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102df0:	00 
80102df1:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102df8:	e8 8f ff ff ff       	call   80102d8c <lapicw>
  lapicw(TICR, 10000000);
80102dfd:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102e04:	00 
80102e05:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102e0c:	e8 7b ff ff ff       	call   80102d8c <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102e11:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e18:	00 
80102e19:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102e20:	e8 67 ff ff ff       	call   80102d8c <lapicw>
  lapicw(LINT1, MASKED);
80102e25:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e2c:	00 
80102e2d:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102e34:	e8 53 ff ff ff       	call   80102d8c <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e39:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102e3e:	83 c0 30             	add    $0x30,%eax
80102e41:	8b 00                	mov    (%eax),%eax
80102e43:	c1 e8 10             	shr    $0x10,%eax
80102e46:	0f b6 c0             	movzbl %al,%eax
80102e49:	83 f8 03             	cmp    $0x3,%eax
80102e4c:	76 14                	jbe    80102e62 <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102e4e:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e55:	00 
80102e56:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102e5d:	e8 2a ff ff ff       	call   80102d8c <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102e62:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102e69:	00 
80102e6a:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102e71:	e8 16 ff ff ff       	call   80102d8c <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102e76:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e7d:	00 
80102e7e:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e85:	e8 02 ff ff ff       	call   80102d8c <lapicw>
  lapicw(ESR, 0);
80102e8a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e91:	00 
80102e92:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e99:	e8 ee fe ff ff       	call   80102d8c <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102e9e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ea5:	00 
80102ea6:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102ead:	e8 da fe ff ff       	call   80102d8c <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102eb2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eb9:	00 
80102eba:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102ec1:	e8 c6 fe ff ff       	call   80102d8c <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102ec6:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102ecd:	00 
80102ece:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102ed5:	e8 b2 fe ff ff       	call   80102d8c <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102eda:	90                   	nop
80102edb:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102ee0:	05 00 03 00 00       	add    $0x300,%eax
80102ee5:	8b 00                	mov    (%eax),%eax
80102ee7:	25 00 10 00 00       	and    $0x1000,%eax
80102eec:	85 c0                	test   %eax,%eax
80102eee:	75 eb                	jne    80102edb <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102ef0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ef7:	00 
80102ef8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102eff:	e8 88 fe ff ff       	call   80102d8c <lapicw>
}
80102f04:	c9                   	leave  
80102f05:	c3                   	ret    

80102f06 <lapicid>:

int
lapicid(void)
{
80102f06:	55                   	push   %ebp
80102f07:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102f09:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102f0e:	85 c0                	test   %eax,%eax
80102f10:	75 07                	jne    80102f19 <lapicid+0x13>
    return 0;
80102f12:	b8 00 00 00 00       	mov    $0x0,%eax
80102f17:	eb 0d                	jmp    80102f26 <lapicid+0x20>
  return lapic[ID] >> 24;
80102f19:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102f1e:	83 c0 20             	add    $0x20,%eax
80102f21:	8b 00                	mov    (%eax),%eax
80102f23:	c1 e8 18             	shr    $0x18,%eax
}
80102f26:	5d                   	pop    %ebp
80102f27:	c3                   	ret    

80102f28 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f28:	55                   	push   %ebp
80102f29:	89 e5                	mov    %esp,%ebp
80102f2b:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102f2e:	a1 fc 36 11 80       	mov    0x801136fc,%eax
80102f33:	85 c0                	test   %eax,%eax
80102f35:	74 14                	je     80102f4b <lapiceoi+0x23>
    lapicw(EOI, 0);
80102f37:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f3e:	00 
80102f3f:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f46:	e8 41 fe ff ff       	call   80102d8c <lapicw>
}
80102f4b:	c9                   	leave  
80102f4c:	c3                   	ret    

80102f4d <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f4d:	55                   	push   %ebp
80102f4e:	89 e5                	mov    %esp,%ebp
}
80102f50:	5d                   	pop    %ebp
80102f51:	c3                   	ret    

80102f52 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f52:	55                   	push   %ebp
80102f53:	89 e5                	mov    %esp,%ebp
80102f55:	83 ec 1c             	sub    $0x1c,%esp
80102f58:	8b 45 08             	mov    0x8(%ebp),%eax
80102f5b:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102f5e:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102f65:	00 
80102f66:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102f6d:	e8 fc fd ff ff       	call   80102d6e <outb>
  outb(CMOS_PORT+1, 0x0A);
80102f72:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102f79:	00 
80102f7a:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102f81:	e8 e8 fd ff ff       	call   80102d6e <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102f86:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102f8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f90:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f95:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f98:	8d 50 02             	lea    0x2(%eax),%edx
80102f9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f9e:	c1 e8 04             	shr    $0x4,%eax
80102fa1:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102fa4:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fa8:	c1 e0 18             	shl    $0x18,%eax
80102fab:	89 44 24 04          	mov    %eax,0x4(%esp)
80102faf:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102fb6:	e8 d1 fd ff ff       	call   80102d8c <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102fbb:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102fc2:	00 
80102fc3:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fca:	e8 bd fd ff ff       	call   80102d8c <lapicw>
  microdelay(200);
80102fcf:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102fd6:	e8 72 ff ff ff       	call   80102f4d <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80102fdb:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80102fe2:	00 
80102fe3:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fea:	e8 9d fd ff ff       	call   80102d8c <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102fef:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102ff6:	e8 52 ff ff ff       	call   80102f4d <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102ffb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103002:	eb 40                	jmp    80103044 <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80103004:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103008:	c1 e0 18             	shl    $0x18,%eax
8010300b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010300f:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80103016:	e8 71 fd ff ff       	call   80102d8c <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
8010301b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010301e:	c1 e8 0c             	shr    $0xc,%eax
80103021:	80 cc 06             	or     $0x6,%ah
80103024:	89 44 24 04          	mov    %eax,0x4(%esp)
80103028:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
8010302f:	e8 58 fd ff ff       	call   80102d8c <lapicw>
    microdelay(200);
80103034:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010303b:	e8 0d ff ff ff       	call   80102f4d <microdelay>
  for(i = 0; i < 2; i++){
80103040:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103044:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103048:	7e ba                	jle    80103004 <lapicstartap+0xb2>
  }
}
8010304a:	c9                   	leave  
8010304b:	c3                   	ret    

8010304c <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
8010304c:	55                   	push   %ebp
8010304d:	89 e5                	mov    %esp,%ebp
8010304f:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
80103052:	8b 45 08             	mov    0x8(%ebp),%eax
80103055:	0f b6 c0             	movzbl %al,%eax
80103058:	89 44 24 04          	mov    %eax,0x4(%esp)
8010305c:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80103063:	e8 06 fd ff ff       	call   80102d6e <outb>
  microdelay(200);
80103068:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010306f:	e8 d9 fe ff ff       	call   80102f4d <microdelay>

  return inb(CMOS_RETURN);
80103074:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
8010307b:	e8 d1 fc ff ff       	call   80102d51 <inb>
80103080:	0f b6 c0             	movzbl %al,%eax
}
80103083:	c9                   	leave  
80103084:	c3                   	ret    

80103085 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103085:	55                   	push   %ebp
80103086:	89 e5                	mov    %esp,%ebp
80103088:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
8010308b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80103092:	e8 b5 ff ff ff       	call   8010304c <cmos_read>
80103097:	8b 55 08             	mov    0x8(%ebp),%edx
8010309a:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
8010309c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801030a3:	e8 a4 ff ff ff       	call   8010304c <cmos_read>
801030a8:	8b 55 08             	mov    0x8(%ebp),%edx
801030ab:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
801030ae:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801030b5:	e8 92 ff ff ff       	call   8010304c <cmos_read>
801030ba:	8b 55 08             	mov    0x8(%ebp),%edx
801030bd:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
801030c0:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
801030c7:	e8 80 ff ff ff       	call   8010304c <cmos_read>
801030cc:	8b 55 08             	mov    0x8(%ebp),%edx
801030cf:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
801030d2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801030d9:	e8 6e ff ff ff       	call   8010304c <cmos_read>
801030de:	8b 55 08             	mov    0x8(%ebp),%edx
801030e1:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
801030e4:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
801030eb:	e8 5c ff ff ff       	call   8010304c <cmos_read>
801030f0:	8b 55 08             	mov    0x8(%ebp),%edx
801030f3:	89 42 14             	mov    %eax,0x14(%edx)
}
801030f6:	c9                   	leave  
801030f7:	c3                   	ret    

801030f8 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801030f8:	55                   	push   %ebp
801030f9:	89 e5                	mov    %esp,%ebp
801030fb:	83 ec 58             	sub    $0x58,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801030fe:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
80103105:	e8 42 ff ff ff       	call   8010304c <cmos_read>
8010310a:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
8010310d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103110:	83 e0 04             	and    $0x4,%eax
80103113:	85 c0                	test   %eax,%eax
80103115:	0f 94 c0             	sete   %al
80103118:	0f b6 c0             	movzbl %al,%eax
8010311b:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010311e:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103121:	89 04 24             	mov    %eax,(%esp)
80103124:	e8 5c ff ff ff       	call   80103085 <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103129:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80103130:	e8 17 ff ff ff       	call   8010304c <cmos_read>
80103135:	25 80 00 00 00       	and    $0x80,%eax
8010313a:	85 c0                	test   %eax,%eax
8010313c:	74 02                	je     80103140 <cmostime+0x48>
        continue;
8010313e:	eb 36                	jmp    80103176 <cmostime+0x7e>
    fill_rtcdate(&t2);
80103140:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103143:	89 04 24             	mov    %eax,(%esp)
80103146:	e8 3a ff ff ff       	call   80103085 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010314b:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80103152:	00 
80103153:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103156:	89 44 24 04          	mov    %eax,0x4(%esp)
8010315a:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010315d:	89 04 24             	mov    %eax,(%esp)
80103160:	e8 cb 1e 00 00       	call   80105030 <memcmp>
80103165:	85 c0                	test   %eax,%eax
80103167:	75 0d                	jne    80103176 <cmostime+0x7e>
      break;
80103169:	90                   	nop
  }

  // convert
  if(bcd) {
8010316a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010316e:	0f 84 ac 00 00 00    	je     80103220 <cmostime+0x128>
80103174:	eb 02                	jmp    80103178 <cmostime+0x80>
  }
80103176:	eb a6                	jmp    8010311e <cmostime+0x26>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103178:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010317b:	c1 e8 04             	shr    $0x4,%eax
8010317e:	89 c2                	mov    %eax,%edx
80103180:	89 d0                	mov    %edx,%eax
80103182:	c1 e0 02             	shl    $0x2,%eax
80103185:	01 d0                	add    %edx,%eax
80103187:	01 c0                	add    %eax,%eax
80103189:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010318c:	83 e2 0f             	and    $0xf,%edx
8010318f:	01 d0                	add    %edx,%eax
80103191:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103194:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103197:	c1 e8 04             	shr    $0x4,%eax
8010319a:	89 c2                	mov    %eax,%edx
8010319c:	89 d0                	mov    %edx,%eax
8010319e:	c1 e0 02             	shl    $0x2,%eax
801031a1:	01 d0                	add    %edx,%eax
801031a3:	01 c0                	add    %eax,%eax
801031a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
801031a8:	83 e2 0f             	and    $0xf,%edx
801031ab:	01 d0                	add    %edx,%eax
801031ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801031b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801031b3:	c1 e8 04             	shr    $0x4,%eax
801031b6:	89 c2                	mov    %eax,%edx
801031b8:	89 d0                	mov    %edx,%eax
801031ba:	c1 e0 02             	shl    $0x2,%eax
801031bd:	01 d0                	add    %edx,%eax
801031bf:	01 c0                	add    %eax,%eax
801031c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
801031c4:	83 e2 0f             	and    $0xf,%edx
801031c7:	01 d0                	add    %edx,%eax
801031c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801031cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031cf:	c1 e8 04             	shr    $0x4,%eax
801031d2:	89 c2                	mov    %eax,%edx
801031d4:	89 d0                	mov    %edx,%eax
801031d6:	c1 e0 02             	shl    $0x2,%eax
801031d9:	01 d0                	add    %edx,%eax
801031db:	01 c0                	add    %eax,%eax
801031dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801031e0:	83 e2 0f             	and    $0xf,%edx
801031e3:	01 d0                	add    %edx,%eax
801031e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801031e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801031eb:	c1 e8 04             	shr    $0x4,%eax
801031ee:	89 c2                	mov    %eax,%edx
801031f0:	89 d0                	mov    %edx,%eax
801031f2:	c1 e0 02             	shl    $0x2,%eax
801031f5:	01 d0                	add    %edx,%eax
801031f7:	01 c0                	add    %eax,%eax
801031f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
801031fc:	83 e2 0f             	and    $0xf,%edx
801031ff:	01 d0                	add    %edx,%eax
80103201:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103204:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103207:	c1 e8 04             	shr    $0x4,%eax
8010320a:	89 c2                	mov    %eax,%edx
8010320c:	89 d0                	mov    %edx,%eax
8010320e:	c1 e0 02             	shl    $0x2,%eax
80103211:	01 d0                	add    %edx,%eax
80103213:	01 c0                	add    %eax,%eax
80103215:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103218:	83 e2 0f             	and    $0xf,%edx
8010321b:	01 d0                	add    %edx,%eax
8010321d:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103220:	8b 45 08             	mov    0x8(%ebp),%eax
80103223:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103226:	89 10                	mov    %edx,(%eax)
80103228:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010322b:	89 50 04             	mov    %edx,0x4(%eax)
8010322e:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103231:	89 50 08             	mov    %edx,0x8(%eax)
80103234:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103237:	89 50 0c             	mov    %edx,0xc(%eax)
8010323a:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010323d:	89 50 10             	mov    %edx,0x10(%eax)
80103240:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103243:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103246:	8b 45 08             	mov    0x8(%ebp),%eax
80103249:	8b 40 14             	mov    0x14(%eax),%eax
8010324c:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103252:	8b 45 08             	mov    0x8(%ebp),%eax
80103255:	89 50 14             	mov    %edx,0x14(%eax)
}
80103258:	c9                   	leave  
80103259:	c3                   	ret    

8010325a <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
8010325a:	55                   	push   %ebp
8010325b:	89 e5                	mov    %esp,%ebp
8010325d:	83 ec 38             	sub    $0x38,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103260:	c7 44 24 04 91 85 10 	movl   $0x80108591,0x4(%esp)
80103267:	80 
80103268:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
8010326f:	e8 c2 1a 00 00       	call   80104d36 <initlock>
  readsb(dev, &sb);
80103274:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103277:	89 44 24 04          	mov    %eax,0x4(%esp)
8010327b:	8b 45 08             	mov    0x8(%ebp),%eax
8010327e:	89 04 24             	mov    %eax,(%esp)
80103281:	e8 a1 e0 ff ff       	call   80101327 <readsb>
  log.start = sb.logstart;
80103286:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103289:	a3 34 37 11 80       	mov    %eax,0x80113734
  log.size = sb.nlog;
8010328e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103291:	a3 38 37 11 80       	mov    %eax,0x80113738
  log.dev = dev;
80103296:	8b 45 08             	mov    0x8(%ebp),%eax
80103299:	a3 44 37 11 80       	mov    %eax,0x80113744
  recover_from_log();
8010329e:	e8 9a 01 00 00       	call   8010343d <recover_from_log>
}
801032a3:	c9                   	leave  
801032a4:	c3                   	ret    

801032a5 <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801032a5:	55                   	push   %ebp
801032a6:	89 e5                	mov    %esp,%ebp
801032a8:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801032ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032b2:	e9 8c 00 00 00       	jmp    80103343 <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801032b7:	8b 15 34 37 11 80    	mov    0x80113734,%edx
801032bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032c0:	01 d0                	add    %edx,%eax
801032c2:	83 c0 01             	add    $0x1,%eax
801032c5:	89 c2                	mov    %eax,%edx
801032c7:	a1 44 37 11 80       	mov    0x80113744,%eax
801032cc:	89 54 24 04          	mov    %edx,0x4(%esp)
801032d0:	89 04 24             	mov    %eax,(%esp)
801032d3:	e8 dd ce ff ff       	call   801001b5 <bread>
801032d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801032db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032de:	83 c0 10             	add    $0x10,%eax
801032e1:	8b 04 85 0c 37 11 80 	mov    -0x7feec8f4(,%eax,4),%eax
801032e8:	89 c2                	mov    %eax,%edx
801032ea:	a1 44 37 11 80       	mov    0x80113744,%eax
801032ef:	89 54 24 04          	mov    %edx,0x4(%esp)
801032f3:	89 04 24             	mov    %eax,(%esp)
801032f6:	e8 ba ce ff ff       	call   801001b5 <bread>
801032fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801032fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103301:	8d 50 5c             	lea    0x5c(%eax),%edx
80103304:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103307:	83 c0 5c             	add    $0x5c,%eax
8010330a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103311:	00 
80103312:	89 54 24 04          	mov    %edx,0x4(%esp)
80103316:	89 04 24             	mov    %eax,(%esp)
80103319:	e8 6a 1d 00 00       	call   80105088 <memmove>
    bwrite(dbuf);  // write dst to disk
8010331e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103321:	89 04 24             	mov    %eax,(%esp)
80103324:	e8 c3 ce ff ff       	call   801001ec <bwrite>
    brelse(lbuf);
80103329:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010332c:	89 04 24             	mov    %eax,(%esp)
8010332f:	e8 f8 ce ff ff       	call   8010022c <brelse>
    brelse(dbuf);
80103334:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103337:	89 04 24             	mov    %eax,(%esp)
8010333a:	e8 ed ce ff ff       	call   8010022c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
8010333f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103343:	a1 48 37 11 80       	mov    0x80113748,%eax
80103348:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010334b:	0f 8f 66 ff ff ff    	jg     801032b7 <install_trans+0x12>
  }
}
80103351:	c9                   	leave  
80103352:	c3                   	ret    

80103353 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103353:	55                   	push   %ebp
80103354:	89 e5                	mov    %esp,%ebp
80103356:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103359:	a1 34 37 11 80       	mov    0x80113734,%eax
8010335e:	89 c2                	mov    %eax,%edx
80103360:	a1 44 37 11 80       	mov    0x80113744,%eax
80103365:	89 54 24 04          	mov    %edx,0x4(%esp)
80103369:	89 04 24             	mov    %eax,(%esp)
8010336c:	e8 44 ce ff ff       	call   801001b5 <bread>
80103371:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103374:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103377:	83 c0 5c             	add    $0x5c,%eax
8010337a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
8010337d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103380:	8b 00                	mov    (%eax),%eax
80103382:	a3 48 37 11 80       	mov    %eax,0x80113748
  for (i = 0; i < log.lh.n; i++) {
80103387:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010338e:	eb 1b                	jmp    801033ab <read_head+0x58>
    log.lh.block[i] = lh->block[i];
80103390:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103393:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103396:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010339a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010339d:	83 c2 10             	add    $0x10,%edx
801033a0:	89 04 95 0c 37 11 80 	mov    %eax,-0x7feec8f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801033a7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033ab:	a1 48 37 11 80       	mov    0x80113748,%eax
801033b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033b3:	7f db                	jg     80103390 <read_head+0x3d>
  }
  brelse(buf);
801033b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033b8:	89 04 24             	mov    %eax,(%esp)
801033bb:	e8 6c ce ff ff       	call   8010022c <brelse>
}
801033c0:	c9                   	leave  
801033c1:	c3                   	ret    

801033c2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801033c2:	55                   	push   %ebp
801033c3:	89 e5                	mov    %esp,%ebp
801033c5:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801033c8:	a1 34 37 11 80       	mov    0x80113734,%eax
801033cd:	89 c2                	mov    %eax,%edx
801033cf:	a1 44 37 11 80       	mov    0x80113744,%eax
801033d4:	89 54 24 04          	mov    %edx,0x4(%esp)
801033d8:	89 04 24             	mov    %eax,(%esp)
801033db:	e8 d5 cd ff ff       	call   801001b5 <bread>
801033e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801033e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033e6:	83 c0 5c             	add    $0x5c,%eax
801033e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801033ec:	8b 15 48 37 11 80    	mov    0x80113748,%edx
801033f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033f5:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801033f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033fe:	eb 1b                	jmp    8010341b <write_head+0x59>
    hb->block[i] = log.lh.block[i];
80103400:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103403:	83 c0 10             	add    $0x10,%eax
80103406:	8b 0c 85 0c 37 11 80 	mov    -0x7feec8f4(,%eax,4),%ecx
8010340d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103410:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103413:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103417:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010341b:	a1 48 37 11 80       	mov    0x80113748,%eax
80103420:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103423:	7f db                	jg     80103400 <write_head+0x3e>
  }
  bwrite(buf);
80103425:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103428:	89 04 24             	mov    %eax,(%esp)
8010342b:	e8 bc cd ff ff       	call   801001ec <bwrite>
  brelse(buf);
80103430:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103433:	89 04 24             	mov    %eax,(%esp)
80103436:	e8 f1 cd ff ff       	call   8010022c <brelse>
}
8010343b:	c9                   	leave  
8010343c:	c3                   	ret    

8010343d <recover_from_log>:

static void
recover_from_log(void)
{
8010343d:	55                   	push   %ebp
8010343e:	89 e5                	mov    %esp,%ebp
80103440:	83 ec 08             	sub    $0x8,%esp
  read_head();
80103443:	e8 0b ff ff ff       	call   80103353 <read_head>
  install_trans(); // if committed, copy from log to disk
80103448:	e8 58 fe ff ff       	call   801032a5 <install_trans>
  log.lh.n = 0;
8010344d:	c7 05 48 37 11 80 00 	movl   $0x0,0x80113748
80103454:	00 00 00 
  write_head(); // clear the log
80103457:	e8 66 ff ff ff       	call   801033c2 <write_head>
}
8010345c:	c9                   	leave  
8010345d:	c3                   	ret    

8010345e <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
8010345e:	55                   	push   %ebp
8010345f:	89 e5                	mov    %esp,%ebp
80103461:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80103464:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
8010346b:	e8 e7 18 00 00       	call   80104d57 <acquire>
  while(1){
    if(log.committing){
80103470:	a1 40 37 11 80       	mov    0x80113740,%eax
80103475:	85 c0                	test   %eax,%eax
80103477:	74 16                	je     8010348f <begin_op+0x31>
      sleep(&log, &log.lock);
80103479:	c7 44 24 04 00 37 11 	movl   $0x80113700,0x4(%esp)
80103480:	80 
80103481:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
80103488:	e8 ff 14 00 00       	call   8010498c <sleep>
8010348d:	eb 4f                	jmp    801034de <begin_op+0x80>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010348f:	8b 0d 48 37 11 80    	mov    0x80113748,%ecx
80103495:	a1 3c 37 11 80       	mov    0x8011373c,%eax
8010349a:	8d 50 01             	lea    0x1(%eax),%edx
8010349d:	89 d0                	mov    %edx,%eax
8010349f:	c1 e0 02             	shl    $0x2,%eax
801034a2:	01 d0                	add    %edx,%eax
801034a4:	01 c0                	add    %eax,%eax
801034a6:	01 c8                	add    %ecx,%eax
801034a8:	83 f8 1e             	cmp    $0x1e,%eax
801034ab:	7e 16                	jle    801034c3 <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801034ad:	c7 44 24 04 00 37 11 	movl   $0x80113700,0x4(%esp)
801034b4:	80 
801034b5:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
801034bc:	e8 cb 14 00 00       	call   8010498c <sleep>
801034c1:	eb 1b                	jmp    801034de <begin_op+0x80>
    } else {
      log.outstanding += 1;
801034c3:	a1 3c 37 11 80       	mov    0x8011373c,%eax
801034c8:	83 c0 01             	add    $0x1,%eax
801034cb:	a3 3c 37 11 80       	mov    %eax,0x8011373c
      release(&log.lock);
801034d0:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
801034d7:	e8 e3 18 00 00       	call   80104dbf <release>
      break;
801034dc:	eb 02                	jmp    801034e0 <begin_op+0x82>
    }
  }
801034de:	eb 90                	jmp    80103470 <begin_op+0x12>
}
801034e0:	c9                   	leave  
801034e1:	c3                   	ret    

801034e2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801034e2:	55                   	push   %ebp
801034e3:	89 e5                	mov    %esp,%ebp
801034e5:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
801034e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801034ef:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
801034f6:	e8 5c 18 00 00       	call   80104d57 <acquire>
  log.outstanding -= 1;
801034fb:	a1 3c 37 11 80       	mov    0x8011373c,%eax
80103500:	83 e8 01             	sub    $0x1,%eax
80103503:	a3 3c 37 11 80       	mov    %eax,0x8011373c
  if(log.committing)
80103508:	a1 40 37 11 80       	mov    0x80113740,%eax
8010350d:	85 c0                	test   %eax,%eax
8010350f:	74 0c                	je     8010351d <end_op+0x3b>
    panic("log.committing");
80103511:	c7 04 24 95 85 10 80 	movl   $0x80108595,(%esp)
80103518:	e8 45 d0 ff ff       	call   80100562 <panic>
  if(log.outstanding == 0){
8010351d:	a1 3c 37 11 80       	mov    0x8011373c,%eax
80103522:	85 c0                	test   %eax,%eax
80103524:	75 13                	jne    80103539 <end_op+0x57>
    do_commit = 1;
80103526:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
8010352d:	c7 05 40 37 11 80 01 	movl   $0x1,0x80113740
80103534:	00 00 00 
80103537:	eb 0c                	jmp    80103545 <end_op+0x63>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80103539:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
80103540:	e8 1b 15 00 00       	call   80104a60 <wakeup>
  }
  release(&log.lock);
80103545:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
8010354c:	e8 6e 18 00 00       	call   80104dbf <release>

  if(do_commit){
80103551:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103555:	74 33                	je     8010358a <end_op+0xa8>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103557:	e8 de 00 00 00       	call   8010363a <commit>
    acquire(&log.lock);
8010355c:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
80103563:	e8 ef 17 00 00       	call   80104d57 <acquire>
    log.committing = 0;
80103568:	c7 05 40 37 11 80 00 	movl   $0x0,0x80113740
8010356f:	00 00 00 
    wakeup(&log);
80103572:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
80103579:	e8 e2 14 00 00       	call   80104a60 <wakeup>
    release(&log.lock);
8010357e:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
80103585:	e8 35 18 00 00       	call   80104dbf <release>
  }
}
8010358a:	c9                   	leave  
8010358b:	c3                   	ret    

8010358c <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
8010358c:	55                   	push   %ebp
8010358d:	89 e5                	mov    %esp,%ebp
8010358f:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103592:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103599:	e9 8c 00 00 00       	jmp    8010362a <write_log+0x9e>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010359e:	8b 15 34 37 11 80    	mov    0x80113734,%edx
801035a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035a7:	01 d0                	add    %edx,%eax
801035a9:	83 c0 01             	add    $0x1,%eax
801035ac:	89 c2                	mov    %eax,%edx
801035ae:	a1 44 37 11 80       	mov    0x80113744,%eax
801035b3:	89 54 24 04          	mov    %edx,0x4(%esp)
801035b7:	89 04 24             	mov    %eax,(%esp)
801035ba:	e8 f6 cb ff ff       	call   801001b5 <bread>
801035bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801035c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035c5:	83 c0 10             	add    $0x10,%eax
801035c8:	8b 04 85 0c 37 11 80 	mov    -0x7feec8f4(,%eax,4),%eax
801035cf:	89 c2                	mov    %eax,%edx
801035d1:	a1 44 37 11 80       	mov    0x80113744,%eax
801035d6:	89 54 24 04          	mov    %edx,0x4(%esp)
801035da:	89 04 24             	mov    %eax,(%esp)
801035dd:	e8 d3 cb ff ff       	call   801001b5 <bread>
801035e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801035e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035e8:	8d 50 5c             	lea    0x5c(%eax),%edx
801035eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035ee:	83 c0 5c             	add    $0x5c,%eax
801035f1:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801035f8:	00 
801035f9:	89 54 24 04          	mov    %edx,0x4(%esp)
801035fd:	89 04 24             	mov    %eax,(%esp)
80103600:	e8 83 1a 00 00       	call   80105088 <memmove>
    bwrite(to);  // write the log
80103605:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103608:	89 04 24             	mov    %eax,(%esp)
8010360b:	e8 dc cb ff ff       	call   801001ec <bwrite>
    brelse(from);
80103610:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103613:	89 04 24             	mov    %eax,(%esp)
80103616:	e8 11 cc ff ff       	call   8010022c <brelse>
    brelse(to);
8010361b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010361e:	89 04 24             	mov    %eax,(%esp)
80103621:	e8 06 cc ff ff       	call   8010022c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103626:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010362a:	a1 48 37 11 80       	mov    0x80113748,%eax
8010362f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103632:	0f 8f 66 ff ff ff    	jg     8010359e <write_log+0x12>
  }
}
80103638:	c9                   	leave  
80103639:	c3                   	ret    

8010363a <commit>:

static void
commit()
{
8010363a:	55                   	push   %ebp
8010363b:	89 e5                	mov    %esp,%ebp
8010363d:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103640:	a1 48 37 11 80       	mov    0x80113748,%eax
80103645:	85 c0                	test   %eax,%eax
80103647:	7e 1e                	jle    80103667 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103649:	e8 3e ff ff ff       	call   8010358c <write_log>
    write_head();    // Write header to disk -- the real commit
8010364e:	e8 6f fd ff ff       	call   801033c2 <write_head>
    install_trans(); // Now install writes to home locations
80103653:	e8 4d fc ff ff       	call   801032a5 <install_trans>
    log.lh.n = 0;
80103658:	c7 05 48 37 11 80 00 	movl   $0x0,0x80113748
8010365f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103662:	e8 5b fd ff ff       	call   801033c2 <write_head>
  }
}
80103667:	c9                   	leave  
80103668:	c3                   	ret    

80103669 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103669:	55                   	push   %ebp
8010366a:	89 e5                	mov    %esp,%ebp
8010366c:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010366f:	a1 48 37 11 80       	mov    0x80113748,%eax
80103674:	83 f8 1d             	cmp    $0x1d,%eax
80103677:	7f 12                	jg     8010368b <log_write+0x22>
80103679:	a1 48 37 11 80       	mov    0x80113748,%eax
8010367e:	8b 15 38 37 11 80    	mov    0x80113738,%edx
80103684:	83 ea 01             	sub    $0x1,%edx
80103687:	39 d0                	cmp    %edx,%eax
80103689:	7c 0c                	jl     80103697 <log_write+0x2e>
    panic("too big a transaction");
8010368b:	c7 04 24 a4 85 10 80 	movl   $0x801085a4,(%esp)
80103692:	e8 cb ce ff ff       	call   80100562 <panic>
  if (log.outstanding < 1)
80103697:	a1 3c 37 11 80       	mov    0x8011373c,%eax
8010369c:	85 c0                	test   %eax,%eax
8010369e:	7f 0c                	jg     801036ac <log_write+0x43>
    panic("log_write outside of trans");
801036a0:	c7 04 24 ba 85 10 80 	movl   $0x801085ba,(%esp)
801036a7:	e8 b6 ce ff ff       	call   80100562 <panic>

  acquire(&log.lock);
801036ac:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
801036b3:	e8 9f 16 00 00       	call   80104d57 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801036b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036bf:	eb 1f                	jmp    801036e0 <log_write+0x77>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801036c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036c4:	83 c0 10             	add    $0x10,%eax
801036c7:	8b 04 85 0c 37 11 80 	mov    -0x7feec8f4(,%eax,4),%eax
801036ce:	89 c2                	mov    %eax,%edx
801036d0:	8b 45 08             	mov    0x8(%ebp),%eax
801036d3:	8b 40 08             	mov    0x8(%eax),%eax
801036d6:	39 c2                	cmp    %eax,%edx
801036d8:	75 02                	jne    801036dc <log_write+0x73>
      break;
801036da:	eb 0e                	jmp    801036ea <log_write+0x81>
  for (i = 0; i < log.lh.n; i++) {
801036dc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801036e0:	a1 48 37 11 80       	mov    0x80113748,%eax
801036e5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036e8:	7f d7                	jg     801036c1 <log_write+0x58>
  }
  log.lh.block[i] = b->blockno;
801036ea:	8b 45 08             	mov    0x8(%ebp),%eax
801036ed:	8b 40 08             	mov    0x8(%eax),%eax
801036f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801036f3:	83 c2 10             	add    $0x10,%edx
801036f6:	89 04 95 0c 37 11 80 	mov    %eax,-0x7feec8f4(,%edx,4)
  if (i == log.lh.n)
801036fd:	a1 48 37 11 80       	mov    0x80113748,%eax
80103702:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103705:	75 0d                	jne    80103714 <log_write+0xab>
    log.lh.n++;
80103707:	a1 48 37 11 80       	mov    0x80113748,%eax
8010370c:	83 c0 01             	add    $0x1,%eax
8010370f:	a3 48 37 11 80       	mov    %eax,0x80113748
  b->flags |= B_DIRTY; // prevent eviction
80103714:	8b 45 08             	mov    0x8(%ebp),%eax
80103717:	8b 00                	mov    (%eax),%eax
80103719:	83 c8 04             	or     $0x4,%eax
8010371c:	89 c2                	mov    %eax,%edx
8010371e:	8b 45 08             	mov    0x8(%ebp),%eax
80103721:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103723:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
8010372a:	e8 90 16 00 00       	call   80104dbf <release>
}
8010372f:	c9                   	leave  
80103730:	c3                   	ret    

80103731 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103731:	55                   	push   %ebp
80103732:	89 e5                	mov    %esp,%ebp
80103734:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103737:	8b 55 08             	mov    0x8(%ebp),%edx
8010373a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010373d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103740:	f0 87 02             	lock xchg %eax,(%edx)
80103743:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103746:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103749:	c9                   	leave  
8010374a:	c3                   	ret    

8010374b <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
8010374b:	55                   	push   %ebp
8010374c:	89 e5                	mov    %esp,%ebp
8010374e:	83 e4 f0             	and    $0xfffffff0,%esp
80103751:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103754:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
8010375b:	80 
8010375c:	c7 04 24 74 69 11 80 	movl   $0x80116974,(%esp)
80103763:	e8 ed f2 ff ff       	call   80102a55 <kinit1>
  kvmalloc();      // kernel page table
80103768:	e8 11 42 00 00       	call   8010797e <kvmalloc>
  mpinit();        // detect other processors
8010376d:	e8 d0 03 00 00       	call   80103b42 <mpinit>
  lapicinit();     // interrupt controller
80103772:	e8 36 f6 ff ff       	call   80102dad <lapicinit>
  seginit();       // segment descriptors
80103777:	e8 ce 3c 00 00       	call   8010744a <seginit>
  picinit();       // disable pic
8010377c:	e8 10 05 00 00       	call   80103c91 <picinit>
  ioapicinit();    // another interrupt controller
80103781:	e8 eb f1 ff ff       	call   80102971 <ioapicinit>
  consoleinit();   // console hardware
80103786:	e8 45 d3 ff ff       	call   80100ad0 <consoleinit>
  uartinit();      // serial port
8010378b:	e8 44 30 00 00       	call   801067d4 <uartinit>
  pinit();         // process table
80103790:	e8 f5 08 00 00       	call   8010408a <pinit>
  shminit();       // shared memory
80103795:	e8 e0 4a 00 00       	call   8010827a <shminit>
  tvinit();        // trap vectors
8010379a:	e8 fe 2b 00 00       	call   8010639d <tvinit>
  binit();         // buffer cache
8010379f:	e8 90 c8 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801037a4:	e8 97 d7 ff ff       	call   80100f40 <fileinit>
  ideinit();       // disk 
801037a9:	e8 cd ed ff ff       	call   8010257b <ideinit>
  startothers();   // start other processors
801037ae:	e8 83 00 00 00       	call   80103836 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801037b3:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
801037ba:	8e 
801037bb:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
801037c2:	e8 c6 f2 ff ff       	call   80102a8d <kinit2>
  userinit();      // first user process
801037c7:	e8 99 0a 00 00       	call   80104265 <userinit>
  mpmain();        // finish this processor's setup
801037cc:	e8 1a 00 00 00       	call   801037eb <mpmain>

801037d1 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801037d1:	55                   	push   %ebp
801037d2:	89 e5                	mov    %esp,%ebp
801037d4:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801037d7:	e8 b9 41 00 00       	call   80107995 <switchkvm>
  seginit();
801037dc:	e8 69 3c 00 00       	call   8010744a <seginit>
  lapicinit();
801037e1:	e8 c7 f5 ff ff       	call   80102dad <lapicinit>
  mpmain();
801037e6:	e8 00 00 00 00       	call   801037eb <mpmain>

801037eb <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801037eb:	55                   	push   %ebp
801037ec:	89 e5                	mov    %esp,%ebp
801037ee:	53                   	push   %ebx
801037ef:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801037f2:	e8 af 08 00 00       	call   801040a6 <cpuid>
801037f7:	89 c3                	mov    %eax,%ebx
801037f9:	e8 a8 08 00 00       	call   801040a6 <cpuid>
801037fe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80103802:	89 44 24 04          	mov    %eax,0x4(%esp)
80103806:	c7 04 24 d5 85 10 80 	movl   $0x801085d5,(%esp)
8010380d:	e8 b6 cb ff ff       	call   801003c8 <cprintf>
  idtinit();       // load idt register
80103812:	e8 fa 2c 00 00       	call   80106511 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103817:	e8 ab 08 00 00       	call   801040c7 <mycpu>
8010381c:	05 a0 00 00 00       	add    $0xa0,%eax
80103821:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80103828:	00 
80103829:	89 04 24             	mov    %eax,(%esp)
8010382c:	e8 00 ff ff ff       	call   80103731 <xchg>
  scheduler();     // start running processes
80103831:	e8 8c 0f 00 00       	call   801047c2 <scheduler>

80103836 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103836:	55                   	push   %ebp
80103837:	89 e5                	mov    %esp,%ebp
80103839:	83 ec 28             	sub    $0x28,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
8010383c:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103843:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103848:	89 44 24 08          	mov    %eax,0x8(%esp)
8010384c:	c7 44 24 04 ec b4 10 	movl   $0x8010b4ec,0x4(%esp)
80103853:	80 
80103854:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103857:	89 04 24             	mov    %eax,(%esp)
8010385a:	e8 29 18 00 00       	call   80105088 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010385f:	c7 45 f4 00 38 11 80 	movl   $0x80113800,-0xc(%ebp)
80103866:	eb 76                	jmp    801038de <startothers+0xa8>
    if(c == mycpu())  // We've started already.
80103868:	e8 5a 08 00 00       	call   801040c7 <mycpu>
8010386d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103870:	75 02                	jne    80103874 <startothers+0x3e>
      continue;
80103872:	eb 63                	jmp    801038d7 <startothers+0xa1>

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103874:	e8 07 f3 ff ff       	call   80102b80 <kalloc>
80103879:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
8010387c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010387f:	83 e8 04             	sub    $0x4,%eax
80103882:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103885:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010388b:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
8010388d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103890:	83 e8 08             	sub    $0x8,%eax
80103893:	c7 00 d1 37 10 80    	movl   $0x801037d1,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103899:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010389c:	8d 50 f4             	lea    -0xc(%eax),%edx
8010389f:	b8 00 a0 10 80       	mov    $0x8010a000,%eax
801038a4:	05 00 00 00 80       	add    $0x80000000,%eax
801038a9:	89 02                	mov    %eax,(%edx)

    lapicstartap(c->apicid, V2P(code));
801038ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038ae:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801038b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038b7:	0f b6 00             	movzbl (%eax),%eax
801038ba:	0f b6 c0             	movzbl %al,%eax
801038bd:	89 54 24 04          	mov    %edx,0x4(%esp)
801038c1:	89 04 24             	mov    %eax,(%esp)
801038c4:	e8 89 f6 ff ff       	call   80102f52 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801038c9:	90                   	nop
801038ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038cd:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
801038d3:	85 c0                	test   %eax,%eax
801038d5:	74 f3                	je     801038ca <startothers+0x94>
  for(c = cpus; c < cpus+ncpu; c++){
801038d7:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
801038de:	a1 80 3d 11 80       	mov    0x80113d80,%eax
801038e3:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801038e9:	05 00 38 11 80       	add    $0x80113800,%eax
801038ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038f1:	0f 87 71 ff ff ff    	ja     80103868 <startothers+0x32>
      ;
  }
}
801038f7:	c9                   	leave  
801038f8:	c3                   	ret    

801038f9 <inb>:
{
801038f9:	55                   	push   %ebp
801038fa:	89 e5                	mov    %esp,%ebp
801038fc:	83 ec 14             	sub    $0x14,%esp
801038ff:	8b 45 08             	mov    0x8(%ebp),%eax
80103902:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103906:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010390a:	89 c2                	mov    %eax,%edx
8010390c:	ec                   	in     (%dx),%al
8010390d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103910:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103914:	c9                   	leave  
80103915:	c3                   	ret    

80103916 <outb>:
{
80103916:	55                   	push   %ebp
80103917:	89 e5                	mov    %esp,%ebp
80103919:	83 ec 08             	sub    $0x8,%esp
8010391c:	8b 55 08             	mov    0x8(%ebp),%edx
8010391f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103922:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103926:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103929:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010392d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103931:	ee                   	out    %al,(%dx)
}
80103932:	c9                   	leave  
80103933:	c3                   	ret    

80103934 <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80103934:	55                   	push   %ebp
80103935:	89 e5                	mov    %esp,%ebp
80103937:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
8010393a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103941:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103948:	eb 15                	jmp    8010395f <sum+0x2b>
    sum += addr[i];
8010394a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010394d:	8b 45 08             	mov    0x8(%ebp),%eax
80103950:	01 d0                	add    %edx,%eax
80103952:	0f b6 00             	movzbl (%eax),%eax
80103955:	0f b6 c0             	movzbl %al,%eax
80103958:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
8010395b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010395f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103962:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103965:	7c e3                	jl     8010394a <sum+0x16>
  return sum;
80103967:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010396a:	c9                   	leave  
8010396b:	c3                   	ret    

8010396c <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010396c:	55                   	push   %ebp
8010396d:	89 e5                	mov    %esp,%ebp
8010396f:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103972:	8b 45 08             	mov    0x8(%ebp),%eax
80103975:	05 00 00 00 80       	add    $0x80000000,%eax
8010397a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
8010397d:	8b 55 0c             	mov    0xc(%ebp),%edx
80103980:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103983:	01 d0                	add    %edx,%eax
80103985:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103988:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010398b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010398e:	eb 3f                	jmp    801039cf <mpsearch1+0x63>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103990:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103997:	00 
80103998:	c7 44 24 04 ec 85 10 	movl   $0x801085ec,0x4(%esp)
8010399f:	80 
801039a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039a3:	89 04 24             	mov    %eax,(%esp)
801039a6:	e8 85 16 00 00       	call   80105030 <memcmp>
801039ab:	85 c0                	test   %eax,%eax
801039ad:	75 1c                	jne    801039cb <mpsearch1+0x5f>
801039af:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801039b6:	00 
801039b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039ba:	89 04 24             	mov    %eax,(%esp)
801039bd:	e8 72 ff ff ff       	call   80103934 <sum>
801039c2:	84 c0                	test   %al,%al
801039c4:	75 05                	jne    801039cb <mpsearch1+0x5f>
      return (struct mp*)p;
801039c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039c9:	eb 11                	jmp    801039dc <mpsearch1+0x70>
  for(p = addr; p < e; p += sizeof(struct mp))
801039cb:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801039cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039d2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801039d5:	72 b9                	jb     80103990 <mpsearch1+0x24>
  return 0;
801039d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801039dc:	c9                   	leave  
801039dd:	c3                   	ret    

801039de <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
801039de:	55                   	push   %ebp
801039df:	89 e5                	mov    %esp,%ebp
801039e1:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
801039e4:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801039eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039ee:	83 c0 0f             	add    $0xf,%eax
801039f1:	0f b6 00             	movzbl (%eax),%eax
801039f4:	0f b6 c0             	movzbl %al,%eax
801039f7:	c1 e0 08             	shl    $0x8,%eax
801039fa:	89 c2                	mov    %eax,%edx
801039fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039ff:	83 c0 0e             	add    $0xe,%eax
80103a02:	0f b6 00             	movzbl (%eax),%eax
80103a05:	0f b6 c0             	movzbl %al,%eax
80103a08:	09 d0                	or     %edx,%eax
80103a0a:	c1 e0 04             	shl    $0x4,%eax
80103a0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103a10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103a14:	74 21                	je     80103a37 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103a16:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103a1d:	00 
80103a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a21:	89 04 24             	mov    %eax,(%esp)
80103a24:	e8 43 ff ff ff       	call   8010396c <mpsearch1>
80103a29:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103a2c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103a30:	74 50                	je     80103a82 <mpsearch+0xa4>
      return mp;
80103a32:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a35:	eb 5f                	jmp    80103a96 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a3a:	83 c0 14             	add    $0x14,%eax
80103a3d:	0f b6 00             	movzbl (%eax),%eax
80103a40:	0f b6 c0             	movzbl %al,%eax
80103a43:	c1 e0 08             	shl    $0x8,%eax
80103a46:	89 c2                	mov    %eax,%edx
80103a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a4b:	83 c0 13             	add    $0x13,%eax
80103a4e:	0f b6 00             	movzbl (%eax),%eax
80103a51:	0f b6 c0             	movzbl %al,%eax
80103a54:	09 d0                	or     %edx,%eax
80103a56:	c1 e0 0a             	shl    $0xa,%eax
80103a59:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a5f:	2d 00 04 00 00       	sub    $0x400,%eax
80103a64:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103a6b:	00 
80103a6c:	89 04 24             	mov    %eax,(%esp)
80103a6f:	e8 f8 fe ff ff       	call   8010396c <mpsearch1>
80103a74:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103a77:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103a7b:	74 05                	je     80103a82 <mpsearch+0xa4>
      return mp;
80103a7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a80:	eb 14                	jmp    80103a96 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103a82:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103a89:	00 
80103a8a:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103a91:	e8 d6 fe ff ff       	call   8010396c <mpsearch1>
}
80103a96:	c9                   	leave  
80103a97:	c3                   	ret    

80103a98 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103a98:	55                   	push   %ebp
80103a99:	89 e5                	mov    %esp,%ebp
80103a9b:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103a9e:	e8 3b ff ff ff       	call   801039de <mpsearch>
80103aa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103aa6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103aaa:	74 0a                	je     80103ab6 <mpconfig+0x1e>
80103aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103aaf:	8b 40 04             	mov    0x4(%eax),%eax
80103ab2:	85 c0                	test   %eax,%eax
80103ab4:	75 0a                	jne    80103ac0 <mpconfig+0x28>
    return 0;
80103ab6:	b8 00 00 00 00       	mov    $0x0,%eax
80103abb:	e9 80 00 00 00       	jmp    80103b40 <mpconfig+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ac3:	8b 40 04             	mov    0x4(%eax),%eax
80103ac6:	05 00 00 00 80       	add    $0x80000000,%eax
80103acb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103ace:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103ad5:	00 
80103ad6:	c7 44 24 04 f1 85 10 	movl   $0x801085f1,0x4(%esp)
80103add:	80 
80103ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ae1:	89 04 24             	mov    %eax,(%esp)
80103ae4:	e8 47 15 00 00       	call   80105030 <memcmp>
80103ae9:	85 c0                	test   %eax,%eax
80103aeb:	74 07                	je     80103af4 <mpconfig+0x5c>
    return 0;
80103aed:	b8 00 00 00 00       	mov    $0x0,%eax
80103af2:	eb 4c                	jmp    80103b40 <mpconfig+0xa8>
  if(conf->version != 1 && conf->version != 4)
80103af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103af7:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103afb:	3c 01                	cmp    $0x1,%al
80103afd:	74 12                	je     80103b11 <mpconfig+0x79>
80103aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b02:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103b06:	3c 04                	cmp    $0x4,%al
80103b08:	74 07                	je     80103b11 <mpconfig+0x79>
    return 0;
80103b0a:	b8 00 00 00 00       	mov    $0x0,%eax
80103b0f:	eb 2f                	jmp    80103b40 <mpconfig+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b14:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103b18:	0f b7 c0             	movzwl %ax,%eax
80103b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b22:	89 04 24             	mov    %eax,(%esp)
80103b25:	e8 0a fe ff ff       	call   80103934 <sum>
80103b2a:	84 c0                	test   %al,%al
80103b2c:	74 07                	je     80103b35 <mpconfig+0x9d>
    return 0;
80103b2e:	b8 00 00 00 00       	mov    $0x0,%eax
80103b33:	eb 0b                	jmp    80103b40 <mpconfig+0xa8>
  *pmp = mp;
80103b35:	8b 45 08             	mov    0x8(%ebp),%eax
80103b38:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b3b:	89 10                	mov    %edx,(%eax)
  return conf;
80103b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103b40:	c9                   	leave  
80103b41:	c3                   	ret    

80103b42 <mpinit>:

void
mpinit(void)
{
80103b42:	55                   	push   %ebp
80103b43:	89 e5                	mov    %esp,%ebp
80103b45:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103b48:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103b4b:	89 04 24             	mov    %eax,(%esp)
80103b4e:	e8 45 ff ff ff       	call   80103a98 <mpconfig>
80103b53:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b56:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b5a:	75 0c                	jne    80103b68 <mpinit+0x26>
    panic("Expect to run on an SMP");
80103b5c:	c7 04 24 f6 85 10 80 	movl   $0x801085f6,(%esp)
80103b63:	e8 fa c9 ff ff       	call   80100562 <panic>
  ismp = 1;
80103b68:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
80103b6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b72:	8b 40 24             	mov    0x24(%eax),%eax
80103b75:	a3 fc 36 11 80       	mov    %eax,0x801136fc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b7d:	83 c0 2c             	add    $0x2c,%eax
80103b80:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b83:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b86:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103b8a:	0f b7 d0             	movzwl %ax,%edx
80103b8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b90:	01 d0                	add    %edx,%eax
80103b92:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103b95:	eb 7b                	jmp    80103c12 <mpinit+0xd0>
    switch(*p){
80103b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b9a:	0f b6 00             	movzbl (%eax),%eax
80103b9d:	0f b6 c0             	movzbl %al,%eax
80103ba0:	83 f8 04             	cmp    $0x4,%eax
80103ba3:	77 65                	ja     80103c0a <mpinit+0xc8>
80103ba5:	8b 04 85 30 86 10 80 	mov    -0x7fef79d0(,%eax,4),%eax
80103bac:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bb1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(ncpu < NCPU) {
80103bb4:	a1 80 3d 11 80       	mov    0x80113d80,%eax
80103bb9:	83 f8 07             	cmp    $0x7,%eax
80103bbc:	7f 28                	jg     80103be6 <mpinit+0xa4>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103bbe:	8b 15 80 3d 11 80    	mov    0x80113d80,%edx
80103bc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103bc7:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103bcb:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
80103bd1:	81 c2 00 38 11 80    	add    $0x80113800,%edx
80103bd7:	88 02                	mov    %al,(%edx)
        ncpu++;
80103bd9:	a1 80 3d 11 80       	mov    0x80113d80,%eax
80103bde:	83 c0 01             	add    $0x1,%eax
80103be1:	a3 80 3d 11 80       	mov    %eax,0x80113d80
      }
      p += sizeof(struct mpproc);
80103be6:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103bea:	eb 26                	jmp    80103c12 <mpinit+0xd0>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bef:	89 45 e0             	mov    %eax,-0x20(%ebp)
      ioapicid = ioapic->apicno;
80103bf2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103bf5:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103bf9:	a2 e0 37 11 80       	mov    %al,0x801137e0
      p += sizeof(struct mpioapic);
80103bfe:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103c02:	eb 0e                	jmp    80103c12 <mpinit+0xd0>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103c04:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103c08:	eb 08                	jmp    80103c12 <mpinit+0xd0>
    default:
      ismp = 0;
80103c0a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
80103c11:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c15:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80103c18:	0f 82 79 ff ff ff    	jb     80103b97 <mpinit+0x55>
    }
  }
  if(!ismp)
80103c1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c22:	75 0c                	jne    80103c30 <mpinit+0xee>
    panic("Didn't find a suitable machine");
80103c24:	c7 04 24 10 86 10 80 	movl   $0x80108610,(%esp)
80103c2b:	e8 32 c9 ff ff       	call   80100562 <panic>

  if(mp->imcrp){
80103c30:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103c33:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103c37:	84 c0                	test   %al,%al
80103c39:	74 36                	je     80103c71 <mpinit+0x12f>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103c3b:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103c42:	00 
80103c43:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103c4a:	e8 c7 fc ff ff       	call   80103916 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103c4f:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103c56:	e8 9e fc ff ff       	call   801038f9 <inb>
80103c5b:	83 c8 01             	or     $0x1,%eax
80103c5e:	0f b6 c0             	movzbl %al,%eax
80103c61:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c65:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103c6c:	e8 a5 fc ff ff       	call   80103916 <outb>
  }
}
80103c71:	c9                   	leave  
80103c72:	c3                   	ret    

80103c73 <outb>:
{
80103c73:	55                   	push   %ebp
80103c74:	89 e5                	mov    %esp,%ebp
80103c76:	83 ec 08             	sub    $0x8,%esp
80103c79:	8b 55 08             	mov    0x8(%ebp),%edx
80103c7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c7f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103c83:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103c86:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103c8a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103c8e:	ee                   	out    %al,(%dx)
}
80103c8f:	c9                   	leave  
80103c90:	c3                   	ret    

80103c91 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103c91:	55                   	push   %ebp
80103c92:	89 e5                	mov    %esp,%ebp
80103c94:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103c97:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103c9e:	00 
80103c9f:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103ca6:	e8 c8 ff ff ff       	call   80103c73 <outb>
  outb(IO_PIC2+1, 0xFF);
80103cab:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103cb2:	00 
80103cb3:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103cba:	e8 b4 ff ff ff       	call   80103c73 <outb>
}
80103cbf:	c9                   	leave  
80103cc0:	c3                   	ret    

80103cc1 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103cc1:	55                   	push   %ebp
80103cc2:	89 e5                	mov    %esp,%ebp
80103cc4:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103cc7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103cce:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cd1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cda:	8b 10                	mov    (%eax),%edx
80103cdc:	8b 45 08             	mov    0x8(%ebp),%eax
80103cdf:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103ce1:	e8 76 d2 ff ff       	call   80100f5c <filealloc>
80103ce6:	8b 55 08             	mov    0x8(%ebp),%edx
80103ce9:	89 02                	mov    %eax,(%edx)
80103ceb:	8b 45 08             	mov    0x8(%ebp),%eax
80103cee:	8b 00                	mov    (%eax),%eax
80103cf0:	85 c0                	test   %eax,%eax
80103cf2:	0f 84 c8 00 00 00    	je     80103dc0 <pipealloc+0xff>
80103cf8:	e8 5f d2 ff ff       	call   80100f5c <filealloc>
80103cfd:	8b 55 0c             	mov    0xc(%ebp),%edx
80103d00:	89 02                	mov    %eax,(%edx)
80103d02:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d05:	8b 00                	mov    (%eax),%eax
80103d07:	85 c0                	test   %eax,%eax
80103d09:	0f 84 b1 00 00 00    	je     80103dc0 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103d0f:	e8 6c ee ff ff       	call   80102b80 <kalloc>
80103d14:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d1b:	75 05                	jne    80103d22 <pipealloc+0x61>
    goto bad;
80103d1d:	e9 9e 00 00 00       	jmp    80103dc0 <pipealloc+0xff>
  p->readopen = 1;
80103d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d25:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103d2c:	00 00 00 
  p->writeopen = 1;
80103d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d32:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103d39:	00 00 00 
  p->nwrite = 0;
80103d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d3f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103d46:	00 00 00 
  p->nread = 0;
80103d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d4c:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103d53:	00 00 00 
  initlock(&p->lock, "pipe");
80103d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d59:	c7 44 24 04 44 86 10 	movl   $0x80108644,0x4(%esp)
80103d60:	80 
80103d61:	89 04 24             	mov    %eax,(%esp)
80103d64:	e8 cd 0f 00 00       	call   80104d36 <initlock>
  (*f0)->type = FD_PIPE;
80103d69:	8b 45 08             	mov    0x8(%ebp),%eax
80103d6c:	8b 00                	mov    (%eax),%eax
80103d6e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103d74:	8b 45 08             	mov    0x8(%ebp),%eax
80103d77:	8b 00                	mov    (%eax),%eax
80103d79:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103d7d:	8b 45 08             	mov    0x8(%ebp),%eax
80103d80:	8b 00                	mov    (%eax),%eax
80103d82:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103d86:	8b 45 08             	mov    0x8(%ebp),%eax
80103d89:	8b 00                	mov    (%eax),%eax
80103d8b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d8e:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103d91:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d94:	8b 00                	mov    (%eax),%eax
80103d96:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d9f:	8b 00                	mov    (%eax),%eax
80103da1:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103da5:	8b 45 0c             	mov    0xc(%ebp),%eax
80103da8:	8b 00                	mov    (%eax),%eax
80103daa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103dae:	8b 45 0c             	mov    0xc(%ebp),%eax
80103db1:	8b 00                	mov    (%eax),%eax
80103db3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103db6:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103db9:	b8 00 00 00 00       	mov    $0x0,%eax
80103dbe:	eb 42                	jmp    80103e02 <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80103dc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103dc4:	74 0b                	je     80103dd1 <pipealloc+0x110>
    kfree((char*)p);
80103dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dc9:	89 04 24             	mov    %eax,(%esp)
80103dcc:	e8 19 ed ff ff       	call   80102aea <kfree>
  if(*f0)
80103dd1:	8b 45 08             	mov    0x8(%ebp),%eax
80103dd4:	8b 00                	mov    (%eax),%eax
80103dd6:	85 c0                	test   %eax,%eax
80103dd8:	74 0d                	je     80103de7 <pipealloc+0x126>
    fileclose(*f0);
80103dda:	8b 45 08             	mov    0x8(%ebp),%eax
80103ddd:	8b 00                	mov    (%eax),%eax
80103ddf:	89 04 24             	mov    %eax,(%esp)
80103de2:	e8 1d d2 ff ff       	call   80101004 <fileclose>
  if(*f1)
80103de7:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dea:	8b 00                	mov    (%eax),%eax
80103dec:	85 c0                	test   %eax,%eax
80103dee:	74 0d                	je     80103dfd <pipealloc+0x13c>
    fileclose(*f1);
80103df0:	8b 45 0c             	mov    0xc(%ebp),%eax
80103df3:	8b 00                	mov    (%eax),%eax
80103df5:	89 04 24             	mov    %eax,(%esp)
80103df8:	e8 07 d2 ff ff       	call   80101004 <fileclose>
  return -1;
80103dfd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103e02:	c9                   	leave  
80103e03:	c3                   	ret    

80103e04 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103e04:	55                   	push   %ebp
80103e05:	89 e5                	mov    %esp,%ebp
80103e07:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103e0a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e0d:	89 04 24             	mov    %eax,(%esp)
80103e10:	e8 42 0f 00 00       	call   80104d57 <acquire>
  if(writable){
80103e15:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103e19:	74 1f                	je     80103e3a <pipeclose+0x36>
    p->writeopen = 0;
80103e1b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e1e:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103e25:	00 00 00 
    wakeup(&p->nread);
80103e28:	8b 45 08             	mov    0x8(%ebp),%eax
80103e2b:	05 34 02 00 00       	add    $0x234,%eax
80103e30:	89 04 24             	mov    %eax,(%esp)
80103e33:	e8 28 0c 00 00       	call   80104a60 <wakeup>
80103e38:	eb 1d                	jmp    80103e57 <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103e3a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e3d:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103e44:	00 00 00 
    wakeup(&p->nwrite);
80103e47:	8b 45 08             	mov    0x8(%ebp),%eax
80103e4a:	05 38 02 00 00       	add    $0x238,%eax
80103e4f:	89 04 24             	mov    %eax,(%esp)
80103e52:	e8 09 0c 00 00       	call   80104a60 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103e57:	8b 45 08             	mov    0x8(%ebp),%eax
80103e5a:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103e60:	85 c0                	test   %eax,%eax
80103e62:	75 25                	jne    80103e89 <pipeclose+0x85>
80103e64:	8b 45 08             	mov    0x8(%ebp),%eax
80103e67:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103e6d:	85 c0                	test   %eax,%eax
80103e6f:	75 18                	jne    80103e89 <pipeclose+0x85>
    release(&p->lock);
80103e71:	8b 45 08             	mov    0x8(%ebp),%eax
80103e74:	89 04 24             	mov    %eax,(%esp)
80103e77:	e8 43 0f 00 00       	call   80104dbf <release>
    kfree((char*)p);
80103e7c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e7f:	89 04 24             	mov    %eax,(%esp)
80103e82:	e8 63 ec ff ff       	call   80102aea <kfree>
80103e87:	eb 0b                	jmp    80103e94 <pipeclose+0x90>
  } else
    release(&p->lock);
80103e89:	8b 45 08             	mov    0x8(%ebp),%eax
80103e8c:	89 04 24             	mov    %eax,(%esp)
80103e8f:	e8 2b 0f 00 00       	call   80104dbf <release>
}
80103e94:	c9                   	leave  
80103e95:	c3                   	ret    

80103e96 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103e96:	55                   	push   %ebp
80103e97:	89 e5                	mov    %esp,%ebp
80103e99:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
80103e9c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e9f:	89 04 24             	mov    %eax,(%esp)
80103ea2:	e8 b0 0e 00 00       	call   80104d57 <acquire>
  for(i = 0; i < n; i++){
80103ea7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103eae:	e9 a5 00 00 00       	jmp    80103f58 <pipewrite+0xc2>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103eb3:	eb 56                	jmp    80103f0b <pipewrite+0x75>
      if(p->readopen == 0 || myproc()->killed){
80103eb5:	8b 45 08             	mov    0x8(%ebp),%eax
80103eb8:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103ebe:	85 c0                	test   %eax,%eax
80103ec0:	74 0c                	je     80103ece <pipewrite+0x38>
80103ec2:	e8 76 02 00 00       	call   8010413d <myproc>
80103ec7:	8b 40 24             	mov    0x24(%eax),%eax
80103eca:	85 c0                	test   %eax,%eax
80103ecc:	74 15                	je     80103ee3 <pipewrite+0x4d>
        release(&p->lock);
80103ece:	8b 45 08             	mov    0x8(%ebp),%eax
80103ed1:	89 04 24             	mov    %eax,(%esp)
80103ed4:	e8 e6 0e 00 00       	call   80104dbf <release>
        return -1;
80103ed9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ede:	e9 9f 00 00 00       	jmp    80103f82 <pipewrite+0xec>
      }
      wakeup(&p->nread);
80103ee3:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee6:	05 34 02 00 00       	add    $0x234,%eax
80103eeb:	89 04 24             	mov    %eax,(%esp)
80103eee:	e8 6d 0b 00 00       	call   80104a60 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ef3:	8b 45 08             	mov    0x8(%ebp),%eax
80103ef6:	8b 55 08             	mov    0x8(%ebp),%edx
80103ef9:	81 c2 38 02 00 00    	add    $0x238,%edx
80103eff:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f03:	89 14 24             	mov    %edx,(%esp)
80103f06:	e8 81 0a 00 00       	call   8010498c <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103f0b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f0e:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103f14:	8b 45 08             	mov    0x8(%ebp),%eax
80103f17:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f1d:	05 00 02 00 00       	add    $0x200,%eax
80103f22:	39 c2                	cmp    %eax,%edx
80103f24:	74 8f                	je     80103eb5 <pipewrite+0x1f>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103f26:	8b 45 08             	mov    0x8(%ebp),%eax
80103f29:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f2f:	8d 48 01             	lea    0x1(%eax),%ecx
80103f32:	8b 55 08             	mov    0x8(%ebp),%edx
80103f35:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103f3b:	25 ff 01 00 00       	and    $0x1ff,%eax
80103f40:	89 c1                	mov    %eax,%ecx
80103f42:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f45:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f48:	01 d0                	add    %edx,%eax
80103f4a:	0f b6 10             	movzbl (%eax),%edx
80103f4d:	8b 45 08             	mov    0x8(%ebp),%eax
80103f50:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
80103f54:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f5b:	3b 45 10             	cmp    0x10(%ebp),%eax
80103f5e:	0f 8c 4f ff ff ff    	jl     80103eb3 <pipewrite+0x1d>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103f64:	8b 45 08             	mov    0x8(%ebp),%eax
80103f67:	05 34 02 00 00       	add    $0x234,%eax
80103f6c:	89 04 24             	mov    %eax,(%esp)
80103f6f:	e8 ec 0a 00 00       	call   80104a60 <wakeup>
  release(&p->lock);
80103f74:	8b 45 08             	mov    0x8(%ebp),%eax
80103f77:	89 04 24             	mov    %eax,(%esp)
80103f7a:	e8 40 0e 00 00       	call   80104dbf <release>
  return n;
80103f7f:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103f82:	c9                   	leave  
80103f83:	c3                   	ret    

80103f84 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103f84:	55                   	push   %ebp
80103f85:	89 e5                	mov    %esp,%ebp
80103f87:	53                   	push   %ebx
80103f88:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103f8b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f8e:	89 04 24             	mov    %eax,(%esp)
80103f91:	e8 c1 0d 00 00       	call   80104d57 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f96:	eb 39                	jmp    80103fd1 <piperead+0x4d>
    if(myproc()->killed){
80103f98:	e8 a0 01 00 00       	call   8010413d <myproc>
80103f9d:	8b 40 24             	mov    0x24(%eax),%eax
80103fa0:	85 c0                	test   %eax,%eax
80103fa2:	74 15                	je     80103fb9 <piperead+0x35>
      release(&p->lock);
80103fa4:	8b 45 08             	mov    0x8(%ebp),%eax
80103fa7:	89 04 24             	mov    %eax,(%esp)
80103faa:	e8 10 0e 00 00       	call   80104dbf <release>
      return -1;
80103faf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fb4:	e9 b5 00 00 00       	jmp    8010406e <piperead+0xea>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103fb9:	8b 45 08             	mov    0x8(%ebp),%eax
80103fbc:	8b 55 08             	mov    0x8(%ebp),%edx
80103fbf:	81 c2 34 02 00 00    	add    $0x234,%edx
80103fc5:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fc9:	89 14 24             	mov    %edx,(%esp)
80103fcc:	e8 bb 09 00 00       	call   8010498c <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103fd1:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd4:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103fda:	8b 45 08             	mov    0x8(%ebp),%eax
80103fdd:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103fe3:	39 c2                	cmp    %eax,%edx
80103fe5:	75 0d                	jne    80103ff4 <piperead+0x70>
80103fe7:	8b 45 08             	mov    0x8(%ebp),%eax
80103fea:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103ff0:	85 c0                	test   %eax,%eax
80103ff2:	75 a4                	jne    80103f98 <piperead+0x14>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103ff4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103ffb:	eb 4b                	jmp    80104048 <piperead+0xc4>
    if(p->nread == p->nwrite)
80103ffd:	8b 45 08             	mov    0x8(%ebp),%eax
80104000:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104006:	8b 45 08             	mov    0x8(%ebp),%eax
80104009:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010400f:	39 c2                	cmp    %eax,%edx
80104011:	75 02                	jne    80104015 <piperead+0x91>
      break;
80104013:	eb 3b                	jmp    80104050 <piperead+0xcc>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104015:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104018:	8b 45 0c             	mov    0xc(%ebp),%eax
8010401b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010401e:	8b 45 08             	mov    0x8(%ebp),%eax
80104021:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104027:	8d 48 01             	lea    0x1(%eax),%ecx
8010402a:	8b 55 08             	mov    0x8(%ebp),%edx
8010402d:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104033:	25 ff 01 00 00       	and    $0x1ff,%eax
80104038:	89 c2                	mov    %eax,%edx
8010403a:	8b 45 08             	mov    0x8(%ebp),%eax
8010403d:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104042:	88 03                	mov    %al,(%ebx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104044:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104048:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010404b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010404e:	7c ad                	jl     80103ffd <piperead+0x79>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104050:	8b 45 08             	mov    0x8(%ebp),%eax
80104053:	05 38 02 00 00       	add    $0x238,%eax
80104058:	89 04 24             	mov    %eax,(%esp)
8010405b:	e8 00 0a 00 00       	call   80104a60 <wakeup>
  release(&p->lock);
80104060:	8b 45 08             	mov    0x8(%ebp),%eax
80104063:	89 04 24             	mov    %eax,(%esp)
80104066:	e8 54 0d 00 00       	call   80104dbf <release>
  return i;
8010406b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010406e:	83 c4 24             	add    $0x24,%esp
80104071:	5b                   	pop    %ebx
80104072:	5d                   	pop    %ebp
80104073:	c3                   	ret    

80104074 <readeflags>:
{
80104074:	55                   	push   %ebp
80104075:	89 e5                	mov    %esp,%ebp
80104077:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010407a:	9c                   	pushf  
8010407b:	58                   	pop    %eax
8010407c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010407f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104082:	c9                   	leave  
80104083:	c3                   	ret    

80104084 <sti>:
{
80104084:	55                   	push   %ebp
80104085:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104087:	fb                   	sti    
}
80104088:	5d                   	pop    %ebp
80104089:	c3                   	ret    

8010408a <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
8010408a:	55                   	push   %ebp
8010408b:	89 e5                	mov    %esp,%ebp
8010408d:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80104090:	c7 44 24 04 4c 86 10 	movl   $0x8010864c,0x4(%esp)
80104097:	80 
80104098:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
8010409f:	e8 92 0c 00 00       	call   80104d36 <initlock>
}
801040a4:	c9                   	leave  
801040a5:	c3                   	ret    

801040a6 <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
801040a6:	55                   	push   %ebp
801040a7:	89 e5                	mov    %esp,%ebp
801040a9:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801040ac:	e8 16 00 00 00       	call   801040c7 <mycpu>
801040b1:	89 c2                	mov    %eax,%edx
801040b3:	b8 00 38 11 80       	mov    $0x80113800,%eax
801040b8:	29 c2                	sub    %eax,%edx
801040ba:	89 d0                	mov    %edx,%eax
801040bc:	c1 f8 04             	sar    $0x4,%eax
801040bf:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801040c5:	c9                   	leave  
801040c6:	c3                   	ret    

801040c7 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
801040c7:	55                   	push   %ebp
801040c8:	89 e5                	mov    %esp,%ebp
801040ca:	83 ec 28             	sub    $0x28,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF)
801040cd:	e8 a2 ff ff ff       	call   80104074 <readeflags>
801040d2:	25 00 02 00 00       	and    $0x200,%eax
801040d7:	85 c0                	test   %eax,%eax
801040d9:	74 0c                	je     801040e7 <mycpu+0x20>
    panic("mycpu called with interrupts enabled\n");
801040db:	c7 04 24 54 86 10 80 	movl   $0x80108654,(%esp)
801040e2:	e8 7b c4 ff ff       	call   80100562 <panic>
  
  apicid = lapicid();
801040e7:	e8 1a ee ff ff       	call   80102f06 <lapicid>
801040ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801040ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801040f6:	eb 2d                	jmp    80104125 <mycpu+0x5e>
    if (cpus[i].apicid == apicid)
801040f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040fb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80104101:	05 00 38 11 80       	add    $0x80113800,%eax
80104106:	0f b6 00             	movzbl (%eax),%eax
80104109:	0f b6 c0             	movzbl %al,%eax
8010410c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010410f:	75 10                	jne    80104121 <mycpu+0x5a>
      return &cpus[i];
80104111:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104114:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010411a:	05 00 38 11 80       	add    $0x80113800,%eax
8010411f:	eb 1a                	jmp    8010413b <mycpu+0x74>
  for (i = 0; i < ncpu; ++i) {
80104121:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104125:	a1 80 3d 11 80       	mov    0x80113d80,%eax
8010412a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010412d:	7c c9                	jl     801040f8 <mycpu+0x31>
  }
  panic("unknown apicid\n");
8010412f:	c7 04 24 7a 86 10 80 	movl   $0x8010867a,(%esp)
80104136:	e8 27 c4 ff ff       	call   80100562 <panic>
}
8010413b:	c9                   	leave  
8010413c:	c3                   	ret    

8010413d <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
8010413d:	55                   	push   %ebp
8010413e:	89 e5                	mov    %esp,%ebp
80104140:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80104143:	e8 6c 0d 00 00       	call   80104eb4 <pushcli>
  c = mycpu();
80104148:	e8 7a ff ff ff       	call   801040c7 <mycpu>
8010414d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
80104150:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104153:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104159:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
8010415c:	e8 9f 0d 00 00       	call   80104f00 <popcli>
  return p;
80104161:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80104164:	c9                   	leave  
80104165:	c3                   	ret    

80104166 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104166:	55                   	push   %ebp
80104167:	89 e5                	mov    %esp,%ebp
80104169:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010416c:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104173:	e8 df 0b 00 00       	call   80104d57 <acquire>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104178:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
8010417f:	eb 50                	jmp    801041d1 <allocproc+0x6b>
    if(p->state == UNUSED)
80104181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104184:	8b 40 0c             	mov    0xc(%eax),%eax
80104187:	85 c0                	test   %eax,%eax
80104189:	75 42                	jne    801041cd <allocproc+0x67>
      goto found;
8010418b:	90                   	nop

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010418c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010418f:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104196:	a1 00 b0 10 80       	mov    0x8010b000,%eax
8010419b:	8d 50 01             	lea    0x1(%eax),%edx
8010419e:	89 15 00 b0 10 80    	mov    %edx,0x8010b000
801041a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041a7:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
801041aa:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801041b1:	e8 09 0c 00 00       	call   80104dbf <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801041b6:	e8 c5 e9 ff ff       	call   80102b80 <kalloc>
801041bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041be:	89 42 08             	mov    %eax,0x8(%edx)
801041c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041c4:	8b 40 08             	mov    0x8(%eax),%eax
801041c7:	85 c0                	test   %eax,%eax
801041c9:	75 33                	jne    801041fe <allocproc+0x98>
801041cb:	eb 20                	jmp    801041ed <allocproc+0x87>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041cd:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
801041d1:	81 7d f4 d4 5d 11 80 	cmpl   $0x80115dd4,-0xc(%ebp)
801041d8:	72 a7                	jb     80104181 <allocproc+0x1b>
  release(&ptable.lock);
801041da:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801041e1:	e8 d9 0b 00 00       	call   80104dbf <release>
  return 0;
801041e6:	b8 00 00 00 00       	mov    $0x0,%eax
801041eb:	eb 76                	jmp    80104263 <allocproc+0xfd>
    p->state = UNUSED;
801041ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041f0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801041f7:	b8 00 00 00 00       	mov    $0x0,%eax
801041fc:	eb 65                	jmp    80104263 <allocproc+0xfd>
  }
  sp = p->kstack + KSTACKSIZE;
801041fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104201:	8b 40 08             	mov    0x8(%eax),%eax
80104204:	05 00 10 00 00       	add    $0x1000,%eax
80104209:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010420c:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104210:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104213:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104216:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104219:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
8010421d:	ba 58 63 10 80       	mov    $0x80106358,%edx
80104222:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104225:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104227:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
8010422b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010422e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104231:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104234:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104237:	8b 40 1c             	mov    0x1c(%eax),%eax
8010423a:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104241:	00 
80104242:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104249:	00 
8010424a:	89 04 24             	mov    %eax,(%esp)
8010424d:	e8 67 0d 00 00       	call   80104fb9 <memset>
  p->context->eip = (uint)forkret;
80104252:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104255:	8b 40 1c             	mov    0x1c(%eax),%eax
80104258:	ba 4d 49 10 80       	mov    $0x8010494d,%edx
8010425d:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80104260:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104263:	c9                   	leave  
80104264:	c3                   	ret    

80104265 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104265:	55                   	push   %ebp
80104266:	89 e5                	mov    %esp,%ebp
80104268:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
8010426b:	e8 f6 fe ff ff       	call   80104166 <allocproc>
80104270:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
80104273:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104276:	a3 20 b6 10 80       	mov    %eax,0x8010b620
  if((p->pgdir = setupkvm()) == 0)
8010427b:	e8 55 36 00 00       	call   801078d5 <setupkvm>
80104280:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104283:	89 42 04             	mov    %eax,0x4(%edx)
80104286:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104289:	8b 40 04             	mov    0x4(%eax),%eax
8010428c:	85 c0                	test   %eax,%eax
8010428e:	75 0c                	jne    8010429c <userinit+0x37>
    panic("userinit: out of memory?");
80104290:	c7 04 24 8a 86 10 80 	movl   $0x8010868a,(%esp)
80104297:	e8 c6 c2 ff ff       	call   80100562 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010429c:	ba 2c 00 00 00       	mov    $0x2c,%edx
801042a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a4:	8b 40 04             	mov    0x4(%eax),%eax
801042a7:	89 54 24 08          	mov    %edx,0x8(%esp)
801042ab:	c7 44 24 04 c0 b4 10 	movl   $0x8010b4c0,0x4(%esp)
801042b2:	80 
801042b3:	89 04 24             	mov    %eax,(%esp)
801042b6:	e8 85 38 00 00       	call   80107b40 <inituvm>
  p->sz = PGSIZE;
801042bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042be:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801042c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042c7:	8b 40 18             	mov    0x18(%eax),%eax
801042ca:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801042d1:	00 
801042d2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801042d9:	00 
801042da:	89 04 24             	mov    %eax,(%esp)
801042dd:	e8 d7 0c 00 00       	call   80104fb9 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801042e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042e5:	8b 40 18             	mov    0x18(%eax),%eax
801042e8:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801042ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f1:	8b 40 18             	mov    0x18(%eax),%eax
801042f4:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
801042fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042fd:	8b 40 18             	mov    0x18(%eax),%eax
80104300:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104303:	8b 52 18             	mov    0x18(%edx),%edx
80104306:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010430a:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010430e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104311:	8b 40 18             	mov    0x18(%eax),%eax
80104314:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104317:	8b 52 18             	mov    0x18(%edx),%edx
8010431a:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010431e:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104322:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104325:	8b 40 18             	mov    0x18(%eax),%eax
80104328:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010432f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104332:	8b 40 18             	mov    0x18(%eax),%eax
80104335:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010433c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010433f:	8b 40 18             	mov    0x18(%eax),%eax
80104342:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010434c:	83 c0 6c             	add    $0x6c,%eax
8010434f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104356:	00 
80104357:	c7 44 24 04 a3 86 10 	movl   $0x801086a3,0x4(%esp)
8010435e:	80 
8010435f:	89 04 24             	mov    %eax,(%esp)
80104362:	e8 72 0e 00 00       	call   801051d9 <safestrcpy>
  p->cwd = namei("/");
80104367:	c7 04 24 ac 86 10 80 	movl   $0x801086ac,(%esp)
8010436e:	e8 fb e0 ff ff       	call   8010246e <namei>
80104373:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104376:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80104379:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104380:	e8 d2 09 00 00       	call   80104d57 <acquire>

  p->state = RUNNABLE;
80104385:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104388:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
8010438f:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104396:	e8 24 0a 00 00       	call   80104dbf <release>
}
8010439b:	c9                   	leave  
8010439c:	c3                   	ret    

8010439d <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010439d:	55                   	push   %ebp
8010439e:	89 e5                	mov    %esp,%ebp
801043a0:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  struct proc *curproc = myproc();
801043a3:	e8 95 fd ff ff       	call   8010413d <myproc>
801043a8:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
801043ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043ae:	8b 00                	mov    (%eax),%eax
801043b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801043b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801043b7:	7e 31                	jle    801043ea <growproc+0x4d>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801043b9:	8b 55 08             	mov    0x8(%ebp),%edx
801043bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043bf:	01 c2                	add    %eax,%edx
801043c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043c4:	8b 40 04             	mov    0x4(%eax),%eax
801043c7:	89 54 24 08          	mov    %edx,0x8(%esp)
801043cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043ce:	89 54 24 04          	mov    %edx,0x4(%esp)
801043d2:	89 04 24             	mov    %eax,(%esp)
801043d5:	e8 d1 38 00 00       	call   80107cab <allocuvm>
801043da:	89 45 f4             	mov    %eax,-0xc(%ebp)
801043dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801043e1:	75 3e                	jne    80104421 <growproc+0x84>
      return -1;
801043e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043e8:	eb 4f                	jmp    80104439 <growproc+0x9c>
  } else if(n < 0){
801043ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801043ee:	79 31                	jns    80104421 <growproc+0x84>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801043f0:	8b 55 08             	mov    0x8(%ebp),%edx
801043f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043f6:	01 c2                	add    %eax,%edx
801043f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043fb:	8b 40 04             	mov    0x4(%eax),%eax
801043fe:	89 54 24 08          	mov    %edx,0x8(%esp)
80104402:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104405:	89 54 24 04          	mov    %edx,0x4(%esp)
80104409:	89 04 24             	mov    %eax,(%esp)
8010440c:	e8 b0 39 00 00       	call   80107dc1 <deallocuvm>
80104411:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104414:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104418:	75 07                	jne    80104421 <growproc+0x84>
      return -1;
8010441a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010441f:	eb 18                	jmp    80104439 <growproc+0x9c>
  }
  curproc->sz = sz;
80104421:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104424:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104427:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
80104429:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010442c:	89 04 24             	mov    %eax,(%esp)
8010442f:	e8 7b 35 00 00       	call   801079af <switchuvm>
  return 0;
80104434:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104439:	c9                   	leave  
8010443a:	c3                   	ret    

8010443b <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
8010443b:	55                   	push   %ebp
8010443c:	89 e5                	mov    %esp,%ebp
8010443e:	57                   	push   %edi
8010443f:	56                   	push   %esi
80104440:	53                   	push   %ebx
80104441:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80104444:	e8 f4 fc ff ff       	call   8010413d <myproc>
80104449:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
8010444c:	e8 15 fd ff ff       	call   80104166 <allocproc>
80104451:	89 45 dc             	mov    %eax,-0x24(%ebp)
80104454:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80104458:	75 0a                	jne    80104464 <fork+0x29>
    return -1;
8010445a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010445f:	e9 40 01 00 00       	jmp    801045a4 <fork+0x169>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz, curproc->pages)) == 0){
80104464:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104467:	8b 48 7c             	mov    0x7c(%eax),%ecx
8010446a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010446d:	8b 10                	mov    (%eax),%edx
8010446f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104472:	8b 40 04             	mov    0x4(%eax),%eax
80104475:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80104479:	89 54 24 04          	mov    %edx,0x4(%esp)
8010447d:	89 04 24             	mov    %eax,(%esp)
80104480:	e8 df 3a 00 00       	call   80107f64 <copyuvm>
80104485:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104488:	89 42 04             	mov    %eax,0x4(%edx)
8010448b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010448e:	8b 40 04             	mov    0x4(%eax),%eax
80104491:	85 c0                	test   %eax,%eax
80104493:	75 2c                	jne    801044c1 <fork+0x86>
    kfree(np->kstack);
80104495:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104498:	8b 40 08             	mov    0x8(%eax),%eax
8010449b:	89 04 24             	mov    %eax,(%esp)
8010449e:	e8 47 e6 ff ff       	call   80102aea <kfree>
    np->kstack = 0;
801044a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
801044a6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801044ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
801044b0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
801044b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044bc:	e9 e3 00 00 00       	jmp    801045a4 <fork+0x169>
  }
  np->sz = curproc->sz;
801044c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044c4:	8b 10                	mov    (%eax),%edx
801044c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801044c9:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
801044cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
801044ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
801044d1:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
801044d4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801044d7:	8b 50 18             	mov    0x18(%eax),%edx
801044da:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044dd:	8b 40 18             	mov    0x18(%eax),%eax
801044e0:	89 c3                	mov    %eax,%ebx
801044e2:	b8 13 00 00 00       	mov    $0x13,%eax
801044e7:	89 d7                	mov    %edx,%edi
801044e9:	89 de                	mov    %ebx,%esi
801044eb:	89 c1                	mov    %eax,%ecx
801044ed:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801044ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
801044f2:	8b 40 18             	mov    0x18(%eax),%eax
801044f5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801044fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104503:	eb 37                	jmp    8010453c <fork+0x101>
    if(curproc->ofile[i])
80104505:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104508:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010450b:	83 c2 08             	add    $0x8,%edx
8010450e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104512:	85 c0                	test   %eax,%eax
80104514:	74 22                	je     80104538 <fork+0xfd>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104516:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104519:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010451c:	83 c2 08             	add    $0x8,%edx
8010451f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104523:	89 04 24             	mov    %eax,(%esp)
80104526:	e8 91 ca ff ff       	call   80100fbc <filedup>
8010452b:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010452e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104531:	83 c1 08             	add    $0x8,%ecx
80104534:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
80104538:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010453c:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104540:	7e c3                	jle    80104505 <fork+0xca>
  np->cwd = idup(curproc->cwd);
80104542:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104545:	8b 40 68             	mov    0x68(%eax),%eax
80104548:	89 04 24             	mov    %eax,(%esp)
8010454b:	e8 b2 d3 ff ff       	call   80101902 <idup>
80104550:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104553:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104556:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104559:	8d 50 6c             	lea    0x6c(%eax),%edx
8010455c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010455f:	83 c0 6c             	add    $0x6c,%eax
80104562:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104569:	00 
8010456a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010456e:	89 04 24             	mov    %eax,(%esp)
80104571:	e8 63 0c 00 00       	call   801051d9 <safestrcpy>

  pid = np->pid;
80104576:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104579:	8b 40 10             	mov    0x10(%eax),%eax
8010457c:	89 45 d8             	mov    %eax,-0x28(%ebp)

  acquire(&ptable.lock);
8010457f:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104586:	e8 cc 07 00 00       	call   80104d57 <acquire>

  np->state = RUNNABLE;
8010458b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010458e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
80104595:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
8010459c:	e8 1e 08 00 00       	call   80104dbf <release>

  return pid;
801045a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
801045a4:	83 c4 2c             	add    $0x2c,%esp
801045a7:	5b                   	pop    %ebx
801045a8:	5e                   	pop    %esi
801045a9:	5f                   	pop    %edi
801045aa:	5d                   	pop    %ebp
801045ab:	c3                   	ret    

801045ac <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
801045ac:	55                   	push   %ebp
801045ad:	89 e5                	mov    %esp,%ebp
801045af:	83 ec 28             	sub    $0x28,%esp
  struct proc *curproc = myproc();
801045b2:	e8 86 fb ff ff       	call   8010413d <myproc>
801045b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
801045ba:	a1 20 b6 10 80       	mov    0x8010b620,%eax
801045bf:	39 45 ec             	cmp    %eax,-0x14(%ebp)
801045c2:	75 0c                	jne    801045d0 <exit+0x24>
    panic("init exiting");
801045c4:	c7 04 24 ae 86 10 80 	movl   $0x801086ae,(%esp)
801045cb:	e8 92 bf ff ff       	call   80100562 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801045d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801045d7:	eb 3b                	jmp    80104614 <exit+0x68>
    if(curproc->ofile[fd]){
801045d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801045dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801045df:	83 c2 08             	add    $0x8,%edx
801045e2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801045e6:	85 c0                	test   %eax,%eax
801045e8:	74 26                	je     80104610 <exit+0x64>
      fileclose(curproc->ofile[fd]);
801045ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
801045ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
801045f0:	83 c2 08             	add    $0x8,%edx
801045f3:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801045f7:	89 04 24             	mov    %eax,(%esp)
801045fa:	e8 05 ca ff ff       	call   80101004 <fileclose>
      curproc->ofile[fd] = 0;
801045ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104602:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104605:	83 c2 08             	add    $0x8,%edx
80104608:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010460f:	00 
  for(fd = 0; fd < NOFILE; fd++){
80104610:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104614:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104618:	7e bf                	jle    801045d9 <exit+0x2d>
    }
  }

  begin_op();
8010461a:	e8 3f ee ff ff       	call   8010345e <begin_op>
  iput(curproc->cwd);
8010461f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104622:	8b 40 68             	mov    0x68(%eax),%eax
80104625:	89 04 24             	mov    %eax,(%esp)
80104628:	e8 58 d4 ff ff       	call   80101a85 <iput>
  end_op();
8010462d:	e8 b0 ee ff ff       	call   801034e2 <end_op>
  curproc->cwd = 0;
80104632:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104635:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
8010463c:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104643:	e8 0f 07 00 00       	call   80104d57 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104648:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010464b:	8b 40 14             	mov    0x14(%eax),%eax
8010464e:	89 04 24             	mov    %eax,(%esp)
80104651:	e8 cc 03 00 00       	call   80104a22 <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104656:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
8010465d:	eb 33                	jmp    80104692 <exit+0xe6>
    if(p->parent == curproc){
8010465f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104662:	8b 40 14             	mov    0x14(%eax),%eax
80104665:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104668:	75 24                	jne    8010468e <exit+0xe2>
      p->parent = initproc;
8010466a:	8b 15 20 b6 10 80    	mov    0x8010b620,%edx
80104670:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104673:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104676:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104679:	8b 40 0c             	mov    0xc(%eax),%eax
8010467c:	83 f8 05             	cmp    $0x5,%eax
8010467f:	75 0d                	jne    8010468e <exit+0xe2>
        wakeup1(initproc);
80104681:	a1 20 b6 10 80       	mov    0x8010b620,%eax
80104686:	89 04 24             	mov    %eax,(%esp)
80104689:	e8 94 03 00 00       	call   80104a22 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010468e:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104692:	81 7d f4 d4 5d 11 80 	cmpl   $0x80115dd4,-0xc(%ebp)
80104699:	72 c4                	jb     8010465f <exit+0xb3>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
8010469b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010469e:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
801046a5:	e8 c3 01 00 00       	call   8010486d <sched>
  panic("zombie exit");
801046aa:	c7 04 24 bb 86 10 80 	movl   $0x801086bb,(%esp)
801046b1:	e8 ac be ff ff       	call   80100562 <panic>

801046b6 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801046b6:	55                   	push   %ebp
801046b7:	89 e5                	mov    %esp,%ebp
801046b9:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
801046bc:	e8 7c fa ff ff       	call   8010413d <myproc>
801046c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
801046c4:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801046cb:	e8 87 06 00 00       	call   80104d57 <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
801046d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046d7:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
801046de:	e9 95 00 00 00       	jmp    80104778 <wait+0xc2>
      if(p->parent != curproc)
801046e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e6:	8b 40 14             	mov    0x14(%eax),%eax
801046e9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801046ec:	74 05                	je     801046f3 <wait+0x3d>
        continue;
801046ee:	e9 81 00 00 00       	jmp    80104774 <wait+0xbe>
      havekids = 1;
801046f3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801046fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046fd:	8b 40 0c             	mov    0xc(%eax),%eax
80104700:	83 f8 05             	cmp    $0x5,%eax
80104703:	75 6f                	jne    80104774 <wait+0xbe>
        // Found one.
        pid = p->pid;
80104705:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104708:	8b 40 10             	mov    0x10(%eax),%eax
8010470b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
8010470e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104711:	8b 40 08             	mov    0x8(%eax),%eax
80104714:	89 04 24             	mov    %eax,(%esp)
80104717:	e8 ce e3 ff ff       	call   80102aea <kfree>
        p->kstack = 0;
8010471c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010471f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104726:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104729:	8b 40 04             	mov    0x4(%eax),%eax
8010472c:	89 04 24             	mov    %eax,(%esp)
8010472f:	e8 53 37 00 00       	call   80107e87 <freevm>
        p->pid = 0;
80104734:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104737:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
8010473e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104741:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104748:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010474b:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
8010474f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104752:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
80104759:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010475c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
80104763:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
8010476a:	e8 50 06 00 00       	call   80104dbf <release>
        return pid;
8010476f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104772:	eb 4c                	jmp    801047c0 <wait+0x10a>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104774:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104778:	81 7d f4 d4 5d 11 80 	cmpl   $0x80115dd4,-0xc(%ebp)
8010477f:	0f 82 5e ff ff ff    	jb     801046e3 <wait+0x2d>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104785:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104789:	74 0a                	je     80104795 <wait+0xdf>
8010478b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010478e:	8b 40 24             	mov    0x24(%eax),%eax
80104791:	85 c0                	test   %eax,%eax
80104793:	74 13                	je     801047a8 <wait+0xf2>
      release(&ptable.lock);
80104795:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
8010479c:	e8 1e 06 00 00       	call   80104dbf <release>
      return -1;
801047a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047a6:	eb 18                	jmp    801047c0 <wait+0x10a>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801047a8:	c7 44 24 04 a0 3d 11 	movl   $0x80113da0,0x4(%esp)
801047af:	80 
801047b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047b3:	89 04 24             	mov    %eax,(%esp)
801047b6:	e8 d1 01 00 00       	call   8010498c <sleep>
  }
801047bb:	e9 10 ff ff ff       	jmp    801046d0 <wait+0x1a>
}
801047c0:	c9                   	leave  
801047c1:	c3                   	ret    

801047c2 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801047c2:	55                   	push   %ebp
801047c3:	89 e5                	mov    %esp,%ebp
801047c5:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  struct cpu *c = mycpu();
801047c8:	e8 fa f8 ff ff       	call   801040c7 <mycpu>
801047cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  c->proc = 0;
801047d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801047d3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801047da:	00 00 00 
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
801047dd:	e8 a2 f8 ff ff       	call   80104084 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801047e2:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801047e9:	e8 69 05 00 00       	call   80104d57 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047ee:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
801047f5:	eb 5c                	jmp    80104853 <scheduler+0x91>
      if(p->state != RUNNABLE)
801047f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047fa:	8b 40 0c             	mov    0xc(%eax),%eax
801047fd:	83 f8 03             	cmp    $0x3,%eax
80104800:	74 02                	je     80104804 <scheduler+0x42>
        continue;
80104802:	eb 4b                	jmp    8010484f <scheduler+0x8d>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80104804:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104807:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010480a:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
      switchuvm(p);
80104810:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104813:	89 04 24             	mov    %eax,(%esp)
80104816:	e8 94 31 00 00       	call   801079af <switchuvm>
      p->state = RUNNING;
8010481b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010481e:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), p->context);
80104825:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104828:	8b 40 1c             	mov    0x1c(%eax),%eax
8010482b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010482e:	83 c2 04             	add    $0x4,%edx
80104831:	89 44 24 04          	mov    %eax,0x4(%esp)
80104835:	89 14 24             	mov    %edx,(%esp)
80104838:	e8 0d 0a 00 00       	call   8010524a <swtch>
      switchkvm();
8010483d:	e8 53 31 00 00       	call   80107995 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80104842:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104845:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010484c:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010484f:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104853:	81 7d f4 d4 5d 11 80 	cmpl   $0x80115dd4,-0xc(%ebp)
8010485a:	72 9b                	jb     801047f7 <scheduler+0x35>
    }
    release(&ptable.lock);
8010485c:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104863:	e8 57 05 00 00       	call   80104dbf <release>

  }
80104868:	e9 70 ff ff ff       	jmp    801047dd <scheduler+0x1b>

8010486d <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
8010486d:	55                   	push   %ebp
8010486e:	89 e5                	mov    %esp,%ebp
80104870:	83 ec 28             	sub    $0x28,%esp
  int intena;
  struct proc *p = myproc();
80104873:	e8 c5 f8 ff ff       	call   8010413d <myproc>
80104878:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
8010487b:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104882:	e8 fc 05 00 00       	call   80104e83 <holding>
80104887:	85 c0                	test   %eax,%eax
80104889:	75 0c                	jne    80104897 <sched+0x2a>
    panic("sched ptable.lock");
8010488b:	c7 04 24 c7 86 10 80 	movl   $0x801086c7,(%esp)
80104892:	e8 cb bc ff ff       	call   80100562 <panic>
  if(mycpu()->ncli != 1)
80104897:	e8 2b f8 ff ff       	call   801040c7 <mycpu>
8010489c:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801048a2:	83 f8 01             	cmp    $0x1,%eax
801048a5:	74 0c                	je     801048b3 <sched+0x46>
    panic("sched locks");
801048a7:	c7 04 24 d9 86 10 80 	movl   $0x801086d9,(%esp)
801048ae:	e8 af bc ff ff       	call   80100562 <panic>
  if(p->state == RUNNING)
801048b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b6:	8b 40 0c             	mov    0xc(%eax),%eax
801048b9:	83 f8 04             	cmp    $0x4,%eax
801048bc:	75 0c                	jne    801048ca <sched+0x5d>
    panic("sched running");
801048be:	c7 04 24 e5 86 10 80 	movl   $0x801086e5,(%esp)
801048c5:	e8 98 bc ff ff       	call   80100562 <panic>
  if(readeflags()&FL_IF)
801048ca:	e8 a5 f7 ff ff       	call   80104074 <readeflags>
801048cf:	25 00 02 00 00       	and    $0x200,%eax
801048d4:	85 c0                	test   %eax,%eax
801048d6:	74 0c                	je     801048e4 <sched+0x77>
    panic("sched interruptible");
801048d8:	c7 04 24 f3 86 10 80 	movl   $0x801086f3,(%esp)
801048df:	e8 7e bc ff ff       	call   80100562 <panic>
  intena = mycpu()->intena;
801048e4:	e8 de f7 ff ff       	call   801040c7 <mycpu>
801048e9:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801048ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
801048f2:	e8 d0 f7 ff ff       	call   801040c7 <mycpu>
801048f7:	8b 40 04             	mov    0x4(%eax),%eax
801048fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048fd:	83 c2 1c             	add    $0x1c,%edx
80104900:	89 44 24 04          	mov    %eax,0x4(%esp)
80104904:	89 14 24             	mov    %edx,(%esp)
80104907:	e8 3e 09 00 00       	call   8010524a <swtch>
  mycpu()->intena = intena;
8010490c:	e8 b6 f7 ff ff       	call   801040c7 <mycpu>
80104911:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104914:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
8010491a:	c9                   	leave  
8010491b:	c3                   	ret    

8010491c <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
8010491c:	55                   	push   %ebp
8010491d:	89 e5                	mov    %esp,%ebp
8010491f:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104922:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104929:	e8 29 04 00 00       	call   80104d57 <acquire>
  myproc()->state = RUNNABLE;
8010492e:	e8 0a f8 ff ff       	call   8010413d <myproc>
80104933:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
8010493a:	e8 2e ff ff ff       	call   8010486d <sched>
  release(&ptable.lock);
8010493f:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104946:	e8 74 04 00 00       	call   80104dbf <release>
}
8010494b:	c9                   	leave  
8010494c:	c3                   	ret    

8010494d <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
8010494d:	55                   	push   %ebp
8010494e:	89 e5                	mov    %esp,%ebp
80104950:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104953:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
8010495a:	e8 60 04 00 00       	call   80104dbf <release>

  if (first) {
8010495f:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104964:	85 c0                	test   %eax,%eax
80104966:	74 22                	je     8010498a <forkret+0x3d>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104968:	c7 05 04 b0 10 80 00 	movl   $0x0,0x8010b004
8010496f:	00 00 00 
    iinit(ROOTDEV);
80104972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104979:	e8 49 cc ff ff       	call   801015c7 <iinit>
    initlog(ROOTDEV);
8010497e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104985:	e8 d0 e8 ff ff       	call   8010325a <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010498a:	c9                   	leave  
8010498b:	c3                   	ret    

8010498c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
8010498c:	55                   	push   %ebp
8010498d:	89 e5                	mov    %esp,%ebp
8010498f:	83 ec 28             	sub    $0x28,%esp
  struct proc *p = myproc();
80104992:	e8 a6 f7 ff ff       	call   8010413d <myproc>
80104997:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
8010499a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010499e:	75 0c                	jne    801049ac <sleep+0x20>
    panic("sleep");
801049a0:	c7 04 24 07 87 10 80 	movl   $0x80108707,(%esp)
801049a7:	e8 b6 bb ff ff       	call   80100562 <panic>

  if(lk == 0)
801049ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801049b0:	75 0c                	jne    801049be <sleep+0x32>
    panic("sleep without lk");
801049b2:	c7 04 24 0d 87 10 80 	movl   $0x8010870d,(%esp)
801049b9:	e8 a4 bb ff ff       	call   80100562 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801049be:	81 7d 0c a0 3d 11 80 	cmpl   $0x80113da0,0xc(%ebp)
801049c5:	74 17                	je     801049de <sleep+0x52>
    acquire(&ptable.lock);  //DOC: sleeplock1
801049c7:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
801049ce:	e8 84 03 00 00       	call   80104d57 <acquire>
    release(lk);
801049d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801049d6:	89 04 24             	mov    %eax,(%esp)
801049d9:	e8 e1 03 00 00       	call   80104dbf <release>
  }
  // Go to sleep.
  p->chan = chan;
801049de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e1:	8b 55 08             	mov    0x8(%ebp),%edx
801049e4:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
801049e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049ea:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
801049f1:	e8 77 fe ff ff       	call   8010486d <sched>

  // Tidy up.
  p->chan = 0;
801049f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f9:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104a00:	81 7d 0c a0 3d 11 80 	cmpl   $0x80113da0,0xc(%ebp)
80104a07:	74 17                	je     80104a20 <sleep+0x94>
    release(&ptable.lock);
80104a09:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104a10:	e8 aa 03 00 00       	call   80104dbf <release>
    acquire(lk);
80104a15:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a18:	89 04 24             	mov    %eax,(%esp)
80104a1b:	e8 37 03 00 00       	call   80104d57 <acquire>
  }
}
80104a20:	c9                   	leave  
80104a21:	c3                   	ret    

80104a22 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104a22:	55                   	push   %ebp
80104a23:	89 e5                	mov    %esp,%ebp
80104a25:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a28:	c7 45 fc d4 3d 11 80 	movl   $0x80113dd4,-0x4(%ebp)
80104a2f:	eb 24                	jmp    80104a55 <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104a31:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a34:	8b 40 0c             	mov    0xc(%eax),%eax
80104a37:	83 f8 02             	cmp    $0x2,%eax
80104a3a:	75 15                	jne    80104a51 <wakeup1+0x2f>
80104a3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a3f:	8b 40 20             	mov    0x20(%eax),%eax
80104a42:	3b 45 08             	cmp    0x8(%ebp),%eax
80104a45:	75 0a                	jne    80104a51 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104a47:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104a4a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a51:	83 6d fc 80          	subl   $0xffffff80,-0x4(%ebp)
80104a55:	81 7d fc d4 5d 11 80 	cmpl   $0x80115dd4,-0x4(%ebp)
80104a5c:	72 d3                	jb     80104a31 <wakeup1+0xf>
}
80104a5e:	c9                   	leave  
80104a5f:	c3                   	ret    

80104a60 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104a66:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104a6d:	e8 e5 02 00 00       	call   80104d57 <acquire>
  wakeup1(chan);
80104a72:	8b 45 08             	mov    0x8(%ebp),%eax
80104a75:	89 04 24             	mov    %eax,(%esp)
80104a78:	e8 a5 ff ff ff       	call   80104a22 <wakeup1>
  release(&ptable.lock);
80104a7d:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104a84:	e8 36 03 00 00       	call   80104dbf <release>
}
80104a89:	c9                   	leave  
80104a8a:	c3                   	ret    

80104a8b <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104a8b:	55                   	push   %ebp
80104a8c:	89 e5                	mov    %esp,%ebp
80104a8e:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104a91:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104a98:	e8 ba 02 00 00       	call   80104d57 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a9d:	c7 45 f4 d4 3d 11 80 	movl   $0x80113dd4,-0xc(%ebp)
80104aa4:	eb 41                	jmp    80104ae7 <kill+0x5c>
    if(p->pid == pid){
80104aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa9:	8b 40 10             	mov    0x10(%eax),%eax
80104aac:	3b 45 08             	cmp    0x8(%ebp),%eax
80104aaf:	75 32                	jne    80104ae3 <kill+0x58>
      p->killed = 1;
80104ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab4:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104abe:	8b 40 0c             	mov    0xc(%eax),%eax
80104ac1:	83 f8 02             	cmp    $0x2,%eax
80104ac4:	75 0a                	jne    80104ad0 <kill+0x45>
        p->state = RUNNABLE;
80104ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac9:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104ad0:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104ad7:	e8 e3 02 00 00       	call   80104dbf <release>
      return 0;
80104adc:	b8 00 00 00 00       	mov    $0x0,%eax
80104ae1:	eb 1e                	jmp    80104b01 <kill+0x76>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ae3:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104ae7:	81 7d f4 d4 5d 11 80 	cmpl   $0x80115dd4,-0xc(%ebp)
80104aee:	72 b6                	jb     80104aa6 <kill+0x1b>
    }
  }
  release(&ptable.lock);
80104af0:	c7 04 24 a0 3d 11 80 	movl   $0x80113da0,(%esp)
80104af7:	e8 c3 02 00 00       	call   80104dbf <release>
  return -1;
80104afc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b01:	c9                   	leave  
80104b02:	c3                   	ret    

80104b03 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104b03:	55                   	push   %ebp
80104b04:	89 e5                	mov    %esp,%ebp
80104b06:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b09:	c7 45 f0 d4 3d 11 80 	movl   $0x80113dd4,-0x10(%ebp)
80104b10:	e9 d6 00 00 00       	jmp    80104beb <procdump+0xe8>
    if(p->state == UNUSED)
80104b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b18:	8b 40 0c             	mov    0xc(%eax),%eax
80104b1b:	85 c0                	test   %eax,%eax
80104b1d:	75 05                	jne    80104b24 <procdump+0x21>
      continue;
80104b1f:	e9 c3 00 00 00       	jmp    80104be7 <procdump+0xe4>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104b24:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b27:	8b 40 0c             	mov    0xc(%eax),%eax
80104b2a:	83 f8 05             	cmp    $0x5,%eax
80104b2d:	77 23                	ja     80104b52 <procdump+0x4f>
80104b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b32:	8b 40 0c             	mov    0xc(%eax),%eax
80104b35:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104b3c:	85 c0                	test   %eax,%eax
80104b3e:	74 12                	je     80104b52 <procdump+0x4f>
      state = states[p->state];
80104b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b43:	8b 40 0c             	mov    0xc(%eax),%eax
80104b46:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104b4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104b50:	eb 07                	jmp    80104b59 <procdump+0x56>
    else
      state = "???";
80104b52:	c7 45 ec 1e 87 10 80 	movl   $0x8010871e,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b5c:	8d 50 6c             	lea    0x6c(%eax),%edx
80104b5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b62:	8b 40 10             	mov    0x10(%eax),%eax
80104b65:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104b69:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104b6c:	89 54 24 08          	mov    %edx,0x8(%esp)
80104b70:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b74:	c7 04 24 22 87 10 80 	movl   $0x80108722,(%esp)
80104b7b:	e8 48 b8 ff ff       	call   801003c8 <cprintf>
    if(p->state == SLEEPING){
80104b80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b83:	8b 40 0c             	mov    0xc(%eax),%eax
80104b86:	83 f8 02             	cmp    $0x2,%eax
80104b89:	75 50                	jne    80104bdb <procdump+0xd8>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b8e:	8b 40 1c             	mov    0x1c(%eax),%eax
80104b91:	8b 40 0c             	mov    0xc(%eax),%eax
80104b94:	83 c0 08             	add    $0x8,%eax
80104b97:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104b9a:	89 54 24 04          	mov    %edx,0x4(%esp)
80104b9e:	89 04 24             	mov    %eax,(%esp)
80104ba1:	e8 64 02 00 00       	call   80104e0a <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104ba6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104bad:	eb 1b                	jmp    80104bca <procdump+0xc7>
        cprintf(" %p", pc[i]);
80104baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb2:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104bb6:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bba:	c7 04 24 2b 87 10 80 	movl   $0x8010872b,(%esp)
80104bc1:	e8 02 b8 ff ff       	call   801003c8 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104bc6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104bca:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104bce:	7f 0b                	jg     80104bdb <procdump+0xd8>
80104bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bd3:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104bd7:	85 c0                	test   %eax,%eax
80104bd9:	75 d4                	jne    80104baf <procdump+0xac>
    }
    cprintf("\n");
80104bdb:	c7 04 24 2f 87 10 80 	movl   $0x8010872f,(%esp)
80104be2:	e8 e1 b7 ff ff       	call   801003c8 <cprintf>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104be7:	83 6d f0 80          	subl   $0xffffff80,-0x10(%ebp)
80104beb:	81 7d f0 d4 5d 11 80 	cmpl   $0x80115dd4,-0x10(%ebp)
80104bf2:	0f 82 1d ff ff ff    	jb     80104b15 <procdump+0x12>
  }
}
80104bf8:	c9                   	leave  
80104bf9:	c3                   	ret    

80104bfa <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104bfa:	55                   	push   %ebp
80104bfb:	89 e5                	mov    %esp,%ebp
80104bfd:	83 ec 18             	sub    $0x18,%esp
  initlock(&lk->lk, "sleep lock");
80104c00:	8b 45 08             	mov    0x8(%ebp),%eax
80104c03:	83 c0 04             	add    $0x4,%eax
80104c06:	c7 44 24 04 5b 87 10 	movl   $0x8010875b,0x4(%esp)
80104c0d:	80 
80104c0e:	89 04 24             	mov    %eax,(%esp)
80104c11:	e8 20 01 00 00       	call   80104d36 <initlock>
  lk->name = name;
80104c16:	8b 45 08             	mov    0x8(%ebp),%eax
80104c19:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c1c:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80104c1f:	8b 45 08             	mov    0x8(%ebp),%eax
80104c22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104c28:	8b 45 08             	mov    0x8(%ebp),%eax
80104c2b:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80104c32:	c9                   	leave  
80104c33:	c3                   	ret    

80104c34 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104c34:	55                   	push   %ebp
80104c35:	89 e5                	mov    %esp,%ebp
80104c37:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
80104c3a:	8b 45 08             	mov    0x8(%ebp),%eax
80104c3d:	83 c0 04             	add    $0x4,%eax
80104c40:	89 04 24             	mov    %eax,(%esp)
80104c43:	e8 0f 01 00 00       	call   80104d57 <acquire>
  while (lk->locked) {
80104c48:	eb 15                	jmp    80104c5f <acquiresleep+0x2b>
    sleep(lk, &lk->lk);
80104c4a:	8b 45 08             	mov    0x8(%ebp),%eax
80104c4d:	83 c0 04             	add    $0x4,%eax
80104c50:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c54:	8b 45 08             	mov    0x8(%ebp),%eax
80104c57:	89 04 24             	mov    %eax,(%esp)
80104c5a:	e8 2d fd ff ff       	call   8010498c <sleep>
  while (lk->locked) {
80104c5f:	8b 45 08             	mov    0x8(%ebp),%eax
80104c62:	8b 00                	mov    (%eax),%eax
80104c64:	85 c0                	test   %eax,%eax
80104c66:	75 e2                	jne    80104c4a <acquiresleep+0x16>
  }
  lk->locked = 1;
80104c68:	8b 45 08             	mov    0x8(%ebp),%eax
80104c6b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
80104c71:	e8 c7 f4 ff ff       	call   8010413d <myproc>
80104c76:	8b 50 10             	mov    0x10(%eax),%edx
80104c79:	8b 45 08             	mov    0x8(%ebp),%eax
80104c7c:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80104c7f:	8b 45 08             	mov    0x8(%ebp),%eax
80104c82:	83 c0 04             	add    $0x4,%eax
80104c85:	89 04 24             	mov    %eax,(%esp)
80104c88:	e8 32 01 00 00       	call   80104dbf <release>
}
80104c8d:	c9                   	leave  
80104c8e:	c3                   	ret    

80104c8f <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104c8f:	55                   	push   %ebp
80104c90:	89 e5                	mov    %esp,%ebp
80104c92:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
80104c95:	8b 45 08             	mov    0x8(%ebp),%eax
80104c98:	83 c0 04             	add    $0x4,%eax
80104c9b:	89 04 24             	mov    %eax,(%esp)
80104c9e:	e8 b4 00 00 00       	call   80104d57 <acquire>
  lk->locked = 0;
80104ca3:	8b 45 08             	mov    0x8(%ebp),%eax
80104ca6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104cac:	8b 45 08             	mov    0x8(%ebp),%eax
80104caf:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80104cb6:	8b 45 08             	mov    0x8(%ebp),%eax
80104cb9:	89 04 24             	mov    %eax,(%esp)
80104cbc:	e8 9f fd ff ff       	call   80104a60 <wakeup>
  release(&lk->lk);
80104cc1:	8b 45 08             	mov    0x8(%ebp),%eax
80104cc4:	83 c0 04             	add    $0x4,%eax
80104cc7:	89 04 24             	mov    %eax,(%esp)
80104cca:	e8 f0 00 00 00       	call   80104dbf <release>
}
80104ccf:	c9                   	leave  
80104cd0:	c3                   	ret    

80104cd1 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104cd1:	55                   	push   %ebp
80104cd2:	89 e5                	mov    %esp,%ebp
80104cd4:	83 ec 28             	sub    $0x28,%esp
  int r;
  
  acquire(&lk->lk);
80104cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80104cda:	83 c0 04             	add    $0x4,%eax
80104cdd:	89 04 24             	mov    %eax,(%esp)
80104ce0:	e8 72 00 00 00       	call   80104d57 <acquire>
  r = lk->locked;
80104ce5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ce8:	8b 00                	mov    (%eax),%eax
80104cea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80104ced:	8b 45 08             	mov    0x8(%ebp),%eax
80104cf0:	83 c0 04             	add    $0x4,%eax
80104cf3:	89 04 24             	mov    %eax,(%esp)
80104cf6:	e8 c4 00 00 00       	call   80104dbf <release>
  return r;
80104cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104cfe:	c9                   	leave  
80104cff:	c3                   	ret    

80104d00 <readeflags>:
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104d06:	9c                   	pushf  
80104d07:	58                   	pop    %eax
80104d08:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104d0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104d0e:	c9                   	leave  
80104d0f:	c3                   	ret    

80104d10 <cli>:
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104d13:	fa                   	cli    
}
80104d14:	5d                   	pop    %ebp
80104d15:	c3                   	ret    

80104d16 <sti>:
{
80104d16:	55                   	push   %ebp
80104d17:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104d19:	fb                   	sti    
}
80104d1a:	5d                   	pop    %ebp
80104d1b:	c3                   	ret    

80104d1c <xchg>:
{
80104d1c:	55                   	push   %ebp
80104d1d:	89 e5                	mov    %esp,%ebp
80104d1f:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
80104d22:	8b 55 08             	mov    0x8(%ebp),%edx
80104d25:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d28:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d2b:	f0 87 02             	lock xchg %eax,(%edx)
80104d2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
80104d31:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104d34:	c9                   	leave  
80104d35:	c3                   	ret    

80104d36 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104d36:	55                   	push   %ebp
80104d37:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104d39:	8b 45 08             	mov    0x8(%ebp),%eax
80104d3c:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d3f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104d42:	8b 45 08             	mov    0x8(%ebp),%eax
80104d45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104d4b:	8b 45 08             	mov    0x8(%ebp),%eax
80104d4e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104d55:	5d                   	pop    %ebp
80104d56:	c3                   	ret    

80104d57 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104d57:	55                   	push   %ebp
80104d58:	89 e5                	mov    %esp,%ebp
80104d5a:	53                   	push   %ebx
80104d5b:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104d5e:	e8 51 01 00 00       	call   80104eb4 <pushcli>
  if(holding(lk))
80104d63:	8b 45 08             	mov    0x8(%ebp),%eax
80104d66:	89 04 24             	mov    %eax,(%esp)
80104d69:	e8 15 01 00 00       	call   80104e83 <holding>
80104d6e:	85 c0                	test   %eax,%eax
80104d70:	74 0c                	je     80104d7e <acquire+0x27>
    panic("acquire");
80104d72:	c7 04 24 66 87 10 80 	movl   $0x80108766,(%esp)
80104d79:	e8 e4 b7 ff ff       	call   80100562 <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104d7e:	90                   	nop
80104d7f:	8b 45 08             	mov    0x8(%ebp),%eax
80104d82:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104d89:	00 
80104d8a:	89 04 24             	mov    %eax,(%esp)
80104d8d:	e8 8a ff ff ff       	call   80104d1c <xchg>
80104d92:	85 c0                	test   %eax,%eax
80104d94:	75 e9                	jne    80104d7f <acquire+0x28>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104d96:	0f ae f0             	mfence 

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104d99:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104d9c:	e8 26 f3 ff ff       	call   801040c7 <mycpu>
80104da1:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80104da4:	8b 45 08             	mov    0x8(%ebp),%eax
80104da7:	83 c0 0c             	add    $0xc,%eax
80104daa:	89 44 24 04          	mov    %eax,0x4(%esp)
80104dae:	8d 45 08             	lea    0x8(%ebp),%eax
80104db1:	89 04 24             	mov    %eax,(%esp)
80104db4:	e8 51 00 00 00       	call   80104e0a <getcallerpcs>
}
80104db9:	83 c4 14             	add    $0x14,%esp
80104dbc:	5b                   	pop    %ebx
80104dbd:	5d                   	pop    %ebp
80104dbe:	c3                   	ret    

80104dbf <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104dbf:	55                   	push   %ebp
80104dc0:	89 e5                	mov    %esp,%ebp
80104dc2:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104dc5:	8b 45 08             	mov    0x8(%ebp),%eax
80104dc8:	89 04 24             	mov    %eax,(%esp)
80104dcb:	e8 b3 00 00 00       	call   80104e83 <holding>
80104dd0:	85 c0                	test   %eax,%eax
80104dd2:	75 0c                	jne    80104de0 <release+0x21>
    panic("release");
80104dd4:	c7 04 24 6e 87 10 80 	movl   $0x8010876e,(%esp)
80104ddb:	e8 82 b7 ff ff       	call   80100562 <panic>

  lk->pcs[0] = 0;
80104de0:	8b 45 08             	mov    0x8(%ebp),%eax
80104de3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104dea:	8b 45 08             	mov    0x8(%ebp),%eax
80104ded:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104df4:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104df7:	8b 45 08             	mov    0x8(%ebp),%eax
80104dfa:	8b 55 08             	mov    0x8(%ebp),%edx
80104dfd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80104e03:	e8 f8 00 00 00       	call   80104f00 <popcli>
}
80104e08:	c9                   	leave  
80104e09:	c3                   	ret    

80104e0a <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104e0a:	55                   	push   %ebp
80104e0b:	89 e5                	mov    %esp,%ebp
80104e0d:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104e10:	8b 45 08             	mov    0x8(%ebp),%eax
80104e13:	83 e8 08             	sub    $0x8,%eax
80104e16:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104e19:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104e20:	eb 38                	jmp    80104e5a <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e22:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104e26:	74 38                	je     80104e60 <getcallerpcs+0x56>
80104e28:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104e2f:	76 2f                	jbe    80104e60 <getcallerpcs+0x56>
80104e31:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104e35:	74 29                	je     80104e60 <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104e37:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e3a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104e41:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e44:	01 c2                	add    %eax,%edx
80104e46:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e49:	8b 40 04             	mov    0x4(%eax),%eax
80104e4c:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104e4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e51:	8b 00                	mov    (%eax),%eax
80104e53:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104e56:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104e5a:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104e5e:	7e c2                	jle    80104e22 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
80104e60:	eb 19                	jmp    80104e7b <getcallerpcs+0x71>
    pcs[i] = 0;
80104e62:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e65:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e6f:	01 d0                	add    %edx,%eax
80104e71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104e77:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80104e7b:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104e7f:	7e e1                	jle    80104e62 <getcallerpcs+0x58>
}
80104e81:	c9                   	leave  
80104e82:	c3                   	ret    

80104e83 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104e83:	55                   	push   %ebp
80104e84:	89 e5                	mov    %esp,%ebp
80104e86:	53                   	push   %ebx
80104e87:	83 ec 04             	sub    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104e8a:	8b 45 08             	mov    0x8(%ebp),%eax
80104e8d:	8b 00                	mov    (%eax),%eax
80104e8f:	85 c0                	test   %eax,%eax
80104e91:	74 16                	je     80104ea9 <holding+0x26>
80104e93:	8b 45 08             	mov    0x8(%ebp),%eax
80104e96:	8b 58 08             	mov    0x8(%eax),%ebx
80104e99:	e8 29 f2 ff ff       	call   801040c7 <mycpu>
80104e9e:	39 c3                	cmp    %eax,%ebx
80104ea0:	75 07                	jne    80104ea9 <holding+0x26>
80104ea2:	b8 01 00 00 00       	mov    $0x1,%eax
80104ea7:	eb 05                	jmp    80104eae <holding+0x2b>
80104ea9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104eae:	83 c4 04             	add    $0x4,%esp
80104eb1:	5b                   	pop    %ebx
80104eb2:	5d                   	pop    %ebp
80104eb3:	c3                   	ret    

80104eb4 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104eb4:	55                   	push   %ebp
80104eb5:	89 e5                	mov    %esp,%ebp
80104eb7:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
80104eba:	e8 41 fe ff ff       	call   80104d00 <readeflags>
80104ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
80104ec2:	e8 49 fe ff ff       	call   80104d10 <cli>
  if(mycpu()->ncli == 0)
80104ec7:	e8 fb f1 ff ff       	call   801040c7 <mycpu>
80104ecc:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ed2:	85 c0                	test   %eax,%eax
80104ed4:	75 14                	jne    80104eea <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
80104ed6:	e8 ec f1 ff ff       	call   801040c7 <mycpu>
80104edb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ede:	81 e2 00 02 00 00    	and    $0x200,%edx
80104ee4:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
80104eea:	e8 d8 f1 ff ff       	call   801040c7 <mycpu>
80104eef:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104ef5:	83 c2 01             	add    $0x1,%edx
80104ef8:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80104efe:	c9                   	leave  
80104eff:	c3                   	ret    

80104f00 <popcli>:

void
popcli(void)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80104f06:	e8 f5 fd ff ff       	call   80104d00 <readeflags>
80104f0b:	25 00 02 00 00       	and    $0x200,%eax
80104f10:	85 c0                	test   %eax,%eax
80104f12:	74 0c                	je     80104f20 <popcli+0x20>
    panic("popcli - interruptible");
80104f14:	c7 04 24 76 87 10 80 	movl   $0x80108776,(%esp)
80104f1b:	e8 42 b6 ff ff       	call   80100562 <panic>
  if(--mycpu()->ncli < 0)
80104f20:	e8 a2 f1 ff ff       	call   801040c7 <mycpu>
80104f25:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104f2b:	83 ea 01             	sub    $0x1,%edx
80104f2e:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104f34:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104f3a:	85 c0                	test   %eax,%eax
80104f3c:	79 0c                	jns    80104f4a <popcli+0x4a>
    panic("popcli");
80104f3e:	c7 04 24 8d 87 10 80 	movl   $0x8010878d,(%esp)
80104f45:	e8 18 b6 ff ff       	call   80100562 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104f4a:	e8 78 f1 ff ff       	call   801040c7 <mycpu>
80104f4f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104f55:	85 c0                	test   %eax,%eax
80104f57:	75 14                	jne    80104f6d <popcli+0x6d>
80104f59:	e8 69 f1 ff ff       	call   801040c7 <mycpu>
80104f5e:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104f64:	85 c0                	test   %eax,%eax
80104f66:	74 05                	je     80104f6d <popcli+0x6d>
    sti();
80104f68:	e8 a9 fd ff ff       	call   80104d16 <sti>
}
80104f6d:	c9                   	leave  
80104f6e:	c3                   	ret    

80104f6f <stosb>:
{
80104f6f:	55                   	push   %ebp
80104f70:	89 e5                	mov    %esp,%ebp
80104f72:	57                   	push   %edi
80104f73:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80104f74:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f77:	8b 55 10             	mov    0x10(%ebp),%edx
80104f7a:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f7d:	89 cb                	mov    %ecx,%ebx
80104f7f:	89 df                	mov    %ebx,%edi
80104f81:	89 d1                	mov    %edx,%ecx
80104f83:	fc                   	cld    
80104f84:	f3 aa                	rep stos %al,%es:(%edi)
80104f86:	89 ca                	mov    %ecx,%edx
80104f88:	89 fb                	mov    %edi,%ebx
80104f8a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104f8d:	89 55 10             	mov    %edx,0x10(%ebp)
}
80104f90:	5b                   	pop    %ebx
80104f91:	5f                   	pop    %edi
80104f92:	5d                   	pop    %ebp
80104f93:	c3                   	ret    

80104f94 <stosl>:
{
80104f94:	55                   	push   %ebp
80104f95:	89 e5                	mov    %esp,%ebp
80104f97:	57                   	push   %edi
80104f98:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80104f99:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f9c:	8b 55 10             	mov    0x10(%ebp),%edx
80104f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fa2:	89 cb                	mov    %ecx,%ebx
80104fa4:	89 df                	mov    %ebx,%edi
80104fa6:	89 d1                	mov    %edx,%ecx
80104fa8:	fc                   	cld    
80104fa9:	f3 ab                	rep stos %eax,%es:(%edi)
80104fab:	89 ca                	mov    %ecx,%edx
80104fad:	89 fb                	mov    %edi,%ebx
80104faf:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104fb2:	89 55 10             	mov    %edx,0x10(%ebp)
}
80104fb5:	5b                   	pop    %ebx
80104fb6:	5f                   	pop    %edi
80104fb7:	5d                   	pop    %ebp
80104fb8:	c3                   	ret    

80104fb9 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104fb9:	55                   	push   %ebp
80104fba:	89 e5                	mov    %esp,%ebp
80104fbc:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80104fbf:	8b 45 08             	mov    0x8(%ebp),%eax
80104fc2:	83 e0 03             	and    $0x3,%eax
80104fc5:	85 c0                	test   %eax,%eax
80104fc7:	75 49                	jne    80105012 <memset+0x59>
80104fc9:	8b 45 10             	mov    0x10(%ebp),%eax
80104fcc:	83 e0 03             	and    $0x3,%eax
80104fcf:	85 c0                	test   %eax,%eax
80104fd1:	75 3f                	jne    80105012 <memset+0x59>
    c &= 0xFF;
80104fd3:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104fda:	8b 45 10             	mov    0x10(%ebp),%eax
80104fdd:	c1 e8 02             	shr    $0x2,%eax
80104fe0:	89 c2                	mov    %eax,%edx
80104fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fe5:	c1 e0 18             	shl    $0x18,%eax
80104fe8:	89 c1                	mov    %eax,%ecx
80104fea:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fed:	c1 e0 10             	shl    $0x10,%eax
80104ff0:	09 c1                	or     %eax,%ecx
80104ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ff5:	c1 e0 08             	shl    $0x8,%eax
80104ff8:	09 c8                	or     %ecx,%eax
80104ffa:	0b 45 0c             	or     0xc(%ebp),%eax
80104ffd:	89 54 24 08          	mov    %edx,0x8(%esp)
80105001:	89 44 24 04          	mov    %eax,0x4(%esp)
80105005:	8b 45 08             	mov    0x8(%ebp),%eax
80105008:	89 04 24             	mov    %eax,(%esp)
8010500b:	e8 84 ff ff ff       	call   80104f94 <stosl>
80105010:	eb 19                	jmp    8010502b <memset+0x72>
  } else
    stosb(dst, c, n);
80105012:	8b 45 10             	mov    0x10(%ebp),%eax
80105015:	89 44 24 08          	mov    %eax,0x8(%esp)
80105019:	8b 45 0c             	mov    0xc(%ebp),%eax
8010501c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105020:	8b 45 08             	mov    0x8(%ebp),%eax
80105023:	89 04 24             	mov    %eax,(%esp)
80105026:	e8 44 ff ff ff       	call   80104f6f <stosb>
  return dst;
8010502b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010502e:	c9                   	leave  
8010502f:	c3                   	ret    

80105030 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
80105036:	8b 45 08             	mov    0x8(%ebp),%eax
80105039:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
8010503c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010503f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105042:	eb 30                	jmp    80105074 <memcmp+0x44>
    if(*s1 != *s2)
80105044:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105047:	0f b6 10             	movzbl (%eax),%edx
8010504a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010504d:	0f b6 00             	movzbl (%eax),%eax
80105050:	38 c2                	cmp    %al,%dl
80105052:	74 18                	je     8010506c <memcmp+0x3c>
      return *s1 - *s2;
80105054:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105057:	0f b6 00             	movzbl (%eax),%eax
8010505a:	0f b6 d0             	movzbl %al,%edx
8010505d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105060:	0f b6 00             	movzbl (%eax),%eax
80105063:	0f b6 c0             	movzbl %al,%eax
80105066:	29 c2                	sub    %eax,%edx
80105068:	89 d0                	mov    %edx,%eax
8010506a:	eb 1a                	jmp    80105086 <memcmp+0x56>
    s1++, s2++;
8010506c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105070:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
80105074:	8b 45 10             	mov    0x10(%ebp),%eax
80105077:	8d 50 ff             	lea    -0x1(%eax),%edx
8010507a:	89 55 10             	mov    %edx,0x10(%ebp)
8010507d:	85 c0                	test   %eax,%eax
8010507f:	75 c3                	jne    80105044 <memcmp+0x14>
  }

  return 0;
80105081:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105086:	c9                   	leave  
80105087:	c3                   	ret    

80105088 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105088:	55                   	push   %ebp
80105089:	89 e5                	mov    %esp,%ebp
8010508b:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
8010508e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105091:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105094:	8b 45 08             	mov    0x8(%ebp),%eax
80105097:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
8010509a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010509d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801050a0:	73 3d                	jae    801050df <memmove+0x57>
801050a2:	8b 45 10             	mov    0x10(%ebp),%eax
801050a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
801050a8:	01 d0                	add    %edx,%eax
801050aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801050ad:	76 30                	jbe    801050df <memmove+0x57>
    s += n;
801050af:	8b 45 10             	mov    0x10(%ebp),%eax
801050b2:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801050b5:	8b 45 10             	mov    0x10(%ebp),%eax
801050b8:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801050bb:	eb 13                	jmp    801050d0 <memmove+0x48>
      *--d = *--s;
801050bd:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801050c1:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801050c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050c8:	0f b6 10             	movzbl (%eax),%edx
801050cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
801050ce:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
801050d0:	8b 45 10             	mov    0x10(%ebp),%eax
801050d3:	8d 50 ff             	lea    -0x1(%eax),%edx
801050d6:	89 55 10             	mov    %edx,0x10(%ebp)
801050d9:	85 c0                	test   %eax,%eax
801050db:	75 e0                	jne    801050bd <memmove+0x35>
  if(s < d && s + n > d){
801050dd:	eb 26                	jmp    80105105 <memmove+0x7d>
  } else
    while(n-- > 0)
801050df:	eb 17                	jmp    801050f8 <memmove+0x70>
      *d++ = *s++;
801050e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801050e4:	8d 50 01             	lea    0x1(%eax),%edx
801050e7:	89 55 f8             	mov    %edx,-0x8(%ebp)
801050ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
801050ed:	8d 4a 01             	lea    0x1(%edx),%ecx
801050f0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801050f3:	0f b6 12             	movzbl (%edx),%edx
801050f6:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
801050f8:	8b 45 10             	mov    0x10(%ebp),%eax
801050fb:	8d 50 ff             	lea    -0x1(%eax),%edx
801050fe:	89 55 10             	mov    %edx,0x10(%ebp)
80105101:	85 c0                	test   %eax,%eax
80105103:	75 dc                	jne    801050e1 <memmove+0x59>

  return dst;
80105105:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105108:	c9                   	leave  
80105109:	c3                   	ret    

8010510a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
8010510a:	55                   	push   %ebp
8010510b:	89 e5                	mov    %esp,%ebp
8010510d:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105110:	8b 45 10             	mov    0x10(%ebp),%eax
80105113:	89 44 24 08          	mov    %eax,0x8(%esp)
80105117:	8b 45 0c             	mov    0xc(%ebp),%eax
8010511a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010511e:	8b 45 08             	mov    0x8(%ebp),%eax
80105121:	89 04 24             	mov    %eax,(%esp)
80105124:	e8 5f ff ff ff       	call   80105088 <memmove>
}
80105129:	c9                   	leave  
8010512a:	c3                   	ret    

8010512b <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010512b:	55                   	push   %ebp
8010512c:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
8010512e:	eb 0c                	jmp    8010513c <strncmp+0x11>
    n--, p++, q++;
80105130:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105134:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105138:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
8010513c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105140:	74 1a                	je     8010515c <strncmp+0x31>
80105142:	8b 45 08             	mov    0x8(%ebp),%eax
80105145:	0f b6 00             	movzbl (%eax),%eax
80105148:	84 c0                	test   %al,%al
8010514a:	74 10                	je     8010515c <strncmp+0x31>
8010514c:	8b 45 08             	mov    0x8(%ebp),%eax
8010514f:	0f b6 10             	movzbl (%eax),%edx
80105152:	8b 45 0c             	mov    0xc(%ebp),%eax
80105155:	0f b6 00             	movzbl (%eax),%eax
80105158:	38 c2                	cmp    %al,%dl
8010515a:	74 d4                	je     80105130 <strncmp+0x5>
  if(n == 0)
8010515c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105160:	75 07                	jne    80105169 <strncmp+0x3e>
    return 0;
80105162:	b8 00 00 00 00       	mov    $0x0,%eax
80105167:	eb 16                	jmp    8010517f <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80105169:	8b 45 08             	mov    0x8(%ebp),%eax
8010516c:	0f b6 00             	movzbl (%eax),%eax
8010516f:	0f b6 d0             	movzbl %al,%edx
80105172:	8b 45 0c             	mov    0xc(%ebp),%eax
80105175:	0f b6 00             	movzbl (%eax),%eax
80105178:	0f b6 c0             	movzbl %al,%eax
8010517b:	29 c2                	sub    %eax,%edx
8010517d:	89 d0                	mov    %edx,%eax
}
8010517f:	5d                   	pop    %ebp
80105180:	c3                   	ret    

80105181 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105181:	55                   	push   %ebp
80105182:	89 e5                	mov    %esp,%ebp
80105184:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80105187:	8b 45 08             	mov    0x8(%ebp),%eax
8010518a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010518d:	90                   	nop
8010518e:	8b 45 10             	mov    0x10(%ebp),%eax
80105191:	8d 50 ff             	lea    -0x1(%eax),%edx
80105194:	89 55 10             	mov    %edx,0x10(%ebp)
80105197:	85 c0                	test   %eax,%eax
80105199:	7e 1e                	jle    801051b9 <strncpy+0x38>
8010519b:	8b 45 08             	mov    0x8(%ebp),%eax
8010519e:	8d 50 01             	lea    0x1(%eax),%edx
801051a1:	89 55 08             	mov    %edx,0x8(%ebp)
801051a4:	8b 55 0c             	mov    0xc(%ebp),%edx
801051a7:	8d 4a 01             	lea    0x1(%edx),%ecx
801051aa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801051ad:	0f b6 12             	movzbl (%edx),%edx
801051b0:	88 10                	mov    %dl,(%eax)
801051b2:	0f b6 00             	movzbl (%eax),%eax
801051b5:	84 c0                	test   %al,%al
801051b7:	75 d5                	jne    8010518e <strncpy+0xd>
    ;
  while(n-- > 0)
801051b9:	eb 0c                	jmp    801051c7 <strncpy+0x46>
    *s++ = 0;
801051bb:	8b 45 08             	mov    0x8(%ebp),%eax
801051be:	8d 50 01             	lea    0x1(%eax),%edx
801051c1:	89 55 08             	mov    %edx,0x8(%ebp)
801051c4:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
801051c7:	8b 45 10             	mov    0x10(%ebp),%eax
801051ca:	8d 50 ff             	lea    -0x1(%eax),%edx
801051cd:	89 55 10             	mov    %edx,0x10(%ebp)
801051d0:	85 c0                	test   %eax,%eax
801051d2:	7f e7                	jg     801051bb <strncpy+0x3a>
  return os;
801051d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801051d7:	c9                   	leave  
801051d8:	c3                   	ret    

801051d9 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801051d9:	55                   	push   %ebp
801051da:	89 e5                	mov    %esp,%ebp
801051dc:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
801051df:	8b 45 08             	mov    0x8(%ebp),%eax
801051e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801051e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801051e9:	7f 05                	jg     801051f0 <safestrcpy+0x17>
    return os;
801051eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051ee:	eb 31                	jmp    80105221 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801051f0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801051f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801051f8:	7e 1e                	jle    80105218 <safestrcpy+0x3f>
801051fa:	8b 45 08             	mov    0x8(%ebp),%eax
801051fd:	8d 50 01             	lea    0x1(%eax),%edx
80105200:	89 55 08             	mov    %edx,0x8(%ebp)
80105203:	8b 55 0c             	mov    0xc(%ebp),%edx
80105206:	8d 4a 01             	lea    0x1(%edx),%ecx
80105209:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010520c:	0f b6 12             	movzbl (%edx),%edx
8010520f:	88 10                	mov    %dl,(%eax)
80105211:	0f b6 00             	movzbl (%eax),%eax
80105214:	84 c0                	test   %al,%al
80105216:	75 d8                	jne    801051f0 <safestrcpy+0x17>
    ;
  *s = 0;
80105218:	8b 45 08             	mov    0x8(%ebp),%eax
8010521b:	c6 00 00             	movb   $0x0,(%eax)
  return os;
8010521e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105221:	c9                   	leave  
80105222:	c3                   	ret    

80105223 <strlen>:

int
strlen(const char *s)
{
80105223:	55                   	push   %ebp
80105224:	89 e5                	mov    %esp,%ebp
80105226:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105229:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105230:	eb 04                	jmp    80105236 <strlen+0x13>
80105232:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105236:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105239:	8b 45 08             	mov    0x8(%ebp),%eax
8010523c:	01 d0                	add    %edx,%eax
8010523e:	0f b6 00             	movzbl (%eax),%eax
80105241:	84 c0                	test   %al,%al
80105243:	75 ed                	jne    80105232 <strlen+0xf>
    ;
  return n;
80105245:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105248:	c9                   	leave  
80105249:	c3                   	ret    

8010524a <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010524a:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010524e:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105252:	55                   	push   %ebp
  pushl %ebx
80105253:	53                   	push   %ebx
  pushl %esi
80105254:	56                   	push   %esi
  pushl %edi
80105255:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105256:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105258:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010525a:	5f                   	pop    %edi
  popl %esi
8010525b:	5e                   	pop    %esi
  popl %ebx
8010525c:	5b                   	pop    %ebx
  popl %ebp
8010525d:	5d                   	pop    %ebp
  ret
8010525e:	c3                   	ret    

8010525f <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010525f:	55                   	push   %ebp
80105260:	89 e5                	mov    %esp,%ebp
  //struct proc *curproc = myproc();

  //if(addr >= curproc->sz || addr+4 > curproc->sz)
  //  return -1;
  *ip = *(int*)(addr);
80105262:	8b 45 08             	mov    0x8(%ebp),%eax
80105265:	8b 10                	mov    (%eax),%edx
80105267:	8b 45 0c             	mov    0xc(%ebp),%eax
8010526a:	89 10                	mov    %edx,(%eax)
  return 0;
8010526c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105271:	5d                   	pop    %ebp
80105272:	c3                   	ret    

80105273 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105273:	55                   	push   %ebp
80105274:	89 e5                	mov    %esp,%ebp
80105276:	83 ec 10             	sub    $0x10,%esp
  char *s;// *ep;
  //struct proc *curproc = myproc();

  //if(addr >= curproc->sz)
  //  return -1;
  *pp = (char*)addr;
80105279:	8b 55 08             	mov    0x8(%ebp),%edx
8010527c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010527f:	89 10                	mov    %edx,(%eax)
  //ep = (char*)curproc->sz;
  s = *pp;
80105281:	8b 45 0c             	mov    0xc(%ebp),%eax
80105284:	8b 00                	mov    (%eax),%eax
80105286:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(*s != 0) {
80105289:	eb 04                	jmp    8010528f <fetchstr+0x1c>
  	s++;
8010528b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  while(*s != 0) {
8010528f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105292:	0f b6 00             	movzbl (%eax),%eax
80105295:	84 c0                	test   %al,%al
80105297:	75 f2                	jne    8010528b <fetchstr+0x18>
  }
  return s - *pp;
80105299:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010529c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010529f:	8b 00                	mov    (%eax),%eax
801052a1:	29 c2                	sub    %eax,%edx
801052a3:	89 d0                	mov    %edx,%eax
  //for(s = *pp; s < ep; s++){
  //  if(*s == 0)
  //    return s - *pp;
  //}
  //return -1;
}
801052a5:	c9                   	leave  
801052a6:	c3                   	ret    

801052a7 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801052a7:	55                   	push   %ebp
801052a8:	89 e5                	mov    %esp,%ebp
801052aa:	83 ec 18             	sub    $0x18,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801052ad:	e8 8b ee ff ff       	call   8010413d <myproc>
801052b2:	8b 40 18             	mov    0x18(%eax),%eax
801052b5:	8b 50 44             	mov    0x44(%eax),%edx
801052b8:	8b 45 08             	mov    0x8(%ebp),%eax
801052bb:	c1 e0 02             	shl    $0x2,%eax
801052be:	01 d0                	add    %edx,%eax
801052c0:	8d 50 04             	lea    0x4(%eax),%edx
801052c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801052c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801052ca:	89 14 24             	mov    %edx,(%esp)
801052cd:	e8 8d ff ff ff       	call   8010525f <fetchint>
}
801052d2:	c9                   	leave  
801052d3:	c3                   	ret    

801052d4 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801052d4:	55                   	push   %ebp
801052d5:	89 e5                	mov    %esp,%ebp
801052d7:	83 ec 28             	sub    $0x28,%esp
  int i;
  //struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
801052da:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801052e1:	8b 45 08             	mov    0x8(%ebp),%eax
801052e4:	89 04 24             	mov    %eax,(%esp)
801052e7:	e8 bb ff ff ff       	call   801052a7 <argint>
801052ec:	85 c0                	test   %eax,%eax
801052ee:	79 07                	jns    801052f7 <argptr+0x23>
    return -1;
801052f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052f5:	eb 0f                	jmp    80105306 <argptr+0x32>
  //if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
  //  return -1;
  *pp = (char*)i;
801052f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052fa:	89 c2                	mov    %eax,%edx
801052fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801052ff:	89 10                	mov    %edx,(%eax)
  return 0;
80105301:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105306:	c9                   	leave  
80105307:	c3                   	ret    

80105308 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105308:	55                   	push   %ebp
80105309:	89 e5                	mov    %esp,%ebp
8010530b:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010530e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105311:	89 44 24 04          	mov    %eax,0x4(%esp)
80105315:	8b 45 08             	mov    0x8(%ebp),%eax
80105318:	89 04 24             	mov    %eax,(%esp)
8010531b:	e8 87 ff ff ff       	call   801052a7 <argint>
80105320:	85 c0                	test   %eax,%eax
80105322:	79 07                	jns    8010532b <argstr+0x23>
    return -1;
80105324:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105329:	eb 12                	jmp    8010533d <argstr+0x35>
  return fetchstr(addr, pp);
8010532b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010532e:	8b 55 0c             	mov    0xc(%ebp),%edx
80105331:	89 54 24 04          	mov    %edx,0x4(%esp)
80105335:	89 04 24             	mov    %eax,(%esp)
80105338:	e8 36 ff ff ff       	call   80105273 <fetchstr>
}
8010533d:	c9                   	leave  
8010533e:	c3                   	ret    

8010533f <syscall>:
[SYS_shm_close] sys_shm_close
};

void
syscall(void)
{
8010533f:	55                   	push   %ebp
80105340:	89 e5                	mov    %esp,%ebp
80105342:	53                   	push   %ebx
80105343:	83 ec 24             	sub    $0x24,%esp
  int num;
  struct proc *curproc = myproc();
80105346:	e8 f2 ed ff ff       	call   8010413d <myproc>
8010534b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
8010534e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105351:	8b 40 18             	mov    0x18(%eax),%eax
80105354:	8b 40 1c             	mov    0x1c(%eax),%eax
80105357:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010535a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010535e:	7e 2d                	jle    8010538d <syscall+0x4e>
80105360:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105363:	83 f8 17             	cmp    $0x17,%eax
80105366:	77 25                	ja     8010538d <syscall+0x4e>
80105368:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010536b:	8b 04 85 20 b0 10 80 	mov    -0x7fef4fe0(,%eax,4),%eax
80105372:	85 c0                	test   %eax,%eax
80105374:	74 17                	je     8010538d <syscall+0x4e>
    curproc->tf->eax = syscalls[num]();
80105376:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105379:	8b 58 18             	mov    0x18(%eax),%ebx
8010537c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010537f:	8b 04 85 20 b0 10 80 	mov    -0x7fef4fe0(,%eax,4),%eax
80105386:	ff d0                	call   *%eax
80105388:	89 43 1c             	mov    %eax,0x1c(%ebx)
8010538b:	eb 34                	jmp    801053c1 <syscall+0x82>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
8010538d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105390:	8d 48 6c             	lea    0x6c(%eax),%ecx
    cprintf("%d %s: unknown sys call %d\n",
80105393:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105396:	8b 40 10             	mov    0x10(%eax),%eax
80105399:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010539c:	89 54 24 0c          	mov    %edx,0xc(%esp)
801053a0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801053a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801053a8:	c7 04 24 94 87 10 80 	movl   $0x80108794,(%esp)
801053af:	e8 14 b0 ff ff       	call   801003c8 <cprintf>
    curproc->tf->eax = -1;
801053b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053b7:	8b 40 18             	mov    0x18(%eax),%eax
801053ba:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801053c1:	83 c4 24             	add    $0x24,%esp
801053c4:	5b                   	pop    %ebx
801053c5:	5d                   	pop    %ebp
801053c6:	c3                   	ret    

801053c7 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801053c7:	55                   	push   %ebp
801053c8:	89 e5                	mov    %esp,%ebp
801053ca:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801053cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801053d4:	8b 45 08             	mov    0x8(%ebp),%eax
801053d7:	89 04 24             	mov    %eax,(%esp)
801053da:	e8 c8 fe ff ff       	call   801052a7 <argint>
801053df:	85 c0                	test   %eax,%eax
801053e1:	79 07                	jns    801053ea <argfd+0x23>
    return -1;
801053e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053e8:	eb 4f                	jmp    80105439 <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801053ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053ed:	85 c0                	test   %eax,%eax
801053ef:	78 20                	js     80105411 <argfd+0x4a>
801053f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053f4:	83 f8 0f             	cmp    $0xf,%eax
801053f7:	7f 18                	jg     80105411 <argfd+0x4a>
801053f9:	e8 3f ed ff ff       	call   8010413d <myproc>
801053fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105401:	83 c2 08             	add    $0x8,%edx
80105404:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105408:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010540b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010540f:	75 07                	jne    80105418 <argfd+0x51>
    return -1;
80105411:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105416:	eb 21                	jmp    80105439 <argfd+0x72>
  if(pfd)
80105418:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010541c:	74 08                	je     80105426 <argfd+0x5f>
    *pfd = fd;
8010541e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105421:	8b 45 0c             	mov    0xc(%ebp),%eax
80105424:	89 10                	mov    %edx,(%eax)
  if(pf)
80105426:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010542a:	74 08                	je     80105434 <argfd+0x6d>
    *pf = f;
8010542c:	8b 45 10             	mov    0x10(%ebp),%eax
8010542f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105432:	89 10                	mov    %edx,(%eax)
  return 0;
80105434:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105439:	c9                   	leave  
8010543a:	c3                   	ret    

8010543b <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010543b:	55                   	push   %ebp
8010543c:	89 e5                	mov    %esp,%ebp
8010543e:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
80105441:	e8 f7 ec ff ff       	call   8010413d <myproc>
80105446:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
80105449:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105450:	eb 2a                	jmp    8010547c <fdalloc+0x41>
    if(curproc->ofile[fd] == 0){
80105452:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105455:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105458:	83 c2 08             	add    $0x8,%edx
8010545b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010545f:	85 c0                	test   %eax,%eax
80105461:	75 15                	jne    80105478 <fdalloc+0x3d>
      curproc->ofile[fd] = f;
80105463:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105466:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105469:	8d 4a 08             	lea    0x8(%edx),%ecx
8010546c:	8b 55 08             	mov    0x8(%ebp),%edx
8010546f:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105473:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105476:	eb 0f                	jmp    80105487 <fdalloc+0x4c>
  for(fd = 0; fd < NOFILE; fd++){
80105478:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010547c:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105480:	7e d0                	jle    80105452 <fdalloc+0x17>
    }
  }
  return -1;
80105482:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105487:	c9                   	leave  
80105488:	c3                   	ret    

80105489 <sys_dup>:

int
sys_dup(void)
{
80105489:	55                   	push   %ebp
8010548a:	89 e5                	mov    %esp,%ebp
8010548c:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
8010548f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105492:	89 44 24 08          	mov    %eax,0x8(%esp)
80105496:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010549d:	00 
8010549e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054a5:	e8 1d ff ff ff       	call   801053c7 <argfd>
801054aa:	85 c0                	test   %eax,%eax
801054ac:	79 07                	jns    801054b5 <sys_dup+0x2c>
    return -1;
801054ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054b3:	eb 29                	jmp    801054de <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801054b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054b8:	89 04 24             	mov    %eax,(%esp)
801054bb:	e8 7b ff ff ff       	call   8010543b <fdalloc>
801054c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801054c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801054c7:	79 07                	jns    801054d0 <sys_dup+0x47>
    return -1;
801054c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ce:	eb 0e                	jmp    801054de <sys_dup+0x55>
  filedup(f);
801054d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054d3:	89 04 24             	mov    %eax,(%esp)
801054d6:	e8 e1 ba ff ff       	call   80100fbc <filedup>
  return fd;
801054db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801054de:	c9                   	leave  
801054df:	c3                   	ret    

801054e0 <sys_read>:

int
sys_read(void)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054e9:	89 44 24 08          	mov    %eax,0x8(%esp)
801054ed:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801054f4:	00 
801054f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054fc:	e8 c6 fe ff ff       	call   801053c7 <argfd>
80105501:	85 c0                	test   %eax,%eax
80105503:	78 35                	js     8010553a <sys_read+0x5a>
80105505:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105508:	89 44 24 04          	mov    %eax,0x4(%esp)
8010550c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105513:	e8 8f fd ff ff       	call   801052a7 <argint>
80105518:	85 c0                	test   %eax,%eax
8010551a:	78 1e                	js     8010553a <sys_read+0x5a>
8010551c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010551f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105523:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105526:	89 44 24 04          	mov    %eax,0x4(%esp)
8010552a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105531:	e8 9e fd ff ff       	call   801052d4 <argptr>
80105536:	85 c0                	test   %eax,%eax
80105538:	79 07                	jns    80105541 <sys_read+0x61>
    return -1;
8010553a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010553f:	eb 19                	jmp    8010555a <sys_read+0x7a>
  return fileread(f, p, n);
80105541:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105544:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105547:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010554a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010554e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105552:	89 04 24             	mov    %eax,(%esp)
80105555:	e8 cf bb ff ff       	call   80101129 <fileread>
}
8010555a:	c9                   	leave  
8010555b:	c3                   	ret    

8010555c <sys_write>:

int
sys_write(void)
{
8010555c:	55                   	push   %ebp
8010555d:	89 e5                	mov    %esp,%ebp
8010555f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105562:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105565:	89 44 24 08          	mov    %eax,0x8(%esp)
80105569:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105570:	00 
80105571:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105578:	e8 4a fe ff ff       	call   801053c7 <argfd>
8010557d:	85 c0                	test   %eax,%eax
8010557f:	78 35                	js     801055b6 <sys_write+0x5a>
80105581:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105584:	89 44 24 04          	mov    %eax,0x4(%esp)
80105588:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010558f:	e8 13 fd ff ff       	call   801052a7 <argint>
80105594:	85 c0                	test   %eax,%eax
80105596:	78 1e                	js     801055b6 <sys_write+0x5a>
80105598:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010559b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010559f:	8d 45 ec             	lea    -0x14(%ebp),%eax
801055a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801055a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801055ad:	e8 22 fd ff ff       	call   801052d4 <argptr>
801055b2:	85 c0                	test   %eax,%eax
801055b4:	79 07                	jns    801055bd <sys_write+0x61>
    return -1;
801055b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055bb:	eb 19                	jmp    801055d6 <sys_write+0x7a>
  return filewrite(f, p, n);
801055bd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801055c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
801055c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055c6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801055ca:	89 54 24 04          	mov    %edx,0x4(%esp)
801055ce:	89 04 24             	mov    %eax,(%esp)
801055d1:	e8 0f bc ff ff       	call   801011e5 <filewrite>
}
801055d6:	c9                   	leave  
801055d7:	c3                   	ret    

801055d8 <sys_close>:

int
sys_close(void)
{
801055d8:	55                   	push   %ebp
801055d9:	89 e5                	mov    %esp,%ebp
801055db:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801055de:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055e1:	89 44 24 08          	mov    %eax,0x8(%esp)
801055e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055e8:	89 44 24 04          	mov    %eax,0x4(%esp)
801055ec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055f3:	e8 cf fd ff ff       	call   801053c7 <argfd>
801055f8:	85 c0                	test   %eax,%eax
801055fa:	79 07                	jns    80105603 <sys_close+0x2b>
    return -1;
801055fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105601:	eb 23                	jmp    80105626 <sys_close+0x4e>
  myproc()->ofile[fd] = 0;
80105603:	e8 35 eb ff ff       	call   8010413d <myproc>
80105608:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010560b:	83 c2 08             	add    $0x8,%edx
8010560e:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105615:	00 
  fileclose(f);
80105616:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105619:	89 04 24             	mov    %eax,(%esp)
8010561c:	e8 e3 b9 ff ff       	call   80101004 <fileclose>
  return 0;
80105621:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105626:	c9                   	leave  
80105627:	c3                   	ret    

80105628 <sys_fstat>:

int
sys_fstat(void)
{
80105628:	55                   	push   %ebp
80105629:	89 e5                	mov    %esp,%ebp
8010562b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010562e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105631:	89 44 24 08          	mov    %eax,0x8(%esp)
80105635:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010563c:	00 
8010563d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105644:	e8 7e fd ff ff       	call   801053c7 <argfd>
80105649:	85 c0                	test   %eax,%eax
8010564b:	78 1f                	js     8010566c <sys_fstat+0x44>
8010564d:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105654:	00 
80105655:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105658:	89 44 24 04          	mov    %eax,0x4(%esp)
8010565c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105663:	e8 6c fc ff ff       	call   801052d4 <argptr>
80105668:	85 c0                	test   %eax,%eax
8010566a:	79 07                	jns    80105673 <sys_fstat+0x4b>
    return -1;
8010566c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105671:	eb 12                	jmp    80105685 <sys_fstat+0x5d>
  return filestat(f, st);
80105673:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105676:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105679:	89 54 24 04          	mov    %edx,0x4(%esp)
8010567d:	89 04 24             	mov    %eax,(%esp)
80105680:	e8 55 ba ff ff       	call   801010da <filestat>
}
80105685:	c9                   	leave  
80105686:	c3                   	ret    

80105687 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105687:	55                   	push   %ebp
80105688:	89 e5                	mov    %esp,%ebp
8010568a:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010568d:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105690:	89 44 24 04          	mov    %eax,0x4(%esp)
80105694:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010569b:	e8 68 fc ff ff       	call   80105308 <argstr>
801056a0:	85 c0                	test   %eax,%eax
801056a2:	78 17                	js     801056bb <sys_link+0x34>
801056a4:	8d 45 dc             	lea    -0x24(%ebp),%eax
801056a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801056ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801056b2:	e8 51 fc ff ff       	call   80105308 <argstr>
801056b7:	85 c0                	test   %eax,%eax
801056b9:	79 0a                	jns    801056c5 <sys_link+0x3e>
    return -1;
801056bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056c0:	e9 42 01 00 00       	jmp    80105807 <sys_link+0x180>

  begin_op();
801056c5:	e8 94 dd ff ff       	call   8010345e <begin_op>
  if((ip = namei(old)) == 0){
801056ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
801056cd:	89 04 24             	mov    %eax,(%esp)
801056d0:	e8 99 cd ff ff       	call   8010246e <namei>
801056d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801056d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801056dc:	75 0f                	jne    801056ed <sys_link+0x66>
    end_op();
801056de:	e8 ff dd ff ff       	call   801034e2 <end_op>
    return -1;
801056e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056e8:	e9 1a 01 00 00       	jmp    80105807 <sys_link+0x180>
  }

  ilock(ip);
801056ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056f0:	89 04 24             	mov    %eax,(%esp)
801056f3:	e8 3c c2 ff ff       	call   80101934 <ilock>
  if(ip->type == T_DIR){
801056f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056fb:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801056ff:	66 83 f8 01          	cmp    $0x1,%ax
80105703:	75 1a                	jne    8010571f <sys_link+0x98>
    iunlockput(ip);
80105705:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105708:	89 04 24             	mov    %eax,(%esp)
8010570b:	e8 26 c4 ff ff       	call   80101b36 <iunlockput>
    end_op();
80105710:	e8 cd dd ff ff       	call   801034e2 <end_op>
    return -1;
80105715:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010571a:	e9 e8 00 00 00       	jmp    80105807 <sys_link+0x180>
  }

  ip->nlink++;
8010571f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105722:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105726:	8d 50 01             	lea    0x1(%eax),%edx
80105729:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010572c:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105730:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105733:	89 04 24             	mov    %eax,(%esp)
80105736:	e8 34 c0 ff ff       	call   8010176f <iupdate>
  iunlock(ip);
8010573b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010573e:	89 04 24             	mov    %eax,(%esp)
80105741:	e8 fb c2 ff ff       	call   80101a41 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105746:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105749:	8d 55 e2             	lea    -0x1e(%ebp),%edx
8010574c:	89 54 24 04          	mov    %edx,0x4(%esp)
80105750:	89 04 24             	mov    %eax,(%esp)
80105753:	e8 38 cd ff ff       	call   80102490 <nameiparent>
80105758:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010575b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010575f:	75 02                	jne    80105763 <sys_link+0xdc>
    goto bad;
80105761:	eb 68                	jmp    801057cb <sys_link+0x144>
  ilock(dp);
80105763:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105766:	89 04 24             	mov    %eax,(%esp)
80105769:	e8 c6 c1 ff ff       	call   80101934 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010576e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105771:	8b 10                	mov    (%eax),%edx
80105773:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105776:	8b 00                	mov    (%eax),%eax
80105778:	39 c2                	cmp    %eax,%edx
8010577a:	75 20                	jne    8010579c <sys_link+0x115>
8010577c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010577f:	8b 40 04             	mov    0x4(%eax),%eax
80105782:	89 44 24 08          	mov    %eax,0x8(%esp)
80105786:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105789:	89 44 24 04          	mov    %eax,0x4(%esp)
8010578d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105790:	89 04 24             	mov    %eax,(%esp)
80105793:	e8 17 ca ff ff       	call   801021af <dirlink>
80105798:	85 c0                	test   %eax,%eax
8010579a:	79 0d                	jns    801057a9 <sys_link+0x122>
    iunlockput(dp);
8010579c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010579f:	89 04 24             	mov    %eax,(%esp)
801057a2:	e8 8f c3 ff ff       	call   80101b36 <iunlockput>
    goto bad;
801057a7:	eb 22                	jmp    801057cb <sys_link+0x144>
  }
  iunlockput(dp);
801057a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057ac:	89 04 24             	mov    %eax,(%esp)
801057af:	e8 82 c3 ff ff       	call   80101b36 <iunlockput>
  iput(ip);
801057b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057b7:	89 04 24             	mov    %eax,(%esp)
801057ba:	e8 c6 c2 ff ff       	call   80101a85 <iput>

  end_op();
801057bf:	e8 1e dd ff ff       	call   801034e2 <end_op>

  return 0;
801057c4:	b8 00 00 00 00       	mov    $0x0,%eax
801057c9:	eb 3c                	jmp    80105807 <sys_link+0x180>

bad:
  ilock(ip);
801057cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ce:	89 04 24             	mov    %eax,(%esp)
801057d1:	e8 5e c1 ff ff       	call   80101934 <ilock>
  ip->nlink--;
801057d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057d9:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801057dd:	8d 50 ff             	lea    -0x1(%eax),%edx
801057e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057e3:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
801057e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ea:	89 04 24             	mov    %eax,(%esp)
801057ed:	e8 7d bf ff ff       	call   8010176f <iupdate>
  iunlockput(ip);
801057f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057f5:	89 04 24             	mov    %eax,(%esp)
801057f8:	e8 39 c3 ff ff       	call   80101b36 <iunlockput>
  end_op();
801057fd:	e8 e0 dc ff ff       	call   801034e2 <end_op>
  return -1;
80105802:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105807:	c9                   	leave  
80105808:	c3                   	ret    

80105809 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105809:	55                   	push   %ebp
8010580a:	89 e5                	mov    %esp,%ebp
8010580c:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010580f:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105816:	eb 4b                	jmp    80105863 <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105818:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010581b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105822:	00 
80105823:	89 44 24 08          	mov    %eax,0x8(%esp)
80105827:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010582a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010582e:	8b 45 08             	mov    0x8(%ebp),%eax
80105831:	89 04 24             	mov    %eax,(%esp)
80105834:	e8 98 c5 ff ff       	call   80101dd1 <readi>
80105839:	83 f8 10             	cmp    $0x10,%eax
8010583c:	74 0c                	je     8010584a <isdirempty+0x41>
      panic("isdirempty: readi");
8010583e:	c7 04 24 b0 87 10 80 	movl   $0x801087b0,(%esp)
80105845:	e8 18 ad ff ff       	call   80100562 <panic>
    if(de.inum != 0)
8010584a:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
8010584e:	66 85 c0             	test   %ax,%ax
80105851:	74 07                	je     8010585a <isdirempty+0x51>
      return 0;
80105853:	b8 00 00 00 00       	mov    $0x0,%eax
80105858:	eb 1b                	jmp    80105875 <isdirempty+0x6c>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010585a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010585d:	83 c0 10             	add    $0x10,%eax
80105860:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105863:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105866:	8b 45 08             	mov    0x8(%ebp),%eax
80105869:	8b 40 58             	mov    0x58(%eax),%eax
8010586c:	39 c2                	cmp    %eax,%edx
8010586e:	72 a8                	jb     80105818 <isdirempty+0xf>
  }
  return 1;
80105870:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105875:	c9                   	leave  
80105876:	c3                   	ret    

80105877 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105877:	55                   	push   %ebp
80105878:	89 e5                	mov    %esp,%ebp
8010587a:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010587d:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105880:	89 44 24 04          	mov    %eax,0x4(%esp)
80105884:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010588b:	e8 78 fa ff ff       	call   80105308 <argstr>
80105890:	85 c0                	test   %eax,%eax
80105892:	79 0a                	jns    8010589e <sys_unlink+0x27>
    return -1;
80105894:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105899:	e9 af 01 00 00       	jmp    80105a4d <sys_unlink+0x1d6>

  begin_op();
8010589e:	e8 bb db ff ff       	call   8010345e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801058a3:	8b 45 cc             	mov    -0x34(%ebp),%eax
801058a6:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801058a9:	89 54 24 04          	mov    %edx,0x4(%esp)
801058ad:	89 04 24             	mov    %eax,(%esp)
801058b0:	e8 db cb ff ff       	call   80102490 <nameiparent>
801058b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801058b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058bc:	75 0f                	jne    801058cd <sys_unlink+0x56>
    end_op();
801058be:	e8 1f dc ff ff       	call   801034e2 <end_op>
    return -1;
801058c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058c8:	e9 80 01 00 00       	jmp    80105a4d <sys_unlink+0x1d6>
  }

  ilock(dp);
801058cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058d0:	89 04 24             	mov    %eax,(%esp)
801058d3:	e8 5c c0 ff ff       	call   80101934 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801058d8:	c7 44 24 04 c2 87 10 	movl   $0x801087c2,0x4(%esp)
801058df:	80 
801058e0:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801058e3:	89 04 24             	mov    %eax,(%esp)
801058e6:	e8 d9 c7 ff ff       	call   801020c4 <namecmp>
801058eb:	85 c0                	test   %eax,%eax
801058ed:	0f 84 45 01 00 00    	je     80105a38 <sys_unlink+0x1c1>
801058f3:	c7 44 24 04 c4 87 10 	movl   $0x801087c4,0x4(%esp)
801058fa:	80 
801058fb:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801058fe:	89 04 24             	mov    %eax,(%esp)
80105901:	e8 be c7 ff ff       	call   801020c4 <namecmp>
80105906:	85 c0                	test   %eax,%eax
80105908:	0f 84 2a 01 00 00    	je     80105a38 <sys_unlink+0x1c1>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010590e:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105911:	89 44 24 08          	mov    %eax,0x8(%esp)
80105915:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105918:	89 44 24 04          	mov    %eax,0x4(%esp)
8010591c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010591f:	89 04 24             	mov    %eax,(%esp)
80105922:	e8 bf c7 ff ff       	call   801020e6 <dirlookup>
80105927:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010592a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010592e:	75 05                	jne    80105935 <sys_unlink+0xbe>
    goto bad;
80105930:	e9 03 01 00 00       	jmp    80105a38 <sys_unlink+0x1c1>
  ilock(ip);
80105935:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105938:	89 04 24             	mov    %eax,(%esp)
8010593b:	e8 f4 bf ff ff       	call   80101934 <ilock>

  if(ip->nlink < 1)
80105940:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105943:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105947:	66 85 c0             	test   %ax,%ax
8010594a:	7f 0c                	jg     80105958 <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
8010594c:	c7 04 24 c7 87 10 80 	movl   $0x801087c7,(%esp)
80105953:	e8 0a ac ff ff       	call   80100562 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105958:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010595b:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010595f:	66 83 f8 01          	cmp    $0x1,%ax
80105963:	75 1f                	jne    80105984 <sys_unlink+0x10d>
80105965:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105968:	89 04 24             	mov    %eax,(%esp)
8010596b:	e8 99 fe ff ff       	call   80105809 <isdirempty>
80105970:	85 c0                	test   %eax,%eax
80105972:	75 10                	jne    80105984 <sys_unlink+0x10d>
    iunlockput(ip);
80105974:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105977:	89 04 24             	mov    %eax,(%esp)
8010597a:	e8 b7 c1 ff ff       	call   80101b36 <iunlockput>
    goto bad;
8010597f:	e9 b4 00 00 00       	jmp    80105a38 <sys_unlink+0x1c1>
  }

  memset(&de, 0, sizeof(de));
80105984:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010598b:	00 
8010598c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105993:	00 
80105994:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105997:	89 04 24             	mov    %eax,(%esp)
8010599a:	e8 1a f6 ff ff       	call   80104fb9 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010599f:	8b 45 c8             	mov    -0x38(%ebp),%eax
801059a2:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801059a9:	00 
801059aa:	89 44 24 08          	mov    %eax,0x8(%esp)
801059ae:	8d 45 e0             	lea    -0x20(%ebp),%eax
801059b1:	89 44 24 04          	mov    %eax,0x4(%esp)
801059b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059b8:	89 04 24             	mov    %eax,(%esp)
801059bb:	e8 75 c5 ff ff       	call   80101f35 <writei>
801059c0:	83 f8 10             	cmp    $0x10,%eax
801059c3:	74 0c                	je     801059d1 <sys_unlink+0x15a>
    panic("unlink: writei");
801059c5:	c7 04 24 d9 87 10 80 	movl   $0x801087d9,(%esp)
801059cc:	e8 91 ab ff ff       	call   80100562 <panic>
  if(ip->type == T_DIR){
801059d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059d4:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801059d8:	66 83 f8 01          	cmp    $0x1,%ax
801059dc:	75 1c                	jne    801059fa <sys_unlink+0x183>
    dp->nlink--;
801059de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059e1:	0f b7 40 56          	movzwl 0x56(%eax),%eax
801059e5:	8d 50 ff             	lea    -0x1(%eax),%edx
801059e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059eb:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
801059ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059f2:	89 04 24             	mov    %eax,(%esp)
801059f5:	e8 75 bd ff ff       	call   8010176f <iupdate>
  }
  iunlockput(dp);
801059fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059fd:	89 04 24             	mov    %eax,(%esp)
80105a00:	e8 31 c1 ff ff       	call   80101b36 <iunlockput>

  ip->nlink--;
80105a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a08:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105a0c:	8d 50 ff             	lea    -0x1(%eax),%edx
80105a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a12:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a19:	89 04 24             	mov    %eax,(%esp)
80105a1c:	e8 4e bd ff ff       	call   8010176f <iupdate>
  iunlockput(ip);
80105a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a24:	89 04 24             	mov    %eax,(%esp)
80105a27:	e8 0a c1 ff ff       	call   80101b36 <iunlockput>

  end_op();
80105a2c:	e8 b1 da ff ff       	call   801034e2 <end_op>

  return 0;
80105a31:	b8 00 00 00 00       	mov    $0x0,%eax
80105a36:	eb 15                	jmp    80105a4d <sys_unlink+0x1d6>

bad:
  iunlockput(dp);
80105a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a3b:	89 04 24             	mov    %eax,(%esp)
80105a3e:	e8 f3 c0 ff ff       	call   80101b36 <iunlockput>
  end_op();
80105a43:	e8 9a da ff ff       	call   801034e2 <end_op>
  return -1;
80105a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a4d:	c9                   	leave  
80105a4e:	c3                   	ret    

80105a4f <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105a4f:	55                   	push   %ebp
80105a50:	89 e5                	mov    %esp,%ebp
80105a52:	83 ec 48             	sub    $0x48,%esp
80105a55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105a58:	8b 55 10             	mov    0x10(%ebp),%edx
80105a5b:	8b 45 14             	mov    0x14(%ebp),%eax
80105a5e:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105a62:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105a66:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105a6a:	8d 45 de             	lea    -0x22(%ebp),%eax
80105a6d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a71:	8b 45 08             	mov    0x8(%ebp),%eax
80105a74:	89 04 24             	mov    %eax,(%esp)
80105a77:	e8 14 ca ff ff       	call   80102490 <nameiparent>
80105a7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a83:	75 0a                	jne    80105a8f <create+0x40>
    return 0;
80105a85:	b8 00 00 00 00       	mov    $0x0,%eax
80105a8a:	e9 7e 01 00 00       	jmp    80105c0d <create+0x1be>
  ilock(dp);
80105a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a92:	89 04 24             	mov    %eax,(%esp)
80105a95:	e8 9a be ff ff       	call   80101934 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105a9a:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a9d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105aa1:	8d 45 de             	lea    -0x22(%ebp),%eax
80105aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
80105aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aab:	89 04 24             	mov    %eax,(%esp)
80105aae:	e8 33 c6 ff ff       	call   801020e6 <dirlookup>
80105ab3:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ab6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105aba:	74 47                	je     80105b03 <create+0xb4>
    iunlockput(dp);
80105abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105abf:	89 04 24             	mov    %eax,(%esp)
80105ac2:	e8 6f c0 ff ff       	call   80101b36 <iunlockput>
    ilock(ip);
80105ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aca:	89 04 24             	mov    %eax,(%esp)
80105acd:	e8 62 be ff ff       	call   80101934 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105ad2:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105ad7:	75 15                	jne    80105aee <create+0x9f>
80105ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105adc:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105ae0:	66 83 f8 02          	cmp    $0x2,%ax
80105ae4:	75 08                	jne    80105aee <create+0x9f>
      return ip;
80105ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ae9:	e9 1f 01 00 00       	jmp    80105c0d <create+0x1be>
    iunlockput(ip);
80105aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105af1:	89 04 24             	mov    %eax,(%esp)
80105af4:	e8 3d c0 ff ff       	call   80101b36 <iunlockput>
    return 0;
80105af9:	b8 00 00 00 00       	mov    $0x0,%eax
80105afe:	e9 0a 01 00 00       	jmp    80105c0d <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105b03:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b0a:	8b 00                	mov    (%eax),%eax
80105b0c:	89 54 24 04          	mov    %edx,0x4(%esp)
80105b10:	89 04 24             	mov    %eax,(%esp)
80105b13:	e8 82 bb ff ff       	call   8010169a <ialloc>
80105b18:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b1f:	75 0c                	jne    80105b2d <create+0xde>
    panic("create: ialloc");
80105b21:	c7 04 24 e8 87 10 80 	movl   $0x801087e8,(%esp)
80105b28:	e8 35 aa ff ff       	call   80100562 <panic>

  ilock(ip);
80105b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b30:	89 04 24             	mov    %eax,(%esp)
80105b33:	e8 fc bd ff ff       	call   80101934 <ilock>
  ip->major = major;
80105b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b3b:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105b3f:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
80105b43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b46:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105b4a:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
80105b4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b51:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80105b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b5a:	89 04 24             	mov    %eax,(%esp)
80105b5d:	e8 0d bc ff ff       	call   8010176f <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105b62:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105b67:	75 6a                	jne    80105bd3 <create+0x184>
    dp->nlink++;  // for ".."
80105b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b6c:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105b70:	8d 50 01             	lea    0x1(%eax),%edx
80105b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b76:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b7d:	89 04 24             	mov    %eax,(%esp)
80105b80:	e8 ea bb ff ff       	call   8010176f <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b88:	8b 40 04             	mov    0x4(%eax),%eax
80105b8b:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b8f:	c7 44 24 04 c2 87 10 	movl   $0x801087c2,0x4(%esp)
80105b96:	80 
80105b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b9a:	89 04 24             	mov    %eax,(%esp)
80105b9d:	e8 0d c6 ff ff       	call   801021af <dirlink>
80105ba2:	85 c0                	test   %eax,%eax
80105ba4:	78 21                	js     80105bc7 <create+0x178>
80105ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ba9:	8b 40 04             	mov    0x4(%eax),%eax
80105bac:	89 44 24 08          	mov    %eax,0x8(%esp)
80105bb0:	c7 44 24 04 c4 87 10 	movl   $0x801087c4,0x4(%esp)
80105bb7:	80 
80105bb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bbb:	89 04 24             	mov    %eax,(%esp)
80105bbe:	e8 ec c5 ff ff       	call   801021af <dirlink>
80105bc3:	85 c0                	test   %eax,%eax
80105bc5:	79 0c                	jns    80105bd3 <create+0x184>
      panic("create dots");
80105bc7:	c7 04 24 f7 87 10 80 	movl   $0x801087f7,(%esp)
80105bce:	e8 8f a9 ff ff       	call   80100562 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bd6:	8b 40 04             	mov    0x4(%eax),%eax
80105bd9:	89 44 24 08          	mov    %eax,0x8(%esp)
80105bdd:	8d 45 de             	lea    -0x22(%ebp),%eax
80105be0:	89 44 24 04          	mov    %eax,0x4(%esp)
80105be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105be7:	89 04 24             	mov    %eax,(%esp)
80105bea:	e8 c0 c5 ff ff       	call   801021af <dirlink>
80105bef:	85 c0                	test   %eax,%eax
80105bf1:	79 0c                	jns    80105bff <create+0x1b0>
    panic("create: dirlink");
80105bf3:	c7 04 24 03 88 10 80 	movl   $0x80108803,(%esp)
80105bfa:	e8 63 a9 ff ff       	call   80100562 <panic>

  iunlockput(dp);
80105bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c02:	89 04 24             	mov    %eax,(%esp)
80105c05:	e8 2c bf ff ff       	call   80101b36 <iunlockput>

  return ip;
80105c0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105c0d:	c9                   	leave  
80105c0e:	c3                   	ret    

80105c0f <sys_open>:

int
sys_open(void)
{
80105c0f:	55                   	push   %ebp
80105c10:	89 e5                	mov    %esp,%ebp
80105c12:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105c15:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105c18:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c1c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c23:	e8 e0 f6 ff ff       	call   80105308 <argstr>
80105c28:	85 c0                	test   %eax,%eax
80105c2a:	78 17                	js     80105c43 <sys_open+0x34>
80105c2c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c2f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105c3a:	e8 68 f6 ff ff       	call   801052a7 <argint>
80105c3f:	85 c0                	test   %eax,%eax
80105c41:	79 0a                	jns    80105c4d <sys_open+0x3e>
    return -1;
80105c43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c48:	e9 5c 01 00 00       	jmp    80105da9 <sys_open+0x19a>

  begin_op();
80105c4d:	e8 0c d8 ff ff       	call   8010345e <begin_op>

  if(omode & O_CREATE){
80105c52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c55:	25 00 02 00 00       	and    $0x200,%eax
80105c5a:	85 c0                	test   %eax,%eax
80105c5c:	74 3b                	je     80105c99 <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80105c5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105c61:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105c68:	00 
80105c69:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105c70:	00 
80105c71:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105c78:	00 
80105c79:	89 04 24             	mov    %eax,(%esp)
80105c7c:	e8 ce fd ff ff       	call   80105a4f <create>
80105c81:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80105c84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c88:	75 6b                	jne    80105cf5 <sys_open+0xe6>
      end_op();
80105c8a:	e8 53 d8 ff ff       	call   801034e2 <end_op>
      return -1;
80105c8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c94:	e9 10 01 00 00       	jmp    80105da9 <sys_open+0x19a>
    }
  } else {
    if((ip = namei(path)) == 0){
80105c99:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105c9c:	89 04 24             	mov    %eax,(%esp)
80105c9f:	e8 ca c7 ff ff       	call   8010246e <namei>
80105ca4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ca7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cab:	75 0f                	jne    80105cbc <sys_open+0xad>
      end_op();
80105cad:	e8 30 d8 ff ff       	call   801034e2 <end_op>
      return -1;
80105cb2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cb7:	e9 ed 00 00 00       	jmp    80105da9 <sys_open+0x19a>
    }
    ilock(ip);
80105cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cbf:	89 04 24             	mov    %eax,(%esp)
80105cc2:	e8 6d bc ff ff       	call   80101934 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cca:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105cce:	66 83 f8 01          	cmp    $0x1,%ax
80105cd2:	75 21                	jne    80105cf5 <sys_open+0xe6>
80105cd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105cd7:	85 c0                	test   %eax,%eax
80105cd9:	74 1a                	je     80105cf5 <sys_open+0xe6>
      iunlockput(ip);
80105cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cde:	89 04 24             	mov    %eax,(%esp)
80105ce1:	e8 50 be ff ff       	call   80101b36 <iunlockput>
      end_op();
80105ce6:	e8 f7 d7 ff ff       	call   801034e2 <end_op>
      return -1;
80105ceb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cf0:	e9 b4 00 00 00       	jmp    80105da9 <sys_open+0x19a>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105cf5:	e8 62 b2 ff ff       	call   80100f5c <filealloc>
80105cfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105cfd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d01:	74 14                	je     80105d17 <sys_open+0x108>
80105d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d06:	89 04 24             	mov    %eax,(%esp)
80105d09:	e8 2d f7 ff ff       	call   8010543b <fdalloc>
80105d0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105d11:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105d15:	79 28                	jns    80105d3f <sys_open+0x130>
    if(f)
80105d17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d1b:	74 0b                	je     80105d28 <sys_open+0x119>
      fileclose(f);
80105d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d20:	89 04 24             	mov    %eax,(%esp)
80105d23:	e8 dc b2 ff ff       	call   80101004 <fileclose>
    iunlockput(ip);
80105d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d2b:	89 04 24             	mov    %eax,(%esp)
80105d2e:	e8 03 be ff ff       	call   80101b36 <iunlockput>
    end_op();
80105d33:	e8 aa d7 ff ff       	call   801034e2 <end_op>
    return -1;
80105d38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d3d:	eb 6a                	jmp    80105da9 <sys_open+0x19a>
  }
  iunlock(ip);
80105d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d42:	89 04 24             	mov    %eax,(%esp)
80105d45:	e8 f7 bc ff ff       	call   80101a41 <iunlock>
  end_op();
80105d4a:	e8 93 d7 ff ff       	call   801034e2 <end_op>

  f->type = FD_INODE;
80105d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d52:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d5e:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d64:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105d6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d6e:	83 e0 01             	and    $0x1,%eax
80105d71:	85 c0                	test   %eax,%eax
80105d73:	0f 94 c0             	sete   %al
80105d76:	89 c2                	mov    %eax,%edx
80105d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d7b:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105d7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d81:	83 e0 01             	and    $0x1,%eax
80105d84:	85 c0                	test   %eax,%eax
80105d86:	75 0a                	jne    80105d92 <sys_open+0x183>
80105d88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105d8b:	83 e0 02             	and    $0x2,%eax
80105d8e:	85 c0                	test   %eax,%eax
80105d90:	74 07                	je     80105d99 <sys_open+0x18a>
80105d92:	b8 01 00 00 00       	mov    $0x1,%eax
80105d97:	eb 05                	jmp    80105d9e <sys_open+0x18f>
80105d99:	b8 00 00 00 00       	mov    $0x0,%eax
80105d9e:	89 c2                	mov    %eax,%edx
80105da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105da3:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105da6:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105da9:	c9                   	leave  
80105daa:	c3                   	ret    

80105dab <sys_mkdir>:

int
sys_mkdir(void)
{
80105dab:	55                   	push   %ebp
80105dac:	89 e5                	mov    %esp,%ebp
80105dae:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105db1:	e8 a8 d6 ff ff       	call   8010345e <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105db6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105db9:	89 44 24 04          	mov    %eax,0x4(%esp)
80105dbd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105dc4:	e8 3f f5 ff ff       	call   80105308 <argstr>
80105dc9:	85 c0                	test   %eax,%eax
80105dcb:	78 2c                	js     80105df9 <sys_mkdir+0x4e>
80105dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dd0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105dd7:	00 
80105dd8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105ddf:	00 
80105de0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105de7:	00 
80105de8:	89 04 24             	mov    %eax,(%esp)
80105deb:	e8 5f fc ff ff       	call   80105a4f <create>
80105df0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105df3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105df7:	75 0c                	jne    80105e05 <sys_mkdir+0x5a>
    end_op();
80105df9:	e8 e4 d6 ff ff       	call   801034e2 <end_op>
    return -1;
80105dfe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e03:	eb 15                	jmp    80105e1a <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80105e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e08:	89 04 24             	mov    %eax,(%esp)
80105e0b:	e8 26 bd ff ff       	call   80101b36 <iunlockput>
  end_op();
80105e10:	e8 cd d6 ff ff       	call   801034e2 <end_op>
  return 0;
80105e15:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e1a:	c9                   	leave  
80105e1b:	c3                   	ret    

80105e1c <sys_mknod>:

int
sys_mknod(void)
{
80105e1c:	55                   	push   %ebp
80105e1d:	89 e5                	mov    %esp,%ebp
80105e1f:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105e22:	e8 37 d6 ff ff       	call   8010345e <begin_op>
  if((argstr(0, &path)) < 0 ||
80105e27:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e2a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e2e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e35:	e8 ce f4 ff ff       	call   80105308 <argstr>
80105e3a:	85 c0                	test   %eax,%eax
80105e3c:	78 5e                	js     80105e9c <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105e3e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e41:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e45:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105e4c:	e8 56 f4 ff ff       	call   801052a7 <argint>
  if((argstr(0, &path)) < 0 ||
80105e51:	85 c0                	test   %eax,%eax
80105e53:	78 47                	js     80105e9c <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105e55:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105e58:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e5c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105e63:	e8 3f f4 ff ff       	call   801052a7 <argint>
     argint(1, &major) < 0 ||
80105e68:	85 c0                	test   %eax,%eax
80105e6a:	78 30                	js     80105e9c <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105e6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105e6f:	0f bf c8             	movswl %ax,%ecx
80105e72:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105e75:	0f bf d0             	movswl %ax,%edx
80105e78:	8b 45 f0             	mov    -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80105e7b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80105e7f:	89 54 24 08          	mov    %edx,0x8(%esp)
80105e83:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80105e8a:	00 
80105e8b:	89 04 24             	mov    %eax,(%esp)
80105e8e:	e8 bc fb ff ff       	call   80105a4f <create>
80105e93:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e9a:	75 0c                	jne    80105ea8 <sys_mknod+0x8c>
    end_op();
80105e9c:	e8 41 d6 ff ff       	call   801034e2 <end_op>
    return -1;
80105ea1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ea6:	eb 15                	jmp    80105ebd <sys_mknod+0xa1>
  }
  iunlockput(ip);
80105ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eab:	89 04 24             	mov    %eax,(%esp)
80105eae:	e8 83 bc ff ff       	call   80101b36 <iunlockput>
  end_op();
80105eb3:	e8 2a d6 ff ff       	call   801034e2 <end_op>
  return 0;
80105eb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ebd:	c9                   	leave  
80105ebe:	c3                   	ret    

80105ebf <sys_chdir>:

int
sys_chdir(void)
{
80105ebf:	55                   	push   %ebp
80105ec0:	89 e5                	mov    %esp,%ebp
80105ec2:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105ec5:	e8 73 e2 ff ff       	call   8010413d <myproc>
80105eca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80105ecd:	e8 8c d5 ff ff       	call   8010345e <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105ed2:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ed5:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ed9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ee0:	e8 23 f4 ff ff       	call   80105308 <argstr>
80105ee5:	85 c0                	test   %eax,%eax
80105ee7:	78 14                	js     80105efd <sys_chdir+0x3e>
80105ee9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105eec:	89 04 24             	mov    %eax,(%esp)
80105eef:	e8 7a c5 ff ff       	call   8010246e <namei>
80105ef4:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ef7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105efb:	75 0c                	jne    80105f09 <sys_chdir+0x4a>
    end_op();
80105efd:	e8 e0 d5 ff ff       	call   801034e2 <end_op>
    return -1;
80105f02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f07:	eb 5b                	jmp    80105f64 <sys_chdir+0xa5>
  }
  ilock(ip);
80105f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f0c:	89 04 24             	mov    %eax,(%esp)
80105f0f:	e8 20 ba ff ff       	call   80101934 <ilock>
  if(ip->type != T_DIR){
80105f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f17:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105f1b:	66 83 f8 01          	cmp    $0x1,%ax
80105f1f:	74 17                	je     80105f38 <sys_chdir+0x79>
    iunlockput(ip);
80105f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f24:	89 04 24             	mov    %eax,(%esp)
80105f27:	e8 0a bc ff ff       	call   80101b36 <iunlockput>
    end_op();
80105f2c:	e8 b1 d5 ff ff       	call   801034e2 <end_op>
    return -1;
80105f31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f36:	eb 2c                	jmp    80105f64 <sys_chdir+0xa5>
  }
  iunlock(ip);
80105f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f3b:	89 04 24             	mov    %eax,(%esp)
80105f3e:	e8 fe ba ff ff       	call   80101a41 <iunlock>
  iput(curproc->cwd);
80105f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f46:	8b 40 68             	mov    0x68(%eax),%eax
80105f49:	89 04 24             	mov    %eax,(%esp)
80105f4c:	e8 34 bb ff ff       	call   80101a85 <iput>
  end_op();
80105f51:	e8 8c d5 ff ff       	call   801034e2 <end_op>
  curproc->cwd = ip;
80105f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f59:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105f5c:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105f5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f64:	c9                   	leave  
80105f65:	c3                   	ret    

80105f66 <sys_exec>:

int
sys_exec(void)
{
80105f66:	55                   	push   %ebp
80105f67:	89 e5                	mov    %esp,%ebp
80105f69:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105f6f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f72:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f76:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f7d:	e8 86 f3 ff ff       	call   80105308 <argstr>
80105f82:	85 c0                	test   %eax,%eax
80105f84:	78 1a                	js     80105fa0 <sys_exec+0x3a>
80105f86:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105f8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f90:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105f97:	e8 0b f3 ff ff       	call   801052a7 <argint>
80105f9c:	85 c0                	test   %eax,%eax
80105f9e:	79 0a                	jns    80105faa <sys_exec+0x44>
    return -1;
80105fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fa5:	e9 c8 00 00 00       	jmp    80106072 <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
80105faa:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105fb1:	00 
80105fb2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105fb9:	00 
80105fba:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105fc0:	89 04 24             	mov    %eax,(%esp)
80105fc3:	e8 f1 ef ff ff       	call   80104fb9 <memset>
  for(i=0;; i++){
80105fc8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fd2:	83 f8 1f             	cmp    $0x1f,%eax
80105fd5:	76 0a                	jbe    80105fe1 <sys_exec+0x7b>
      return -1;
80105fd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fdc:	e9 91 00 00 00       	jmp    80106072 <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fe4:	c1 e0 02             	shl    $0x2,%eax
80105fe7:	89 c2                	mov    %eax,%edx
80105fe9:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105fef:	01 c2                	add    %eax,%edx
80105ff1:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105ff7:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ffb:	89 14 24             	mov    %edx,(%esp)
80105ffe:	e8 5c f2 ff ff       	call   8010525f <fetchint>
80106003:	85 c0                	test   %eax,%eax
80106005:	79 07                	jns    8010600e <sys_exec+0xa8>
      return -1;
80106007:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010600c:	eb 64                	jmp    80106072 <sys_exec+0x10c>
    if(uarg == 0){
8010600e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106014:	85 c0                	test   %eax,%eax
80106016:	75 26                	jne    8010603e <sys_exec+0xd8>
      argv[i] = 0;
80106018:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010601b:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106022:	00 00 00 00 
      break;
80106026:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106027:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010602a:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106030:	89 54 24 04          	mov    %edx,0x4(%esp)
80106034:	89 04 24             	mov    %eax,(%esp)
80106037:	e8 e2 aa ff ff       	call   80100b1e <exec>
8010603c:	eb 34                	jmp    80106072 <sys_exec+0x10c>
    if(fetchstr(uarg, &argv[i]) < 0)
8010603e:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106044:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106047:	c1 e2 02             	shl    $0x2,%edx
8010604a:	01 c2                	add    %eax,%edx
8010604c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106052:	89 54 24 04          	mov    %edx,0x4(%esp)
80106056:	89 04 24             	mov    %eax,(%esp)
80106059:	e8 15 f2 ff ff       	call   80105273 <fetchstr>
8010605e:	85 c0                	test   %eax,%eax
80106060:	79 07                	jns    80106069 <sys_exec+0x103>
      return -1;
80106062:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106067:	eb 09                	jmp    80106072 <sys_exec+0x10c>
  for(i=0;; i++){
80106069:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }
8010606d:	e9 5d ff ff ff       	jmp    80105fcf <sys_exec+0x69>
}
80106072:	c9                   	leave  
80106073:	c3                   	ret    

80106074 <sys_pipe>:

int
sys_pipe(void)
{
80106074:	55                   	push   %ebp
80106075:	89 e5                	mov    %esp,%ebp
80106077:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010607a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106081:	00 
80106082:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106085:	89 44 24 04          	mov    %eax,0x4(%esp)
80106089:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106090:	e8 3f f2 ff ff       	call   801052d4 <argptr>
80106095:	85 c0                	test   %eax,%eax
80106097:	79 0a                	jns    801060a3 <sys_pipe+0x2f>
    return -1;
80106099:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010609e:	e9 9a 00 00 00       	jmp    8010613d <sys_pipe+0xc9>
  if(pipealloc(&rf, &wf) < 0)
801060a3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801060a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801060aa:	8d 45 e8             	lea    -0x18(%ebp),%eax
801060ad:	89 04 24             	mov    %eax,(%esp)
801060b0:	e8 0c dc ff ff       	call   80103cc1 <pipealloc>
801060b5:	85 c0                	test   %eax,%eax
801060b7:	79 07                	jns    801060c0 <sys_pipe+0x4c>
    return -1;
801060b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060be:	eb 7d                	jmp    8010613d <sys_pipe+0xc9>
  fd0 = -1;
801060c0:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801060c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801060ca:	89 04 24             	mov    %eax,(%esp)
801060cd:	e8 69 f3 ff ff       	call   8010543b <fdalloc>
801060d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060d9:	78 14                	js     801060ef <sys_pipe+0x7b>
801060db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060de:	89 04 24             	mov    %eax,(%esp)
801060e1:	e8 55 f3 ff ff       	call   8010543b <fdalloc>
801060e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801060e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060ed:	79 36                	jns    80106125 <sys_pipe+0xb1>
    if(fd0 >= 0)
801060ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060f3:	78 13                	js     80106108 <sys_pipe+0x94>
      myproc()->ofile[fd0] = 0;
801060f5:	e8 43 e0 ff ff       	call   8010413d <myproc>
801060fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801060fd:	83 c2 08             	add    $0x8,%edx
80106100:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106107:	00 
    fileclose(rf);
80106108:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010610b:	89 04 24             	mov    %eax,(%esp)
8010610e:	e8 f1 ae ff ff       	call   80101004 <fileclose>
    fileclose(wf);
80106113:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106116:	89 04 24             	mov    %eax,(%esp)
80106119:	e8 e6 ae ff ff       	call   80101004 <fileclose>
    return -1;
8010611e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106123:	eb 18                	jmp    8010613d <sys_pipe+0xc9>
  }
  fd[0] = fd0;
80106125:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106128:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010612b:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
8010612d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106130:	8d 50 04             	lea    0x4(%eax),%edx
80106133:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106136:	89 02                	mov    %eax,(%edx)
  return 0;
80106138:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010613d:	c9                   	leave  
8010613e:	c3                   	ret    

8010613f <sys_shm_open>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_shm_open(void) {
8010613f:	55                   	push   %ebp
80106140:	89 e5                	mov    %esp,%ebp
80106142:	83 ec 28             	sub    $0x28,%esp
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
80106145:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106148:	89 44 24 04          	mov    %eax,0x4(%esp)
8010614c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106153:	e8 4f f1 ff ff       	call   801052a7 <argint>
80106158:	85 c0                	test   %eax,%eax
8010615a:	79 07                	jns    80106163 <sys_shm_open+0x24>
    return -1;
8010615c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106161:	eb 38                	jmp    8010619b <sys_shm_open+0x5c>

  if(argptr(1, (char **) (&pointer),4)<0)
80106163:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010616a:	00 
8010616b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010616e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106172:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106179:	e8 56 f1 ff ff       	call   801052d4 <argptr>
8010617e:	85 c0                	test   %eax,%eax
80106180:	79 07                	jns    80106189 <sys_shm_open+0x4a>
    return -1;
80106182:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106187:	eb 12                	jmp    8010619b <sys_shm_open+0x5c>
  return shm_open(id, pointer);
80106189:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010618c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010618f:	89 54 24 04          	mov    %edx,0x4(%esp)
80106193:	89 04 24             	mov    %eax,(%esp)
80106196:	e8 6b 21 00 00       	call   80108306 <shm_open>
}
8010619b:	c9                   	leave  
8010619c:	c3                   	ret    

8010619d <sys_shm_close>:

int sys_shm_close(void) {
8010619d:	55                   	push   %ebp
8010619e:	89 e5                	mov    %esp,%ebp
801061a0:	83 ec 28             	sub    $0x28,%esp
  int id;

  if(argint(0, &id) < 0)
801061a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801061aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061b1:	e8 f1 f0 ff ff       	call   801052a7 <argint>
801061b6:	85 c0                	test   %eax,%eax
801061b8:	79 07                	jns    801061c1 <sys_shm_close+0x24>
    return -1;
801061ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061bf:	eb 0b                	jmp    801061cc <sys_shm_close+0x2f>

  
  return shm_close(id);
801061c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061c4:	89 04 24             	mov    %eax,(%esp)
801061c7:	e8 44 21 00 00       	call   80108310 <shm_close>
}
801061cc:	c9                   	leave  
801061cd:	c3                   	ret    

801061ce <sys_fork>:

int
sys_fork(void)
{
801061ce:	55                   	push   %ebp
801061cf:	89 e5                	mov    %esp,%ebp
801061d1:	83 ec 08             	sub    $0x8,%esp
  return fork();
801061d4:	e8 62 e2 ff ff       	call   8010443b <fork>
}
801061d9:	c9                   	leave  
801061da:	c3                   	ret    

801061db <sys_exit>:

int
sys_exit(void)
{
801061db:	55                   	push   %ebp
801061dc:	89 e5                	mov    %esp,%ebp
801061de:	83 ec 08             	sub    $0x8,%esp
  exit();
801061e1:	e8 c6 e3 ff ff       	call   801045ac <exit>
  return 0;  // not reached
801061e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061eb:	c9                   	leave  
801061ec:	c3                   	ret    

801061ed <sys_wait>:

int
sys_wait(void)
{
801061ed:	55                   	push   %ebp
801061ee:	89 e5                	mov    %esp,%ebp
801061f0:	83 ec 08             	sub    $0x8,%esp
  return wait();
801061f3:	e8 be e4 ff ff       	call   801046b6 <wait>
}
801061f8:	c9                   	leave  
801061f9:	c3                   	ret    

801061fa <sys_kill>:

int
sys_kill(void)
{
801061fa:	55                   	push   %ebp
801061fb:	89 e5                	mov    %esp,%ebp
801061fd:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106200:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106203:	89 44 24 04          	mov    %eax,0x4(%esp)
80106207:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010620e:	e8 94 f0 ff ff       	call   801052a7 <argint>
80106213:	85 c0                	test   %eax,%eax
80106215:	79 07                	jns    8010621e <sys_kill+0x24>
    return -1;
80106217:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010621c:	eb 0b                	jmp    80106229 <sys_kill+0x2f>
  return kill(pid);
8010621e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106221:	89 04 24             	mov    %eax,(%esp)
80106224:	e8 62 e8 ff ff       	call   80104a8b <kill>
}
80106229:	c9                   	leave  
8010622a:	c3                   	ret    

8010622b <sys_getpid>:

int
sys_getpid(void)
{
8010622b:	55                   	push   %ebp
8010622c:	89 e5                	mov    %esp,%ebp
8010622e:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106231:	e8 07 df ff ff       	call   8010413d <myproc>
80106236:	8b 40 10             	mov    0x10(%eax),%eax
}
80106239:	c9                   	leave  
8010623a:	c3                   	ret    

8010623b <sys_sbrk>:

int
sys_sbrk(void)
{
8010623b:	55                   	push   %ebp
8010623c:	89 e5                	mov    %esp,%ebp
8010623e:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106241:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106244:	89 44 24 04          	mov    %eax,0x4(%esp)
80106248:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010624f:	e8 53 f0 ff ff       	call   801052a7 <argint>
80106254:	85 c0                	test   %eax,%eax
80106256:	79 07                	jns    8010625f <sys_sbrk+0x24>
    return -1;
80106258:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010625d:	eb 23                	jmp    80106282 <sys_sbrk+0x47>
  addr = myproc()->sz;
8010625f:	e8 d9 de ff ff       	call   8010413d <myproc>
80106264:	8b 00                	mov    (%eax),%eax
80106266:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106269:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010626c:	89 04 24             	mov    %eax,(%esp)
8010626f:	e8 29 e1 ff ff       	call   8010439d <growproc>
80106274:	85 c0                	test   %eax,%eax
80106276:	79 07                	jns    8010627f <sys_sbrk+0x44>
    return -1;
80106278:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010627d:	eb 03                	jmp    80106282 <sys_sbrk+0x47>
  return addr;
8010627f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106282:	c9                   	leave  
80106283:	c3                   	ret    

80106284 <sys_sleep>:

int
sys_sleep(void)
{
80106284:	55                   	push   %ebp
80106285:	89 e5                	mov    %esp,%ebp
80106287:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
8010628a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010628d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106291:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106298:	e8 0a f0 ff ff       	call   801052a7 <argint>
8010629d:	85 c0                	test   %eax,%eax
8010629f:	79 07                	jns    801062a8 <sys_sleep+0x24>
    return -1;
801062a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062a6:	eb 6b                	jmp    80106313 <sys_sleep+0x8f>
  acquire(&tickslock);
801062a8:	c7 04 24 e0 5d 11 80 	movl   $0x80115de0,(%esp)
801062af:	e8 a3 ea ff ff       	call   80104d57 <acquire>
  ticks0 = ticks;
801062b4:	a1 20 66 11 80       	mov    0x80116620,%eax
801062b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801062bc:	eb 33                	jmp    801062f1 <sys_sleep+0x6d>
    if(myproc()->killed){
801062be:	e8 7a de ff ff       	call   8010413d <myproc>
801062c3:	8b 40 24             	mov    0x24(%eax),%eax
801062c6:	85 c0                	test   %eax,%eax
801062c8:	74 13                	je     801062dd <sys_sleep+0x59>
      release(&tickslock);
801062ca:	c7 04 24 e0 5d 11 80 	movl   $0x80115de0,(%esp)
801062d1:	e8 e9 ea ff ff       	call   80104dbf <release>
      return -1;
801062d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062db:	eb 36                	jmp    80106313 <sys_sleep+0x8f>
    }
    sleep(&ticks, &tickslock);
801062dd:	c7 44 24 04 e0 5d 11 	movl   $0x80115de0,0x4(%esp)
801062e4:	80 
801062e5:	c7 04 24 20 66 11 80 	movl   $0x80116620,(%esp)
801062ec:	e8 9b e6 ff ff       	call   8010498c <sleep>
  while(ticks - ticks0 < n){
801062f1:	a1 20 66 11 80       	mov    0x80116620,%eax
801062f6:	2b 45 f4             	sub    -0xc(%ebp),%eax
801062f9:	89 c2                	mov    %eax,%edx
801062fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062fe:	39 c2                	cmp    %eax,%edx
80106300:	72 bc                	jb     801062be <sys_sleep+0x3a>
  }
  release(&tickslock);
80106302:	c7 04 24 e0 5d 11 80 	movl   $0x80115de0,(%esp)
80106309:	e8 b1 ea ff ff       	call   80104dbf <release>
  return 0;
8010630e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106313:	c9                   	leave  
80106314:	c3                   	ret    

80106315 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106315:	55                   	push   %ebp
80106316:	89 e5                	mov    %esp,%ebp
80106318:	83 ec 28             	sub    $0x28,%esp
  uint xticks;

  acquire(&tickslock);
8010631b:	c7 04 24 e0 5d 11 80 	movl   $0x80115de0,(%esp)
80106322:	e8 30 ea ff ff       	call   80104d57 <acquire>
  xticks = ticks;
80106327:	a1 20 66 11 80       	mov    0x80116620,%eax
8010632c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010632f:	c7 04 24 e0 5d 11 80 	movl   $0x80115de0,(%esp)
80106336:	e8 84 ea ff ff       	call   80104dbf <release>
  return xticks;
8010633b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010633e:	c9                   	leave  
8010633f:	c3                   	ret    

80106340 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106340:	1e                   	push   %ds
  pushl %es
80106341:	06                   	push   %es
  pushl %fs
80106342:	0f a0                	push   %fs
  pushl %gs
80106344:	0f a8                	push   %gs
  pushal
80106346:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106347:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010634b:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010634d:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010634f:	54                   	push   %esp
  call trap
80106350:	e8 d8 01 00 00       	call   8010652d <trap>
  addl $4, %esp
80106355:	83 c4 04             	add    $0x4,%esp

80106358 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106358:	61                   	popa   
  popl %gs
80106359:	0f a9                	pop    %gs
  popl %fs
8010635b:	0f a1                	pop    %fs
  popl %es
8010635d:	07                   	pop    %es
  popl %ds
8010635e:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010635f:	83 c4 08             	add    $0x8,%esp
  iret
80106362:	cf                   	iret   

80106363 <lidt>:
{
80106363:	55                   	push   %ebp
80106364:	89 e5                	mov    %esp,%ebp
80106366:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106369:	8b 45 0c             	mov    0xc(%ebp),%eax
8010636c:	83 e8 01             	sub    $0x1,%eax
8010636f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106373:	8b 45 08             	mov    0x8(%ebp),%eax
80106376:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010637a:	8b 45 08             	mov    0x8(%ebp),%eax
8010637d:	c1 e8 10             	shr    $0x10,%eax
80106380:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106384:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106387:	0f 01 18             	lidtl  (%eax)
}
8010638a:	c9                   	leave  
8010638b:	c3                   	ret    

8010638c <rcr2>:

static inline uint
rcr2(void)
{
8010638c:	55                   	push   %ebp
8010638d:	89 e5                	mov    %esp,%ebp
8010638f:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106392:	0f 20 d0             	mov    %cr2,%eax
80106395:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106398:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010639b:	c9                   	leave  
8010639c:	c3                   	ret    

8010639d <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010639d:	55                   	push   %ebp
8010639e:	89 e5                	mov    %esp,%ebp
801063a0:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
801063a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801063aa:	e9 c3 00 00 00       	jmp    80106472 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801063af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063b2:	8b 04 85 80 b0 10 80 	mov    -0x7fef4f80(,%eax,4),%eax
801063b9:	89 c2                	mov    %eax,%edx
801063bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063be:	66 89 14 c5 20 5e 11 	mov    %dx,-0x7feea1e0(,%eax,8)
801063c5:	80 
801063c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063c9:	66 c7 04 c5 22 5e 11 	movw   $0x8,-0x7feea1de(,%eax,8)
801063d0:	80 08 00 
801063d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063d6:	0f b6 14 c5 24 5e 11 	movzbl -0x7feea1dc(,%eax,8),%edx
801063dd:	80 
801063de:	83 e2 e0             	and    $0xffffffe0,%edx
801063e1:	88 14 c5 24 5e 11 80 	mov    %dl,-0x7feea1dc(,%eax,8)
801063e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063eb:	0f b6 14 c5 24 5e 11 	movzbl -0x7feea1dc(,%eax,8),%edx
801063f2:	80 
801063f3:	83 e2 1f             	and    $0x1f,%edx
801063f6:	88 14 c5 24 5e 11 80 	mov    %dl,-0x7feea1dc(,%eax,8)
801063fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106400:	0f b6 14 c5 25 5e 11 	movzbl -0x7feea1db(,%eax,8),%edx
80106407:	80 
80106408:	83 e2 f0             	and    $0xfffffff0,%edx
8010640b:	83 ca 0e             	or     $0xe,%edx
8010640e:	88 14 c5 25 5e 11 80 	mov    %dl,-0x7feea1db(,%eax,8)
80106415:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106418:	0f b6 14 c5 25 5e 11 	movzbl -0x7feea1db(,%eax,8),%edx
8010641f:	80 
80106420:	83 e2 ef             	and    $0xffffffef,%edx
80106423:	88 14 c5 25 5e 11 80 	mov    %dl,-0x7feea1db(,%eax,8)
8010642a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010642d:	0f b6 14 c5 25 5e 11 	movzbl -0x7feea1db(,%eax,8),%edx
80106434:	80 
80106435:	83 e2 9f             	and    $0xffffff9f,%edx
80106438:	88 14 c5 25 5e 11 80 	mov    %dl,-0x7feea1db(,%eax,8)
8010643f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106442:	0f b6 14 c5 25 5e 11 	movzbl -0x7feea1db(,%eax,8),%edx
80106449:	80 
8010644a:	83 ca 80             	or     $0xffffff80,%edx
8010644d:	88 14 c5 25 5e 11 80 	mov    %dl,-0x7feea1db(,%eax,8)
80106454:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106457:	8b 04 85 80 b0 10 80 	mov    -0x7fef4f80(,%eax,4),%eax
8010645e:	c1 e8 10             	shr    $0x10,%eax
80106461:	89 c2                	mov    %eax,%edx
80106463:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106466:	66 89 14 c5 26 5e 11 	mov    %dx,-0x7feea1da(,%eax,8)
8010646d:	80 
  for(i = 0; i < 256; i++)
8010646e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106472:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106479:	0f 8e 30 ff ff ff    	jle    801063af <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010647f:	a1 80 b1 10 80       	mov    0x8010b180,%eax
80106484:	66 a3 20 60 11 80    	mov    %ax,0x80116020
8010648a:	66 c7 05 22 60 11 80 	movw   $0x8,0x80116022
80106491:	08 00 
80106493:	0f b6 05 24 60 11 80 	movzbl 0x80116024,%eax
8010649a:	83 e0 e0             	and    $0xffffffe0,%eax
8010649d:	a2 24 60 11 80       	mov    %al,0x80116024
801064a2:	0f b6 05 24 60 11 80 	movzbl 0x80116024,%eax
801064a9:	83 e0 1f             	and    $0x1f,%eax
801064ac:	a2 24 60 11 80       	mov    %al,0x80116024
801064b1:	0f b6 05 25 60 11 80 	movzbl 0x80116025,%eax
801064b8:	83 c8 0f             	or     $0xf,%eax
801064bb:	a2 25 60 11 80       	mov    %al,0x80116025
801064c0:	0f b6 05 25 60 11 80 	movzbl 0x80116025,%eax
801064c7:	83 e0 ef             	and    $0xffffffef,%eax
801064ca:	a2 25 60 11 80       	mov    %al,0x80116025
801064cf:	0f b6 05 25 60 11 80 	movzbl 0x80116025,%eax
801064d6:	83 c8 60             	or     $0x60,%eax
801064d9:	a2 25 60 11 80       	mov    %al,0x80116025
801064de:	0f b6 05 25 60 11 80 	movzbl 0x80116025,%eax
801064e5:	83 c8 80             	or     $0xffffff80,%eax
801064e8:	a2 25 60 11 80       	mov    %al,0x80116025
801064ed:	a1 80 b1 10 80       	mov    0x8010b180,%eax
801064f2:	c1 e8 10             	shr    $0x10,%eax
801064f5:	66 a3 26 60 11 80    	mov    %ax,0x80116026

  initlock(&tickslock, "time");
801064fb:	c7 44 24 04 14 88 10 	movl   $0x80108814,0x4(%esp)
80106502:	80 
80106503:	c7 04 24 e0 5d 11 80 	movl   $0x80115de0,(%esp)
8010650a:	e8 27 e8 ff ff       	call   80104d36 <initlock>
}
8010650f:	c9                   	leave  
80106510:	c3                   	ret    

80106511 <idtinit>:

void
idtinit(void)
{
80106511:	55                   	push   %ebp
80106512:	89 e5                	mov    %esp,%ebp
80106514:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106517:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
8010651e:	00 
8010651f:	c7 04 24 20 5e 11 80 	movl   $0x80115e20,(%esp)
80106526:	e8 38 fe ff ff       	call   80106363 <lidt>
}
8010652b:	c9                   	leave  
8010652c:	c3                   	ret    

8010652d <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010652d:	55                   	push   %ebp
8010652e:	89 e5                	mov    %esp,%ebp
80106530:	57                   	push   %edi
80106531:	56                   	push   %esi
80106532:	53                   	push   %ebx
80106533:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106536:	8b 45 08             	mov    0x8(%ebp),%eax
80106539:	8b 40 30             	mov    0x30(%eax),%eax
8010653c:	83 f8 40             	cmp    $0x40,%eax
8010653f:	75 3c                	jne    8010657d <trap+0x50>
    if(myproc()->killed)
80106541:	e8 f7 db ff ff       	call   8010413d <myproc>
80106546:	8b 40 24             	mov    0x24(%eax),%eax
80106549:	85 c0                	test   %eax,%eax
8010654b:	74 05                	je     80106552 <trap+0x25>
      exit();
8010654d:	e8 5a e0 ff ff       	call   801045ac <exit>
    myproc()->tf = tf;
80106552:	e8 e6 db ff ff       	call   8010413d <myproc>
80106557:	8b 55 08             	mov    0x8(%ebp),%edx
8010655a:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
8010655d:	e8 dd ed ff ff       	call   8010533f <syscall>
    if(myproc()->killed)
80106562:	e8 d6 db ff ff       	call   8010413d <myproc>
80106567:	8b 40 24             	mov    0x24(%eax),%eax
8010656a:	85 c0                	test   %eax,%eax
8010656c:	74 0a                	je     80106578 <trap+0x4b>
      exit();
8010656e:	e8 39 e0 ff ff       	call   801045ac <exit>
    return;
80106573:	e9 19 02 00 00       	jmp    80106791 <trap+0x264>
80106578:	e9 14 02 00 00       	jmp    80106791 <trap+0x264>
  }

  switch(tf->trapno){
8010657d:	8b 45 08             	mov    0x8(%ebp),%eax
80106580:	8b 40 30             	mov    0x30(%eax),%eax
80106583:	83 e8 20             	sub    $0x20,%eax
80106586:	83 f8 1f             	cmp    $0x1f,%eax
80106589:	0f 87 b1 00 00 00    	ja     80106640 <trap+0x113>
8010658f:	8b 04 85 bc 88 10 80 	mov    -0x7fef7744(,%eax,4),%eax
80106596:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106598:	e8 09 db ff ff       	call   801040a6 <cpuid>
8010659d:	85 c0                	test   %eax,%eax
8010659f:	75 31                	jne    801065d2 <trap+0xa5>
      acquire(&tickslock);
801065a1:	c7 04 24 e0 5d 11 80 	movl   $0x80115de0,(%esp)
801065a8:	e8 aa e7 ff ff       	call   80104d57 <acquire>
      ticks++;
801065ad:	a1 20 66 11 80       	mov    0x80116620,%eax
801065b2:	83 c0 01             	add    $0x1,%eax
801065b5:	a3 20 66 11 80       	mov    %eax,0x80116620
      wakeup(&ticks);
801065ba:	c7 04 24 20 66 11 80 	movl   $0x80116620,(%esp)
801065c1:	e8 9a e4 ff ff       	call   80104a60 <wakeup>
      release(&tickslock);
801065c6:	c7 04 24 e0 5d 11 80 	movl   $0x80115de0,(%esp)
801065cd:	e8 ed e7 ff ff       	call   80104dbf <release>
    }
    lapiceoi();
801065d2:	e8 51 c9 ff ff       	call   80102f28 <lapiceoi>
    break;
801065d7:	e9 37 01 00 00       	jmp    80106713 <trap+0x1e6>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801065dc:	e8 be c1 ff ff       	call   8010279f <ideintr>
    lapiceoi();
801065e1:	e8 42 c9 ff ff       	call   80102f28 <lapiceoi>
    break;
801065e6:	e9 28 01 00 00       	jmp    80106713 <trap+0x1e6>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801065eb:	e8 4d c7 ff ff       	call   80102d3d <kbdintr>
    lapiceoi();
801065f0:	e8 33 c9 ff ff       	call   80102f28 <lapiceoi>
    break;
801065f5:	e9 19 01 00 00       	jmp    80106713 <trap+0x1e6>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801065fa:	e8 7b 03 00 00       	call   8010697a <uartintr>
    lapiceoi();
801065ff:	e8 24 c9 ff ff       	call   80102f28 <lapiceoi>
    break;
80106604:	e9 0a 01 00 00       	jmp    80106713 <trap+0x1e6>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106609:	8b 45 08             	mov    0x8(%ebp),%eax
8010660c:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
8010660f:	8b 45 08             	mov    0x8(%ebp),%eax
80106612:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106616:	0f b7 d8             	movzwl %ax,%ebx
80106619:	e8 88 da ff ff       	call   801040a6 <cpuid>
8010661e:	89 74 24 0c          	mov    %esi,0xc(%esp)
80106622:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80106626:	89 44 24 04          	mov    %eax,0x4(%esp)
8010662a:	c7 04 24 1c 88 10 80 	movl   $0x8010881c,(%esp)
80106631:	e8 92 9d ff ff       	call   801003c8 <cprintf>
    lapiceoi();
80106636:	e8 ed c8 ff ff       	call   80102f28 <lapiceoi>
    break;
8010663b:	e9 d3 00 00 00       	jmp    80106713 <trap+0x1e6>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106640:	e8 f8 da ff ff       	call   8010413d <myproc>
80106645:	85 c0                	test   %eax,%eax
80106647:	74 11                	je     8010665a <trap+0x12d>
80106649:	8b 45 08             	mov    0x8(%ebp),%eax
8010664c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106650:	0f b7 c0             	movzwl %ax,%eax
80106653:	83 e0 03             	and    $0x3,%eax
80106656:	85 c0                	test   %eax,%eax
80106658:	75 40                	jne    8010669a <trap+0x16d>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010665a:	e8 2d fd ff ff       	call   8010638c <rcr2>
8010665f:	89 c3                	mov    %eax,%ebx
80106661:	8b 45 08             	mov    0x8(%ebp),%eax
80106664:	8b 70 38             	mov    0x38(%eax),%esi
80106667:	e8 3a da ff ff       	call   801040a6 <cpuid>
8010666c:	8b 55 08             	mov    0x8(%ebp),%edx
8010666f:	8b 52 30             	mov    0x30(%edx),%edx
80106672:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106676:	89 74 24 0c          	mov    %esi,0xc(%esp)
8010667a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010667e:	89 54 24 04          	mov    %edx,0x4(%esp)
80106682:	c7 04 24 40 88 10 80 	movl   $0x80108840,(%esp)
80106689:	e8 3a 9d ff ff       	call   801003c8 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
8010668e:	c7 04 24 72 88 10 80 	movl   $0x80108872,(%esp)
80106695:	e8 c8 9e ff ff       	call   80100562 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010669a:	e8 ed fc ff ff       	call   8010638c <rcr2>
8010669f:	89 c6                	mov    %eax,%esi
801066a1:	8b 45 08             	mov    0x8(%ebp),%eax
801066a4:	8b 40 38             	mov    0x38(%eax),%eax
801066a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801066aa:	e8 f7 d9 ff ff       	call   801040a6 <cpuid>
801066af:	89 c3                	mov    %eax,%ebx
801066b1:	8b 45 08             	mov    0x8(%ebp),%eax
801066b4:	8b 78 34             	mov    0x34(%eax),%edi
801066b7:	89 7d e0             	mov    %edi,-0x20(%ebp)
801066ba:	8b 45 08             	mov    0x8(%ebp),%eax
801066bd:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801066c0:	e8 78 da ff ff       	call   8010413d <myproc>
801066c5:	8d 50 6c             	lea    0x6c(%eax),%edx
801066c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
801066cb:	e8 6d da ff ff       	call   8010413d <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066d0:	8b 40 10             	mov    0x10(%eax),%eax
801066d3:	89 74 24 1c          	mov    %esi,0x1c(%esp)
801066d7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801066da:	89 4c 24 18          	mov    %ecx,0x18(%esp)
801066de:	89 5c 24 14          	mov    %ebx,0x14(%esp)
801066e2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801066e5:	89 4c 24 10          	mov    %ecx,0x10(%esp)
801066e9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801066ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
801066f0:	89 54 24 08          	mov    %edx,0x8(%esp)
801066f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801066f8:	c7 04 24 78 88 10 80 	movl   $0x80108878,(%esp)
801066ff:	e8 c4 9c ff ff       	call   801003c8 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106704:	e8 34 da ff ff       	call   8010413d <myproc>
80106709:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106710:	eb 01                	jmp    80106713 <trap+0x1e6>
    break;
80106712:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106713:	e8 25 da ff ff       	call   8010413d <myproc>
80106718:	85 c0                	test   %eax,%eax
8010671a:	74 23                	je     8010673f <trap+0x212>
8010671c:	e8 1c da ff ff       	call   8010413d <myproc>
80106721:	8b 40 24             	mov    0x24(%eax),%eax
80106724:	85 c0                	test   %eax,%eax
80106726:	74 17                	je     8010673f <trap+0x212>
80106728:	8b 45 08             	mov    0x8(%ebp),%eax
8010672b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010672f:	0f b7 c0             	movzwl %ax,%eax
80106732:	83 e0 03             	and    $0x3,%eax
80106735:	83 f8 03             	cmp    $0x3,%eax
80106738:	75 05                	jne    8010673f <trap+0x212>
    exit();
8010673a:	e8 6d de ff ff       	call   801045ac <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010673f:	e8 f9 d9 ff ff       	call   8010413d <myproc>
80106744:	85 c0                	test   %eax,%eax
80106746:	74 1d                	je     80106765 <trap+0x238>
80106748:	e8 f0 d9 ff ff       	call   8010413d <myproc>
8010674d:	8b 40 0c             	mov    0xc(%eax),%eax
80106750:	83 f8 04             	cmp    $0x4,%eax
80106753:	75 10                	jne    80106765 <trap+0x238>
     tf->trapno == T_IRQ0+IRQ_TIMER)
80106755:	8b 45 08             	mov    0x8(%ebp),%eax
80106758:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
8010675b:	83 f8 20             	cmp    $0x20,%eax
8010675e:	75 05                	jne    80106765 <trap+0x238>
    yield();
80106760:	e8 b7 e1 ff ff       	call   8010491c <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106765:	e8 d3 d9 ff ff       	call   8010413d <myproc>
8010676a:	85 c0                	test   %eax,%eax
8010676c:	74 23                	je     80106791 <trap+0x264>
8010676e:	e8 ca d9 ff ff       	call   8010413d <myproc>
80106773:	8b 40 24             	mov    0x24(%eax),%eax
80106776:	85 c0                	test   %eax,%eax
80106778:	74 17                	je     80106791 <trap+0x264>
8010677a:	8b 45 08             	mov    0x8(%ebp),%eax
8010677d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106781:	0f b7 c0             	movzwl %ax,%eax
80106784:	83 e0 03             	and    $0x3,%eax
80106787:	83 f8 03             	cmp    $0x3,%eax
8010678a:	75 05                	jne    80106791 <trap+0x264>
    exit();
8010678c:	e8 1b de ff ff       	call   801045ac <exit>
}
80106791:	83 c4 3c             	add    $0x3c,%esp
80106794:	5b                   	pop    %ebx
80106795:	5e                   	pop    %esi
80106796:	5f                   	pop    %edi
80106797:	5d                   	pop    %ebp
80106798:	c3                   	ret    

80106799 <inb>:
{
80106799:	55                   	push   %ebp
8010679a:	89 e5                	mov    %esp,%ebp
8010679c:	83 ec 14             	sub    $0x14,%esp
8010679f:	8b 45 08             	mov    0x8(%ebp),%eax
801067a2:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801067a6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801067aa:	89 c2                	mov    %eax,%edx
801067ac:	ec                   	in     (%dx),%al
801067ad:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801067b0:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801067b4:	c9                   	leave  
801067b5:	c3                   	ret    

801067b6 <outb>:
{
801067b6:	55                   	push   %ebp
801067b7:	89 e5                	mov    %esp,%ebp
801067b9:	83 ec 08             	sub    $0x8,%esp
801067bc:	8b 55 08             	mov    0x8(%ebp),%edx
801067bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801067c2:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801067c6:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801067c9:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801067cd:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801067d1:	ee                   	out    %al,(%dx)
}
801067d2:	c9                   	leave  
801067d3:	c3                   	ret    

801067d4 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801067d4:	55                   	push   %ebp
801067d5:	89 e5                	mov    %esp,%ebp
801067d7:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801067da:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801067e1:	00 
801067e2:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801067e9:	e8 c8 ff ff ff       	call   801067b6 <outb>

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801067ee:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
801067f5:	00 
801067f6:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801067fd:	e8 b4 ff ff ff       	call   801067b6 <outb>
  outb(COM1+0, 115200/9600);
80106802:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106809:	00 
8010680a:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106811:	e8 a0 ff ff ff       	call   801067b6 <outb>
  outb(COM1+1, 0);
80106816:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010681d:	00 
8010681e:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106825:	e8 8c ff ff ff       	call   801067b6 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
8010682a:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106831:	00 
80106832:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106839:	e8 78 ff ff ff       	call   801067b6 <outb>
  outb(COM1+4, 0);
8010683e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106845:	00 
80106846:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
8010684d:	e8 64 ff ff ff       	call   801067b6 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106852:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106859:	00 
8010685a:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106861:	e8 50 ff ff ff       	call   801067b6 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106866:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010686d:	e8 27 ff ff ff       	call   80106799 <inb>
80106872:	3c ff                	cmp    $0xff,%al
80106874:	75 02                	jne    80106878 <uartinit+0xa4>
    return;
80106876:	eb 5e                	jmp    801068d6 <uartinit+0x102>
  uart = 1;
80106878:	c7 05 24 b6 10 80 01 	movl   $0x1,0x8010b624
8010687f:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106882:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106889:	e8 0b ff ff ff       	call   80106799 <inb>
  inb(COM1+0);
8010688e:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106895:	e8 ff fe ff ff       	call   80106799 <inb>
  ioapicenable(IRQ_COM1, 0);
8010689a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801068a1:	00 
801068a2:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801068a9:	e8 68 c1 ff ff       	call   80102a16 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801068ae:	c7 45 f4 3c 89 10 80 	movl   $0x8010893c,-0xc(%ebp)
801068b5:	eb 15                	jmp    801068cc <uartinit+0xf8>
    uartputc(*p);
801068b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068ba:	0f b6 00             	movzbl (%eax),%eax
801068bd:	0f be c0             	movsbl %al,%eax
801068c0:	89 04 24             	mov    %eax,(%esp)
801068c3:	e8 10 00 00 00       	call   801068d8 <uartputc>
  for(p="xv6...\n"; *p; p++)
801068c8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801068cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068cf:	0f b6 00             	movzbl (%eax),%eax
801068d2:	84 c0                	test   %al,%al
801068d4:	75 e1                	jne    801068b7 <uartinit+0xe3>
}
801068d6:	c9                   	leave  
801068d7:	c3                   	ret    

801068d8 <uartputc>:

void
uartputc(int c)
{
801068d8:	55                   	push   %ebp
801068d9:	89 e5                	mov    %esp,%ebp
801068db:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
801068de:	a1 24 b6 10 80       	mov    0x8010b624,%eax
801068e3:	85 c0                	test   %eax,%eax
801068e5:	75 02                	jne    801068e9 <uartputc+0x11>
    return;
801068e7:	eb 4b                	jmp    80106934 <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801068e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801068f0:	eb 10                	jmp    80106902 <uartputc+0x2a>
    microdelay(10);
801068f2:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801068f9:	e8 4f c6 ff ff       	call   80102f4d <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801068fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106902:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106906:	7f 16                	jg     8010691e <uartputc+0x46>
80106908:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010690f:	e8 85 fe ff ff       	call   80106799 <inb>
80106914:	0f b6 c0             	movzbl %al,%eax
80106917:	83 e0 20             	and    $0x20,%eax
8010691a:	85 c0                	test   %eax,%eax
8010691c:	74 d4                	je     801068f2 <uartputc+0x1a>
  outb(COM1+0, c);
8010691e:	8b 45 08             	mov    0x8(%ebp),%eax
80106921:	0f b6 c0             	movzbl %al,%eax
80106924:	89 44 24 04          	mov    %eax,0x4(%esp)
80106928:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010692f:	e8 82 fe ff ff       	call   801067b6 <outb>
}
80106934:	c9                   	leave  
80106935:	c3                   	ret    

80106936 <uartgetc>:

static int
uartgetc(void)
{
80106936:	55                   	push   %ebp
80106937:	89 e5                	mov    %esp,%ebp
80106939:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
8010693c:	a1 24 b6 10 80       	mov    0x8010b624,%eax
80106941:	85 c0                	test   %eax,%eax
80106943:	75 07                	jne    8010694c <uartgetc+0x16>
    return -1;
80106945:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010694a:	eb 2c                	jmp    80106978 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
8010694c:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106953:	e8 41 fe ff ff       	call   80106799 <inb>
80106958:	0f b6 c0             	movzbl %al,%eax
8010695b:	83 e0 01             	and    $0x1,%eax
8010695e:	85 c0                	test   %eax,%eax
80106960:	75 07                	jne    80106969 <uartgetc+0x33>
    return -1;
80106962:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106967:	eb 0f                	jmp    80106978 <uartgetc+0x42>
  return inb(COM1+0);
80106969:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106970:	e8 24 fe ff ff       	call   80106799 <inb>
80106975:	0f b6 c0             	movzbl %al,%eax
}
80106978:	c9                   	leave  
80106979:	c3                   	ret    

8010697a <uartintr>:

void
uartintr(void)
{
8010697a:	55                   	push   %ebp
8010697b:	89 e5                	mov    %esp,%ebp
8010697d:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106980:	c7 04 24 36 69 10 80 	movl   $0x80106936,(%esp)
80106987:	e8 5d 9e ff ff       	call   801007e9 <consoleintr>
}
8010698c:	c9                   	leave  
8010698d:	c3                   	ret    

8010698e <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010698e:	6a 00                	push   $0x0
  pushl $0
80106990:	6a 00                	push   $0x0
  jmp alltraps
80106992:	e9 a9 f9 ff ff       	jmp    80106340 <alltraps>

80106997 <vector1>:
.globl vector1
vector1:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $1
80106999:	6a 01                	push   $0x1
  jmp alltraps
8010699b:	e9 a0 f9 ff ff       	jmp    80106340 <alltraps>

801069a0 <vector2>:
.globl vector2
vector2:
  pushl $0
801069a0:	6a 00                	push   $0x0
  pushl $2
801069a2:	6a 02                	push   $0x2
  jmp alltraps
801069a4:	e9 97 f9 ff ff       	jmp    80106340 <alltraps>

801069a9 <vector3>:
.globl vector3
vector3:
  pushl $0
801069a9:	6a 00                	push   $0x0
  pushl $3
801069ab:	6a 03                	push   $0x3
  jmp alltraps
801069ad:	e9 8e f9 ff ff       	jmp    80106340 <alltraps>

801069b2 <vector4>:
.globl vector4
vector4:
  pushl $0
801069b2:	6a 00                	push   $0x0
  pushl $4
801069b4:	6a 04                	push   $0x4
  jmp alltraps
801069b6:	e9 85 f9 ff ff       	jmp    80106340 <alltraps>

801069bb <vector5>:
.globl vector5
vector5:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $5
801069bd:	6a 05                	push   $0x5
  jmp alltraps
801069bf:	e9 7c f9 ff ff       	jmp    80106340 <alltraps>

801069c4 <vector6>:
.globl vector6
vector6:
  pushl $0
801069c4:	6a 00                	push   $0x0
  pushl $6
801069c6:	6a 06                	push   $0x6
  jmp alltraps
801069c8:	e9 73 f9 ff ff       	jmp    80106340 <alltraps>

801069cd <vector7>:
.globl vector7
vector7:
  pushl $0
801069cd:	6a 00                	push   $0x0
  pushl $7
801069cf:	6a 07                	push   $0x7
  jmp alltraps
801069d1:	e9 6a f9 ff ff       	jmp    80106340 <alltraps>

801069d6 <vector8>:
.globl vector8
vector8:
  pushl $8
801069d6:	6a 08                	push   $0x8
  jmp alltraps
801069d8:	e9 63 f9 ff ff       	jmp    80106340 <alltraps>

801069dd <vector9>:
.globl vector9
vector9:
  pushl $0
801069dd:	6a 00                	push   $0x0
  pushl $9
801069df:	6a 09                	push   $0x9
  jmp alltraps
801069e1:	e9 5a f9 ff ff       	jmp    80106340 <alltraps>

801069e6 <vector10>:
.globl vector10
vector10:
  pushl $10
801069e6:	6a 0a                	push   $0xa
  jmp alltraps
801069e8:	e9 53 f9 ff ff       	jmp    80106340 <alltraps>

801069ed <vector11>:
.globl vector11
vector11:
  pushl $11
801069ed:	6a 0b                	push   $0xb
  jmp alltraps
801069ef:	e9 4c f9 ff ff       	jmp    80106340 <alltraps>

801069f4 <vector12>:
.globl vector12
vector12:
  pushl $12
801069f4:	6a 0c                	push   $0xc
  jmp alltraps
801069f6:	e9 45 f9 ff ff       	jmp    80106340 <alltraps>

801069fb <vector13>:
.globl vector13
vector13:
  pushl $13
801069fb:	6a 0d                	push   $0xd
  jmp alltraps
801069fd:	e9 3e f9 ff ff       	jmp    80106340 <alltraps>

80106a02 <vector14>:
.globl vector14
vector14:
  pushl $14
80106a02:	6a 0e                	push   $0xe
  jmp alltraps
80106a04:	e9 37 f9 ff ff       	jmp    80106340 <alltraps>

80106a09 <vector15>:
.globl vector15
vector15:
  pushl $0
80106a09:	6a 00                	push   $0x0
  pushl $15
80106a0b:	6a 0f                	push   $0xf
  jmp alltraps
80106a0d:	e9 2e f9 ff ff       	jmp    80106340 <alltraps>

80106a12 <vector16>:
.globl vector16
vector16:
  pushl $0
80106a12:	6a 00                	push   $0x0
  pushl $16
80106a14:	6a 10                	push   $0x10
  jmp alltraps
80106a16:	e9 25 f9 ff ff       	jmp    80106340 <alltraps>

80106a1b <vector17>:
.globl vector17
vector17:
  pushl $17
80106a1b:	6a 11                	push   $0x11
  jmp alltraps
80106a1d:	e9 1e f9 ff ff       	jmp    80106340 <alltraps>

80106a22 <vector18>:
.globl vector18
vector18:
  pushl $0
80106a22:	6a 00                	push   $0x0
  pushl $18
80106a24:	6a 12                	push   $0x12
  jmp alltraps
80106a26:	e9 15 f9 ff ff       	jmp    80106340 <alltraps>

80106a2b <vector19>:
.globl vector19
vector19:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $19
80106a2d:	6a 13                	push   $0x13
  jmp alltraps
80106a2f:	e9 0c f9 ff ff       	jmp    80106340 <alltraps>

80106a34 <vector20>:
.globl vector20
vector20:
  pushl $0
80106a34:	6a 00                	push   $0x0
  pushl $20
80106a36:	6a 14                	push   $0x14
  jmp alltraps
80106a38:	e9 03 f9 ff ff       	jmp    80106340 <alltraps>

80106a3d <vector21>:
.globl vector21
vector21:
  pushl $0
80106a3d:	6a 00                	push   $0x0
  pushl $21
80106a3f:	6a 15                	push   $0x15
  jmp alltraps
80106a41:	e9 fa f8 ff ff       	jmp    80106340 <alltraps>

80106a46 <vector22>:
.globl vector22
vector22:
  pushl $0
80106a46:	6a 00                	push   $0x0
  pushl $22
80106a48:	6a 16                	push   $0x16
  jmp alltraps
80106a4a:	e9 f1 f8 ff ff       	jmp    80106340 <alltraps>

80106a4f <vector23>:
.globl vector23
vector23:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $23
80106a51:	6a 17                	push   $0x17
  jmp alltraps
80106a53:	e9 e8 f8 ff ff       	jmp    80106340 <alltraps>

80106a58 <vector24>:
.globl vector24
vector24:
  pushl $0
80106a58:	6a 00                	push   $0x0
  pushl $24
80106a5a:	6a 18                	push   $0x18
  jmp alltraps
80106a5c:	e9 df f8 ff ff       	jmp    80106340 <alltraps>

80106a61 <vector25>:
.globl vector25
vector25:
  pushl $0
80106a61:	6a 00                	push   $0x0
  pushl $25
80106a63:	6a 19                	push   $0x19
  jmp alltraps
80106a65:	e9 d6 f8 ff ff       	jmp    80106340 <alltraps>

80106a6a <vector26>:
.globl vector26
vector26:
  pushl $0
80106a6a:	6a 00                	push   $0x0
  pushl $26
80106a6c:	6a 1a                	push   $0x1a
  jmp alltraps
80106a6e:	e9 cd f8 ff ff       	jmp    80106340 <alltraps>

80106a73 <vector27>:
.globl vector27
vector27:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $27
80106a75:	6a 1b                	push   $0x1b
  jmp alltraps
80106a77:	e9 c4 f8 ff ff       	jmp    80106340 <alltraps>

80106a7c <vector28>:
.globl vector28
vector28:
  pushl $0
80106a7c:	6a 00                	push   $0x0
  pushl $28
80106a7e:	6a 1c                	push   $0x1c
  jmp alltraps
80106a80:	e9 bb f8 ff ff       	jmp    80106340 <alltraps>

80106a85 <vector29>:
.globl vector29
vector29:
  pushl $0
80106a85:	6a 00                	push   $0x0
  pushl $29
80106a87:	6a 1d                	push   $0x1d
  jmp alltraps
80106a89:	e9 b2 f8 ff ff       	jmp    80106340 <alltraps>

80106a8e <vector30>:
.globl vector30
vector30:
  pushl $0
80106a8e:	6a 00                	push   $0x0
  pushl $30
80106a90:	6a 1e                	push   $0x1e
  jmp alltraps
80106a92:	e9 a9 f8 ff ff       	jmp    80106340 <alltraps>

80106a97 <vector31>:
.globl vector31
vector31:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $31
80106a99:	6a 1f                	push   $0x1f
  jmp alltraps
80106a9b:	e9 a0 f8 ff ff       	jmp    80106340 <alltraps>

80106aa0 <vector32>:
.globl vector32
vector32:
  pushl $0
80106aa0:	6a 00                	push   $0x0
  pushl $32
80106aa2:	6a 20                	push   $0x20
  jmp alltraps
80106aa4:	e9 97 f8 ff ff       	jmp    80106340 <alltraps>

80106aa9 <vector33>:
.globl vector33
vector33:
  pushl $0
80106aa9:	6a 00                	push   $0x0
  pushl $33
80106aab:	6a 21                	push   $0x21
  jmp alltraps
80106aad:	e9 8e f8 ff ff       	jmp    80106340 <alltraps>

80106ab2 <vector34>:
.globl vector34
vector34:
  pushl $0
80106ab2:	6a 00                	push   $0x0
  pushl $34
80106ab4:	6a 22                	push   $0x22
  jmp alltraps
80106ab6:	e9 85 f8 ff ff       	jmp    80106340 <alltraps>

80106abb <vector35>:
.globl vector35
vector35:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $35
80106abd:	6a 23                	push   $0x23
  jmp alltraps
80106abf:	e9 7c f8 ff ff       	jmp    80106340 <alltraps>

80106ac4 <vector36>:
.globl vector36
vector36:
  pushl $0
80106ac4:	6a 00                	push   $0x0
  pushl $36
80106ac6:	6a 24                	push   $0x24
  jmp alltraps
80106ac8:	e9 73 f8 ff ff       	jmp    80106340 <alltraps>

80106acd <vector37>:
.globl vector37
vector37:
  pushl $0
80106acd:	6a 00                	push   $0x0
  pushl $37
80106acf:	6a 25                	push   $0x25
  jmp alltraps
80106ad1:	e9 6a f8 ff ff       	jmp    80106340 <alltraps>

80106ad6 <vector38>:
.globl vector38
vector38:
  pushl $0
80106ad6:	6a 00                	push   $0x0
  pushl $38
80106ad8:	6a 26                	push   $0x26
  jmp alltraps
80106ada:	e9 61 f8 ff ff       	jmp    80106340 <alltraps>

80106adf <vector39>:
.globl vector39
vector39:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $39
80106ae1:	6a 27                	push   $0x27
  jmp alltraps
80106ae3:	e9 58 f8 ff ff       	jmp    80106340 <alltraps>

80106ae8 <vector40>:
.globl vector40
vector40:
  pushl $0
80106ae8:	6a 00                	push   $0x0
  pushl $40
80106aea:	6a 28                	push   $0x28
  jmp alltraps
80106aec:	e9 4f f8 ff ff       	jmp    80106340 <alltraps>

80106af1 <vector41>:
.globl vector41
vector41:
  pushl $0
80106af1:	6a 00                	push   $0x0
  pushl $41
80106af3:	6a 29                	push   $0x29
  jmp alltraps
80106af5:	e9 46 f8 ff ff       	jmp    80106340 <alltraps>

80106afa <vector42>:
.globl vector42
vector42:
  pushl $0
80106afa:	6a 00                	push   $0x0
  pushl $42
80106afc:	6a 2a                	push   $0x2a
  jmp alltraps
80106afe:	e9 3d f8 ff ff       	jmp    80106340 <alltraps>

80106b03 <vector43>:
.globl vector43
vector43:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $43
80106b05:	6a 2b                	push   $0x2b
  jmp alltraps
80106b07:	e9 34 f8 ff ff       	jmp    80106340 <alltraps>

80106b0c <vector44>:
.globl vector44
vector44:
  pushl $0
80106b0c:	6a 00                	push   $0x0
  pushl $44
80106b0e:	6a 2c                	push   $0x2c
  jmp alltraps
80106b10:	e9 2b f8 ff ff       	jmp    80106340 <alltraps>

80106b15 <vector45>:
.globl vector45
vector45:
  pushl $0
80106b15:	6a 00                	push   $0x0
  pushl $45
80106b17:	6a 2d                	push   $0x2d
  jmp alltraps
80106b19:	e9 22 f8 ff ff       	jmp    80106340 <alltraps>

80106b1e <vector46>:
.globl vector46
vector46:
  pushl $0
80106b1e:	6a 00                	push   $0x0
  pushl $46
80106b20:	6a 2e                	push   $0x2e
  jmp alltraps
80106b22:	e9 19 f8 ff ff       	jmp    80106340 <alltraps>

80106b27 <vector47>:
.globl vector47
vector47:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $47
80106b29:	6a 2f                	push   $0x2f
  jmp alltraps
80106b2b:	e9 10 f8 ff ff       	jmp    80106340 <alltraps>

80106b30 <vector48>:
.globl vector48
vector48:
  pushl $0
80106b30:	6a 00                	push   $0x0
  pushl $48
80106b32:	6a 30                	push   $0x30
  jmp alltraps
80106b34:	e9 07 f8 ff ff       	jmp    80106340 <alltraps>

80106b39 <vector49>:
.globl vector49
vector49:
  pushl $0
80106b39:	6a 00                	push   $0x0
  pushl $49
80106b3b:	6a 31                	push   $0x31
  jmp alltraps
80106b3d:	e9 fe f7 ff ff       	jmp    80106340 <alltraps>

80106b42 <vector50>:
.globl vector50
vector50:
  pushl $0
80106b42:	6a 00                	push   $0x0
  pushl $50
80106b44:	6a 32                	push   $0x32
  jmp alltraps
80106b46:	e9 f5 f7 ff ff       	jmp    80106340 <alltraps>

80106b4b <vector51>:
.globl vector51
vector51:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $51
80106b4d:	6a 33                	push   $0x33
  jmp alltraps
80106b4f:	e9 ec f7 ff ff       	jmp    80106340 <alltraps>

80106b54 <vector52>:
.globl vector52
vector52:
  pushl $0
80106b54:	6a 00                	push   $0x0
  pushl $52
80106b56:	6a 34                	push   $0x34
  jmp alltraps
80106b58:	e9 e3 f7 ff ff       	jmp    80106340 <alltraps>

80106b5d <vector53>:
.globl vector53
vector53:
  pushl $0
80106b5d:	6a 00                	push   $0x0
  pushl $53
80106b5f:	6a 35                	push   $0x35
  jmp alltraps
80106b61:	e9 da f7 ff ff       	jmp    80106340 <alltraps>

80106b66 <vector54>:
.globl vector54
vector54:
  pushl $0
80106b66:	6a 00                	push   $0x0
  pushl $54
80106b68:	6a 36                	push   $0x36
  jmp alltraps
80106b6a:	e9 d1 f7 ff ff       	jmp    80106340 <alltraps>

80106b6f <vector55>:
.globl vector55
vector55:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $55
80106b71:	6a 37                	push   $0x37
  jmp alltraps
80106b73:	e9 c8 f7 ff ff       	jmp    80106340 <alltraps>

80106b78 <vector56>:
.globl vector56
vector56:
  pushl $0
80106b78:	6a 00                	push   $0x0
  pushl $56
80106b7a:	6a 38                	push   $0x38
  jmp alltraps
80106b7c:	e9 bf f7 ff ff       	jmp    80106340 <alltraps>

80106b81 <vector57>:
.globl vector57
vector57:
  pushl $0
80106b81:	6a 00                	push   $0x0
  pushl $57
80106b83:	6a 39                	push   $0x39
  jmp alltraps
80106b85:	e9 b6 f7 ff ff       	jmp    80106340 <alltraps>

80106b8a <vector58>:
.globl vector58
vector58:
  pushl $0
80106b8a:	6a 00                	push   $0x0
  pushl $58
80106b8c:	6a 3a                	push   $0x3a
  jmp alltraps
80106b8e:	e9 ad f7 ff ff       	jmp    80106340 <alltraps>

80106b93 <vector59>:
.globl vector59
vector59:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $59
80106b95:	6a 3b                	push   $0x3b
  jmp alltraps
80106b97:	e9 a4 f7 ff ff       	jmp    80106340 <alltraps>

80106b9c <vector60>:
.globl vector60
vector60:
  pushl $0
80106b9c:	6a 00                	push   $0x0
  pushl $60
80106b9e:	6a 3c                	push   $0x3c
  jmp alltraps
80106ba0:	e9 9b f7 ff ff       	jmp    80106340 <alltraps>

80106ba5 <vector61>:
.globl vector61
vector61:
  pushl $0
80106ba5:	6a 00                	push   $0x0
  pushl $61
80106ba7:	6a 3d                	push   $0x3d
  jmp alltraps
80106ba9:	e9 92 f7 ff ff       	jmp    80106340 <alltraps>

80106bae <vector62>:
.globl vector62
vector62:
  pushl $0
80106bae:	6a 00                	push   $0x0
  pushl $62
80106bb0:	6a 3e                	push   $0x3e
  jmp alltraps
80106bb2:	e9 89 f7 ff ff       	jmp    80106340 <alltraps>

80106bb7 <vector63>:
.globl vector63
vector63:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $63
80106bb9:	6a 3f                	push   $0x3f
  jmp alltraps
80106bbb:	e9 80 f7 ff ff       	jmp    80106340 <alltraps>

80106bc0 <vector64>:
.globl vector64
vector64:
  pushl $0
80106bc0:	6a 00                	push   $0x0
  pushl $64
80106bc2:	6a 40                	push   $0x40
  jmp alltraps
80106bc4:	e9 77 f7 ff ff       	jmp    80106340 <alltraps>

80106bc9 <vector65>:
.globl vector65
vector65:
  pushl $0
80106bc9:	6a 00                	push   $0x0
  pushl $65
80106bcb:	6a 41                	push   $0x41
  jmp alltraps
80106bcd:	e9 6e f7 ff ff       	jmp    80106340 <alltraps>

80106bd2 <vector66>:
.globl vector66
vector66:
  pushl $0
80106bd2:	6a 00                	push   $0x0
  pushl $66
80106bd4:	6a 42                	push   $0x42
  jmp alltraps
80106bd6:	e9 65 f7 ff ff       	jmp    80106340 <alltraps>

80106bdb <vector67>:
.globl vector67
vector67:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $67
80106bdd:	6a 43                	push   $0x43
  jmp alltraps
80106bdf:	e9 5c f7 ff ff       	jmp    80106340 <alltraps>

80106be4 <vector68>:
.globl vector68
vector68:
  pushl $0
80106be4:	6a 00                	push   $0x0
  pushl $68
80106be6:	6a 44                	push   $0x44
  jmp alltraps
80106be8:	e9 53 f7 ff ff       	jmp    80106340 <alltraps>

80106bed <vector69>:
.globl vector69
vector69:
  pushl $0
80106bed:	6a 00                	push   $0x0
  pushl $69
80106bef:	6a 45                	push   $0x45
  jmp alltraps
80106bf1:	e9 4a f7 ff ff       	jmp    80106340 <alltraps>

80106bf6 <vector70>:
.globl vector70
vector70:
  pushl $0
80106bf6:	6a 00                	push   $0x0
  pushl $70
80106bf8:	6a 46                	push   $0x46
  jmp alltraps
80106bfa:	e9 41 f7 ff ff       	jmp    80106340 <alltraps>

80106bff <vector71>:
.globl vector71
vector71:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $71
80106c01:	6a 47                	push   $0x47
  jmp alltraps
80106c03:	e9 38 f7 ff ff       	jmp    80106340 <alltraps>

80106c08 <vector72>:
.globl vector72
vector72:
  pushl $0
80106c08:	6a 00                	push   $0x0
  pushl $72
80106c0a:	6a 48                	push   $0x48
  jmp alltraps
80106c0c:	e9 2f f7 ff ff       	jmp    80106340 <alltraps>

80106c11 <vector73>:
.globl vector73
vector73:
  pushl $0
80106c11:	6a 00                	push   $0x0
  pushl $73
80106c13:	6a 49                	push   $0x49
  jmp alltraps
80106c15:	e9 26 f7 ff ff       	jmp    80106340 <alltraps>

80106c1a <vector74>:
.globl vector74
vector74:
  pushl $0
80106c1a:	6a 00                	push   $0x0
  pushl $74
80106c1c:	6a 4a                	push   $0x4a
  jmp alltraps
80106c1e:	e9 1d f7 ff ff       	jmp    80106340 <alltraps>

80106c23 <vector75>:
.globl vector75
vector75:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $75
80106c25:	6a 4b                	push   $0x4b
  jmp alltraps
80106c27:	e9 14 f7 ff ff       	jmp    80106340 <alltraps>

80106c2c <vector76>:
.globl vector76
vector76:
  pushl $0
80106c2c:	6a 00                	push   $0x0
  pushl $76
80106c2e:	6a 4c                	push   $0x4c
  jmp alltraps
80106c30:	e9 0b f7 ff ff       	jmp    80106340 <alltraps>

80106c35 <vector77>:
.globl vector77
vector77:
  pushl $0
80106c35:	6a 00                	push   $0x0
  pushl $77
80106c37:	6a 4d                	push   $0x4d
  jmp alltraps
80106c39:	e9 02 f7 ff ff       	jmp    80106340 <alltraps>

80106c3e <vector78>:
.globl vector78
vector78:
  pushl $0
80106c3e:	6a 00                	push   $0x0
  pushl $78
80106c40:	6a 4e                	push   $0x4e
  jmp alltraps
80106c42:	e9 f9 f6 ff ff       	jmp    80106340 <alltraps>

80106c47 <vector79>:
.globl vector79
vector79:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $79
80106c49:	6a 4f                	push   $0x4f
  jmp alltraps
80106c4b:	e9 f0 f6 ff ff       	jmp    80106340 <alltraps>

80106c50 <vector80>:
.globl vector80
vector80:
  pushl $0
80106c50:	6a 00                	push   $0x0
  pushl $80
80106c52:	6a 50                	push   $0x50
  jmp alltraps
80106c54:	e9 e7 f6 ff ff       	jmp    80106340 <alltraps>

80106c59 <vector81>:
.globl vector81
vector81:
  pushl $0
80106c59:	6a 00                	push   $0x0
  pushl $81
80106c5b:	6a 51                	push   $0x51
  jmp alltraps
80106c5d:	e9 de f6 ff ff       	jmp    80106340 <alltraps>

80106c62 <vector82>:
.globl vector82
vector82:
  pushl $0
80106c62:	6a 00                	push   $0x0
  pushl $82
80106c64:	6a 52                	push   $0x52
  jmp alltraps
80106c66:	e9 d5 f6 ff ff       	jmp    80106340 <alltraps>

80106c6b <vector83>:
.globl vector83
vector83:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $83
80106c6d:	6a 53                	push   $0x53
  jmp alltraps
80106c6f:	e9 cc f6 ff ff       	jmp    80106340 <alltraps>

80106c74 <vector84>:
.globl vector84
vector84:
  pushl $0
80106c74:	6a 00                	push   $0x0
  pushl $84
80106c76:	6a 54                	push   $0x54
  jmp alltraps
80106c78:	e9 c3 f6 ff ff       	jmp    80106340 <alltraps>

80106c7d <vector85>:
.globl vector85
vector85:
  pushl $0
80106c7d:	6a 00                	push   $0x0
  pushl $85
80106c7f:	6a 55                	push   $0x55
  jmp alltraps
80106c81:	e9 ba f6 ff ff       	jmp    80106340 <alltraps>

80106c86 <vector86>:
.globl vector86
vector86:
  pushl $0
80106c86:	6a 00                	push   $0x0
  pushl $86
80106c88:	6a 56                	push   $0x56
  jmp alltraps
80106c8a:	e9 b1 f6 ff ff       	jmp    80106340 <alltraps>

80106c8f <vector87>:
.globl vector87
vector87:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $87
80106c91:	6a 57                	push   $0x57
  jmp alltraps
80106c93:	e9 a8 f6 ff ff       	jmp    80106340 <alltraps>

80106c98 <vector88>:
.globl vector88
vector88:
  pushl $0
80106c98:	6a 00                	push   $0x0
  pushl $88
80106c9a:	6a 58                	push   $0x58
  jmp alltraps
80106c9c:	e9 9f f6 ff ff       	jmp    80106340 <alltraps>

80106ca1 <vector89>:
.globl vector89
vector89:
  pushl $0
80106ca1:	6a 00                	push   $0x0
  pushl $89
80106ca3:	6a 59                	push   $0x59
  jmp alltraps
80106ca5:	e9 96 f6 ff ff       	jmp    80106340 <alltraps>

80106caa <vector90>:
.globl vector90
vector90:
  pushl $0
80106caa:	6a 00                	push   $0x0
  pushl $90
80106cac:	6a 5a                	push   $0x5a
  jmp alltraps
80106cae:	e9 8d f6 ff ff       	jmp    80106340 <alltraps>

80106cb3 <vector91>:
.globl vector91
vector91:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $91
80106cb5:	6a 5b                	push   $0x5b
  jmp alltraps
80106cb7:	e9 84 f6 ff ff       	jmp    80106340 <alltraps>

80106cbc <vector92>:
.globl vector92
vector92:
  pushl $0
80106cbc:	6a 00                	push   $0x0
  pushl $92
80106cbe:	6a 5c                	push   $0x5c
  jmp alltraps
80106cc0:	e9 7b f6 ff ff       	jmp    80106340 <alltraps>

80106cc5 <vector93>:
.globl vector93
vector93:
  pushl $0
80106cc5:	6a 00                	push   $0x0
  pushl $93
80106cc7:	6a 5d                	push   $0x5d
  jmp alltraps
80106cc9:	e9 72 f6 ff ff       	jmp    80106340 <alltraps>

80106cce <vector94>:
.globl vector94
vector94:
  pushl $0
80106cce:	6a 00                	push   $0x0
  pushl $94
80106cd0:	6a 5e                	push   $0x5e
  jmp alltraps
80106cd2:	e9 69 f6 ff ff       	jmp    80106340 <alltraps>

80106cd7 <vector95>:
.globl vector95
vector95:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $95
80106cd9:	6a 5f                	push   $0x5f
  jmp alltraps
80106cdb:	e9 60 f6 ff ff       	jmp    80106340 <alltraps>

80106ce0 <vector96>:
.globl vector96
vector96:
  pushl $0
80106ce0:	6a 00                	push   $0x0
  pushl $96
80106ce2:	6a 60                	push   $0x60
  jmp alltraps
80106ce4:	e9 57 f6 ff ff       	jmp    80106340 <alltraps>

80106ce9 <vector97>:
.globl vector97
vector97:
  pushl $0
80106ce9:	6a 00                	push   $0x0
  pushl $97
80106ceb:	6a 61                	push   $0x61
  jmp alltraps
80106ced:	e9 4e f6 ff ff       	jmp    80106340 <alltraps>

80106cf2 <vector98>:
.globl vector98
vector98:
  pushl $0
80106cf2:	6a 00                	push   $0x0
  pushl $98
80106cf4:	6a 62                	push   $0x62
  jmp alltraps
80106cf6:	e9 45 f6 ff ff       	jmp    80106340 <alltraps>

80106cfb <vector99>:
.globl vector99
vector99:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $99
80106cfd:	6a 63                	push   $0x63
  jmp alltraps
80106cff:	e9 3c f6 ff ff       	jmp    80106340 <alltraps>

80106d04 <vector100>:
.globl vector100
vector100:
  pushl $0
80106d04:	6a 00                	push   $0x0
  pushl $100
80106d06:	6a 64                	push   $0x64
  jmp alltraps
80106d08:	e9 33 f6 ff ff       	jmp    80106340 <alltraps>

80106d0d <vector101>:
.globl vector101
vector101:
  pushl $0
80106d0d:	6a 00                	push   $0x0
  pushl $101
80106d0f:	6a 65                	push   $0x65
  jmp alltraps
80106d11:	e9 2a f6 ff ff       	jmp    80106340 <alltraps>

80106d16 <vector102>:
.globl vector102
vector102:
  pushl $0
80106d16:	6a 00                	push   $0x0
  pushl $102
80106d18:	6a 66                	push   $0x66
  jmp alltraps
80106d1a:	e9 21 f6 ff ff       	jmp    80106340 <alltraps>

80106d1f <vector103>:
.globl vector103
vector103:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $103
80106d21:	6a 67                	push   $0x67
  jmp alltraps
80106d23:	e9 18 f6 ff ff       	jmp    80106340 <alltraps>

80106d28 <vector104>:
.globl vector104
vector104:
  pushl $0
80106d28:	6a 00                	push   $0x0
  pushl $104
80106d2a:	6a 68                	push   $0x68
  jmp alltraps
80106d2c:	e9 0f f6 ff ff       	jmp    80106340 <alltraps>

80106d31 <vector105>:
.globl vector105
vector105:
  pushl $0
80106d31:	6a 00                	push   $0x0
  pushl $105
80106d33:	6a 69                	push   $0x69
  jmp alltraps
80106d35:	e9 06 f6 ff ff       	jmp    80106340 <alltraps>

80106d3a <vector106>:
.globl vector106
vector106:
  pushl $0
80106d3a:	6a 00                	push   $0x0
  pushl $106
80106d3c:	6a 6a                	push   $0x6a
  jmp alltraps
80106d3e:	e9 fd f5 ff ff       	jmp    80106340 <alltraps>

80106d43 <vector107>:
.globl vector107
vector107:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $107
80106d45:	6a 6b                	push   $0x6b
  jmp alltraps
80106d47:	e9 f4 f5 ff ff       	jmp    80106340 <alltraps>

80106d4c <vector108>:
.globl vector108
vector108:
  pushl $0
80106d4c:	6a 00                	push   $0x0
  pushl $108
80106d4e:	6a 6c                	push   $0x6c
  jmp alltraps
80106d50:	e9 eb f5 ff ff       	jmp    80106340 <alltraps>

80106d55 <vector109>:
.globl vector109
vector109:
  pushl $0
80106d55:	6a 00                	push   $0x0
  pushl $109
80106d57:	6a 6d                	push   $0x6d
  jmp alltraps
80106d59:	e9 e2 f5 ff ff       	jmp    80106340 <alltraps>

80106d5e <vector110>:
.globl vector110
vector110:
  pushl $0
80106d5e:	6a 00                	push   $0x0
  pushl $110
80106d60:	6a 6e                	push   $0x6e
  jmp alltraps
80106d62:	e9 d9 f5 ff ff       	jmp    80106340 <alltraps>

80106d67 <vector111>:
.globl vector111
vector111:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $111
80106d69:	6a 6f                	push   $0x6f
  jmp alltraps
80106d6b:	e9 d0 f5 ff ff       	jmp    80106340 <alltraps>

80106d70 <vector112>:
.globl vector112
vector112:
  pushl $0
80106d70:	6a 00                	push   $0x0
  pushl $112
80106d72:	6a 70                	push   $0x70
  jmp alltraps
80106d74:	e9 c7 f5 ff ff       	jmp    80106340 <alltraps>

80106d79 <vector113>:
.globl vector113
vector113:
  pushl $0
80106d79:	6a 00                	push   $0x0
  pushl $113
80106d7b:	6a 71                	push   $0x71
  jmp alltraps
80106d7d:	e9 be f5 ff ff       	jmp    80106340 <alltraps>

80106d82 <vector114>:
.globl vector114
vector114:
  pushl $0
80106d82:	6a 00                	push   $0x0
  pushl $114
80106d84:	6a 72                	push   $0x72
  jmp alltraps
80106d86:	e9 b5 f5 ff ff       	jmp    80106340 <alltraps>

80106d8b <vector115>:
.globl vector115
vector115:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $115
80106d8d:	6a 73                	push   $0x73
  jmp alltraps
80106d8f:	e9 ac f5 ff ff       	jmp    80106340 <alltraps>

80106d94 <vector116>:
.globl vector116
vector116:
  pushl $0
80106d94:	6a 00                	push   $0x0
  pushl $116
80106d96:	6a 74                	push   $0x74
  jmp alltraps
80106d98:	e9 a3 f5 ff ff       	jmp    80106340 <alltraps>

80106d9d <vector117>:
.globl vector117
vector117:
  pushl $0
80106d9d:	6a 00                	push   $0x0
  pushl $117
80106d9f:	6a 75                	push   $0x75
  jmp alltraps
80106da1:	e9 9a f5 ff ff       	jmp    80106340 <alltraps>

80106da6 <vector118>:
.globl vector118
vector118:
  pushl $0
80106da6:	6a 00                	push   $0x0
  pushl $118
80106da8:	6a 76                	push   $0x76
  jmp alltraps
80106daa:	e9 91 f5 ff ff       	jmp    80106340 <alltraps>

80106daf <vector119>:
.globl vector119
vector119:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $119
80106db1:	6a 77                	push   $0x77
  jmp alltraps
80106db3:	e9 88 f5 ff ff       	jmp    80106340 <alltraps>

80106db8 <vector120>:
.globl vector120
vector120:
  pushl $0
80106db8:	6a 00                	push   $0x0
  pushl $120
80106dba:	6a 78                	push   $0x78
  jmp alltraps
80106dbc:	e9 7f f5 ff ff       	jmp    80106340 <alltraps>

80106dc1 <vector121>:
.globl vector121
vector121:
  pushl $0
80106dc1:	6a 00                	push   $0x0
  pushl $121
80106dc3:	6a 79                	push   $0x79
  jmp alltraps
80106dc5:	e9 76 f5 ff ff       	jmp    80106340 <alltraps>

80106dca <vector122>:
.globl vector122
vector122:
  pushl $0
80106dca:	6a 00                	push   $0x0
  pushl $122
80106dcc:	6a 7a                	push   $0x7a
  jmp alltraps
80106dce:	e9 6d f5 ff ff       	jmp    80106340 <alltraps>

80106dd3 <vector123>:
.globl vector123
vector123:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $123
80106dd5:	6a 7b                	push   $0x7b
  jmp alltraps
80106dd7:	e9 64 f5 ff ff       	jmp    80106340 <alltraps>

80106ddc <vector124>:
.globl vector124
vector124:
  pushl $0
80106ddc:	6a 00                	push   $0x0
  pushl $124
80106dde:	6a 7c                	push   $0x7c
  jmp alltraps
80106de0:	e9 5b f5 ff ff       	jmp    80106340 <alltraps>

80106de5 <vector125>:
.globl vector125
vector125:
  pushl $0
80106de5:	6a 00                	push   $0x0
  pushl $125
80106de7:	6a 7d                	push   $0x7d
  jmp alltraps
80106de9:	e9 52 f5 ff ff       	jmp    80106340 <alltraps>

80106dee <vector126>:
.globl vector126
vector126:
  pushl $0
80106dee:	6a 00                	push   $0x0
  pushl $126
80106df0:	6a 7e                	push   $0x7e
  jmp alltraps
80106df2:	e9 49 f5 ff ff       	jmp    80106340 <alltraps>

80106df7 <vector127>:
.globl vector127
vector127:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $127
80106df9:	6a 7f                	push   $0x7f
  jmp alltraps
80106dfb:	e9 40 f5 ff ff       	jmp    80106340 <alltraps>

80106e00 <vector128>:
.globl vector128
vector128:
  pushl $0
80106e00:	6a 00                	push   $0x0
  pushl $128
80106e02:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106e07:	e9 34 f5 ff ff       	jmp    80106340 <alltraps>

80106e0c <vector129>:
.globl vector129
vector129:
  pushl $0
80106e0c:	6a 00                	push   $0x0
  pushl $129
80106e0e:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106e13:	e9 28 f5 ff ff       	jmp    80106340 <alltraps>

80106e18 <vector130>:
.globl vector130
vector130:
  pushl $0
80106e18:	6a 00                	push   $0x0
  pushl $130
80106e1a:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106e1f:	e9 1c f5 ff ff       	jmp    80106340 <alltraps>

80106e24 <vector131>:
.globl vector131
vector131:
  pushl $0
80106e24:	6a 00                	push   $0x0
  pushl $131
80106e26:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106e2b:	e9 10 f5 ff ff       	jmp    80106340 <alltraps>

80106e30 <vector132>:
.globl vector132
vector132:
  pushl $0
80106e30:	6a 00                	push   $0x0
  pushl $132
80106e32:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106e37:	e9 04 f5 ff ff       	jmp    80106340 <alltraps>

80106e3c <vector133>:
.globl vector133
vector133:
  pushl $0
80106e3c:	6a 00                	push   $0x0
  pushl $133
80106e3e:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106e43:	e9 f8 f4 ff ff       	jmp    80106340 <alltraps>

80106e48 <vector134>:
.globl vector134
vector134:
  pushl $0
80106e48:	6a 00                	push   $0x0
  pushl $134
80106e4a:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106e4f:	e9 ec f4 ff ff       	jmp    80106340 <alltraps>

80106e54 <vector135>:
.globl vector135
vector135:
  pushl $0
80106e54:	6a 00                	push   $0x0
  pushl $135
80106e56:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106e5b:	e9 e0 f4 ff ff       	jmp    80106340 <alltraps>

80106e60 <vector136>:
.globl vector136
vector136:
  pushl $0
80106e60:	6a 00                	push   $0x0
  pushl $136
80106e62:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106e67:	e9 d4 f4 ff ff       	jmp    80106340 <alltraps>

80106e6c <vector137>:
.globl vector137
vector137:
  pushl $0
80106e6c:	6a 00                	push   $0x0
  pushl $137
80106e6e:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106e73:	e9 c8 f4 ff ff       	jmp    80106340 <alltraps>

80106e78 <vector138>:
.globl vector138
vector138:
  pushl $0
80106e78:	6a 00                	push   $0x0
  pushl $138
80106e7a:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106e7f:	e9 bc f4 ff ff       	jmp    80106340 <alltraps>

80106e84 <vector139>:
.globl vector139
vector139:
  pushl $0
80106e84:	6a 00                	push   $0x0
  pushl $139
80106e86:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106e8b:	e9 b0 f4 ff ff       	jmp    80106340 <alltraps>

80106e90 <vector140>:
.globl vector140
vector140:
  pushl $0
80106e90:	6a 00                	push   $0x0
  pushl $140
80106e92:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106e97:	e9 a4 f4 ff ff       	jmp    80106340 <alltraps>

80106e9c <vector141>:
.globl vector141
vector141:
  pushl $0
80106e9c:	6a 00                	push   $0x0
  pushl $141
80106e9e:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106ea3:	e9 98 f4 ff ff       	jmp    80106340 <alltraps>

80106ea8 <vector142>:
.globl vector142
vector142:
  pushl $0
80106ea8:	6a 00                	push   $0x0
  pushl $142
80106eaa:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106eaf:	e9 8c f4 ff ff       	jmp    80106340 <alltraps>

80106eb4 <vector143>:
.globl vector143
vector143:
  pushl $0
80106eb4:	6a 00                	push   $0x0
  pushl $143
80106eb6:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106ebb:	e9 80 f4 ff ff       	jmp    80106340 <alltraps>

80106ec0 <vector144>:
.globl vector144
vector144:
  pushl $0
80106ec0:	6a 00                	push   $0x0
  pushl $144
80106ec2:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106ec7:	e9 74 f4 ff ff       	jmp    80106340 <alltraps>

80106ecc <vector145>:
.globl vector145
vector145:
  pushl $0
80106ecc:	6a 00                	push   $0x0
  pushl $145
80106ece:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106ed3:	e9 68 f4 ff ff       	jmp    80106340 <alltraps>

80106ed8 <vector146>:
.globl vector146
vector146:
  pushl $0
80106ed8:	6a 00                	push   $0x0
  pushl $146
80106eda:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106edf:	e9 5c f4 ff ff       	jmp    80106340 <alltraps>

80106ee4 <vector147>:
.globl vector147
vector147:
  pushl $0
80106ee4:	6a 00                	push   $0x0
  pushl $147
80106ee6:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106eeb:	e9 50 f4 ff ff       	jmp    80106340 <alltraps>

80106ef0 <vector148>:
.globl vector148
vector148:
  pushl $0
80106ef0:	6a 00                	push   $0x0
  pushl $148
80106ef2:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106ef7:	e9 44 f4 ff ff       	jmp    80106340 <alltraps>

80106efc <vector149>:
.globl vector149
vector149:
  pushl $0
80106efc:	6a 00                	push   $0x0
  pushl $149
80106efe:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106f03:	e9 38 f4 ff ff       	jmp    80106340 <alltraps>

80106f08 <vector150>:
.globl vector150
vector150:
  pushl $0
80106f08:	6a 00                	push   $0x0
  pushl $150
80106f0a:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106f0f:	e9 2c f4 ff ff       	jmp    80106340 <alltraps>

80106f14 <vector151>:
.globl vector151
vector151:
  pushl $0
80106f14:	6a 00                	push   $0x0
  pushl $151
80106f16:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106f1b:	e9 20 f4 ff ff       	jmp    80106340 <alltraps>

80106f20 <vector152>:
.globl vector152
vector152:
  pushl $0
80106f20:	6a 00                	push   $0x0
  pushl $152
80106f22:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106f27:	e9 14 f4 ff ff       	jmp    80106340 <alltraps>

80106f2c <vector153>:
.globl vector153
vector153:
  pushl $0
80106f2c:	6a 00                	push   $0x0
  pushl $153
80106f2e:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106f33:	e9 08 f4 ff ff       	jmp    80106340 <alltraps>

80106f38 <vector154>:
.globl vector154
vector154:
  pushl $0
80106f38:	6a 00                	push   $0x0
  pushl $154
80106f3a:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106f3f:	e9 fc f3 ff ff       	jmp    80106340 <alltraps>

80106f44 <vector155>:
.globl vector155
vector155:
  pushl $0
80106f44:	6a 00                	push   $0x0
  pushl $155
80106f46:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106f4b:	e9 f0 f3 ff ff       	jmp    80106340 <alltraps>

80106f50 <vector156>:
.globl vector156
vector156:
  pushl $0
80106f50:	6a 00                	push   $0x0
  pushl $156
80106f52:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106f57:	e9 e4 f3 ff ff       	jmp    80106340 <alltraps>

80106f5c <vector157>:
.globl vector157
vector157:
  pushl $0
80106f5c:	6a 00                	push   $0x0
  pushl $157
80106f5e:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106f63:	e9 d8 f3 ff ff       	jmp    80106340 <alltraps>

80106f68 <vector158>:
.globl vector158
vector158:
  pushl $0
80106f68:	6a 00                	push   $0x0
  pushl $158
80106f6a:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106f6f:	e9 cc f3 ff ff       	jmp    80106340 <alltraps>

80106f74 <vector159>:
.globl vector159
vector159:
  pushl $0
80106f74:	6a 00                	push   $0x0
  pushl $159
80106f76:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106f7b:	e9 c0 f3 ff ff       	jmp    80106340 <alltraps>

80106f80 <vector160>:
.globl vector160
vector160:
  pushl $0
80106f80:	6a 00                	push   $0x0
  pushl $160
80106f82:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106f87:	e9 b4 f3 ff ff       	jmp    80106340 <alltraps>

80106f8c <vector161>:
.globl vector161
vector161:
  pushl $0
80106f8c:	6a 00                	push   $0x0
  pushl $161
80106f8e:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106f93:	e9 a8 f3 ff ff       	jmp    80106340 <alltraps>

80106f98 <vector162>:
.globl vector162
vector162:
  pushl $0
80106f98:	6a 00                	push   $0x0
  pushl $162
80106f9a:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106f9f:	e9 9c f3 ff ff       	jmp    80106340 <alltraps>

80106fa4 <vector163>:
.globl vector163
vector163:
  pushl $0
80106fa4:	6a 00                	push   $0x0
  pushl $163
80106fa6:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106fab:	e9 90 f3 ff ff       	jmp    80106340 <alltraps>

80106fb0 <vector164>:
.globl vector164
vector164:
  pushl $0
80106fb0:	6a 00                	push   $0x0
  pushl $164
80106fb2:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106fb7:	e9 84 f3 ff ff       	jmp    80106340 <alltraps>

80106fbc <vector165>:
.globl vector165
vector165:
  pushl $0
80106fbc:	6a 00                	push   $0x0
  pushl $165
80106fbe:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106fc3:	e9 78 f3 ff ff       	jmp    80106340 <alltraps>

80106fc8 <vector166>:
.globl vector166
vector166:
  pushl $0
80106fc8:	6a 00                	push   $0x0
  pushl $166
80106fca:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106fcf:	e9 6c f3 ff ff       	jmp    80106340 <alltraps>

80106fd4 <vector167>:
.globl vector167
vector167:
  pushl $0
80106fd4:	6a 00                	push   $0x0
  pushl $167
80106fd6:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106fdb:	e9 60 f3 ff ff       	jmp    80106340 <alltraps>

80106fe0 <vector168>:
.globl vector168
vector168:
  pushl $0
80106fe0:	6a 00                	push   $0x0
  pushl $168
80106fe2:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106fe7:	e9 54 f3 ff ff       	jmp    80106340 <alltraps>

80106fec <vector169>:
.globl vector169
vector169:
  pushl $0
80106fec:	6a 00                	push   $0x0
  pushl $169
80106fee:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106ff3:	e9 48 f3 ff ff       	jmp    80106340 <alltraps>

80106ff8 <vector170>:
.globl vector170
vector170:
  pushl $0
80106ff8:	6a 00                	push   $0x0
  pushl $170
80106ffa:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106fff:	e9 3c f3 ff ff       	jmp    80106340 <alltraps>

80107004 <vector171>:
.globl vector171
vector171:
  pushl $0
80107004:	6a 00                	push   $0x0
  pushl $171
80107006:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
8010700b:	e9 30 f3 ff ff       	jmp    80106340 <alltraps>

80107010 <vector172>:
.globl vector172
vector172:
  pushl $0
80107010:	6a 00                	push   $0x0
  pushl $172
80107012:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107017:	e9 24 f3 ff ff       	jmp    80106340 <alltraps>

8010701c <vector173>:
.globl vector173
vector173:
  pushl $0
8010701c:	6a 00                	push   $0x0
  pushl $173
8010701e:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107023:	e9 18 f3 ff ff       	jmp    80106340 <alltraps>

80107028 <vector174>:
.globl vector174
vector174:
  pushl $0
80107028:	6a 00                	push   $0x0
  pushl $174
8010702a:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010702f:	e9 0c f3 ff ff       	jmp    80106340 <alltraps>

80107034 <vector175>:
.globl vector175
vector175:
  pushl $0
80107034:	6a 00                	push   $0x0
  pushl $175
80107036:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
8010703b:	e9 00 f3 ff ff       	jmp    80106340 <alltraps>

80107040 <vector176>:
.globl vector176
vector176:
  pushl $0
80107040:	6a 00                	push   $0x0
  pushl $176
80107042:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107047:	e9 f4 f2 ff ff       	jmp    80106340 <alltraps>

8010704c <vector177>:
.globl vector177
vector177:
  pushl $0
8010704c:	6a 00                	push   $0x0
  pushl $177
8010704e:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107053:	e9 e8 f2 ff ff       	jmp    80106340 <alltraps>

80107058 <vector178>:
.globl vector178
vector178:
  pushl $0
80107058:	6a 00                	push   $0x0
  pushl $178
8010705a:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010705f:	e9 dc f2 ff ff       	jmp    80106340 <alltraps>

80107064 <vector179>:
.globl vector179
vector179:
  pushl $0
80107064:	6a 00                	push   $0x0
  pushl $179
80107066:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
8010706b:	e9 d0 f2 ff ff       	jmp    80106340 <alltraps>

80107070 <vector180>:
.globl vector180
vector180:
  pushl $0
80107070:	6a 00                	push   $0x0
  pushl $180
80107072:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107077:	e9 c4 f2 ff ff       	jmp    80106340 <alltraps>

8010707c <vector181>:
.globl vector181
vector181:
  pushl $0
8010707c:	6a 00                	push   $0x0
  pushl $181
8010707e:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107083:	e9 b8 f2 ff ff       	jmp    80106340 <alltraps>

80107088 <vector182>:
.globl vector182
vector182:
  pushl $0
80107088:	6a 00                	push   $0x0
  pushl $182
8010708a:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010708f:	e9 ac f2 ff ff       	jmp    80106340 <alltraps>

80107094 <vector183>:
.globl vector183
vector183:
  pushl $0
80107094:	6a 00                	push   $0x0
  pushl $183
80107096:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
8010709b:	e9 a0 f2 ff ff       	jmp    80106340 <alltraps>

801070a0 <vector184>:
.globl vector184
vector184:
  pushl $0
801070a0:	6a 00                	push   $0x0
  pushl $184
801070a2:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801070a7:	e9 94 f2 ff ff       	jmp    80106340 <alltraps>

801070ac <vector185>:
.globl vector185
vector185:
  pushl $0
801070ac:	6a 00                	push   $0x0
  pushl $185
801070ae:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801070b3:	e9 88 f2 ff ff       	jmp    80106340 <alltraps>

801070b8 <vector186>:
.globl vector186
vector186:
  pushl $0
801070b8:	6a 00                	push   $0x0
  pushl $186
801070ba:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801070bf:	e9 7c f2 ff ff       	jmp    80106340 <alltraps>

801070c4 <vector187>:
.globl vector187
vector187:
  pushl $0
801070c4:	6a 00                	push   $0x0
  pushl $187
801070c6:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801070cb:	e9 70 f2 ff ff       	jmp    80106340 <alltraps>

801070d0 <vector188>:
.globl vector188
vector188:
  pushl $0
801070d0:	6a 00                	push   $0x0
  pushl $188
801070d2:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801070d7:	e9 64 f2 ff ff       	jmp    80106340 <alltraps>

801070dc <vector189>:
.globl vector189
vector189:
  pushl $0
801070dc:	6a 00                	push   $0x0
  pushl $189
801070de:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801070e3:	e9 58 f2 ff ff       	jmp    80106340 <alltraps>

801070e8 <vector190>:
.globl vector190
vector190:
  pushl $0
801070e8:	6a 00                	push   $0x0
  pushl $190
801070ea:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801070ef:	e9 4c f2 ff ff       	jmp    80106340 <alltraps>

801070f4 <vector191>:
.globl vector191
vector191:
  pushl $0
801070f4:	6a 00                	push   $0x0
  pushl $191
801070f6:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801070fb:	e9 40 f2 ff ff       	jmp    80106340 <alltraps>

80107100 <vector192>:
.globl vector192
vector192:
  pushl $0
80107100:	6a 00                	push   $0x0
  pushl $192
80107102:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107107:	e9 34 f2 ff ff       	jmp    80106340 <alltraps>

8010710c <vector193>:
.globl vector193
vector193:
  pushl $0
8010710c:	6a 00                	push   $0x0
  pushl $193
8010710e:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107113:	e9 28 f2 ff ff       	jmp    80106340 <alltraps>

80107118 <vector194>:
.globl vector194
vector194:
  pushl $0
80107118:	6a 00                	push   $0x0
  pushl $194
8010711a:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010711f:	e9 1c f2 ff ff       	jmp    80106340 <alltraps>

80107124 <vector195>:
.globl vector195
vector195:
  pushl $0
80107124:	6a 00                	push   $0x0
  pushl $195
80107126:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
8010712b:	e9 10 f2 ff ff       	jmp    80106340 <alltraps>

80107130 <vector196>:
.globl vector196
vector196:
  pushl $0
80107130:	6a 00                	push   $0x0
  pushl $196
80107132:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107137:	e9 04 f2 ff ff       	jmp    80106340 <alltraps>

8010713c <vector197>:
.globl vector197
vector197:
  pushl $0
8010713c:	6a 00                	push   $0x0
  pushl $197
8010713e:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107143:	e9 f8 f1 ff ff       	jmp    80106340 <alltraps>

80107148 <vector198>:
.globl vector198
vector198:
  pushl $0
80107148:	6a 00                	push   $0x0
  pushl $198
8010714a:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010714f:	e9 ec f1 ff ff       	jmp    80106340 <alltraps>

80107154 <vector199>:
.globl vector199
vector199:
  pushl $0
80107154:	6a 00                	push   $0x0
  pushl $199
80107156:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
8010715b:	e9 e0 f1 ff ff       	jmp    80106340 <alltraps>

80107160 <vector200>:
.globl vector200
vector200:
  pushl $0
80107160:	6a 00                	push   $0x0
  pushl $200
80107162:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107167:	e9 d4 f1 ff ff       	jmp    80106340 <alltraps>

8010716c <vector201>:
.globl vector201
vector201:
  pushl $0
8010716c:	6a 00                	push   $0x0
  pushl $201
8010716e:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107173:	e9 c8 f1 ff ff       	jmp    80106340 <alltraps>

80107178 <vector202>:
.globl vector202
vector202:
  pushl $0
80107178:	6a 00                	push   $0x0
  pushl $202
8010717a:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010717f:	e9 bc f1 ff ff       	jmp    80106340 <alltraps>

80107184 <vector203>:
.globl vector203
vector203:
  pushl $0
80107184:	6a 00                	push   $0x0
  pushl $203
80107186:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
8010718b:	e9 b0 f1 ff ff       	jmp    80106340 <alltraps>

80107190 <vector204>:
.globl vector204
vector204:
  pushl $0
80107190:	6a 00                	push   $0x0
  pushl $204
80107192:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107197:	e9 a4 f1 ff ff       	jmp    80106340 <alltraps>

8010719c <vector205>:
.globl vector205
vector205:
  pushl $0
8010719c:	6a 00                	push   $0x0
  pushl $205
8010719e:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801071a3:	e9 98 f1 ff ff       	jmp    80106340 <alltraps>

801071a8 <vector206>:
.globl vector206
vector206:
  pushl $0
801071a8:	6a 00                	push   $0x0
  pushl $206
801071aa:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801071af:	e9 8c f1 ff ff       	jmp    80106340 <alltraps>

801071b4 <vector207>:
.globl vector207
vector207:
  pushl $0
801071b4:	6a 00                	push   $0x0
  pushl $207
801071b6:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801071bb:	e9 80 f1 ff ff       	jmp    80106340 <alltraps>

801071c0 <vector208>:
.globl vector208
vector208:
  pushl $0
801071c0:	6a 00                	push   $0x0
  pushl $208
801071c2:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801071c7:	e9 74 f1 ff ff       	jmp    80106340 <alltraps>

801071cc <vector209>:
.globl vector209
vector209:
  pushl $0
801071cc:	6a 00                	push   $0x0
  pushl $209
801071ce:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801071d3:	e9 68 f1 ff ff       	jmp    80106340 <alltraps>

801071d8 <vector210>:
.globl vector210
vector210:
  pushl $0
801071d8:	6a 00                	push   $0x0
  pushl $210
801071da:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801071df:	e9 5c f1 ff ff       	jmp    80106340 <alltraps>

801071e4 <vector211>:
.globl vector211
vector211:
  pushl $0
801071e4:	6a 00                	push   $0x0
  pushl $211
801071e6:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801071eb:	e9 50 f1 ff ff       	jmp    80106340 <alltraps>

801071f0 <vector212>:
.globl vector212
vector212:
  pushl $0
801071f0:	6a 00                	push   $0x0
  pushl $212
801071f2:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801071f7:	e9 44 f1 ff ff       	jmp    80106340 <alltraps>

801071fc <vector213>:
.globl vector213
vector213:
  pushl $0
801071fc:	6a 00                	push   $0x0
  pushl $213
801071fe:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107203:	e9 38 f1 ff ff       	jmp    80106340 <alltraps>

80107208 <vector214>:
.globl vector214
vector214:
  pushl $0
80107208:	6a 00                	push   $0x0
  pushl $214
8010720a:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010720f:	e9 2c f1 ff ff       	jmp    80106340 <alltraps>

80107214 <vector215>:
.globl vector215
vector215:
  pushl $0
80107214:	6a 00                	push   $0x0
  pushl $215
80107216:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
8010721b:	e9 20 f1 ff ff       	jmp    80106340 <alltraps>

80107220 <vector216>:
.globl vector216
vector216:
  pushl $0
80107220:	6a 00                	push   $0x0
  pushl $216
80107222:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107227:	e9 14 f1 ff ff       	jmp    80106340 <alltraps>

8010722c <vector217>:
.globl vector217
vector217:
  pushl $0
8010722c:	6a 00                	push   $0x0
  pushl $217
8010722e:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107233:	e9 08 f1 ff ff       	jmp    80106340 <alltraps>

80107238 <vector218>:
.globl vector218
vector218:
  pushl $0
80107238:	6a 00                	push   $0x0
  pushl $218
8010723a:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010723f:	e9 fc f0 ff ff       	jmp    80106340 <alltraps>

80107244 <vector219>:
.globl vector219
vector219:
  pushl $0
80107244:	6a 00                	push   $0x0
  pushl $219
80107246:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
8010724b:	e9 f0 f0 ff ff       	jmp    80106340 <alltraps>

80107250 <vector220>:
.globl vector220
vector220:
  pushl $0
80107250:	6a 00                	push   $0x0
  pushl $220
80107252:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107257:	e9 e4 f0 ff ff       	jmp    80106340 <alltraps>

8010725c <vector221>:
.globl vector221
vector221:
  pushl $0
8010725c:	6a 00                	push   $0x0
  pushl $221
8010725e:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107263:	e9 d8 f0 ff ff       	jmp    80106340 <alltraps>

80107268 <vector222>:
.globl vector222
vector222:
  pushl $0
80107268:	6a 00                	push   $0x0
  pushl $222
8010726a:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010726f:	e9 cc f0 ff ff       	jmp    80106340 <alltraps>

80107274 <vector223>:
.globl vector223
vector223:
  pushl $0
80107274:	6a 00                	push   $0x0
  pushl $223
80107276:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
8010727b:	e9 c0 f0 ff ff       	jmp    80106340 <alltraps>

80107280 <vector224>:
.globl vector224
vector224:
  pushl $0
80107280:	6a 00                	push   $0x0
  pushl $224
80107282:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107287:	e9 b4 f0 ff ff       	jmp    80106340 <alltraps>

8010728c <vector225>:
.globl vector225
vector225:
  pushl $0
8010728c:	6a 00                	push   $0x0
  pushl $225
8010728e:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107293:	e9 a8 f0 ff ff       	jmp    80106340 <alltraps>

80107298 <vector226>:
.globl vector226
vector226:
  pushl $0
80107298:	6a 00                	push   $0x0
  pushl $226
8010729a:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010729f:	e9 9c f0 ff ff       	jmp    80106340 <alltraps>

801072a4 <vector227>:
.globl vector227
vector227:
  pushl $0
801072a4:	6a 00                	push   $0x0
  pushl $227
801072a6:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801072ab:	e9 90 f0 ff ff       	jmp    80106340 <alltraps>

801072b0 <vector228>:
.globl vector228
vector228:
  pushl $0
801072b0:	6a 00                	push   $0x0
  pushl $228
801072b2:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801072b7:	e9 84 f0 ff ff       	jmp    80106340 <alltraps>

801072bc <vector229>:
.globl vector229
vector229:
  pushl $0
801072bc:	6a 00                	push   $0x0
  pushl $229
801072be:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801072c3:	e9 78 f0 ff ff       	jmp    80106340 <alltraps>

801072c8 <vector230>:
.globl vector230
vector230:
  pushl $0
801072c8:	6a 00                	push   $0x0
  pushl $230
801072ca:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801072cf:	e9 6c f0 ff ff       	jmp    80106340 <alltraps>

801072d4 <vector231>:
.globl vector231
vector231:
  pushl $0
801072d4:	6a 00                	push   $0x0
  pushl $231
801072d6:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801072db:	e9 60 f0 ff ff       	jmp    80106340 <alltraps>

801072e0 <vector232>:
.globl vector232
vector232:
  pushl $0
801072e0:	6a 00                	push   $0x0
  pushl $232
801072e2:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801072e7:	e9 54 f0 ff ff       	jmp    80106340 <alltraps>

801072ec <vector233>:
.globl vector233
vector233:
  pushl $0
801072ec:	6a 00                	push   $0x0
  pushl $233
801072ee:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801072f3:	e9 48 f0 ff ff       	jmp    80106340 <alltraps>

801072f8 <vector234>:
.globl vector234
vector234:
  pushl $0
801072f8:	6a 00                	push   $0x0
  pushl $234
801072fa:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801072ff:	e9 3c f0 ff ff       	jmp    80106340 <alltraps>

80107304 <vector235>:
.globl vector235
vector235:
  pushl $0
80107304:	6a 00                	push   $0x0
  pushl $235
80107306:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
8010730b:	e9 30 f0 ff ff       	jmp    80106340 <alltraps>

80107310 <vector236>:
.globl vector236
vector236:
  pushl $0
80107310:	6a 00                	push   $0x0
  pushl $236
80107312:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107317:	e9 24 f0 ff ff       	jmp    80106340 <alltraps>

8010731c <vector237>:
.globl vector237
vector237:
  pushl $0
8010731c:	6a 00                	push   $0x0
  pushl $237
8010731e:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107323:	e9 18 f0 ff ff       	jmp    80106340 <alltraps>

80107328 <vector238>:
.globl vector238
vector238:
  pushl $0
80107328:	6a 00                	push   $0x0
  pushl $238
8010732a:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010732f:	e9 0c f0 ff ff       	jmp    80106340 <alltraps>

80107334 <vector239>:
.globl vector239
vector239:
  pushl $0
80107334:	6a 00                	push   $0x0
  pushl $239
80107336:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
8010733b:	e9 00 f0 ff ff       	jmp    80106340 <alltraps>

80107340 <vector240>:
.globl vector240
vector240:
  pushl $0
80107340:	6a 00                	push   $0x0
  pushl $240
80107342:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107347:	e9 f4 ef ff ff       	jmp    80106340 <alltraps>

8010734c <vector241>:
.globl vector241
vector241:
  pushl $0
8010734c:	6a 00                	push   $0x0
  pushl $241
8010734e:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107353:	e9 e8 ef ff ff       	jmp    80106340 <alltraps>

80107358 <vector242>:
.globl vector242
vector242:
  pushl $0
80107358:	6a 00                	push   $0x0
  pushl $242
8010735a:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010735f:	e9 dc ef ff ff       	jmp    80106340 <alltraps>

80107364 <vector243>:
.globl vector243
vector243:
  pushl $0
80107364:	6a 00                	push   $0x0
  pushl $243
80107366:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
8010736b:	e9 d0 ef ff ff       	jmp    80106340 <alltraps>

80107370 <vector244>:
.globl vector244
vector244:
  pushl $0
80107370:	6a 00                	push   $0x0
  pushl $244
80107372:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107377:	e9 c4 ef ff ff       	jmp    80106340 <alltraps>

8010737c <vector245>:
.globl vector245
vector245:
  pushl $0
8010737c:	6a 00                	push   $0x0
  pushl $245
8010737e:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107383:	e9 b8 ef ff ff       	jmp    80106340 <alltraps>

80107388 <vector246>:
.globl vector246
vector246:
  pushl $0
80107388:	6a 00                	push   $0x0
  pushl $246
8010738a:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010738f:	e9 ac ef ff ff       	jmp    80106340 <alltraps>

80107394 <vector247>:
.globl vector247
vector247:
  pushl $0
80107394:	6a 00                	push   $0x0
  pushl $247
80107396:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
8010739b:	e9 a0 ef ff ff       	jmp    80106340 <alltraps>

801073a0 <vector248>:
.globl vector248
vector248:
  pushl $0
801073a0:	6a 00                	push   $0x0
  pushl $248
801073a2:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801073a7:	e9 94 ef ff ff       	jmp    80106340 <alltraps>

801073ac <vector249>:
.globl vector249
vector249:
  pushl $0
801073ac:	6a 00                	push   $0x0
  pushl $249
801073ae:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801073b3:	e9 88 ef ff ff       	jmp    80106340 <alltraps>

801073b8 <vector250>:
.globl vector250
vector250:
  pushl $0
801073b8:	6a 00                	push   $0x0
  pushl $250
801073ba:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801073bf:	e9 7c ef ff ff       	jmp    80106340 <alltraps>

801073c4 <vector251>:
.globl vector251
vector251:
  pushl $0
801073c4:	6a 00                	push   $0x0
  pushl $251
801073c6:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801073cb:	e9 70 ef ff ff       	jmp    80106340 <alltraps>

801073d0 <vector252>:
.globl vector252
vector252:
  pushl $0
801073d0:	6a 00                	push   $0x0
  pushl $252
801073d2:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801073d7:	e9 64 ef ff ff       	jmp    80106340 <alltraps>

801073dc <vector253>:
.globl vector253
vector253:
  pushl $0
801073dc:	6a 00                	push   $0x0
  pushl $253
801073de:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801073e3:	e9 58 ef ff ff       	jmp    80106340 <alltraps>

801073e8 <vector254>:
.globl vector254
vector254:
  pushl $0
801073e8:	6a 00                	push   $0x0
  pushl $254
801073ea:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801073ef:	e9 4c ef ff ff       	jmp    80106340 <alltraps>

801073f4 <vector255>:
.globl vector255
vector255:
  pushl $0
801073f4:	6a 00                	push   $0x0
  pushl $255
801073f6:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801073fb:	e9 40 ef ff ff       	jmp    80106340 <alltraps>

80107400 <lgdt>:
{
80107400:	55                   	push   %ebp
80107401:	89 e5                	mov    %esp,%ebp
80107403:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107406:	8b 45 0c             	mov    0xc(%ebp),%eax
80107409:	83 e8 01             	sub    $0x1,%eax
8010740c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107410:	8b 45 08             	mov    0x8(%ebp),%eax
80107413:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107417:	8b 45 08             	mov    0x8(%ebp),%eax
8010741a:	c1 e8 10             	shr    $0x10,%eax
8010741d:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107421:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107424:	0f 01 10             	lgdtl  (%eax)
}
80107427:	c9                   	leave  
80107428:	c3                   	ret    

80107429 <ltr>:
{
80107429:	55                   	push   %ebp
8010742a:	89 e5                	mov    %esp,%ebp
8010742c:	83 ec 04             	sub    $0x4,%esp
8010742f:	8b 45 08             	mov    0x8(%ebp),%eax
80107432:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107436:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010743a:	0f 00 d8             	ltr    %ax
}
8010743d:	c9                   	leave  
8010743e:	c3                   	ret    

8010743f <lcr3>:

static inline void
lcr3(uint val)
{
8010743f:	55                   	push   %ebp
80107440:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107442:	8b 45 08             	mov    0x8(%ebp),%eax
80107445:	0f 22 d8             	mov    %eax,%cr3
}
80107448:	5d                   	pop    %ebp
80107449:	c3                   	ret    

8010744a <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
8010744a:	55                   	push   %ebp
8010744b:	89 e5                	mov    %esp,%ebp
8010744d:	83 ec 28             	sub    $0x28,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107450:	e8 51 cc ff ff       	call   801040a6 <cpuid>
80107455:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010745b:	05 00 38 11 80       	add    $0x80113800,%eax
80107460:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107463:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107466:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
8010746c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010746f:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107475:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107478:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010747c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010747f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107483:	83 e2 f0             	and    $0xfffffff0,%edx
80107486:	83 ca 0a             	or     $0xa,%edx
80107489:	88 50 7d             	mov    %dl,0x7d(%eax)
8010748c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010748f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107493:	83 ca 10             	or     $0x10,%edx
80107496:	88 50 7d             	mov    %dl,0x7d(%eax)
80107499:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010749c:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801074a0:	83 e2 9f             	and    $0xffffff9f,%edx
801074a3:	88 50 7d             	mov    %dl,0x7d(%eax)
801074a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074a9:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801074ad:	83 ca 80             	or     $0xffffff80,%edx
801074b0:	88 50 7d             	mov    %dl,0x7d(%eax)
801074b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074b6:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801074ba:	83 ca 0f             	or     $0xf,%edx
801074bd:	88 50 7e             	mov    %dl,0x7e(%eax)
801074c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074c3:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801074c7:	83 e2 ef             	and    $0xffffffef,%edx
801074ca:	88 50 7e             	mov    %dl,0x7e(%eax)
801074cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074d0:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801074d4:	83 e2 df             	and    $0xffffffdf,%edx
801074d7:	88 50 7e             	mov    %dl,0x7e(%eax)
801074da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074dd:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801074e1:	83 ca 40             	or     $0x40,%edx
801074e4:	88 50 7e             	mov    %dl,0x7e(%eax)
801074e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074ea:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801074ee:	83 ca 80             	or     $0xffffff80,%edx
801074f1:	88 50 7e             	mov    %dl,0x7e(%eax)
801074f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074f7:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801074fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074fe:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107505:	ff ff 
80107507:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010750a:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107511:	00 00 
80107513:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107516:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
8010751d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107520:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107527:	83 e2 f0             	and    $0xfffffff0,%edx
8010752a:	83 ca 02             	or     $0x2,%edx
8010752d:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107533:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107536:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010753d:	83 ca 10             	or     $0x10,%edx
80107540:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107546:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107549:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107550:	83 e2 9f             	and    $0xffffff9f,%edx
80107553:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107559:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010755c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107563:	83 ca 80             	or     $0xffffff80,%edx
80107566:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010756c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010756f:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107576:	83 ca 0f             	or     $0xf,%edx
80107579:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010757f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107582:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107589:	83 e2 ef             	and    $0xffffffef,%edx
8010758c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107592:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107595:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010759c:	83 e2 df             	and    $0xffffffdf,%edx
8010759f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801075a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075a8:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801075af:	83 ca 40             	or     $0x40,%edx
801075b2:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801075b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075bb:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801075c2:	83 ca 80             	or     $0xffffff80,%edx
801075c5:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801075cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075ce:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801075d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075d8:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
801075df:	ff ff 
801075e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075e4:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
801075eb:	00 00 
801075ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075f0:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
801075f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075fa:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107601:	83 e2 f0             	and    $0xfffffff0,%edx
80107604:	83 ca 0a             	or     $0xa,%edx
80107607:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010760d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107610:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107617:	83 ca 10             	or     $0x10,%edx
8010761a:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107620:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107623:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010762a:	83 ca 60             	or     $0x60,%edx
8010762d:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107633:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107636:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010763d:	83 ca 80             	or     $0xffffff80,%edx
80107640:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107646:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107649:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107650:	83 ca 0f             	or     $0xf,%edx
80107653:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107659:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010765c:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107663:	83 e2 ef             	and    $0xffffffef,%edx
80107666:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010766c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010766f:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107676:	83 e2 df             	and    $0xffffffdf,%edx
80107679:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010767f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107682:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107689:	83 ca 40             	or     $0x40,%edx
8010768c:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107692:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107695:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010769c:	83 ca 80             	or     $0xffffff80,%edx
8010769f:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801076a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076a8:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801076af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b2:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801076b9:	ff ff 
801076bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076be:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801076c5:	00 00 
801076c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ca:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801076d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076d4:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801076db:	83 e2 f0             	and    $0xfffffff0,%edx
801076de:	83 ca 02             	or     $0x2,%edx
801076e1:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801076e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ea:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801076f1:	83 ca 10             	or     $0x10,%edx
801076f4:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801076fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076fd:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107704:	83 ca 60             	or     $0x60,%edx
80107707:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010770d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107710:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107717:	83 ca 80             	or     $0xffffff80,%edx
8010771a:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107720:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107723:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010772a:	83 ca 0f             	or     $0xf,%edx
8010772d:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107733:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107736:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010773d:	83 e2 ef             	and    $0xffffffef,%edx
80107740:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107746:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107749:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107750:	83 e2 df             	and    $0xffffffdf,%edx
80107753:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107759:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010775c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107763:	83 ca 40             	or     $0x40,%edx
80107766:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010776c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010776f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107776:	83 ca 80             	or     $0xffffff80,%edx
80107779:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010777f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107782:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80107789:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010778c:	83 c0 70             	add    $0x70,%eax
8010778f:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
80107796:	00 
80107797:	89 04 24             	mov    %eax,(%esp)
8010779a:	e8 61 fc ff ff       	call   80107400 <lgdt>
}
8010779f:	c9                   	leave  
801077a0:	c3                   	ret    

801077a1 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801077a1:	55                   	push   %ebp
801077a2:	89 e5                	mov    %esp,%ebp
801077a4:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801077a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801077aa:	c1 e8 16             	shr    $0x16,%eax
801077ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801077b4:	8b 45 08             	mov    0x8(%ebp),%eax
801077b7:	01 d0                	add    %edx,%eax
801077b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801077bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077bf:	8b 00                	mov    (%eax),%eax
801077c1:	83 e0 01             	and    $0x1,%eax
801077c4:	85 c0                	test   %eax,%eax
801077c6:	74 14                	je     801077dc <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801077c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077cb:	8b 00                	mov    (%eax),%eax
801077cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801077d2:	05 00 00 00 80       	add    $0x80000000,%eax
801077d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801077da:	eb 48                	jmp    80107824 <walkpgdir+0x83>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801077dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801077e0:	74 0e                	je     801077f0 <walkpgdir+0x4f>
801077e2:	e8 99 b3 ff ff       	call   80102b80 <kalloc>
801077e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801077ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801077ee:	75 07                	jne    801077f7 <walkpgdir+0x56>
      return 0;
801077f0:	b8 00 00 00 00       	mov    $0x0,%eax
801077f5:	eb 44                	jmp    8010783b <walkpgdir+0x9a>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801077f7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801077fe:	00 
801077ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107806:	00 
80107807:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010780a:	89 04 24             	mov    %eax,(%esp)
8010780d:	e8 a7 d7 ff ff       	call   80104fb9 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107812:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107815:	05 00 00 00 80       	add    $0x80000000,%eax
8010781a:	83 c8 07             	or     $0x7,%eax
8010781d:	89 c2                	mov    %eax,%edx
8010781f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107822:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107824:	8b 45 0c             	mov    0xc(%ebp),%eax
80107827:	c1 e8 0c             	shr    $0xc,%eax
8010782a:	25 ff 03 00 00       	and    $0x3ff,%eax
8010782f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107836:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107839:	01 d0                	add    %edx,%eax
}
8010783b:	c9                   	leave  
8010783c:	c3                   	ret    

8010783d <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010783d:	55                   	push   %ebp
8010783e:	89 e5                	mov    %esp,%ebp
80107840:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107843:	8b 45 0c             	mov    0xc(%ebp),%eax
80107846:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010784b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010784e:	8b 55 0c             	mov    0xc(%ebp),%edx
80107851:	8b 45 10             	mov    0x10(%ebp),%eax
80107854:	01 d0                	add    %edx,%eax
80107856:	83 e8 01             	sub    $0x1,%eax
80107859:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010785e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107861:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107868:	00 
80107869:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010786c:	89 44 24 04          	mov    %eax,0x4(%esp)
80107870:	8b 45 08             	mov    0x8(%ebp),%eax
80107873:	89 04 24             	mov    %eax,(%esp)
80107876:	e8 26 ff ff ff       	call   801077a1 <walkpgdir>
8010787b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010787e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107882:	75 07                	jne    8010788b <mappages+0x4e>
      return -1;
80107884:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107889:	eb 48                	jmp    801078d3 <mappages+0x96>
    if(*pte & PTE_P)
8010788b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010788e:	8b 00                	mov    (%eax),%eax
80107890:	83 e0 01             	and    $0x1,%eax
80107893:	85 c0                	test   %eax,%eax
80107895:	74 0c                	je     801078a3 <mappages+0x66>
      panic("remap");
80107897:	c7 04 24 44 89 10 80 	movl   $0x80108944,(%esp)
8010789e:	e8 bf 8c ff ff       	call   80100562 <panic>
    *pte = pa | perm | PTE_P;
801078a3:	8b 45 18             	mov    0x18(%ebp),%eax
801078a6:	0b 45 14             	or     0x14(%ebp),%eax
801078a9:	83 c8 01             	or     $0x1,%eax
801078ac:	89 c2                	mov    %eax,%edx
801078ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
801078b1:	89 10                	mov    %edx,(%eax)
    if(a == last)
801078b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078b6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801078b9:	75 08                	jne    801078c3 <mappages+0x86>
      break;
801078bb:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801078bc:	b8 00 00 00 00       	mov    $0x0,%eax
801078c1:	eb 10                	jmp    801078d3 <mappages+0x96>
    a += PGSIZE;
801078c3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801078ca:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801078d1:	eb 8e                	jmp    80107861 <mappages+0x24>
}
801078d3:	c9                   	leave  
801078d4:	c3                   	ret    

801078d5 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801078d5:	55                   	push   %ebp
801078d6:	89 e5                	mov    %esp,%ebp
801078d8:	53                   	push   %ebx
801078d9:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801078dc:	e8 9f b2 ff ff       	call   80102b80 <kalloc>
801078e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801078e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801078e8:	75 0a                	jne    801078f4 <setupkvm+0x1f>
    return 0;
801078ea:	b8 00 00 00 00       	mov    $0x0,%eax
801078ef:	e9 84 00 00 00       	jmp    80107978 <setupkvm+0xa3>
  memset(pgdir, 0, PGSIZE);
801078f4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801078fb:	00 
801078fc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107903:	00 
80107904:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107907:	89 04 24             	mov    %eax,(%esp)
8010790a:	e8 aa d6 ff ff       	call   80104fb9 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010790f:	c7 45 f4 80 b4 10 80 	movl   $0x8010b480,-0xc(%ebp)
80107916:	eb 54                	jmp    8010796c <setupkvm+0x97>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107918:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010791b:	8b 48 0c             	mov    0xc(%eax),%ecx
8010791e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107921:	8b 50 04             	mov    0x4(%eax),%edx
80107924:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107927:	8b 58 08             	mov    0x8(%eax),%ebx
8010792a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010792d:	8b 40 04             	mov    0x4(%eax),%eax
80107930:	29 c3                	sub    %eax,%ebx
80107932:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107935:	8b 00                	mov    (%eax),%eax
80107937:	89 4c 24 10          	mov    %ecx,0x10(%esp)
8010793b:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010793f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107943:	89 44 24 04          	mov    %eax,0x4(%esp)
80107947:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010794a:	89 04 24             	mov    %eax,(%esp)
8010794d:	e8 eb fe ff ff       	call   8010783d <mappages>
80107952:	85 c0                	test   %eax,%eax
80107954:	79 12                	jns    80107968 <setupkvm+0x93>
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107956:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107959:	89 04 24             	mov    %eax,(%esp)
8010795c:	e8 26 05 00 00       	call   80107e87 <freevm>
      return 0;
80107961:	b8 00 00 00 00       	mov    $0x0,%eax
80107966:	eb 10                	jmp    80107978 <setupkvm+0xa3>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107968:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010796c:	81 7d f4 c0 b4 10 80 	cmpl   $0x8010b4c0,-0xc(%ebp)
80107973:	72 a3                	jb     80107918 <setupkvm+0x43>
    }
  return pgdir;
80107975:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107978:	83 c4 34             	add    $0x34,%esp
8010797b:	5b                   	pop    %ebx
8010797c:	5d                   	pop    %ebp
8010797d:	c3                   	ret    

8010797e <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010797e:	55                   	push   %ebp
8010797f:	89 e5                	mov    %esp,%ebp
80107981:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107984:	e8 4c ff ff ff       	call   801078d5 <setupkvm>
80107989:	a3 24 66 11 80       	mov    %eax,0x80116624
  switchkvm();
8010798e:	e8 02 00 00 00       	call   80107995 <switchkvm>
}
80107993:	c9                   	leave  
80107994:	c3                   	ret    

80107995 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107995:	55                   	push   %ebp
80107996:	89 e5                	mov    %esp,%ebp
80107998:	83 ec 04             	sub    $0x4,%esp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
8010799b:	a1 24 66 11 80       	mov    0x80116624,%eax
801079a0:	05 00 00 00 80       	add    $0x80000000,%eax
801079a5:	89 04 24             	mov    %eax,(%esp)
801079a8:	e8 92 fa ff ff       	call   8010743f <lcr3>
}
801079ad:	c9                   	leave  
801079ae:	c3                   	ret    

801079af <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801079af:	55                   	push   %ebp
801079b0:	89 e5                	mov    %esp,%ebp
801079b2:	57                   	push   %edi
801079b3:	56                   	push   %esi
801079b4:	53                   	push   %ebx
801079b5:	83 ec 1c             	sub    $0x1c,%esp
  if(p == 0)
801079b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801079bc:	75 0c                	jne    801079ca <switchuvm+0x1b>
    panic("switchuvm: no process");
801079be:	c7 04 24 4a 89 10 80 	movl   $0x8010894a,(%esp)
801079c5:	e8 98 8b ff ff       	call   80100562 <panic>
  if(p->kstack == 0)
801079ca:	8b 45 08             	mov    0x8(%ebp),%eax
801079cd:	8b 40 08             	mov    0x8(%eax),%eax
801079d0:	85 c0                	test   %eax,%eax
801079d2:	75 0c                	jne    801079e0 <switchuvm+0x31>
    panic("switchuvm: no kstack");
801079d4:	c7 04 24 60 89 10 80 	movl   $0x80108960,(%esp)
801079db:	e8 82 8b ff ff       	call   80100562 <panic>
  if(p->pgdir == 0)
801079e0:	8b 45 08             	mov    0x8(%ebp),%eax
801079e3:	8b 40 04             	mov    0x4(%eax),%eax
801079e6:	85 c0                	test   %eax,%eax
801079e8:	75 0c                	jne    801079f6 <switchuvm+0x47>
    panic("switchuvm: no pgdir");
801079ea:	c7 04 24 75 89 10 80 	movl   $0x80108975,(%esp)
801079f1:	e8 6c 8b ff ff       	call   80100562 <panic>

  pushcli();
801079f6:	e8 b9 d4 ff ff       	call   80104eb4 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801079fb:	e8 c7 c6 ff ff       	call   801040c7 <mycpu>
80107a00:	89 c3                	mov    %eax,%ebx
80107a02:	e8 c0 c6 ff ff       	call   801040c7 <mycpu>
80107a07:	83 c0 08             	add    $0x8,%eax
80107a0a:	89 c7                	mov    %eax,%edi
80107a0c:	e8 b6 c6 ff ff       	call   801040c7 <mycpu>
80107a11:	83 c0 08             	add    $0x8,%eax
80107a14:	c1 e8 10             	shr    $0x10,%eax
80107a17:	89 c6                	mov    %eax,%esi
80107a19:	e8 a9 c6 ff ff       	call   801040c7 <mycpu>
80107a1e:	83 c0 08             	add    $0x8,%eax
80107a21:	c1 e8 18             	shr    $0x18,%eax
80107a24:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80107a2b:	67 00 
80107a2d:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107a34:	89 f1                	mov    %esi,%ecx
80107a36:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107a3c:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
80107a43:	83 e2 f0             	and    $0xfffffff0,%edx
80107a46:	83 ca 09             	or     $0x9,%edx
80107a49:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107a4f:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
80107a56:	83 ca 10             	or     $0x10,%edx
80107a59:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107a5f:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
80107a66:	83 e2 9f             	and    $0xffffff9f,%edx
80107a69:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107a6f:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
80107a76:	83 ca 80             	or     $0xffffff80,%edx
80107a79:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107a7f:	0f b6 93 9e 00 00 00 	movzbl 0x9e(%ebx),%edx
80107a86:	83 e2 f0             	and    $0xfffffff0,%edx
80107a89:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107a8f:	0f b6 93 9e 00 00 00 	movzbl 0x9e(%ebx),%edx
80107a96:	83 e2 ef             	and    $0xffffffef,%edx
80107a99:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107a9f:	0f b6 93 9e 00 00 00 	movzbl 0x9e(%ebx),%edx
80107aa6:	83 e2 df             	and    $0xffffffdf,%edx
80107aa9:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107aaf:	0f b6 93 9e 00 00 00 	movzbl 0x9e(%ebx),%edx
80107ab6:	83 ca 40             	or     $0x40,%edx
80107ab9:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107abf:	0f b6 93 9e 00 00 00 	movzbl 0x9e(%ebx),%edx
80107ac6:	83 e2 7f             	and    $0x7f,%edx
80107ac9:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107acf:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107ad5:	e8 ed c5 ff ff       	call   801040c7 <mycpu>
80107ada:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107ae1:	83 e2 ef             	and    $0xffffffef,%edx
80107ae4:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107aea:	e8 d8 c5 ff ff       	call   801040c7 <mycpu>
80107aef:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107af5:	e8 cd c5 ff ff       	call   801040c7 <mycpu>
80107afa:	8b 55 08             	mov    0x8(%ebp),%edx
80107afd:	8b 52 08             	mov    0x8(%edx),%edx
80107b00:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107b06:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107b09:	e8 b9 c5 ff ff       	call   801040c7 <mycpu>
80107b0e:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
80107b14:	c7 04 24 28 00 00 00 	movl   $0x28,(%esp)
80107b1b:	e8 09 f9 ff ff       	call   80107429 <ltr>
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107b20:	8b 45 08             	mov    0x8(%ebp),%eax
80107b23:	8b 40 04             	mov    0x4(%eax),%eax
80107b26:	05 00 00 00 80       	add    $0x80000000,%eax
80107b2b:	89 04 24             	mov    %eax,(%esp)
80107b2e:	e8 0c f9 ff ff       	call   8010743f <lcr3>
  popcli();
80107b33:	e8 c8 d3 ff ff       	call   80104f00 <popcli>
}
80107b38:	83 c4 1c             	add    $0x1c,%esp
80107b3b:	5b                   	pop    %ebx
80107b3c:	5e                   	pop    %esi
80107b3d:	5f                   	pop    %edi
80107b3e:	5d                   	pop    %ebp
80107b3f:	c3                   	ret    

80107b40 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107b40:	55                   	push   %ebp
80107b41:	89 e5                	mov    %esp,%ebp
80107b43:	83 ec 38             	sub    $0x38,%esp
  char *mem;

  if(sz >= PGSIZE)
80107b46:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107b4d:	76 0c                	jbe    80107b5b <inituvm+0x1b>
    panic("inituvm: more than a page");
80107b4f:	c7 04 24 89 89 10 80 	movl   $0x80108989,(%esp)
80107b56:	e8 07 8a ff ff       	call   80100562 <panic>
  mem = kalloc();
80107b5b:	e8 20 b0 ff ff       	call   80102b80 <kalloc>
80107b60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107b63:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107b6a:	00 
80107b6b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107b72:	00 
80107b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b76:	89 04 24             	mov    %eax,(%esp)
80107b79:	e8 3b d4 ff ff       	call   80104fb9 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b81:	05 00 00 00 80       	add    $0x80000000,%eax
80107b86:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107b8d:	00 
80107b8e:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107b92:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107b99:	00 
80107b9a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107ba1:	00 
80107ba2:	8b 45 08             	mov    0x8(%ebp),%eax
80107ba5:	89 04 24             	mov    %eax,(%esp)
80107ba8:	e8 90 fc ff ff       	call   8010783d <mappages>
  memmove(mem, init, sz);
80107bad:	8b 45 10             	mov    0x10(%ebp),%eax
80107bb0:	89 44 24 08          	mov    %eax,0x8(%esp)
80107bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80107bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bbe:	89 04 24             	mov    %eax,(%esp)
80107bc1:	e8 c2 d4 ff ff       	call   80105088 <memmove>
}
80107bc6:	c9                   	leave  
80107bc7:	c3                   	ret    

80107bc8 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107bc8:	55                   	push   %ebp
80107bc9:	89 e5                	mov    %esp,%ebp
80107bcb:	83 ec 28             	sub    $0x28,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107bce:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bd1:	25 ff 0f 00 00       	and    $0xfff,%eax
80107bd6:	85 c0                	test   %eax,%eax
80107bd8:	74 0c                	je     80107be6 <loaduvm+0x1e>
    panic("loaduvm: addr must be page aligned");
80107bda:	c7 04 24 a4 89 10 80 	movl   $0x801089a4,(%esp)
80107be1:	e8 7c 89 ff ff       	call   80100562 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107be6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107bed:	e9 a6 00 00 00       	jmp    80107c98 <loaduvm+0xd0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bf5:	8b 55 0c             	mov    0xc(%ebp),%edx
80107bf8:	01 d0                	add    %edx,%eax
80107bfa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107c01:	00 
80107c02:	89 44 24 04          	mov    %eax,0x4(%esp)
80107c06:	8b 45 08             	mov    0x8(%ebp),%eax
80107c09:	89 04 24             	mov    %eax,(%esp)
80107c0c:	e8 90 fb ff ff       	call   801077a1 <walkpgdir>
80107c11:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107c14:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107c18:	75 0c                	jne    80107c26 <loaduvm+0x5e>
      panic("loaduvm: address should exist");
80107c1a:	c7 04 24 c7 89 10 80 	movl   $0x801089c7,(%esp)
80107c21:	e8 3c 89 ff ff       	call   80100562 <panic>
    pa = PTE_ADDR(*pte);
80107c26:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c29:	8b 00                	mov    (%eax),%eax
80107c2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c30:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c36:	8b 55 18             	mov    0x18(%ebp),%edx
80107c39:	29 c2                	sub    %eax,%edx
80107c3b:	89 d0                	mov    %edx,%eax
80107c3d:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107c42:	77 0f                	ja     80107c53 <loaduvm+0x8b>
      n = sz - i;
80107c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c47:	8b 55 18             	mov    0x18(%ebp),%edx
80107c4a:	29 c2                	sub    %eax,%edx
80107c4c:	89 d0                	mov    %edx,%eax
80107c4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c51:	eb 07                	jmp    80107c5a <loaduvm+0x92>
    else
      n = PGSIZE;
80107c53:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c5d:	8b 55 14             	mov    0x14(%ebp),%edx
80107c60:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80107c63:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107c66:	05 00 00 00 80       	add    $0x80000000,%eax
80107c6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107c6e:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107c72:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80107c76:	89 44 24 04          	mov    %eax,0x4(%esp)
80107c7a:	8b 45 10             	mov    0x10(%ebp),%eax
80107c7d:	89 04 24             	mov    %eax,(%esp)
80107c80:	e8 4c a1 ff ff       	call   80101dd1 <readi>
80107c85:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107c88:	74 07                	je     80107c91 <loaduvm+0xc9>
      return -1;
80107c8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c8f:	eb 18                	jmp    80107ca9 <loaduvm+0xe1>
  for(i = 0; i < sz; i += PGSIZE){
80107c91:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c9b:	3b 45 18             	cmp    0x18(%ebp),%eax
80107c9e:	0f 82 4e ff ff ff    	jb     80107bf2 <loaduvm+0x2a>
  }
  return 0;
80107ca4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107ca9:	c9                   	leave  
80107caa:	c3                   	ret    

80107cab <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107cab:	55                   	push   %ebp
80107cac:	89 e5                	mov    %esp,%ebp
80107cae:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107cb1:	8b 45 10             	mov    0x10(%ebp),%eax
80107cb4:	85 c0                	test   %eax,%eax
80107cb6:	79 0a                	jns    80107cc2 <allocuvm+0x17>
    return 0;
80107cb8:	b8 00 00 00 00       	mov    $0x0,%eax
80107cbd:	e9 fd 00 00 00       	jmp    80107dbf <allocuvm+0x114>
  if(newsz < oldsz)
80107cc2:	8b 45 10             	mov    0x10(%ebp),%eax
80107cc5:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107cc8:	73 08                	jae    80107cd2 <allocuvm+0x27>
    return oldsz;
80107cca:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ccd:	e9 ed 00 00 00       	jmp    80107dbf <allocuvm+0x114>

  a = PGROUNDUP(oldsz);
80107cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cd5:	05 ff 0f 00 00       	add    $0xfff,%eax
80107cda:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107cdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107ce2:	e9 c9 00 00 00       	jmp    80107db0 <allocuvm+0x105>
    mem = kalloc();
80107ce7:	e8 94 ae ff ff       	call   80102b80 <kalloc>
80107cec:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107cef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107cf3:	75 2f                	jne    80107d24 <allocuvm+0x79>
      cprintf("allocuvm out of memory\n");
80107cf5:	c7 04 24 e5 89 10 80 	movl   $0x801089e5,(%esp)
80107cfc:	e8 c7 86 ff ff       	call   801003c8 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107d01:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d04:	89 44 24 08          	mov    %eax,0x8(%esp)
80107d08:	8b 45 10             	mov    0x10(%ebp),%eax
80107d0b:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d0f:	8b 45 08             	mov    0x8(%ebp),%eax
80107d12:	89 04 24             	mov    %eax,(%esp)
80107d15:	e8 a7 00 00 00       	call   80107dc1 <deallocuvm>
      return 0;
80107d1a:	b8 00 00 00 00       	mov    $0x0,%eax
80107d1f:	e9 9b 00 00 00       	jmp    80107dbf <allocuvm+0x114>
    }
    memset(mem, 0, PGSIZE);
80107d24:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107d2b:	00 
80107d2c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107d33:	00 
80107d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d37:	89 04 24             	mov    %eax,(%esp)
80107d3a:	e8 7a d2 ff ff       	call   80104fb9 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107d3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d42:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80107d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d4b:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107d52:	00 
80107d53:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107d57:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107d5e:	00 
80107d5f:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d63:	8b 45 08             	mov    0x8(%ebp),%eax
80107d66:	89 04 24             	mov    %eax,(%esp)
80107d69:	e8 cf fa ff ff       	call   8010783d <mappages>
80107d6e:	85 c0                	test   %eax,%eax
80107d70:	79 37                	jns    80107da9 <allocuvm+0xfe>
      cprintf("allocuvm out of memory (2)\n");
80107d72:	c7 04 24 fd 89 10 80 	movl   $0x801089fd,(%esp)
80107d79:	e8 4a 86 ff ff       	call   801003c8 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d81:	89 44 24 08          	mov    %eax,0x8(%esp)
80107d85:	8b 45 10             	mov    0x10(%ebp),%eax
80107d88:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d8c:	8b 45 08             	mov    0x8(%ebp),%eax
80107d8f:	89 04 24             	mov    %eax,(%esp)
80107d92:	e8 2a 00 00 00       	call   80107dc1 <deallocuvm>
      kfree(mem);
80107d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d9a:	89 04 24             	mov    %eax,(%esp)
80107d9d:	e8 48 ad ff ff       	call   80102aea <kfree>
      return 0;
80107da2:	b8 00 00 00 00       	mov    $0x0,%eax
80107da7:	eb 16                	jmp    80107dbf <allocuvm+0x114>
  for(; a < newsz; a += PGSIZE){
80107da9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db3:	3b 45 10             	cmp    0x10(%ebp),%eax
80107db6:	0f 82 2b ff ff ff    	jb     80107ce7 <allocuvm+0x3c>
    }
  }
  return newsz;
80107dbc:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107dbf:	c9                   	leave  
80107dc0:	c3                   	ret    

80107dc1 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107dc1:	55                   	push   %ebp
80107dc2:	89 e5                	mov    %esp,%ebp
80107dc4:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107dc7:	8b 45 10             	mov    0x10(%ebp),%eax
80107dca:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107dcd:	72 08                	jb     80107dd7 <deallocuvm+0x16>
    return oldsz;
80107dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
80107dd2:	e9 ae 00 00 00       	jmp    80107e85 <deallocuvm+0xc4>

  a = PGROUNDUP(newsz);
80107dd7:	8b 45 10             	mov    0x10(%ebp),%eax
80107dda:	05 ff 0f 00 00       	add    $0xfff,%eax
80107ddf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107de4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107de7:	e9 8a 00 00 00       	jmp    80107e76 <deallocuvm+0xb5>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107def:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107df6:	00 
80107df7:	89 44 24 04          	mov    %eax,0x4(%esp)
80107dfb:	8b 45 08             	mov    0x8(%ebp),%eax
80107dfe:	89 04 24             	mov    %eax,(%esp)
80107e01:	e8 9b f9 ff ff       	call   801077a1 <walkpgdir>
80107e06:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107e09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107e0d:	75 16                	jne    80107e25 <deallocuvm+0x64>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e12:	c1 e8 16             	shr    $0x16,%eax
80107e15:	83 c0 01             	add    $0x1,%eax
80107e18:	c1 e0 16             	shl    $0x16,%eax
80107e1b:	2d 00 10 00 00       	sub    $0x1000,%eax
80107e20:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107e23:	eb 4a                	jmp    80107e6f <deallocuvm+0xae>
    else if((*pte & PTE_P) != 0){
80107e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e28:	8b 00                	mov    (%eax),%eax
80107e2a:	83 e0 01             	and    $0x1,%eax
80107e2d:	85 c0                	test   %eax,%eax
80107e2f:	74 3e                	je     80107e6f <deallocuvm+0xae>
      pa = PTE_ADDR(*pte);
80107e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e34:	8b 00                	mov    (%eax),%eax
80107e36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107e3e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107e42:	75 0c                	jne    80107e50 <deallocuvm+0x8f>
        panic("kfree");
80107e44:	c7 04 24 19 8a 10 80 	movl   $0x80108a19,(%esp)
80107e4b:	e8 12 87 ff ff       	call   80100562 <panic>
      char *v = P2V(pa);
80107e50:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e53:	05 00 00 00 80       	add    $0x80000000,%eax
80107e58:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107e5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107e5e:	89 04 24             	mov    %eax,(%esp)
80107e61:	e8 84 ac ff ff       	call   80102aea <kfree>
      *pte = 0;
80107e66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107e6f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e79:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107e7c:	0f 82 6a ff ff ff    	jb     80107dec <deallocuvm+0x2b>
    }
  }
  return newsz;
80107e82:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107e85:	c9                   	leave  
80107e86:	c3                   	ret    

80107e87 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107e87:	55                   	push   %ebp
80107e88:	89 e5                	mov    %esp,%ebp
80107e8a:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80107e8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107e91:	75 0c                	jne    80107e9f <freevm+0x18>
    panic("freevm: no pgdir");
80107e93:	c7 04 24 1f 8a 10 80 	movl   $0x80108a1f,(%esp)
80107e9a:	e8 c3 86 ff ff       	call   80100562 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107e9f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107ea6:	00 
80107ea7:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80107eae:	80 
80107eaf:	8b 45 08             	mov    0x8(%ebp),%eax
80107eb2:	89 04 24             	mov    %eax,(%esp)
80107eb5:	e8 07 ff ff ff       	call   80107dc1 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80107eba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107ec1:	eb 45                	jmp    80107f08 <freevm+0x81>
    if(pgdir[i] & PTE_P){
80107ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ec6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107ecd:	8b 45 08             	mov    0x8(%ebp),%eax
80107ed0:	01 d0                	add    %edx,%eax
80107ed2:	8b 00                	mov    (%eax),%eax
80107ed4:	83 e0 01             	and    $0x1,%eax
80107ed7:	85 c0                	test   %eax,%eax
80107ed9:	74 29                	je     80107f04 <freevm+0x7d>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ede:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107ee5:	8b 45 08             	mov    0x8(%ebp),%eax
80107ee8:	01 d0                	add    %edx,%eax
80107eea:	8b 00                	mov    (%eax),%eax
80107eec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ef1:	05 00 00 00 80       	add    $0x80000000,%eax
80107ef6:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80107ef9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107efc:	89 04 24             	mov    %eax,(%esp)
80107eff:	e8 e6 ab ff ff       	call   80102aea <kfree>
  for(i = 0; i < NPDENTRIES; i++){
80107f04:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107f08:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107f0f:	76 b2                	jbe    80107ec3 <freevm+0x3c>
    }
  }
  kfree((char*)pgdir);
80107f11:	8b 45 08             	mov    0x8(%ebp),%eax
80107f14:	89 04 24             	mov    %eax,(%esp)
80107f17:	e8 ce ab ff ff       	call   80102aea <kfree>
}
80107f1c:	c9                   	leave  
80107f1d:	c3                   	ret    

80107f1e <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107f1e:	55                   	push   %ebp
80107f1f:	89 e5                	mov    %esp,%ebp
80107f21:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107f24:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107f2b:	00 
80107f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f2f:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f33:	8b 45 08             	mov    0x8(%ebp),%eax
80107f36:	89 04 24             	mov    %eax,(%esp)
80107f39:	e8 63 f8 ff ff       	call   801077a1 <walkpgdir>
80107f3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80107f41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107f45:	75 0c                	jne    80107f53 <clearpteu+0x35>
    panic("clearpteu");
80107f47:	c7 04 24 30 8a 10 80 	movl   $0x80108a30,(%esp)
80107f4e:	e8 0f 86 ff ff       	call   80100562 <panic>
  *pte &= ~PTE_U;
80107f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f56:	8b 00                	mov    (%eax),%eax
80107f58:	83 e0 fb             	and    $0xfffffffb,%eax
80107f5b:	89 c2                	mov    %eax,%edx
80107f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f60:	89 10                	mov    %edx,(%eax)
}
80107f62:	c9                   	leave  
80107f63:	c3                   	ret    

80107f64 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz, int pages)
{
80107f64:	55                   	push   %ebp
80107f65:	89 e5                	mov    %esp,%ebp
80107f67:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107f6a:	e8 66 f9 ff ff       	call   801078d5 <setupkvm>
80107f6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107f72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107f76:	75 0a                	jne    80107f82 <copyuvm+0x1e>
    return 0;
80107f78:	b8 00 00 00 00       	mov    $0x0,%eax
80107f7d:	e9 f3 01 00 00       	jmp    80108175 <copyuvm+0x211>
  for(i = 0; i < sz; i += PGSIZE){
80107f82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107f89:	e9 d1 00 00 00       	jmp    8010805f <copyuvm+0xfb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f91:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107f98:	00 
80107f99:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f9d:	8b 45 08             	mov    0x8(%ebp),%eax
80107fa0:	89 04 24             	mov    %eax,(%esp)
80107fa3:	e8 f9 f7 ff ff       	call   801077a1 <walkpgdir>
80107fa8:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107fab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107faf:	75 0c                	jne    80107fbd <copyuvm+0x59>
      panic("copyuvm: pte should exist");
80107fb1:	c7 04 24 3a 8a 10 80 	movl   $0x80108a3a,(%esp)
80107fb8:	e8 a5 85 ff ff       	call   80100562 <panic>
    if(!(*pte & PTE_P))
80107fbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fc0:	8b 00                	mov    (%eax),%eax
80107fc2:	83 e0 01             	and    $0x1,%eax
80107fc5:	85 c0                	test   %eax,%eax
80107fc7:	75 0c                	jne    80107fd5 <copyuvm+0x71>
      panic("copyuvm: page not present");
80107fc9:	c7 04 24 54 8a 10 80 	movl   $0x80108a54,(%esp)
80107fd0:	e8 8d 85 ff ff       	call   80100562 <panic>
    pa = PTE_ADDR(*pte);
80107fd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fd8:	8b 00                	mov    (%eax),%eax
80107fda:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107fdf:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80107fe2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fe5:	8b 00                	mov    (%eax),%eax
80107fe7:	25 ff 0f 00 00       	and    $0xfff,%eax
80107fec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107fef:	e8 8c ab ff ff       	call   80102b80 <kalloc>
80107ff4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107ff7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80107ffb:	75 05                	jne    80108002 <copyuvm+0x9e>
      goto bad;
80107ffd:	e9 63 01 00 00       	jmp    80108165 <copyuvm+0x201>
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108002:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108005:	05 00 00 00 80       	add    $0x80000000,%eax
8010800a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108011:	00 
80108012:	89 44 24 04          	mov    %eax,0x4(%esp)
80108016:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108019:	89 04 24             	mov    %eax,(%esp)
8010801c:	e8 67 d0 ff ff       	call   80105088 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80108021:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108024:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108027:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010802d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108030:	89 54 24 10          	mov    %edx,0x10(%esp)
80108034:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80108038:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010803f:	00 
80108040:	89 44 24 04          	mov    %eax,0x4(%esp)
80108044:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108047:	89 04 24             	mov    %eax,(%esp)
8010804a:	e8 ee f7 ff ff       	call   8010783d <mappages>
8010804f:	85 c0                	test   %eax,%eax
80108051:	79 05                	jns    80108058 <copyuvm+0xf4>
      goto bad;
80108053:	e9 0d 01 00 00       	jmp    80108165 <copyuvm+0x201>
  for(i = 0; i < sz; i += PGSIZE){
80108058:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010805f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108062:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108065:	0f 82 23 ff ff ff    	jb     80107f8e <copyuvm+0x2a>
  }
 for(i = 0; i < pages; i++){
8010806b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108072:	e9 dd 00 00 00       	jmp    80108154 <copyuvm+0x1f0>
   uint x = STACK - (PGSIZE * (i + 1)); 
80108077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010807a:	83 c0 01             	add    $0x1,%eax
8010807d:	c1 e0 0c             	shl    $0xc,%eax
80108080:	89 c2                	mov    %eax,%edx
80108082:	b8 ff ff ff 7f       	mov    $0x7fffffff,%eax
80108087:	29 d0                	sub    %edx,%eax
80108089:	89 45 dc             	mov    %eax,-0x24(%ebp)
   if((pte = walkpgdir(pgdir, (void *) x, 0)) == 0)
8010808c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010808f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108096:	00 
80108097:	89 44 24 04          	mov    %eax,0x4(%esp)
8010809b:	8b 45 08             	mov    0x8(%ebp),%eax
8010809e:	89 04 24             	mov    %eax,(%esp)
801080a1:	e8 fb f6 ff ff       	call   801077a1 <walkpgdir>
801080a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
801080a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801080ad:	75 0c                	jne    801080bb <copyuvm+0x157>
      panic("copyuvm: pte should exist");
801080af:	c7 04 24 3a 8a 10 80 	movl   $0x80108a3a,(%esp)
801080b6:	e8 a7 84 ff ff       	call   80100562 <panic>
    if(!(*pte & PTE_P))
801080bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080be:	8b 00                	mov    (%eax),%eax
801080c0:	83 e0 01             	and    $0x1,%eax
801080c3:	85 c0                	test   %eax,%eax
801080c5:	75 0c                	jne    801080d3 <copyuvm+0x16f>
      panic("copyuvm: page not present");
801080c7:	c7 04 24 54 8a 10 80 	movl   $0x80108a54,(%esp)
801080ce:	e8 8f 84 ff ff       	call   80100562 <panic>
    pa = PTE_ADDR(*pte);
801080d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080d6:	8b 00                	mov    (%eax),%eax
801080d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801080e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080e3:	8b 00                	mov    (%eax),%eax
801080e5:	25 ff 0f 00 00       	and    $0xfff,%eax
801080ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801080ed:	e8 8e aa ff ff       	call   80102b80 <kalloc>
801080f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801080f5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801080f9:	75 02                	jne    801080fd <copyuvm+0x199>
      goto bad;
801080fb:	eb 68                	jmp    80108165 <copyuvm+0x201>
    memmove(mem, (char*)P2V(pa), PGSIZE);
801080fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108100:	05 00 00 00 80       	add    $0x80000000,%eax
80108105:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010810c:	00 
8010810d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108111:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108114:	89 04 24             	mov    %eax,(%esp)
80108117:	e8 6c cf ff ff       	call   80105088 <memmove>
    if(mappages(d, (void*) x, PGSIZE, V2P(mem), flags) < 0)
8010811c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010811f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108122:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80108128:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010812b:	89 54 24 10          	mov    %edx,0x10(%esp)
8010812f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80108133:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010813a:	00 
8010813b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010813f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108142:	89 04 24             	mov    %eax,(%esp)
80108145:	e8 f3 f6 ff ff       	call   8010783d <mappages>
8010814a:	85 c0                	test   %eax,%eax
8010814c:	79 02                	jns    80108150 <copyuvm+0x1ec>
      goto bad;
8010814e:	eb 15                	jmp    80108165 <copyuvm+0x201>
 for(i = 0; i < pages; i++){
80108150:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108154:	8b 45 10             	mov    0x10(%ebp),%eax
80108157:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010815a:	0f 87 17 ff ff ff    	ja     80108077 <copyuvm+0x113>
  } 
  return d;
80108160:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108163:	eb 10                	jmp    80108175 <copyuvm+0x211>

bad:
  freevm(d);
80108165:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108168:	89 04 24             	mov    %eax,(%esp)
8010816b:	e8 17 fd ff ff       	call   80107e87 <freevm>
  return 0;
80108170:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108175:	c9                   	leave  
80108176:	c3                   	ret    

80108177 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108177:	55                   	push   %ebp
80108178:	89 e5                	mov    %esp,%ebp
8010817a:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010817d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108184:	00 
80108185:	8b 45 0c             	mov    0xc(%ebp),%eax
80108188:	89 44 24 04          	mov    %eax,0x4(%esp)
8010818c:	8b 45 08             	mov    0x8(%ebp),%eax
8010818f:	89 04 24             	mov    %eax,(%esp)
80108192:	e8 0a f6 ff ff       	call   801077a1 <walkpgdir>
80108197:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
8010819a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010819d:	8b 00                	mov    (%eax),%eax
8010819f:	83 e0 01             	and    $0x1,%eax
801081a2:	85 c0                	test   %eax,%eax
801081a4:	75 07                	jne    801081ad <uva2ka+0x36>
    return 0;
801081a6:	b8 00 00 00 00       	mov    $0x0,%eax
801081ab:	eb 22                	jmp    801081cf <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
801081ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b0:	8b 00                	mov    (%eax),%eax
801081b2:	83 e0 04             	and    $0x4,%eax
801081b5:	85 c0                	test   %eax,%eax
801081b7:	75 07                	jne    801081c0 <uva2ka+0x49>
    return 0;
801081b9:	b8 00 00 00 00       	mov    $0x0,%eax
801081be:	eb 0f                	jmp    801081cf <uva2ka+0x58>
  return (char*)P2V(PTE_ADDR(*pte));
801081c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c3:	8b 00                	mov    (%eax),%eax
801081c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081ca:	05 00 00 00 80       	add    $0x80000000,%eax
}
801081cf:	c9                   	leave  
801081d0:	c3                   	ret    

801081d1 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801081d1:	55                   	push   %ebp
801081d2:	89 e5                	mov    %esp,%ebp
801081d4:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801081d7:	8b 45 10             	mov    0x10(%ebp),%eax
801081da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801081dd:	e9 87 00 00 00       	jmp    80108269 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
801081e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801081e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801081ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
801081f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801081f4:	8b 45 08             	mov    0x8(%ebp),%eax
801081f7:	89 04 24             	mov    %eax,(%esp)
801081fa:	e8 78 ff ff ff       	call   80108177 <uva2ka>
801081ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108202:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108206:	75 07                	jne    8010820f <copyout+0x3e>
      return -1;
80108208:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010820d:	eb 69                	jmp    80108278 <copyout+0xa7>
    n = PGSIZE - (va - va0);
8010820f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108212:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108215:	29 c2                	sub    %eax,%edx
80108217:	89 d0                	mov    %edx,%eax
80108219:	05 00 10 00 00       	add    $0x1000,%eax
8010821e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108221:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108224:	3b 45 14             	cmp    0x14(%ebp),%eax
80108227:	76 06                	jbe    8010822f <copyout+0x5e>
      n = len;
80108229:	8b 45 14             	mov    0x14(%ebp),%eax
8010822c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
8010822f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108232:	8b 55 0c             	mov    0xc(%ebp),%edx
80108235:	29 c2                	sub    %eax,%edx
80108237:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010823a:	01 c2                	add    %eax,%edx
8010823c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010823f:	89 44 24 08          	mov    %eax,0x8(%esp)
80108243:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108246:	89 44 24 04          	mov    %eax,0x4(%esp)
8010824a:	89 14 24             	mov    %edx,(%esp)
8010824d:	e8 36 ce ff ff       	call   80105088 <memmove>
    len -= n;
80108252:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108255:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108258:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010825b:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
8010825e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108261:	05 00 10 00 00       	add    $0x1000,%eax
80108266:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80108269:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010826d:	0f 85 6f ff ff ff    	jne    801081e2 <copyout+0x11>
  }
  return 0;
80108273:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108278:	c9                   	leave  
80108279:	c3                   	ret    

8010827a <shminit>:
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
8010827a:	55                   	push   %ebp
8010827b:	89 e5                	mov    %esp,%ebp
8010827d:	83 ec 28             	sub    $0x28,%esp
  int i;
  initlock(&(shm_table.lock), "SHM lock");
80108280:	c7 44 24 04 6e 8a 10 	movl   $0x80108a6e,0x4(%esp)
80108287:	80 
80108288:	c7 04 24 40 66 11 80 	movl   $0x80116640,(%esp)
8010828f:	e8 a2 ca ff ff       	call   80104d36 <initlock>
  acquire(&(shm_table.lock));
80108294:	c7 04 24 40 66 11 80 	movl   $0x80116640,(%esp)
8010829b:	e8 b7 ca ff ff       	call   80104d57 <acquire>
  for (i = 0; i< 64; i++) {
801082a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801082a7:	eb 49                	jmp    801082f2 <shminit+0x78>
    shm_table.shm_pages[i].id =0;
801082a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801082ac:	89 d0                	mov    %edx,%eax
801082ae:	01 c0                	add    %eax,%eax
801082b0:	01 d0                	add    %edx,%eax
801082b2:	c1 e0 02             	shl    $0x2,%eax
801082b5:	05 74 66 11 80       	add    $0x80116674,%eax
801082ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    shm_table.shm_pages[i].frame =0;
801082c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801082c3:	89 d0                	mov    %edx,%eax
801082c5:	01 c0                	add    %eax,%eax
801082c7:	01 d0                	add    %edx,%eax
801082c9:	c1 e0 02             	shl    $0x2,%eax
801082cc:	05 78 66 11 80       	add    $0x80116678,%eax
801082d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    shm_table.shm_pages[i].refcnt =0;
801082d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801082da:	89 d0                	mov    %edx,%eax
801082dc:	01 c0                	add    %eax,%eax
801082de:	01 d0                	add    %edx,%eax
801082e0:	c1 e0 02             	shl    $0x2,%eax
801082e3:	05 7c 66 11 80       	add    $0x8011667c,%eax
801082e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for (i = 0; i< 64; i++) {
801082ee:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801082f2:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
801082f6:	7e b1                	jle    801082a9 <shminit+0x2f>
  }
  release(&(shm_table.lock));
801082f8:	c7 04 24 40 66 11 80 	movl   $0x80116640,(%esp)
801082ff:	e8 bb ca ff ff       	call   80104dbf <release>
}
80108304:	c9                   	leave  
80108305:	c3                   	ret    

80108306 <shm_open>:

int shm_open(int id, char **pointer) {
80108306:	55                   	push   %ebp
80108307:	89 e5                	mov    %esp,%ebp
//you write this




return 0; //added to remove compiler warning -- you should decide what to return
80108309:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010830e:	5d                   	pop    %ebp
8010830f:	c3                   	ret    

80108310 <shm_close>:


int shm_close(int id) {
80108310:	55                   	push   %ebp
80108311:	89 e5                	mov    %esp,%ebp
//you write this too!




return 0; //added to remove compiler warning -- you should decide what to return
80108313:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108318:	5d                   	pop    %ebp
80108319:	c3                   	ret    
