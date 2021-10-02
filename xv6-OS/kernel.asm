
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 50 30 10 80       	mov    $0x80103050,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 e0 71 10 80       	push   $0x801071e0
80100055:	68 c0 b5 10 80       	push   $0x8010b5c0
8010005a:	e8 21 44 00 00       	call   80104480 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc fc 10 80       	mov    $0x8010fcbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006e:	fc 10 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100078:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 71 10 80       	push   $0x801071e7
80100097:	50                   	push   %eax
80100098:	e8 a3 42 00 00       	call   80104340 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 fa 10 80    	cmp    $0x8010fa60,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e8:	e8 13 45 00 00       	call   80104600 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 59 45 00 00       	call   801046c0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 42 00 00       	call   80104380 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 ff 20 00 00       	call   80102290 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 ee 71 10 80       	push   $0x801071ee
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 59 42 00 00       	call   80104420 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 b3 20 00 00       	jmp    80102290 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 ff 71 10 80       	push   $0x801071ff
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 18 42 00 00       	call   80104420 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 c8 41 00 00       	call   801043e0 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010021f:	e8 dc 43 00 00       	call   80104600 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 4b 44 00 00       	jmp    801046c0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 06 72 10 80       	push   $0x80107206
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 a6 15 00 00       	call   80101850 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801002b1:	e8 4a 43 00 00       	call   80104600 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cb:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 a5 10 80       	push   $0x8010a520
801002e0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002e5:	e8 76 3c 00 00       	call   80103f60 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 81 36 00 00       	call   80103980 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 a5 10 80       	push   $0x8010a520
8010030e:	e8 ad 43 00 00       	call   801046c0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 54 14 00 00       	call   80101770 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 a5 10 80       	push   $0x8010a520
80100365:	e8 56 43 00 00       	call   801046c0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 fd 13 00 00       	call   80101770 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 fe 24 00 00       	call   801028b0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 0d 72 10 80       	push   $0x8010720d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 3f 7b 10 80 	movl   $0x80107b3f,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 bf 40 00 00       	call   801044a0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 21 72 10 80       	push   $0x80107221
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 a1 59 00 00       	call   80105dd0 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 b6 58 00 00       	call   80105dd0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 aa 58 00 00       	call   80105dd0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 9e 58 00 00       	call   80105dd0 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 4a 42 00 00       	call   801047b0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 95 41 00 00       	call   80104710 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 25 72 10 80       	push   $0x80107225
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 50 72 10 80 	movzbl -0x7fef8db0(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 f8 11 00 00       	call   80101850 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010065f:	e8 9c 3f 00 00       	call   80104600 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 a5 10 80       	push   $0x8010a520
80100697:	e8 24 40 00 00       	call   801046c0 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 cb 10 00 00       	call   80101770 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb 38 72 10 80       	mov    $0x80107238,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 a5 10 80       	push   $0x8010a520
801007bd:	e8 3e 3e 00 00       	call   80104600 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 a5 10 80    	mov    0x8010a558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 a5 10 80       	push   $0x8010a520
80100828:	e8 93 3e 00 00       	call   801046c0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 3f 72 10 80       	push   $0x8010723f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 a5 10 80       	push   $0x8010a520
80100877:	e8 84 3d 00 00       	call   80104600 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 20 ff 10 80    	mov    %bl,-0x7fef00e0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100925:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.e--;
8010094c:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010096f:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100985:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100999:	a1 58 a5 10 80       	mov    0x8010a558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 a5 10 80       	push   $0x8010a520
801009cf:	e8 ec 3c 00 00       	call   801046c0 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 0c 38 00 00       	jmp    80104210 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100a1b:	68 a0 ff 10 80       	push   $0x8010ffa0
80100a20:	e8 fb 36 00 00       	call   80104120 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 48 72 10 80       	push   $0x80107248
80100a3f:	68 20 a5 10 80       	push   $0x8010a520
80100a44:	e8 37 3a 00 00       	call   80104480 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 09 11 80 40 	movl   $0x80100640,0x8011096c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 09 11 80 90 	movl   $0x80100290,0x80110968
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 ce 19 00 00       	call   80102440 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 eb 2e 00 00       	call   80103980 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 a0 22 00 00       	call   80102d40 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 95 15 00 00       	call   80102040 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 05 03 00 00    	je     80100dbb <exec+0x33b>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 af 0c 00 00       	call   80101770 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 9e 0f 00 00       	call   80101a70 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 2d 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100ae3:	e8 c8 22 00 00       	call   80102db0 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 2f 64 00 00       	call   80106f40 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 ab 02 00 00    	je     80100dda <exec+0x35a>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 e8 61 00 00       	call   80106d60 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 e2 60 00 00       	call   80106c90 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 9a 0e 00 00       	call   80101a70 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 d0 62 00 00       	call   80106ec0 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 ef 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c21:	e8 8a 21 00 00       	call   80102db0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 29 61 00 00       	call   80106d60 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 88 63 00 00       	call   80106fe0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 68 3c 00 00       	call   80104910 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 55 3c 00 00       	call   80104910 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 74 64 00 00       	call   80107140 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 da 61 00 00       	call   80106ec0 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 fd fd ff ff       	jmp    80100af0 <exec+0x70>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 08 64 00 00       	call   80107140 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 5a 3b 00 00       	call   801048d0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  curproc->priority = 3;
80100d9a:	c7 41 7c 03 00 00 00 	movl   $0x3,0x7c(%ecx)
  switchuvm(curproc);
80100da1:	89 0c 24             	mov    %ecx,(%esp)
80100da4:	e8 57 5d 00 00       	call   80106b00 <switchuvm>
  freevm(oldpgdir);
80100da9:	89 3c 24             	mov    %edi,(%esp)
80100dac:	e8 0f 61 00 00       	call   80106ec0 <freevm>
  return 0;
80100db1:	83 c4 10             	add    $0x10,%esp
80100db4:	31 c0                	xor    %eax,%eax
80100db6:	e9 35 fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100dbb:	e8 f0 1f 00 00       	call   80102db0 <end_op>
    cprintf("exec: fail\n");
80100dc0:	83 ec 0c             	sub    $0xc,%esp
80100dc3:	68 61 72 10 80       	push   $0x80107261
80100dc8:	e8 e3 f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dcd:	83 c4 10             	add    $0x10,%esp
80100dd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dd5:	e9 16 fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dda:	31 ff                	xor    %edi,%edi
80100ddc:	be 00 20 00 00       	mov    $0x2000,%esi
80100de1:	e9 32 fe ff ff       	jmp    80100c18 <exec+0x198>
80100de6:	66 90                	xchg   %ax,%ax
80100de8:	66 90                	xchg   %ax,%ax
80100dea:	66 90                	xchg   %ax,%ax
80100dec:	66 90                	xchg   %ax,%ax
80100dee:	66 90                	xchg   %ax,%ax

80100df0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100df0:	f3 0f 1e fb          	endbr32 
80100df4:	55                   	push   %ebp
80100df5:	89 e5                	mov    %esp,%ebp
80100df7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dfa:	68 6d 72 10 80       	push   $0x8010726d
80100dff:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e04:	e8 77 36 00 00       	call   80104480 <initlock>
}
80100e09:	83 c4 10             	add    $0x10,%esp
80100e0c:	c9                   	leave  
80100e0d:	c3                   	ret    
80100e0e:	66 90                	xchg   %ax,%ax

80100e10 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e10:	f3 0f 1e fb          	endbr32 
80100e14:	55                   	push   %ebp
80100e15:	89 e5                	mov    %esp,%ebp
80100e17:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e18:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100e1d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e20:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e25:	e8 d6 37 00 00       	call   80104600 <acquire>
80100e2a:	83 c4 10             	add    $0x10,%esp
80100e2d:	eb 0c                	jmp    80100e3b <filealloc+0x2b>
80100e2f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e30:	83 c3 18             	add    $0x18,%ebx
80100e33:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e39:	74 25                	je     80100e60 <filealloc+0x50>
    if(f->ref == 0){
80100e3b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e3e:	85 c0                	test   %eax,%eax
80100e40:	75 ee                	jne    80100e30 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e42:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e45:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e4c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e51:	e8 6a 38 00 00       	call   801046c0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e56:	89 d8                	mov    %ebx,%eax
      return f;
80100e58:	83 c4 10             	add    $0x10,%esp
}
80100e5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e5e:	c9                   	leave  
80100e5f:	c3                   	ret    
  release(&ftable.lock);
80100e60:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e63:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e65:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e6a:	e8 51 38 00 00       	call   801046c0 <release>
}
80100e6f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e71:	83 c4 10             	add    $0x10,%esp
}
80100e74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e77:	c9                   	leave  
80100e78:	c3                   	ret    
80100e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e80 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e80:	f3 0f 1e fb          	endbr32 
80100e84:	55                   	push   %ebp
80100e85:	89 e5                	mov    %esp,%ebp
80100e87:	53                   	push   %ebx
80100e88:	83 ec 10             	sub    $0x10,%esp
80100e8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e8e:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e93:	e8 68 37 00 00       	call   80104600 <acquire>
  if(f->ref < 1)
80100e98:	8b 43 04             	mov    0x4(%ebx),%eax
80100e9b:	83 c4 10             	add    $0x10,%esp
80100e9e:	85 c0                	test   %eax,%eax
80100ea0:	7e 1a                	jle    80100ebc <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100ea2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ea5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ea8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100eab:	68 c0 ff 10 80       	push   $0x8010ffc0
80100eb0:	e8 0b 38 00 00       	call   801046c0 <release>
  return f;
}
80100eb5:	89 d8                	mov    %ebx,%eax
80100eb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eba:	c9                   	leave  
80100ebb:	c3                   	ret    
    panic("filedup");
80100ebc:	83 ec 0c             	sub    $0xc,%esp
80100ebf:	68 74 72 10 80       	push   $0x80107274
80100ec4:	e8 c7 f4 ff ff       	call   80100390 <panic>
80100ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ed0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ed0:	f3 0f 1e fb          	endbr32 
80100ed4:	55                   	push   %ebp
80100ed5:	89 e5                	mov    %esp,%ebp
80100ed7:	57                   	push   %edi
80100ed8:	56                   	push   %esi
80100ed9:	53                   	push   %ebx
80100eda:	83 ec 28             	sub    $0x28,%esp
80100edd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ee0:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ee5:	e8 16 37 00 00       	call   80104600 <acquire>
  if(f->ref < 1)
80100eea:	8b 53 04             	mov    0x4(%ebx),%edx
80100eed:	83 c4 10             	add    $0x10,%esp
80100ef0:	85 d2                	test   %edx,%edx
80100ef2:	0f 8e a1 00 00 00    	jle    80100f99 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ef8:	83 ea 01             	sub    $0x1,%edx
80100efb:	89 53 04             	mov    %edx,0x4(%ebx)
80100efe:	75 40                	jne    80100f40 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f00:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f04:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f07:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f09:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f0f:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f12:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f15:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f18:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100f1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f20:	e8 9b 37 00 00       	call   801046c0 <release>

  if(ff.type == FD_PIPE)
80100f25:	83 c4 10             	add    $0x10,%esp
80100f28:	83 ff 01             	cmp    $0x1,%edi
80100f2b:	74 53                	je     80100f80 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f2d:	83 ff 02             	cmp    $0x2,%edi
80100f30:	74 26                	je     80100f58 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f35:	5b                   	pop    %ebx
80100f36:	5e                   	pop    %esi
80100f37:	5f                   	pop    %edi
80100f38:	5d                   	pop    %ebp
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f40:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
}
80100f47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f4a:	5b                   	pop    %ebx
80100f4b:	5e                   	pop    %esi
80100f4c:	5f                   	pop    %edi
80100f4d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f4e:	e9 6d 37 00 00       	jmp    801046c0 <release>
80100f53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f57:	90                   	nop
    begin_op();
80100f58:	e8 e3 1d 00 00       	call   80102d40 <begin_op>
    iput(ff.ip);
80100f5d:	83 ec 0c             	sub    $0xc,%esp
80100f60:	ff 75 e0             	pushl  -0x20(%ebp)
80100f63:	e8 38 09 00 00       	call   801018a0 <iput>
    end_op();
80100f68:	83 c4 10             	add    $0x10,%esp
}
80100f6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6e:	5b                   	pop    %ebx
80100f6f:	5e                   	pop    %esi
80100f70:	5f                   	pop    %edi
80100f71:	5d                   	pop    %ebp
    end_op();
80100f72:	e9 39 1e 00 00       	jmp    80102db0 <end_op>
80100f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f7e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f80:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f84:	83 ec 08             	sub    $0x8,%esp
80100f87:	53                   	push   %ebx
80100f88:	56                   	push   %esi
80100f89:	e8 82 25 00 00       	call   80103510 <pipeclose>
80100f8e:	83 c4 10             	add    $0x10,%esp
}
80100f91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f94:	5b                   	pop    %ebx
80100f95:	5e                   	pop    %esi
80100f96:	5f                   	pop    %edi
80100f97:	5d                   	pop    %ebp
80100f98:	c3                   	ret    
    panic("fileclose");
80100f99:	83 ec 0c             	sub    $0xc,%esp
80100f9c:	68 7c 72 10 80       	push   $0x8010727c
80100fa1:	e8 ea f3 ff ff       	call   80100390 <panic>
80100fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fad:	8d 76 00             	lea    0x0(%esi),%esi

80100fb0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fb0:	f3 0f 1e fb          	endbr32 
80100fb4:	55                   	push   %ebp
80100fb5:	89 e5                	mov    %esp,%ebp
80100fb7:	53                   	push   %ebx
80100fb8:	83 ec 04             	sub    $0x4,%esp
80100fbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fbe:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fc1:	75 2d                	jne    80100ff0 <filestat+0x40>
    ilock(f->ip);
80100fc3:	83 ec 0c             	sub    $0xc,%esp
80100fc6:	ff 73 10             	pushl  0x10(%ebx)
80100fc9:	e8 a2 07 00 00       	call   80101770 <ilock>
    stati(f->ip, st);
80100fce:	58                   	pop    %eax
80100fcf:	5a                   	pop    %edx
80100fd0:	ff 75 0c             	pushl  0xc(%ebp)
80100fd3:	ff 73 10             	pushl  0x10(%ebx)
80100fd6:	e8 65 0a 00 00       	call   80101a40 <stati>
    iunlock(f->ip);
80100fdb:	59                   	pop    %ecx
80100fdc:	ff 73 10             	pushl  0x10(%ebx)
80100fdf:	e8 6c 08 00 00       	call   80101850 <iunlock>
    return 0;
  }
  return -1;
}
80100fe4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fe7:	83 c4 10             	add    $0x10,%esp
80100fea:	31 c0                	xor    %eax,%eax
}
80100fec:	c9                   	leave  
80100fed:	c3                   	ret    
80100fee:	66 90                	xchg   %ax,%ax
80100ff0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100ff3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ff8:	c9                   	leave  
80100ff9:	c3                   	ret    
80100ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101000 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101000:	f3 0f 1e fb          	endbr32 
80101004:	55                   	push   %ebp
80101005:	89 e5                	mov    %esp,%ebp
80101007:	57                   	push   %edi
80101008:	56                   	push   %esi
80101009:	53                   	push   %ebx
8010100a:	83 ec 0c             	sub    $0xc,%esp
8010100d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101010:	8b 75 0c             	mov    0xc(%ebp),%esi
80101013:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101016:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010101a:	74 64                	je     80101080 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010101c:	8b 03                	mov    (%ebx),%eax
8010101e:	83 f8 01             	cmp    $0x1,%eax
80101021:	74 45                	je     80101068 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101023:	83 f8 02             	cmp    $0x2,%eax
80101026:	75 5f                	jne    80101087 <fileread+0x87>
    ilock(f->ip);
80101028:	83 ec 0c             	sub    $0xc,%esp
8010102b:	ff 73 10             	pushl  0x10(%ebx)
8010102e:	e8 3d 07 00 00       	call   80101770 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101033:	57                   	push   %edi
80101034:	ff 73 14             	pushl  0x14(%ebx)
80101037:	56                   	push   %esi
80101038:	ff 73 10             	pushl  0x10(%ebx)
8010103b:	e8 30 0a 00 00       	call   80101a70 <readi>
80101040:	83 c4 20             	add    $0x20,%esp
80101043:	89 c6                	mov    %eax,%esi
80101045:	85 c0                	test   %eax,%eax
80101047:	7e 03                	jle    8010104c <fileread+0x4c>
      f->off += r;
80101049:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010104c:	83 ec 0c             	sub    $0xc,%esp
8010104f:	ff 73 10             	pushl  0x10(%ebx)
80101052:	e8 f9 07 00 00       	call   80101850 <iunlock>
    return r;
80101057:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010105a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010105d:	89 f0                	mov    %esi,%eax
8010105f:	5b                   	pop    %ebx
80101060:	5e                   	pop    %esi
80101061:	5f                   	pop    %edi
80101062:	5d                   	pop    %ebp
80101063:	c3                   	ret    
80101064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101068:	8b 43 0c             	mov    0xc(%ebx),%eax
8010106b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010106e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101071:	5b                   	pop    %ebx
80101072:	5e                   	pop    %esi
80101073:	5f                   	pop    %edi
80101074:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101075:	e9 36 26 00 00       	jmp    801036b0 <piperead>
8010107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101080:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101085:	eb d3                	jmp    8010105a <fileread+0x5a>
  panic("fileread");
80101087:	83 ec 0c             	sub    $0xc,%esp
8010108a:	68 86 72 10 80       	push   $0x80107286
8010108f:	e8 fc f2 ff ff       	call   80100390 <panic>
80101094:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010109b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010109f:	90                   	nop

801010a0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010a0:	f3 0f 1e fb          	endbr32 
801010a4:	55                   	push   %ebp
801010a5:	89 e5                	mov    %esp,%ebp
801010a7:	57                   	push   %edi
801010a8:	56                   	push   %esi
801010a9:	53                   	push   %ebx
801010aa:	83 ec 1c             	sub    $0x1c,%esp
801010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801010b0:	8b 75 08             	mov    0x8(%ebp),%esi
801010b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010b6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010b9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010c0:	0f 84 c1 00 00 00    	je     80101187 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010c6:	8b 06                	mov    (%esi),%eax
801010c8:	83 f8 01             	cmp    $0x1,%eax
801010cb:	0f 84 c3 00 00 00    	je     80101194 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010d1:	83 f8 02             	cmp    $0x2,%eax
801010d4:	0f 85 cc 00 00 00    	jne    801011a6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010dd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010df:	85 c0                	test   %eax,%eax
801010e1:	7f 34                	jg     80101117 <filewrite+0x77>
801010e3:	e9 98 00 00 00       	jmp    80101180 <filewrite+0xe0>
801010e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ef:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010f3:	83 ec 0c             	sub    $0xc,%esp
801010f6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010fc:	e8 4f 07 00 00       	call   80101850 <iunlock>
      end_op();
80101101:	e8 aa 1c 00 00       	call   80102db0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101106:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101109:	83 c4 10             	add    $0x10,%esp
8010110c:	39 c3                	cmp    %eax,%ebx
8010110e:	75 60                	jne    80101170 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101110:	01 df                	add    %ebx,%edi
    while(i < n){
80101112:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101115:	7e 69                	jle    80101180 <filewrite+0xe0>
      int n1 = n - i;
80101117:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010111a:	b8 00 06 00 00       	mov    $0x600,%eax
8010111f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101121:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101127:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010112a:	e8 11 1c 00 00       	call   80102d40 <begin_op>
      ilock(f->ip);
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	ff 76 10             	pushl  0x10(%esi)
80101135:	e8 36 06 00 00       	call   80101770 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010113d:	53                   	push   %ebx
8010113e:	ff 76 14             	pushl  0x14(%esi)
80101141:	01 f8                	add    %edi,%eax
80101143:	50                   	push   %eax
80101144:	ff 76 10             	pushl  0x10(%esi)
80101147:	e8 24 0a 00 00       	call   80101b70 <writei>
8010114c:	83 c4 20             	add    $0x20,%esp
8010114f:	85 c0                	test   %eax,%eax
80101151:	7f 9d                	jg     801010f0 <filewrite+0x50>
      iunlock(f->ip);
80101153:	83 ec 0c             	sub    $0xc,%esp
80101156:	ff 76 10             	pushl  0x10(%esi)
80101159:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010115c:	e8 ef 06 00 00       	call   80101850 <iunlock>
      end_op();
80101161:	e8 4a 1c 00 00       	call   80102db0 <end_op>
      if(r < 0)
80101166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101169:	83 c4 10             	add    $0x10,%esp
8010116c:	85 c0                	test   %eax,%eax
8010116e:	75 17                	jne    80101187 <filewrite+0xe7>
        panic("short filewrite");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 8f 72 10 80       	push   $0x8010728f
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101180:	89 f8                	mov    %edi,%eax
80101182:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101185:	74 05                	je     8010118c <filewrite+0xec>
80101187:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010118c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118f:	5b                   	pop    %ebx
80101190:	5e                   	pop    %esi
80101191:	5f                   	pop    %edi
80101192:	5d                   	pop    %ebp
80101193:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101194:	8b 46 0c             	mov    0xc(%esi),%eax
80101197:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010119a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010119d:	5b                   	pop    %ebx
8010119e:	5e                   	pop    %esi
8010119f:	5f                   	pop    %edi
801011a0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a1:	e9 0a 24 00 00       	jmp    801035b0 <pipewrite>
  panic("filewrite");
801011a6:	83 ec 0c             	sub    $0xc,%esp
801011a9:	68 95 72 10 80       	push   $0x80107295
801011ae:	e8 dd f1 ff ff       	call   80100390 <panic>
801011b3:	66 90                	xchg   %ax,%ax
801011b5:	66 90                	xchg   %ax,%ax
801011b7:	66 90                	xchg   %ax,%ax
801011b9:	66 90                	xchg   %ax,%ax
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 d8 09 11 80    	add    0x801109d8,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011e3:	ba 01 00 00 00       	mov    $0x1,%edx
801011e8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011eb:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011f1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011f4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011f6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011fb:	85 d1                	test   %edx,%ecx
801011fd:	74 25                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011ff:	f7 d2                	not    %edx
  log_write(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101206:	21 ca                	and    %ecx,%edx
80101208:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010120c:	50                   	push   %eax
8010120d:	e8 0e 1d 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 9f 72 10 80       	push   $0x8010729f
8010122c:	e8 5f f1 ff ff       	call   80100390 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	pushl  -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 b2 72 10 80       	push   $0x801072b2
801012e9:	e8 a2 f0 ff ff       	call   80100390 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 1e 1c 00 00       	call   80102f20 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	pushl  -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 e6 33 00 00       	call   80104710 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 ee 1b 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 e0 09 11 80       	push   $0x801109e0
8010136a:	e8 91 32 00 00       	call   80104600 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010138a:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101395:	85 c9                	test   %ecx,%ecx
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	89 d8                	mov    %ebx,%eax
8010139f:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a5:	85 c9                	test   %ecx,%ecx
801013a7:	75 6e                	jne    80101417 <iget+0xc7>
801013a9:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ab:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801013b1:	72 df                	jb     80101392 <iget+0x42>
801013b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013b7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 73                	je     8010142f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 e0 09 11 80       	push   $0x801109e0
801013d7:	e8 e4 32 00 00       	call   801046c0 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
80101402:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 b6 32 00 00       	call   801046c0 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010141d:	73 10                	jae    8010142f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010141f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101422:	85 c9                	test   %ecx,%ecx
80101424:	0f 8f 56 ff ff ff    	jg     80101380 <iget+0x30>
8010142a:	e9 6e ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
8010142f:	83 ec 0c             	sub    $0xc,%esp
80101432:	68 c8 72 10 80       	push   $0x801072c8
80101437:	e8 54 ef ff ff       	call   80100390 <panic>
8010143c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101440 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	57                   	push   %edi
80101444:	56                   	push   %esi
80101445:	89 c6                	mov    %eax,%esi
80101447:	53                   	push   %ebx
80101448:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010144b:	83 fa 0b             	cmp    $0xb,%edx
8010144e:	0f 86 84 00 00 00    	jbe    801014d8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101454:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101457:	83 fb 7f             	cmp    $0x7f,%ebx
8010145a:	0f 87 98 00 00 00    	ja     801014f8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101460:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101466:	8b 16                	mov    (%esi),%edx
80101468:	85 c0                	test   %eax,%eax
8010146a:	74 54                	je     801014c0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010146c:	83 ec 08             	sub    $0x8,%esp
8010146f:	50                   	push   %eax
80101470:	52                   	push   %edx
80101471:	e8 5a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101476:	83 c4 10             	add    $0x10,%esp
80101479:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010147d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010147f:	8b 1a                	mov    (%edx),%ebx
80101481:	85 db                	test   %ebx,%ebx
80101483:	74 1b                	je     801014a0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101485:	83 ec 0c             	sub    $0xc,%esp
80101488:	57                   	push   %edi
80101489:	e8 62 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010148e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101491:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101494:	89 d8                	mov    %ebx,%eax
80101496:	5b                   	pop    %ebx
80101497:	5e                   	pop    %esi
80101498:	5f                   	pop    %edi
80101499:	5d                   	pop    %ebp
8010149a:	c3                   	ret    
8010149b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010149f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801014a0:	8b 06                	mov    (%esi),%eax
801014a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014a5:	e8 96 fd ff ff       	call   80101240 <balloc>
801014aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801014ad:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014b0:	89 c3                	mov    %eax,%ebx
801014b2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014b4:	57                   	push   %edi
801014b5:	e8 66 1a 00 00       	call   80102f20 <log_write>
801014ba:	83 c4 10             	add    $0x10,%esp
801014bd:	eb c6                	jmp    80101485 <bmap+0x45>
801014bf:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014c0:	89 d0                	mov    %edx,%eax
801014c2:	e8 79 fd ff ff       	call   80101240 <balloc>
801014c7:	8b 16                	mov    (%esi),%edx
801014c9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014cf:	eb 9b                	jmp    8010146c <bmap+0x2c>
801014d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014d8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014db:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014de:	85 db                	test   %ebx,%ebx
801014e0:	75 af                	jne    80101491 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014e2:	8b 00                	mov    (%eax),%eax
801014e4:	e8 57 fd ff ff       	call   80101240 <balloc>
801014e9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014ec:	89 c3                	mov    %eax,%ebx
}
801014ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014f1:	89 d8                	mov    %ebx,%eax
801014f3:	5b                   	pop    %ebx
801014f4:	5e                   	pop    %esi
801014f5:	5f                   	pop    %edi
801014f6:	5d                   	pop    %ebp
801014f7:	c3                   	ret    
  panic("bmap: out of range");
801014f8:	83 ec 0c             	sub    $0xc,%esp
801014fb:	68 d8 72 10 80       	push   $0x801072d8
80101500:	e8 8b ee ff ff       	call   80100390 <panic>
80101505:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <readsb>:
{
80101510:	f3 0f 1e fb          	endbr32 
80101514:	55                   	push   %ebp
80101515:	89 e5                	mov    %esp,%ebp
80101517:	56                   	push   %esi
80101518:	53                   	push   %ebx
80101519:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010151c:	83 ec 08             	sub    $0x8,%esp
8010151f:	6a 01                	push   $0x1
80101521:	ff 75 08             	pushl  0x8(%ebp)
80101524:	e8 a7 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101529:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010152c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010152e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101531:	6a 1c                	push   $0x1c
80101533:	50                   	push   %eax
80101534:	56                   	push   %esi
80101535:	e8 76 32 00 00       	call   801047b0 <memmove>
  brelse(bp);
8010153a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010153d:	83 c4 10             	add    $0x10,%esp
}
80101540:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101543:	5b                   	pop    %ebx
80101544:	5e                   	pop    %esi
80101545:	5d                   	pop    %ebp
  brelse(bp);
80101546:	e9 a5 ec ff ff       	jmp    801001f0 <brelse>
8010154b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010154f:	90                   	nop

80101550 <iinit>:
{
80101550:	f3 0f 1e fb          	endbr32 
80101554:	55                   	push   %ebp
80101555:	89 e5                	mov    %esp,%ebp
80101557:	53                   	push   %ebx
80101558:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
8010155d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101560:	68 eb 72 10 80       	push   $0x801072eb
80101565:	68 e0 09 11 80       	push   $0x801109e0
8010156a:	e8 11 2f 00 00       	call   80104480 <initlock>
  for(i = 0; i < NINODE; i++) {
8010156f:	83 c4 10             	add    $0x10,%esp
80101572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101578:	83 ec 08             	sub    $0x8,%esp
8010157b:	68 f2 72 10 80       	push   $0x801072f2
80101580:	53                   	push   %ebx
80101581:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101587:	e8 b4 2d 00 00       	call   80104340 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010158c:	83 c4 10             	add    $0x10,%esp
8010158f:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
80101595:	75 e1                	jne    80101578 <iinit+0x28>
  readsb(dev, &sb);
80101597:	83 ec 08             	sub    $0x8,%esp
8010159a:	68 c0 09 11 80       	push   $0x801109c0
8010159f:	ff 75 08             	pushl  0x8(%ebp)
801015a2:	e8 69 ff ff ff       	call   80101510 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015a7:	ff 35 d8 09 11 80    	pushl  0x801109d8
801015ad:	ff 35 d4 09 11 80    	pushl  0x801109d4
801015b3:	ff 35 d0 09 11 80    	pushl  0x801109d0
801015b9:	ff 35 cc 09 11 80    	pushl  0x801109cc
801015bf:	ff 35 c8 09 11 80    	pushl  0x801109c8
801015c5:	ff 35 c4 09 11 80    	pushl  0x801109c4
801015cb:	ff 35 c0 09 11 80    	pushl  0x801109c0
801015d1:	68 58 73 10 80       	push   $0x80107358
801015d6:	e8 d5 f0 ff ff       	call   801006b0 <cprintf>
}
801015db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015de:	83 c4 30             	add    $0x30,%esp
801015e1:	c9                   	leave  
801015e2:	c3                   	ret    
801015e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015f0 <ialloc>:
{
801015f0:	f3 0f 1e fb          	endbr32 
801015f4:	55                   	push   %ebp
801015f5:	89 e5                	mov    %esp,%ebp
801015f7:	57                   	push   %edi
801015f8:	56                   	push   %esi
801015f9:	53                   	push   %ebx
801015fa:	83 ec 1c             	sub    $0x1c,%esp
801015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101600:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101607:	8b 75 08             	mov    0x8(%ebp),%esi
8010160a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010160d:	0f 86 8d 00 00 00    	jbe    801016a0 <ialloc+0xb0>
80101613:	bf 01 00 00 00       	mov    $0x1,%edi
80101618:	eb 1d                	jmp    80101637 <ialloc+0x47>
8010161a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101620:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101623:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101626:	53                   	push   %ebx
80101627:	e8 c4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010162c:	83 c4 10             	add    $0x10,%esp
8010162f:	3b 3d c8 09 11 80    	cmp    0x801109c8,%edi
80101635:	73 69                	jae    801016a0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101637:	89 f8                	mov    %edi,%eax
80101639:	83 ec 08             	sub    $0x8,%esp
8010163c:	c1 e8 03             	shr    $0x3,%eax
8010163f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101645:	50                   	push   %eax
80101646:	56                   	push   %esi
80101647:	e8 84 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010164c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010164f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101651:	89 f8                	mov    %edi,%eax
80101653:	83 e0 07             	and    $0x7,%eax
80101656:	c1 e0 06             	shl    $0x6,%eax
80101659:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010165d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101661:	75 bd                	jne    80101620 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101663:	83 ec 04             	sub    $0x4,%esp
80101666:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101669:	6a 40                	push   $0x40
8010166b:	6a 00                	push   $0x0
8010166d:	51                   	push   %ecx
8010166e:	e8 9d 30 00 00       	call   80104710 <memset>
      dip->type = type;
80101673:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101677:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010167a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010167d:	89 1c 24             	mov    %ebx,(%esp)
80101680:	e8 9b 18 00 00       	call   80102f20 <log_write>
      brelse(bp);
80101685:	89 1c 24             	mov    %ebx,(%esp)
80101688:	e8 63 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010168d:	83 c4 10             	add    $0x10,%esp
}
80101690:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101693:	89 fa                	mov    %edi,%edx
}
80101695:	5b                   	pop    %ebx
      return iget(dev, inum);
80101696:	89 f0                	mov    %esi,%eax
}
80101698:	5e                   	pop    %esi
80101699:	5f                   	pop    %edi
8010169a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010169b:	e9 b0 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016a0:	83 ec 0c             	sub    $0xc,%esp
801016a3:	68 f8 72 10 80       	push   $0x801072f8
801016a8:	e8 e3 ec ff ff       	call   80100390 <panic>
801016ad:	8d 76 00             	lea    0x0(%esi),%esi

801016b0 <iupdate>:
{
801016b0:	f3 0f 1e fb          	endbr32 
801016b4:	55                   	push   %ebp
801016b5:	89 e5                	mov    %esp,%ebp
801016b7:	56                   	push   %esi
801016b8:	53                   	push   %ebx
801016b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016bc:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016bf:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c2:	83 ec 08             	sub    $0x8,%esp
801016c5:	c1 e8 03             	shr    $0x3,%eax
801016c8:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016ce:	50                   	push   %eax
801016cf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016d7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016e3:	83 e0 07             	and    $0x7,%eax
801016e6:	c1 e0 06             	shl    $0x6,%eax
801016e9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016ed:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016f0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016f7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016fb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ff:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101703:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101707:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
8010170b:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010170e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	53                   	push   %ebx
80101714:	50                   	push   %eax
80101715:	e8 96 30 00 00       	call   801047b0 <memmove>
  log_write(bp);
8010171a:	89 34 24             	mov    %esi,(%esp)
8010171d:	e8 fe 17 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101722:	89 75 08             	mov    %esi,0x8(%ebp)
80101725:	83 c4 10             	add    $0x10,%esp
}
80101728:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010172b:	5b                   	pop    %ebx
8010172c:	5e                   	pop    %esi
8010172d:	5d                   	pop    %ebp
  brelse(bp);
8010172e:	e9 bd ea ff ff       	jmp    801001f0 <brelse>
80101733:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010173a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101740 <idup>:
{
80101740:	f3 0f 1e fb          	endbr32 
80101744:	55                   	push   %ebp
80101745:	89 e5                	mov    %esp,%ebp
80101747:	53                   	push   %ebx
80101748:	83 ec 10             	sub    $0x10,%esp
8010174b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010174e:	68 e0 09 11 80       	push   $0x801109e0
80101753:	e8 a8 2e 00 00       	call   80104600 <acquire>
  ip->ref++;
80101758:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010175c:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101763:	e8 58 2f 00 00       	call   801046c0 <release>
}
80101768:	89 d8                	mov    %ebx,%eax
8010176a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010176d:	c9                   	leave  
8010176e:	c3                   	ret    
8010176f:	90                   	nop

80101770 <ilock>:
{
80101770:	f3 0f 1e fb          	endbr32 
80101774:	55                   	push   %ebp
80101775:	89 e5                	mov    %esp,%ebp
80101777:	56                   	push   %esi
80101778:	53                   	push   %ebx
80101779:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010177c:	85 db                	test   %ebx,%ebx
8010177e:	0f 84 b3 00 00 00    	je     80101837 <ilock+0xc7>
80101784:	8b 53 08             	mov    0x8(%ebx),%edx
80101787:	85 d2                	test   %edx,%edx
80101789:	0f 8e a8 00 00 00    	jle    80101837 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010178f:	83 ec 0c             	sub    $0xc,%esp
80101792:	8d 43 0c             	lea    0xc(%ebx),%eax
80101795:	50                   	push   %eax
80101796:	e8 e5 2b 00 00       	call   80104380 <acquiresleep>
  if(ip->valid == 0){
8010179b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010179e:	83 c4 10             	add    $0x10,%esp
801017a1:	85 c0                	test   %eax,%eax
801017a3:	74 0b                	je     801017b0 <ilock+0x40>
}
801017a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017a8:	5b                   	pop    %ebx
801017a9:	5e                   	pop    %esi
801017aa:	5d                   	pop    %ebp
801017ab:	c3                   	ret    
801017ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017b0:	8b 43 04             	mov    0x4(%ebx),%eax
801017b3:	83 ec 08             	sub    $0x8,%esp
801017b6:	c1 e8 03             	shr    $0x3,%eax
801017b9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801017bf:	50                   	push   %eax
801017c0:	ff 33                	pushl  (%ebx)
801017c2:	e8 09 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017c7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ca:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017cc:	8b 43 04             	mov    0x4(%ebx),%eax
801017cf:	83 e0 07             	and    $0x7,%eax
801017d2:	c1 e0 06             	shl    $0x6,%eax
801017d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017d9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017dc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017df:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017e3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017e7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017eb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017f3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017fb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017fe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101801:	6a 34                	push   $0x34
80101803:	50                   	push   %eax
80101804:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101807:	50                   	push   %eax
80101808:	e8 a3 2f 00 00       	call   801047b0 <memmove>
    brelse(bp);
8010180d:	89 34 24             	mov    %esi,(%esp)
80101810:	e8 db e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101815:	83 c4 10             	add    $0x10,%esp
80101818:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010181d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101824:	0f 85 7b ff ff ff    	jne    801017a5 <ilock+0x35>
      panic("ilock: no type");
8010182a:	83 ec 0c             	sub    $0xc,%esp
8010182d:	68 10 73 10 80       	push   $0x80107310
80101832:	e8 59 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101837:	83 ec 0c             	sub    $0xc,%esp
8010183a:	68 0a 73 10 80       	push   $0x8010730a
8010183f:	e8 4c eb ff ff       	call   80100390 <panic>
80101844:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010184b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010184f:	90                   	nop

80101850 <iunlock>:
{
80101850:	f3 0f 1e fb          	endbr32 
80101854:	55                   	push   %ebp
80101855:	89 e5                	mov    %esp,%ebp
80101857:	56                   	push   %esi
80101858:	53                   	push   %ebx
80101859:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010185c:	85 db                	test   %ebx,%ebx
8010185e:	74 28                	je     80101888 <iunlock+0x38>
80101860:	83 ec 0c             	sub    $0xc,%esp
80101863:	8d 73 0c             	lea    0xc(%ebx),%esi
80101866:	56                   	push   %esi
80101867:	e8 b4 2b 00 00       	call   80104420 <holdingsleep>
8010186c:	83 c4 10             	add    $0x10,%esp
8010186f:	85 c0                	test   %eax,%eax
80101871:	74 15                	je     80101888 <iunlock+0x38>
80101873:	8b 43 08             	mov    0x8(%ebx),%eax
80101876:	85 c0                	test   %eax,%eax
80101878:	7e 0e                	jle    80101888 <iunlock+0x38>
  releasesleep(&ip->lock);
8010187a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010187d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101880:	5b                   	pop    %ebx
80101881:	5e                   	pop    %esi
80101882:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101883:	e9 58 2b 00 00       	jmp    801043e0 <releasesleep>
    panic("iunlock");
80101888:	83 ec 0c             	sub    $0xc,%esp
8010188b:	68 1f 73 10 80       	push   $0x8010731f
80101890:	e8 fb ea ff ff       	call   80100390 <panic>
80101895:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010189c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018a0 <iput>:
{
801018a0:	f3 0f 1e fb          	endbr32 
801018a4:	55                   	push   %ebp
801018a5:	89 e5                	mov    %esp,%ebp
801018a7:	57                   	push   %edi
801018a8:	56                   	push   %esi
801018a9:	53                   	push   %ebx
801018aa:	83 ec 28             	sub    $0x28,%esp
801018ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018b0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018b3:	57                   	push   %edi
801018b4:	e8 c7 2a 00 00       	call   80104380 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018b9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018bc:	83 c4 10             	add    $0x10,%esp
801018bf:	85 d2                	test   %edx,%edx
801018c1:	74 07                	je     801018ca <iput+0x2a>
801018c3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018c8:	74 36                	je     80101900 <iput+0x60>
  releasesleep(&ip->lock);
801018ca:	83 ec 0c             	sub    $0xc,%esp
801018cd:	57                   	push   %edi
801018ce:	e8 0d 2b 00 00       	call   801043e0 <releasesleep>
  acquire(&icache.lock);
801018d3:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018da:	e8 21 2d 00 00       	call   80104600 <acquire>
  ip->ref--;
801018df:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018e3:	83 c4 10             	add    $0x10,%esp
801018e6:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801018ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018f0:	5b                   	pop    %ebx
801018f1:	5e                   	pop    %esi
801018f2:	5f                   	pop    %edi
801018f3:	5d                   	pop    %ebp
  release(&icache.lock);
801018f4:	e9 c7 2d 00 00       	jmp    801046c0 <release>
801018f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101900:	83 ec 0c             	sub    $0xc,%esp
80101903:	68 e0 09 11 80       	push   $0x801109e0
80101908:	e8 f3 2c 00 00       	call   80104600 <acquire>
    int r = ip->ref;
8010190d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101910:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101917:	e8 a4 2d 00 00       	call   801046c0 <release>
    if(r == 1){
8010191c:	83 c4 10             	add    $0x10,%esp
8010191f:	83 fe 01             	cmp    $0x1,%esi
80101922:	75 a6                	jne    801018ca <iput+0x2a>
80101924:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010192a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010192d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101930:	89 cf                	mov    %ecx,%edi
80101932:	eb 0b                	jmp    8010193f <iput+0x9f>
80101934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101938:	83 c6 04             	add    $0x4,%esi
8010193b:	39 fe                	cmp    %edi,%esi
8010193d:	74 19                	je     80101958 <iput+0xb8>
    if(ip->addrs[i]){
8010193f:	8b 16                	mov    (%esi),%edx
80101941:	85 d2                	test   %edx,%edx
80101943:	74 f3                	je     80101938 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101945:	8b 03                	mov    (%ebx),%eax
80101947:	e8 74 f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
8010194c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101952:	eb e4                	jmp    80101938 <iput+0x98>
80101954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101958:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010195e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101961:	85 c0                	test   %eax,%eax
80101963:	75 33                	jne    80101998 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101965:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101968:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010196f:	53                   	push   %ebx
80101970:	e8 3b fd ff ff       	call   801016b0 <iupdate>
      ip->type = 0;
80101975:	31 c0                	xor    %eax,%eax
80101977:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010197b:	89 1c 24             	mov    %ebx,(%esp)
8010197e:	e8 2d fd ff ff       	call   801016b0 <iupdate>
      ip->valid = 0;
80101983:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010198a:	83 c4 10             	add    $0x10,%esp
8010198d:	e9 38 ff ff ff       	jmp    801018ca <iput+0x2a>
80101992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101998:	83 ec 08             	sub    $0x8,%esp
8010199b:	50                   	push   %eax
8010199c:	ff 33                	pushl  (%ebx)
8010199e:	e8 2d e7 ff ff       	call   801000d0 <bread>
801019a3:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a6:	83 c4 10             	add    $0x10,%esp
801019a9:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b5:	89 cf                	mov    %ecx,%edi
801019b7:	eb 0e                	jmp    801019c7 <iput+0x127>
801019b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 19                	je     801019e0 <iput+0x140>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x120>
801019d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019dd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019e0:	83 ec 0c             	sub    $0xc,%esp
801019e3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019e6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019e9:	e8 02 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019ee:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019f4:	8b 03                	mov    (%ebx),%eax
801019f6:	e8 c5 f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019fb:	83 c4 10             	add    $0x10,%esp
801019fe:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a05:	00 00 00 
80101a08:	e9 58 ff ff ff       	jmp    80101965 <iput+0xc5>
80101a0d:	8d 76 00             	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	f3 0f 1e fb          	endbr32 
80101a14:	55                   	push   %ebp
80101a15:	89 e5                	mov    %esp,%ebp
80101a17:	53                   	push   %ebx
80101a18:	83 ec 10             	sub    $0x10,%esp
80101a1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a1e:	53                   	push   %ebx
80101a1f:	e8 2c fe ff ff       	call   80101850 <iunlock>
  iput(ip);
80101a24:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a27:	83 c4 10             	add    $0x10,%esp
}
80101a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a2d:	c9                   	leave  
  iput(ip);
80101a2e:	e9 6d fe ff ff       	jmp    801018a0 <iput>
80101a33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a40 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a40:	f3 0f 1e fb          	endbr32 
80101a44:	55                   	push   %ebp
80101a45:	89 e5                	mov    %esp,%ebp
80101a47:	8b 55 08             	mov    0x8(%ebp),%edx
80101a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a4d:	8b 0a                	mov    (%edx),%ecx
80101a4f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a52:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a55:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a58:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a5c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a5f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a63:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a67:	8b 52 58             	mov    0x58(%edx),%edx
80101a6a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a6d:	5d                   	pop    %ebp
80101a6e:	c3                   	ret    
80101a6f:	90                   	nop

80101a70 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a70:	f3 0f 1e fb          	endbr32 
80101a74:	55                   	push   %ebp
80101a75:	89 e5                	mov    %esp,%ebp
80101a77:	57                   	push   %edi
80101a78:	56                   	push   %esi
80101a79:	53                   	push   %ebx
80101a7a:	83 ec 1c             	sub    $0x1c,%esp
80101a7d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a80:	8b 45 08             	mov    0x8(%ebp),%eax
80101a83:	8b 75 10             	mov    0x10(%ebp),%esi
80101a86:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a89:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a8c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a91:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a94:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a97:	0f 84 a3 00 00 00    	je     80101b40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aa0:	8b 40 58             	mov    0x58(%eax),%eax
80101aa3:	39 c6                	cmp    %eax,%esi
80101aa5:	0f 87 b6 00 00 00    	ja     80101b61 <readi+0xf1>
80101aab:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aae:	31 c9                	xor    %ecx,%ecx
80101ab0:	89 da                	mov    %ebx,%edx
80101ab2:	01 f2                	add    %esi,%edx
80101ab4:	0f 92 c1             	setb   %cl
80101ab7:	89 cf                	mov    %ecx,%edi
80101ab9:	0f 82 a2 00 00 00    	jb     80101b61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101abf:	89 c1                	mov    %eax,%ecx
80101ac1:	29 f1                	sub    %esi,%ecx
80101ac3:	39 d0                	cmp    %edx,%eax
80101ac5:	0f 43 cb             	cmovae %ebx,%ecx
80101ac8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101acb:	85 c9                	test   %ecx,%ecx
80101acd:	74 63                	je     80101b32 <readi+0xc2>
80101acf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ad3:	89 f2                	mov    %esi,%edx
80101ad5:	c1 ea 09             	shr    $0x9,%edx
80101ad8:	89 d8                	mov    %ebx,%eax
80101ada:	e8 61 f9 ff ff       	call   80101440 <bmap>
80101adf:	83 ec 08             	sub    $0x8,%esp
80101ae2:	50                   	push   %eax
80101ae3:	ff 33                	pushl  (%ebx)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aed:	b9 00 02 00 00       	mov    $0x200,%ecx
80101af2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101af7:	89 f0                	mov    %esi,%eax
80101af9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101afe:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b00:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b03:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b05:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b09:	39 d9                	cmp    %ebx,%ecx
80101b0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b0e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b0f:	01 df                	add    %ebx,%edi
80101b11:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b13:	50                   	push   %eax
80101b14:	ff 75 e0             	pushl  -0x20(%ebp)
80101b17:	e8 94 2c 00 00       	call   801047b0 <memmove>
    brelse(bp);
80101b1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b1f:	89 14 24             	mov    %edx,(%esp)
80101b22:	e8 c9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b2a:	83 c4 10             	add    $0x10,%esp
80101b2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b30:	77 9e                	ja     80101ad0 <readi+0x60>
  }
  return n;
80101b32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b38:	5b                   	pop    %ebx
80101b39:	5e                   	pop    %esi
80101b3a:	5f                   	pop    %edi
80101b3b:	5d                   	pop    %ebp
80101b3c:	c3                   	ret    
80101b3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 17                	ja     80101b61 <readi+0xf1>
80101b4a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 0c                	je     80101b61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b5f:	ff e0                	jmp    *%eax
      return -1;
80101b61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b66:	eb cd                	jmp    80101b35 <readi+0xc5>
80101b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b6f:	90                   	nop

80101b70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b70:	f3 0f 1e fb          	endbr32 
80101b74:	55                   	push   %ebp
80101b75:	89 e5                	mov    %esp,%ebp
80101b77:	57                   	push   %edi
80101b78:	56                   	push   %esi
80101b79:	53                   	push   %ebx
80101b7a:	83 ec 1c             	sub    $0x1c,%esp
80101b7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b80:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b83:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b86:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b8b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b91:	8b 75 10             	mov    0x10(%ebp),%esi
80101b94:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b97:	0f 84 b3 00 00 00    	je     80101c50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ba0:	39 70 58             	cmp    %esi,0x58(%eax)
80101ba3:	0f 82 e3 00 00 00    	jb     80101c8c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ba9:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bac:	89 f8                	mov    %edi,%eax
80101bae:	01 f0                	add    %esi,%eax
80101bb0:	0f 82 d6 00 00 00    	jb     80101c8c <writei+0x11c>
80101bb6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bbb:	0f 87 cb 00 00 00    	ja     80101c8c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bc1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bc8:	85 ff                	test   %edi,%edi
80101bca:	74 75                	je     80101c41 <writei+0xd1>
80101bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bd0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bd3:	89 f2                	mov    %esi,%edx
80101bd5:	c1 ea 09             	shr    $0x9,%edx
80101bd8:	89 f8                	mov    %edi,%eax
80101bda:	e8 61 f8 ff ff       	call   80101440 <bmap>
80101bdf:	83 ec 08             	sub    $0x8,%esp
80101be2:	50                   	push   %eax
80101be3:	ff 37                	pushl  (%edi)
80101be5:	e8 e6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bea:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bef:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101bf2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	89 f0                	mov    %esi,%eax
80101bf9:	83 c4 0c             	add    $0xc,%esp
80101bfc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c01:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c07:	39 d9                	cmp    %ebx,%ecx
80101c09:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c0c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c0d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c0f:	ff 75 dc             	pushl  -0x24(%ebp)
80101c12:	50                   	push   %eax
80101c13:	e8 98 2b 00 00       	call   801047b0 <memmove>
    log_write(bp);
80101c18:	89 3c 24             	mov    %edi,(%esp)
80101c1b:	e8 00 13 00 00       	call   80102f20 <log_write>
    brelse(bp);
80101c20:	89 3c 24             	mov    %edi,(%esp)
80101c23:	e8 c8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c2b:	83 c4 10             	add    $0x10,%esp
80101c2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c31:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c37:	77 97                	ja     80101bd0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c3f:	77 37                	ja     80101c78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c47:	5b                   	pop    %ebx
80101c48:	5e                   	pop    %esi
80101c49:	5f                   	pop    %edi
80101c4a:	5d                   	pop    %ebp
80101c4b:	c3                   	ret    
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c54:	66 83 f8 09          	cmp    $0x9,%ax
80101c58:	77 32                	ja     80101c8c <writei+0x11c>
80101c5a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101c61:	85 c0                	test   %eax,%eax
80101c63:	74 27                	je     80101c8c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c6b:	5b                   	pop    %ebx
80101c6c:	5e                   	pop    %esi
80101c6d:	5f                   	pop    %edi
80101c6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c6f:	ff e0                	jmp    *%eax
80101c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c81:	50                   	push   %eax
80101c82:	e8 29 fa ff ff       	call   801016b0 <iupdate>
80101c87:	83 c4 10             	add    $0x10,%esp
80101c8a:	eb b5                	jmp    80101c41 <writei+0xd1>
      return -1;
80101c8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c91:	eb b1                	jmp    80101c44 <writei+0xd4>
80101c93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ca0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ca0:	f3 0f 1e fb          	endbr32 
80101ca4:	55                   	push   %ebp
80101ca5:	89 e5                	mov    %esp,%ebp
80101ca7:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101caa:	6a 0e                	push   $0xe
80101cac:	ff 75 0c             	pushl  0xc(%ebp)
80101caf:	ff 75 08             	pushl  0x8(%ebp)
80101cb2:	e8 69 2b 00 00       	call   80104820 <strncmp>
}
80101cb7:	c9                   	leave  
80101cb8:	c3                   	ret    
80101cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cc0:	f3 0f 1e fb          	endbr32 
80101cc4:	55                   	push   %ebp
80101cc5:	89 e5                	mov    %esp,%ebp
80101cc7:	57                   	push   %edi
80101cc8:	56                   	push   %esi
80101cc9:	53                   	push   %ebx
80101cca:	83 ec 1c             	sub    $0x1c,%esp
80101ccd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cd0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cd5:	0f 85 89 00 00 00    	jne    80101d64 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cdb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cde:	31 ff                	xor    %edi,%edi
80101ce0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ce3:	85 d2                	test   %edx,%edx
80101ce5:	74 42                	je     80101d29 <dirlookup+0x69>
80101ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cee:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101cf0:	6a 10                	push   $0x10
80101cf2:	57                   	push   %edi
80101cf3:	56                   	push   %esi
80101cf4:	53                   	push   %ebx
80101cf5:	e8 76 fd ff ff       	call   80101a70 <readi>
80101cfa:	83 c4 10             	add    $0x10,%esp
80101cfd:	83 f8 10             	cmp    $0x10,%eax
80101d00:	75 55                	jne    80101d57 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101d02:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d07:	74 18                	je     80101d21 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101d09:	83 ec 04             	sub    $0x4,%esp
80101d0c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d0f:	6a 0e                	push   $0xe
80101d11:	50                   	push   %eax
80101d12:	ff 75 0c             	pushl  0xc(%ebp)
80101d15:	e8 06 2b 00 00       	call   80104820 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d1a:	83 c4 10             	add    $0x10,%esp
80101d1d:	85 c0                	test   %eax,%eax
80101d1f:	74 17                	je     80101d38 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d21:	83 c7 10             	add    $0x10,%edi
80101d24:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d27:	72 c7                	jb     80101cf0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d2c:	31 c0                	xor    %eax,%eax
}
80101d2e:	5b                   	pop    %ebx
80101d2f:	5e                   	pop    %esi
80101d30:	5f                   	pop    %edi
80101d31:	5d                   	pop    %ebp
80101d32:	c3                   	ret    
80101d33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d37:	90                   	nop
      if(poff)
80101d38:	8b 45 10             	mov    0x10(%ebp),%eax
80101d3b:	85 c0                	test   %eax,%eax
80101d3d:	74 05                	je     80101d44 <dirlookup+0x84>
        *poff = off;
80101d3f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d42:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d44:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d48:	8b 03                	mov    (%ebx),%eax
80101d4a:	e8 01 f6 ff ff       	call   80101350 <iget>
}
80101d4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d52:	5b                   	pop    %ebx
80101d53:	5e                   	pop    %esi
80101d54:	5f                   	pop    %edi
80101d55:	5d                   	pop    %ebp
80101d56:	c3                   	ret    
      panic("dirlookup read");
80101d57:	83 ec 0c             	sub    $0xc,%esp
80101d5a:	68 39 73 10 80       	push   $0x80107339
80101d5f:	e8 2c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d64:	83 ec 0c             	sub    $0xc,%esp
80101d67:	68 27 73 10 80       	push   $0x80107327
80101d6c:	e8 1f e6 ff ff       	call   80100390 <panic>
80101d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d7f:	90                   	nop

80101d80 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d80:	55                   	push   %ebp
80101d81:	89 e5                	mov    %esp,%ebp
80101d83:	57                   	push   %edi
80101d84:	56                   	push   %esi
80101d85:	53                   	push   %ebx
80101d86:	89 c3                	mov    %eax,%ebx
80101d88:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d8b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d8e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d91:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d94:	0f 84 86 01 00 00    	je     80101f20 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d9a:	e8 e1 1b 00 00       	call   80103980 <myproc>
  acquire(&icache.lock);
80101d9f:	83 ec 0c             	sub    $0xc,%esp
80101da2:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101da4:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101da7:	68 e0 09 11 80       	push   $0x801109e0
80101dac:	e8 4f 28 00 00       	call   80104600 <acquire>
  ip->ref++;
80101db1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101db5:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101dbc:	e8 ff 28 00 00       	call   801046c0 <release>
80101dc1:	83 c4 10             	add    $0x10,%esp
80101dc4:	eb 0d                	jmp    80101dd3 <namex+0x53>
80101dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dcd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dd0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dd3:	0f b6 07             	movzbl (%edi),%eax
80101dd6:	3c 2f                	cmp    $0x2f,%al
80101dd8:	74 f6                	je     80101dd0 <namex+0x50>
  if(*path == 0)
80101dda:	84 c0                	test   %al,%al
80101ddc:	0f 84 ee 00 00 00    	je     80101ed0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101de2:	0f b6 07             	movzbl (%edi),%eax
80101de5:	84 c0                	test   %al,%al
80101de7:	0f 84 fb 00 00 00    	je     80101ee8 <namex+0x168>
80101ded:	89 fb                	mov    %edi,%ebx
80101def:	3c 2f                	cmp    $0x2f,%al
80101df1:	0f 84 f1 00 00 00    	je     80101ee8 <namex+0x168>
80101df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dfe:	66 90                	xchg   %ax,%ax
80101e00:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101e04:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x8f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x80>
  len = path - s;
80101e0f:	89 d8                	mov    %ebx,%eax
80101e11:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e 84 00 00 00    	jle    80101ea0 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	57                   	push   %edi
    path++;
80101e22:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e27:	e8 84 29 00 00       	call   801047b0 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e32:	75 0c                	jne    80101e40 <namex+0xc0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e3b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e3e:	74 f8                	je     80101e38 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 27 f9 ff ff       	call   80101770 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 a1 00 00 00    	jne    80101ef8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e5a:	85 d2                	test   %edx,%edx
80101e5c:	74 09                	je     80101e67 <namex+0xe7>
80101e5e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e61:	0f 84 d9 00 00 00    	je     80101f40 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 4b fe ff ff       	call   80101cc0 <dirlookup>
80101e75:	83 c4 10             	add    $0x10,%esp
80101e78:	89 c3                	mov    %eax,%ebx
80101e7a:	85 c0                	test   %eax,%eax
80101e7c:	74 7a                	je     80101ef8 <namex+0x178>
  iunlock(ip);
80101e7e:	83 ec 0c             	sub    $0xc,%esp
80101e81:	56                   	push   %esi
80101e82:	e8 c9 f9 ff ff       	call   80101850 <iunlock>
  iput(ip);
80101e87:	89 34 24             	mov    %esi,(%esp)
80101e8a:	89 de                	mov    %ebx,%esi
80101e8c:	e8 0f fa ff ff       	call   801018a0 <iput>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	e9 3a ff ff ff       	jmp    80101dd3 <namex+0x53>
80101e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ea0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ea3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101ea6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101ea9:	83 ec 04             	sub    $0x4,%esp
80101eac:	50                   	push   %eax
80101ead:	57                   	push   %edi
    name[len] = 0;
80101eae:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101eb0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101eb3:	e8 f8 28 00 00       	call   801047b0 <memmove>
    name[len] = 0;
80101eb8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ebb:	83 c4 10             	add    $0x10,%esp
80101ebe:	c6 00 00             	movb   $0x0,(%eax)
80101ec1:	e9 69 ff ff ff       	jmp    80101e2f <namex+0xaf>
80101ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ecd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ed0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ed3:	85 c0                	test   %eax,%eax
80101ed5:	0f 85 85 00 00 00    	jne    80101f60 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101edb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ede:	89 f0                	mov    %esi,%eax
80101ee0:	5b                   	pop    %ebx
80101ee1:	5e                   	pop    %esi
80101ee2:	5f                   	pop    %edi
80101ee3:	5d                   	pop    %ebp
80101ee4:	c3                   	ret    
80101ee5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ee8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101eeb:	89 fb                	mov    %edi,%ebx
80101eed:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ef0:	31 c0                	xor    %eax,%eax
80101ef2:	eb b5                	jmp    80101ea9 <namex+0x129>
80101ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ef8:	83 ec 0c             	sub    $0xc,%esp
80101efb:	56                   	push   %esi
80101efc:	e8 4f f9 ff ff       	call   80101850 <iunlock>
  iput(ip);
80101f01:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f04:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f06:	e8 95 f9 ff ff       	call   801018a0 <iput>
      return 0;
80101f0b:	83 c4 10             	add    $0x10,%esp
}
80101f0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f11:	89 f0                	mov    %esi,%eax
80101f13:	5b                   	pop    %ebx
80101f14:	5e                   	pop    %esi
80101f15:	5f                   	pop    %edi
80101f16:	5d                   	pop    %ebp
80101f17:	c3                   	ret    
80101f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f1f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f20:	ba 01 00 00 00       	mov    $0x1,%edx
80101f25:	b8 01 00 00 00       	mov    $0x1,%eax
80101f2a:	89 df                	mov    %ebx,%edi
80101f2c:	e8 1f f4 ff ff       	call   80101350 <iget>
80101f31:	89 c6                	mov    %eax,%esi
80101f33:	e9 9b fe ff ff       	jmp    80101dd3 <namex+0x53>
80101f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f3f:	90                   	nop
      iunlock(ip);
80101f40:	83 ec 0c             	sub    $0xc,%esp
80101f43:	56                   	push   %esi
80101f44:	e8 07 f9 ff ff       	call   80101850 <iunlock>
      return ip;
80101f49:	83 c4 10             	add    $0x10,%esp
}
80101f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f4f:	89 f0                	mov    %esi,%eax
80101f51:	5b                   	pop    %ebx
80101f52:	5e                   	pop    %esi
80101f53:	5f                   	pop    %edi
80101f54:	5d                   	pop    %ebp
80101f55:	c3                   	ret    
80101f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f5d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f60:	83 ec 0c             	sub    $0xc,%esp
80101f63:	56                   	push   %esi
    return 0;
80101f64:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f66:	e8 35 f9 ff ff       	call   801018a0 <iput>
    return 0;
80101f6b:	83 c4 10             	add    $0x10,%esp
80101f6e:	e9 68 ff ff ff       	jmp    80101edb <namex+0x15b>
80101f73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f80 <dirlink>:
{
80101f80:	f3 0f 1e fb          	endbr32 
80101f84:	55                   	push   %ebp
80101f85:	89 e5                	mov    %esp,%ebp
80101f87:	57                   	push   %edi
80101f88:	56                   	push   %esi
80101f89:	53                   	push   %ebx
80101f8a:	83 ec 20             	sub    $0x20,%esp
80101f8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f90:	6a 00                	push   $0x0
80101f92:	ff 75 0c             	pushl  0xc(%ebp)
80101f95:	53                   	push   %ebx
80101f96:	e8 25 fd ff ff       	call   80101cc0 <dirlookup>
80101f9b:	83 c4 10             	add    $0x10,%esp
80101f9e:	85 c0                	test   %eax,%eax
80101fa0:	75 6b                	jne    8010200d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fa2:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fa5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa8:	85 ff                	test   %edi,%edi
80101faa:	74 2d                	je     80101fd9 <dirlink+0x59>
80101fac:	31 ff                	xor    %edi,%edi
80101fae:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fb1:	eb 0d                	jmp    80101fc0 <dirlink+0x40>
80101fb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fb7:	90                   	nop
80101fb8:	83 c7 10             	add    $0x10,%edi
80101fbb:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fbe:	73 19                	jae    80101fd9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fc0:	6a 10                	push   $0x10
80101fc2:	57                   	push   %edi
80101fc3:	56                   	push   %esi
80101fc4:	53                   	push   %ebx
80101fc5:	e8 a6 fa ff ff       	call   80101a70 <readi>
80101fca:	83 c4 10             	add    $0x10,%esp
80101fcd:	83 f8 10             	cmp    $0x10,%eax
80101fd0:	75 4e                	jne    80102020 <dirlink+0xa0>
    if(de.inum == 0)
80101fd2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fd7:	75 df                	jne    80101fb8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fd9:	83 ec 04             	sub    $0x4,%esp
80101fdc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fdf:	6a 0e                	push   $0xe
80101fe1:	ff 75 0c             	pushl  0xc(%ebp)
80101fe4:	50                   	push   %eax
80101fe5:	e8 86 28 00 00       	call   80104870 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fea:	6a 10                	push   $0x10
  de.inum = inum;
80101fec:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fef:	57                   	push   %edi
80101ff0:	56                   	push   %esi
80101ff1:	53                   	push   %ebx
  de.inum = inum;
80101ff2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ff6:	e8 75 fb ff ff       	call   80101b70 <writei>
80101ffb:	83 c4 20             	add    $0x20,%esp
80101ffe:	83 f8 10             	cmp    $0x10,%eax
80102001:	75 2a                	jne    8010202d <dirlink+0xad>
  return 0;
80102003:	31 c0                	xor    %eax,%eax
}
80102005:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102008:	5b                   	pop    %ebx
80102009:	5e                   	pop    %esi
8010200a:	5f                   	pop    %edi
8010200b:	5d                   	pop    %ebp
8010200c:	c3                   	ret    
    iput(ip);
8010200d:	83 ec 0c             	sub    $0xc,%esp
80102010:	50                   	push   %eax
80102011:	e8 8a f8 ff ff       	call   801018a0 <iput>
    return -1;
80102016:	83 c4 10             	add    $0x10,%esp
80102019:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010201e:	eb e5                	jmp    80102005 <dirlink+0x85>
      panic("dirlink read");
80102020:	83 ec 0c             	sub    $0xc,%esp
80102023:	68 48 73 10 80       	push   $0x80107348
80102028:	e8 63 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010202d:	83 ec 0c             	sub    $0xc,%esp
80102030:	68 26 79 10 80       	push   $0x80107926
80102035:	e8 56 e3 ff ff       	call   80100390 <panic>
8010203a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102040 <namei>:

struct inode*
namei(char *path)
{
80102040:	f3 0f 1e fb          	endbr32 
80102044:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102045:	31 d2                	xor    %edx,%edx
{
80102047:	89 e5                	mov    %esp,%ebp
80102049:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010204c:	8b 45 08             	mov    0x8(%ebp),%eax
8010204f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102052:	e8 29 fd ff ff       	call   80101d80 <namex>
}
80102057:	c9                   	leave  
80102058:	c3                   	ret    
80102059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102060 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102060:	f3 0f 1e fb          	endbr32 
80102064:	55                   	push   %ebp
  return namex(path, 1, name);
80102065:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010206a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010206c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010206f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102072:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102073:	e9 08 fd ff ff       	jmp    80101d80 <namex>
80102078:	66 90                	xchg   %ax,%ax
8010207a:	66 90                	xchg   %ax,%ax
8010207c:	66 90                	xchg   %ax,%ax
8010207e:	66 90                	xchg   %ax,%ax

80102080 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102089:	85 c0                	test   %eax,%eax
8010208b:	0f 84 b4 00 00 00    	je     80102145 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102091:	8b 70 08             	mov    0x8(%eax),%esi
80102094:	89 c3                	mov    %eax,%ebx
80102096:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010209c:	0f 87 96 00 00 00    	ja     80102138 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020a2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020ae:	66 90                	xchg   %ax,%ax
801020b0:	89 ca                	mov    %ecx,%edx
801020b2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020b3:	83 e0 c0             	and    $0xffffffc0,%eax
801020b6:	3c 40                	cmp    $0x40,%al
801020b8:	75 f6                	jne    801020b0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020ba:	31 ff                	xor    %edi,%edi
801020bc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020c1:	89 f8                	mov    %edi,%eax
801020c3:	ee                   	out    %al,(%dx)
801020c4:	b8 01 00 00 00       	mov    $0x1,%eax
801020c9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020ce:	ee                   	out    %al,(%dx)
801020cf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020d4:	89 f0                	mov    %esi,%eax
801020d6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020d7:	89 f0                	mov    %esi,%eax
801020d9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020de:	c1 f8 08             	sar    $0x8,%eax
801020e1:	ee                   	out    %al,(%dx)
801020e2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020e7:	89 f8                	mov    %edi,%eax
801020e9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020ea:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801020ee:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020f3:	c1 e0 04             	shl    $0x4,%eax
801020f6:	83 e0 10             	and    $0x10,%eax
801020f9:	83 c8 e0             	or     $0xffffffe0,%eax
801020fc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020fd:	f6 03 04             	testb  $0x4,(%ebx)
80102100:	75 16                	jne    80102118 <idestart+0x98>
80102102:	b8 20 00 00 00       	mov    $0x20,%eax
80102107:	89 ca                	mov    %ecx,%edx
80102109:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010210a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010210d:	5b                   	pop    %ebx
8010210e:	5e                   	pop    %esi
8010210f:	5f                   	pop    %edi
80102110:	5d                   	pop    %ebp
80102111:	c3                   	ret    
80102112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102118:	b8 30 00 00 00       	mov    $0x30,%eax
8010211d:	89 ca                	mov    %ecx,%edx
8010211f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102120:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102125:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102128:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010212d:	fc                   	cld    
8010212e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102130:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102133:	5b                   	pop    %ebx
80102134:	5e                   	pop    %esi
80102135:	5f                   	pop    %edi
80102136:	5d                   	pop    %ebp
80102137:	c3                   	ret    
    panic("incorrect blockno");
80102138:	83 ec 0c             	sub    $0xc,%esp
8010213b:	68 b4 73 10 80       	push   $0x801073b4
80102140:	e8 4b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102145:	83 ec 0c             	sub    $0xc,%esp
80102148:	68 ab 73 10 80       	push   $0x801073ab
8010214d:	e8 3e e2 ff ff       	call   80100390 <panic>
80102152:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102160 <ideinit>:
{
80102160:	f3 0f 1e fb          	endbr32 
80102164:	55                   	push   %ebp
80102165:	89 e5                	mov    %esp,%ebp
80102167:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010216a:	68 c6 73 10 80       	push   $0x801073c6
8010216f:	68 80 a5 10 80       	push   $0x8010a580
80102174:	e8 07 23 00 00       	call   80104480 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102179:	58                   	pop    %eax
8010217a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010217f:	5a                   	pop    %edx
80102180:	83 e8 01             	sub    $0x1,%eax
80102183:	50                   	push   %eax
80102184:	6a 0e                	push   $0xe
80102186:	e8 b5 02 00 00       	call   80102440 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010218b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010218e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102193:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102197:	90                   	nop
80102198:	ec                   	in     (%dx),%al
80102199:	83 e0 c0             	and    $0xffffffc0,%eax
8010219c:	3c 40                	cmp    $0x40,%al
8010219e:	75 f8                	jne    80102198 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021a0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021a5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021aa:	ee                   	out    %al,(%dx)
801021ab:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021b0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021b5:	eb 0e                	jmp    801021c5 <ideinit+0x65>
801021b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021be:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801021c0:	83 e9 01             	sub    $0x1,%ecx
801021c3:	74 0f                	je     801021d4 <ideinit+0x74>
801021c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021c6:	84 c0                	test   %al,%al
801021c8:	74 f6                	je     801021c0 <ideinit+0x60>
      havedisk1 = 1;
801021ca:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
801021d1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021d4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021de:	ee                   	out    %al,(%dx)
}
801021df:	c9                   	leave  
801021e0:	c3                   	ret    
801021e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ef:	90                   	nop

801021f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801021f0:	f3 0f 1e fb          	endbr32 
801021f4:	55                   	push   %ebp
801021f5:	89 e5                	mov    %esp,%ebp
801021f7:	57                   	push   %edi
801021f8:	56                   	push   %esi
801021f9:	53                   	push   %ebx
801021fa:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801021fd:	68 80 a5 10 80       	push   $0x8010a580
80102202:	e8 f9 23 00 00       	call   80104600 <acquire>

  if((b = idequeue) == 0){
80102207:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
8010220d:	83 c4 10             	add    $0x10,%esp
80102210:	85 db                	test   %ebx,%ebx
80102212:	74 5f                	je     80102273 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102214:	8b 43 58             	mov    0x58(%ebx),%eax
80102217:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010221c:	8b 33                	mov    (%ebx),%esi
8010221e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102224:	75 2b                	jne    80102251 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102226:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010222b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010222f:	90                   	nop
80102230:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102231:	89 c1                	mov    %eax,%ecx
80102233:	83 e1 c0             	and    $0xffffffc0,%ecx
80102236:	80 f9 40             	cmp    $0x40,%cl
80102239:	75 f5                	jne    80102230 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010223b:	a8 21                	test   $0x21,%al
8010223d:	75 12                	jne    80102251 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010223f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102242:	b9 80 00 00 00       	mov    $0x80,%ecx
80102247:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010224c:	fc                   	cld    
8010224d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010224f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102251:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102254:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102257:	83 ce 02             	or     $0x2,%esi
8010225a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010225c:	53                   	push   %ebx
8010225d:	e8 be 1e 00 00       	call   80104120 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102262:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102267:	83 c4 10             	add    $0x10,%esp
8010226a:	85 c0                	test   %eax,%eax
8010226c:	74 05                	je     80102273 <ideintr+0x83>
    idestart(idequeue);
8010226e:	e8 0d fe ff ff       	call   80102080 <idestart>
    release(&idelock);
80102273:	83 ec 0c             	sub    $0xc,%esp
80102276:	68 80 a5 10 80       	push   $0x8010a580
8010227b:	e8 40 24 00 00       	call   801046c0 <release>

  release(&idelock);
}
80102280:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102283:	5b                   	pop    %ebx
80102284:	5e                   	pop    %esi
80102285:	5f                   	pop    %edi
80102286:	5d                   	pop    %ebp
80102287:	c3                   	ret    
80102288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228f:	90                   	nop

80102290 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102290:	f3 0f 1e fb          	endbr32 
80102294:	55                   	push   %ebp
80102295:	89 e5                	mov    %esp,%ebp
80102297:	53                   	push   %ebx
80102298:	83 ec 10             	sub    $0x10,%esp
8010229b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010229e:	8d 43 0c             	lea    0xc(%ebx),%eax
801022a1:	50                   	push   %eax
801022a2:	e8 79 21 00 00       	call   80104420 <holdingsleep>
801022a7:	83 c4 10             	add    $0x10,%esp
801022aa:	85 c0                	test   %eax,%eax
801022ac:	0f 84 cf 00 00 00    	je     80102381 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022b2:	8b 03                	mov    (%ebx),%eax
801022b4:	83 e0 06             	and    $0x6,%eax
801022b7:	83 f8 02             	cmp    $0x2,%eax
801022ba:	0f 84 b4 00 00 00    	je     80102374 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022c0:	8b 53 04             	mov    0x4(%ebx),%edx
801022c3:	85 d2                	test   %edx,%edx
801022c5:	74 0d                	je     801022d4 <iderw+0x44>
801022c7:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801022cc:	85 c0                	test   %eax,%eax
801022ce:	0f 84 93 00 00 00    	je     80102367 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022d4:	83 ec 0c             	sub    $0xc,%esp
801022d7:	68 80 a5 10 80       	push   $0x8010a580
801022dc:	e8 1f 23 00 00       	call   80104600 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022e1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
801022e6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022ed:	83 c4 10             	add    $0x10,%esp
801022f0:	85 c0                	test   %eax,%eax
801022f2:	74 6c                	je     80102360 <iderw+0xd0>
801022f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022f8:	89 c2                	mov    %eax,%edx
801022fa:	8b 40 58             	mov    0x58(%eax),%eax
801022fd:	85 c0                	test   %eax,%eax
801022ff:	75 f7                	jne    801022f8 <iderw+0x68>
80102301:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102304:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102306:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010230c:	74 42                	je     80102350 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010230e:	8b 03                	mov    (%ebx),%eax
80102310:	83 e0 06             	and    $0x6,%eax
80102313:	83 f8 02             	cmp    $0x2,%eax
80102316:	74 23                	je     8010233b <iderw+0xab>
80102318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010231f:	90                   	nop
    sleep(b, &idelock);
80102320:	83 ec 08             	sub    $0x8,%esp
80102323:	68 80 a5 10 80       	push   $0x8010a580
80102328:	53                   	push   %ebx
80102329:	e8 32 1c 00 00       	call   80103f60 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010232e:	8b 03                	mov    (%ebx),%eax
80102330:	83 c4 10             	add    $0x10,%esp
80102333:	83 e0 06             	and    $0x6,%eax
80102336:	83 f8 02             	cmp    $0x2,%eax
80102339:	75 e5                	jne    80102320 <iderw+0x90>
  }


  release(&idelock);
8010233b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102342:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102345:	c9                   	leave  
  release(&idelock);
80102346:	e9 75 23 00 00       	jmp    801046c0 <release>
8010234b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010234f:	90                   	nop
    idestart(b);
80102350:	89 d8                	mov    %ebx,%eax
80102352:	e8 29 fd ff ff       	call   80102080 <idestart>
80102357:	eb b5                	jmp    8010230e <iderw+0x7e>
80102359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102360:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102365:	eb 9d                	jmp    80102304 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102367:	83 ec 0c             	sub    $0xc,%esp
8010236a:	68 f5 73 10 80       	push   $0x801073f5
8010236f:	e8 1c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102374:	83 ec 0c             	sub    $0xc,%esp
80102377:	68 e0 73 10 80       	push   $0x801073e0
8010237c:	e8 0f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102381:	83 ec 0c             	sub    $0xc,%esp
80102384:	68 ca 73 10 80       	push   $0x801073ca
80102389:	e8 02 e0 ff ff       	call   80100390 <panic>
8010238e:	66 90                	xchg   %ax,%ax

80102390 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102390:	f3 0f 1e fb          	endbr32 
80102394:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102395:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010239c:	00 c0 fe 
{
8010239f:	89 e5                	mov    %esp,%ebp
801023a1:	56                   	push   %esi
801023a2:	53                   	push   %ebx
  ioapic->reg = reg;
801023a3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023aa:	00 00 00 
  return ioapic->data;
801023ad:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023b3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023b6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023bc:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023c2:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023c9:	c1 ee 10             	shr    $0x10,%esi
801023cc:	89 f0                	mov    %esi,%eax
801023ce:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023d1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801023d4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023d7:	39 c2                	cmp    %eax,%edx
801023d9:	74 16                	je     801023f1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023db:	83 ec 0c             	sub    $0xc,%esp
801023de:	68 14 74 10 80       	push   $0x80107414
801023e3:	e8 c8 e2 ff ff       	call   801006b0 <cprintf>
801023e8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801023ee:	83 c4 10             	add    $0x10,%esp
801023f1:	83 c6 21             	add    $0x21,%esi
{
801023f4:	ba 10 00 00 00       	mov    $0x10,%edx
801023f9:	b8 20 00 00 00       	mov    $0x20,%eax
801023fe:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102400:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102402:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102404:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010240a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010240d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102413:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102416:	8d 5a 01             	lea    0x1(%edx),%ebx
80102419:	83 c2 02             	add    $0x2,%edx
8010241c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010241e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102424:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010242b:	39 f0                	cmp    %esi,%eax
8010242d:	75 d1                	jne    80102400 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010242f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102432:	5b                   	pop    %ebx
80102433:	5e                   	pop    %esi
80102434:	5d                   	pop    %ebp
80102435:	c3                   	ret    
80102436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010243d:	8d 76 00             	lea    0x0(%esi),%esi

80102440 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102440:	f3 0f 1e fb          	endbr32 
80102444:	55                   	push   %ebp
  ioapic->reg = reg;
80102445:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
8010244b:	89 e5                	mov    %esp,%ebp
8010244d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102450:	8d 50 20             	lea    0x20(%eax),%edx
80102453:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102457:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102459:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010245f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102462:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102465:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102468:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010246a:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010246f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102472:	89 50 10             	mov    %edx,0x10(%eax)
}
80102475:	5d                   	pop    %ebp
80102476:	c3                   	ret    
80102477:	66 90                	xchg   %ax,%ax
80102479:	66 90                	xchg   %ax,%ax
8010247b:	66 90                	xchg   %ax,%ax
8010247d:	66 90                	xchg   %ax,%ax
8010247f:	90                   	nop

80102480 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102480:	f3 0f 1e fb          	endbr32 
80102484:	55                   	push   %ebp
80102485:	89 e5                	mov    %esp,%ebp
80102487:	53                   	push   %ebx
80102488:	83 ec 04             	sub    $0x4,%esp
8010248b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010248e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102494:	75 7a                	jne    80102510 <kfree+0x90>
80102496:	81 fb a8 55 11 80    	cmp    $0x801155a8,%ebx
8010249c:	72 72                	jb     80102510 <kfree+0x90>
8010249e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024a4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024a9:	77 65                	ja     80102510 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024ab:	83 ec 04             	sub    $0x4,%esp
801024ae:	68 00 10 00 00       	push   $0x1000
801024b3:	6a 01                	push   $0x1
801024b5:	53                   	push   %ebx
801024b6:	e8 55 22 00 00       	call   80104710 <memset>

  if(kmem.use_lock)
801024bb:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024c1:	83 c4 10             	add    $0x10,%esp
801024c4:	85 d2                	test   %edx,%edx
801024c6:	75 20                	jne    801024e8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024c8:	a1 78 26 11 80       	mov    0x80112678,%eax
801024cd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024cf:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
801024d4:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801024da:	85 c0                	test   %eax,%eax
801024dc:	75 22                	jne    80102500 <kfree+0x80>
    release(&kmem.lock);
}
801024de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024e1:	c9                   	leave  
801024e2:	c3                   	ret    
801024e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024e7:	90                   	nop
    acquire(&kmem.lock);
801024e8:	83 ec 0c             	sub    $0xc,%esp
801024eb:	68 40 26 11 80       	push   $0x80112640
801024f0:	e8 0b 21 00 00       	call   80104600 <acquire>
801024f5:	83 c4 10             	add    $0x10,%esp
801024f8:	eb ce                	jmp    801024c8 <kfree+0x48>
801024fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102500:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102507:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010250a:	c9                   	leave  
    release(&kmem.lock);
8010250b:	e9 b0 21 00 00       	jmp    801046c0 <release>
    panic("kfree");
80102510:	83 ec 0c             	sub    $0xc,%esp
80102513:	68 46 74 10 80       	push   $0x80107446
80102518:	e8 73 de ff ff       	call   80100390 <panic>
8010251d:	8d 76 00             	lea    0x0(%esi),%esi

80102520 <freerange>:
{
80102520:	f3 0f 1e fb          	endbr32 
80102524:	55                   	push   %ebp
80102525:	89 e5                	mov    %esp,%ebp
80102527:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102528:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010252b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010252e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010252f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102535:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010253b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102541:	39 de                	cmp    %ebx,%esi
80102543:	72 1f                	jb     80102564 <freerange+0x44>
80102545:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102551:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102557:	50                   	push   %eax
80102558:	e8 23 ff ff ff       	call   80102480 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	39 f3                	cmp    %esi,%ebx
80102562:	76 e4                	jbe    80102548 <freerange+0x28>
}
80102564:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102567:	5b                   	pop    %ebx
80102568:	5e                   	pop    %esi
80102569:	5d                   	pop    %ebp
8010256a:	c3                   	ret    
8010256b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010256f:	90                   	nop

80102570 <kinit1>:
{
80102570:	f3 0f 1e fb          	endbr32 
80102574:	55                   	push   %ebp
80102575:	89 e5                	mov    %esp,%ebp
80102577:	56                   	push   %esi
80102578:	53                   	push   %ebx
80102579:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010257c:	83 ec 08             	sub    $0x8,%esp
8010257f:	68 4c 74 10 80       	push   $0x8010744c
80102584:	68 40 26 11 80       	push   $0x80112640
80102589:	e8 f2 1e 00 00       	call   80104480 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010258e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102594:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
8010259b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010259e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025a4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025aa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025b0:	39 de                	cmp    %ebx,%esi
801025b2:	72 20                	jb     801025d4 <kinit1+0x64>
801025b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025b8:	83 ec 0c             	sub    $0xc,%esp
801025bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025c7:	50                   	push   %eax
801025c8:	e8 b3 fe ff ff       	call   80102480 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025cd:	83 c4 10             	add    $0x10,%esp
801025d0:	39 de                	cmp    %ebx,%esi
801025d2:	73 e4                	jae    801025b8 <kinit1+0x48>
}
801025d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025d7:	5b                   	pop    %ebx
801025d8:	5e                   	pop    %esi
801025d9:	5d                   	pop    %ebp
801025da:	c3                   	ret    
801025db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025df:	90                   	nop

801025e0 <kinit2>:
{
801025e0:	f3 0f 1e fb          	endbr32 
801025e4:	55                   	push   %ebp
801025e5:	89 e5                	mov    %esp,%ebp
801025e7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025e8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025eb:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ee:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025ef:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025f5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102601:	39 de                	cmp    %ebx,%esi
80102603:	72 1f                	jb     80102624 <kinit2+0x44>
80102605:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102608:	83 ec 0c             	sub    $0xc,%esp
8010260b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102611:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102617:	50                   	push   %eax
80102618:	e8 63 fe ff ff       	call   80102480 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261d:	83 c4 10             	add    $0x10,%esp
80102620:	39 de                	cmp    %ebx,%esi
80102622:	73 e4                	jae    80102608 <kinit2+0x28>
  kmem.use_lock = 1;
80102624:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010262b:	00 00 00 
}
8010262e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102631:	5b                   	pop    %ebx
80102632:	5e                   	pop    %esi
80102633:	5d                   	pop    %ebp
80102634:	c3                   	ret    
80102635:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010263c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102640 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102640:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102644:	a1 74 26 11 80       	mov    0x80112674,%eax
80102649:	85 c0                	test   %eax,%eax
8010264b:	75 1b                	jne    80102668 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010264d:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
80102652:	85 c0                	test   %eax,%eax
80102654:	74 0a                	je     80102660 <kalloc+0x20>
    kmem.freelist = r->next;
80102656:	8b 10                	mov    (%eax),%edx
80102658:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010265e:	c3                   	ret    
8010265f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102660:	c3                   	ret    
80102661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102668:	55                   	push   %ebp
80102669:	89 e5                	mov    %esp,%ebp
8010266b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010266e:	68 40 26 11 80       	push   $0x80112640
80102673:	e8 88 1f 00 00       	call   80104600 <acquire>
  r = kmem.freelist;
80102678:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010267d:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102683:	83 c4 10             	add    $0x10,%esp
80102686:	85 c0                	test   %eax,%eax
80102688:	74 08                	je     80102692 <kalloc+0x52>
    kmem.freelist = r->next;
8010268a:	8b 08                	mov    (%eax),%ecx
8010268c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102692:	85 d2                	test   %edx,%edx
80102694:	74 16                	je     801026ac <kalloc+0x6c>
    release(&kmem.lock);
80102696:	83 ec 0c             	sub    $0xc,%esp
80102699:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010269c:	68 40 26 11 80       	push   $0x80112640
801026a1:	e8 1a 20 00 00       	call   801046c0 <release>
  return (char*)r;
801026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026a9:	83 c4 10             	add    $0x10,%esp
}
801026ac:	c9                   	leave  
801026ad:	c3                   	ret    
801026ae:	66 90                	xchg   %ax,%ax

801026b0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801026b0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026b4:	ba 64 00 00 00       	mov    $0x64,%edx
801026b9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026ba:	a8 01                	test   $0x1,%al
801026bc:	0f 84 be 00 00 00    	je     80102780 <kbdgetc+0xd0>
{
801026c2:	55                   	push   %ebp
801026c3:	ba 60 00 00 00       	mov    $0x60,%edx
801026c8:	89 e5                	mov    %esp,%ebp
801026ca:	53                   	push   %ebx
801026cb:	ec                   	in     (%dx),%al
  return data;
801026cc:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
    return -1;
  data = inb(KBDATAP);
801026d2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801026d5:	3c e0                	cmp    $0xe0,%al
801026d7:	74 57                	je     80102730 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026d9:	89 d9                	mov    %ebx,%ecx
801026db:	83 e1 40             	and    $0x40,%ecx
801026de:	84 c0                	test   %al,%al
801026e0:	78 5e                	js     80102740 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026e2:	85 c9                	test   %ecx,%ecx
801026e4:	74 09                	je     801026ef <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026e6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026e9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801026ec:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801026ef:	0f b6 8a 80 75 10 80 	movzbl -0x7fef8a80(%edx),%ecx
  shift ^= togglecode[data];
801026f6:	0f b6 82 80 74 10 80 	movzbl -0x7fef8b80(%edx),%eax
  shift |= shiftcode[data];
801026fd:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801026ff:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102701:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102703:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102709:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010270c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010270f:	8b 04 85 60 74 10 80 	mov    -0x7fef8ba0(,%eax,4),%eax
80102716:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010271a:	74 0b                	je     80102727 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010271c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010271f:	83 fa 19             	cmp    $0x19,%edx
80102722:	77 44                	ja     80102768 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102724:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102727:	5b                   	pop    %ebx
80102728:	5d                   	pop    %ebp
80102729:	c3                   	ret    
8010272a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102730:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102733:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102735:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
8010273b:	5b                   	pop    %ebx
8010273c:	5d                   	pop    %ebp
8010273d:	c3                   	ret    
8010273e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102740:	83 e0 7f             	and    $0x7f,%eax
80102743:	85 c9                	test   %ecx,%ecx
80102745:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102748:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010274a:	0f b6 8a 80 75 10 80 	movzbl -0x7fef8a80(%edx),%ecx
80102751:	83 c9 40             	or     $0x40,%ecx
80102754:	0f b6 c9             	movzbl %cl,%ecx
80102757:	f7 d1                	not    %ecx
80102759:	21 d9                	and    %ebx,%ecx
}
8010275b:	5b                   	pop    %ebx
8010275c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010275d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102763:	c3                   	ret    
80102764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102768:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010276b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010276e:	5b                   	pop    %ebx
8010276f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102770:	83 f9 1a             	cmp    $0x1a,%ecx
80102773:	0f 42 c2             	cmovb  %edx,%eax
}
80102776:	c3                   	ret    
80102777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277e:	66 90                	xchg   %ax,%ax
    return -1;
80102780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102785:	c3                   	ret    
80102786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278d:	8d 76 00             	lea    0x0(%esi),%esi

80102790 <kbdintr>:

void
kbdintr(void)
{
80102790:	f3 0f 1e fb          	endbr32 
80102794:	55                   	push   %ebp
80102795:	89 e5                	mov    %esp,%ebp
80102797:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010279a:	68 b0 26 10 80       	push   $0x801026b0
8010279f:	e8 bc e0 ff ff       	call   80100860 <consoleintr>
}
801027a4:	83 c4 10             	add    $0x10,%esp
801027a7:	c9                   	leave  
801027a8:	c3                   	ret    
801027a9:	66 90                	xchg   %ax,%ax
801027ab:	66 90                	xchg   %ax,%ax
801027ad:	66 90                	xchg   %ax,%ax
801027af:	90                   	nop

801027b0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801027b0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801027b4:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801027b9:	85 c0                	test   %eax,%eax
801027bb:	0f 84 c7 00 00 00    	je     80102888 <lapicinit+0xd8>
  lapic[index] = value;
801027c1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027c8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ce:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027d5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027db:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027e2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027e5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027ef:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027f2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027fc:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027ff:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102802:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102809:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010280c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010280f:	8b 50 30             	mov    0x30(%eax),%edx
80102812:	c1 ea 10             	shr    $0x10,%edx
80102815:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010281b:	75 73                	jne    80102890 <lapicinit+0xe0>
  lapic[index] = value;
8010281d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102824:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102827:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102831:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102834:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102837:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010283e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102841:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102844:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010284b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102851:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102858:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010285b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010285e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102865:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102868:	8b 50 20             	mov    0x20(%eax),%edx
8010286b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010286f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102870:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102876:	80 e6 10             	and    $0x10,%dh
80102879:	75 f5                	jne    80102870 <lapicinit+0xc0>
  lapic[index] = value;
8010287b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102882:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102885:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102888:	c3                   	ret    
80102889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102890:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102897:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010289a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010289d:	e9 7b ff ff ff       	jmp    8010281d <lapicinit+0x6d>
801028a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028b0 <lapicid>:

int
lapicid(void)
{
801028b0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801028b4:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028b9:	85 c0                	test   %eax,%eax
801028bb:	74 0b                	je     801028c8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801028bd:	8b 40 20             	mov    0x20(%eax),%eax
801028c0:	c1 e8 18             	shr    $0x18,%eax
801028c3:	c3                   	ret    
801028c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801028c8:	31 c0                	xor    %eax,%eax
}
801028ca:	c3                   	ret    
801028cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028cf:	90                   	nop

801028d0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801028d0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801028d4:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028d9:	85 c0                	test   %eax,%eax
801028db:	74 0d                	je     801028ea <lapiceoi+0x1a>
  lapic[index] = value;
801028dd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028ea:	c3                   	ret    
801028eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028ef:	90                   	nop

801028f0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801028f0:	f3 0f 1e fb          	endbr32 
}
801028f4:	c3                   	ret    
801028f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102900 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102900:	f3 0f 1e fb          	endbr32 
80102904:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102905:	b8 0f 00 00 00       	mov    $0xf,%eax
8010290a:	ba 70 00 00 00       	mov    $0x70,%edx
8010290f:	89 e5                	mov    %esp,%ebp
80102911:	53                   	push   %ebx
80102912:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102915:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102918:	ee                   	out    %al,(%dx)
80102919:	b8 0a 00 00 00       	mov    $0xa,%eax
8010291e:	ba 71 00 00 00       	mov    $0x71,%edx
80102923:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102924:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102926:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102929:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010292f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102931:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102934:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102936:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102939:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010293c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102942:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102947:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010294d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102950:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102957:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010295a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010295d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102964:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102967:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102970:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102973:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102979:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010297c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102982:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102985:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010298b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010298c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010298f:	5d                   	pop    %ebp
80102990:	c3                   	ret    
80102991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299f:	90                   	nop

801029a0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029a0:	f3 0f 1e fb          	endbr32 
801029a4:	55                   	push   %ebp
801029a5:	b8 0b 00 00 00       	mov    $0xb,%eax
801029aa:	ba 70 00 00 00       	mov    $0x70,%edx
801029af:	89 e5                	mov    %esp,%ebp
801029b1:	57                   	push   %edi
801029b2:	56                   	push   %esi
801029b3:	53                   	push   %ebx
801029b4:	83 ec 4c             	sub    $0x4c,%esp
801029b7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029b8:	ba 71 00 00 00       	mov    $0x71,%edx
801029bd:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029be:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c1:	bb 70 00 00 00       	mov    $0x70,%ebx
801029c6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029d0:	31 c0                	xor    %eax,%eax
801029d2:	89 da                	mov    %ebx,%edx
801029d4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d5:	b9 71 00 00 00       	mov    $0x71,%ecx
801029da:	89 ca                	mov    %ecx,%edx
801029dc:	ec                   	in     (%dx),%al
801029dd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e0:	89 da                	mov    %ebx,%edx
801029e2:	b8 02 00 00 00       	mov    $0x2,%eax
801029e7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e8:	89 ca                	mov    %ecx,%edx
801029ea:	ec                   	in     (%dx),%al
801029eb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ee:	89 da                	mov    %ebx,%edx
801029f0:	b8 04 00 00 00       	mov    $0x4,%eax
801029f5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f6:	89 ca                	mov    %ecx,%edx
801029f8:	ec                   	in     (%dx),%al
801029f9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fc:	89 da                	mov    %ebx,%edx
801029fe:	b8 07 00 00 00       	mov    $0x7,%eax
80102a03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a04:	89 ca                	mov    %ecx,%edx
80102a06:	ec                   	in     (%dx),%al
80102a07:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a0a:	89 da                	mov    %ebx,%edx
80102a0c:	b8 08 00 00 00       	mov    $0x8,%eax
80102a11:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a12:	89 ca                	mov    %ecx,%edx
80102a14:	ec                   	in     (%dx),%al
80102a15:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a17:	89 da                	mov    %ebx,%edx
80102a19:	b8 09 00 00 00       	mov    $0x9,%eax
80102a1e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1f:	89 ca                	mov    %ecx,%edx
80102a21:	ec                   	in     (%dx),%al
80102a22:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a2f:	84 c0                	test   %al,%al
80102a31:	78 9d                	js     801029d0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a33:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a37:	89 fa                	mov    %edi,%edx
80102a39:	0f b6 fa             	movzbl %dl,%edi
80102a3c:	89 f2                	mov    %esi,%edx
80102a3e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a41:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a45:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a48:	89 da                	mov    %ebx,%edx
80102a4a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a4d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a50:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a54:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a57:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a5a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a5e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a61:	31 c0                	xor    %eax,%eax
80102a63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a64:	89 ca                	mov    %ecx,%edx
80102a66:	ec                   	in     (%dx),%al
80102a67:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6a:	89 da                	mov    %ebx,%edx
80102a6c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a6f:	b8 02 00 00 00       	mov    $0x2,%eax
80102a74:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a75:	89 ca                	mov    %ecx,%edx
80102a77:	ec                   	in     (%dx),%al
80102a78:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7b:	89 da                	mov    %ebx,%edx
80102a7d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a80:	b8 04 00 00 00       	mov    $0x4,%eax
80102a85:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a86:	89 ca                	mov    %ecx,%edx
80102a88:	ec                   	in     (%dx),%al
80102a89:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8c:	89 da                	mov    %ebx,%edx
80102a8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a91:	b8 07 00 00 00       	mov    $0x7,%eax
80102a96:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a97:	89 ca                	mov    %ecx,%edx
80102a99:	ec                   	in     (%dx),%al
80102a9a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9d:	89 da                	mov    %ebx,%edx
80102a9f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aa2:	b8 08 00 00 00       	mov    $0x8,%eax
80102aa7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa8:	89 ca                	mov    %ecx,%edx
80102aaa:	ec                   	in     (%dx),%al
80102aab:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aae:	89 da                	mov    %ebx,%edx
80102ab0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ab3:	b8 09 00 00 00       	mov    $0x9,%eax
80102ab8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab9:	89 ca                	mov    %ecx,%edx
80102abb:	ec                   	in     (%dx),%al
80102abc:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102abf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ac2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ac5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ac8:	6a 18                	push   $0x18
80102aca:	50                   	push   %eax
80102acb:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ace:	50                   	push   %eax
80102acf:	e8 8c 1c 00 00       	call   80104760 <memcmp>
80102ad4:	83 c4 10             	add    $0x10,%esp
80102ad7:	85 c0                	test   %eax,%eax
80102ad9:	0f 85 f1 fe ff ff    	jne    801029d0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102adf:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ae3:	75 78                	jne    80102b5d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ae5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ae8:	89 c2                	mov    %eax,%edx
80102aea:	83 e0 0f             	and    $0xf,%eax
80102aed:	c1 ea 04             	shr    $0x4,%edx
80102af0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102af3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102af6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102af9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102afc:	89 c2                	mov    %eax,%edx
80102afe:	83 e0 0f             	and    $0xf,%eax
80102b01:	c1 ea 04             	shr    $0x4,%edx
80102b04:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b07:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b0a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b0d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b10:	89 c2                	mov    %eax,%edx
80102b12:	83 e0 0f             	and    $0xf,%eax
80102b15:	c1 ea 04             	shr    $0x4,%edx
80102b18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b21:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b24:	89 c2                	mov    %eax,%edx
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b32:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b35:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b49:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b5d:	8b 75 08             	mov    0x8(%ebp),%esi
80102b60:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b63:	89 06                	mov    %eax,(%esi)
80102b65:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b68:	89 46 04             	mov    %eax,0x4(%esi)
80102b6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b6e:	89 46 08             	mov    %eax,0x8(%esi)
80102b71:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b74:	89 46 0c             	mov    %eax,0xc(%esi)
80102b77:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b7a:	89 46 10             	mov    %eax,0x10(%esi)
80102b7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b80:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b83:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b8d:	5b                   	pop    %ebx
80102b8e:	5e                   	pop    %esi
80102b8f:	5f                   	pop    %edi
80102b90:	5d                   	pop    %ebp
80102b91:	c3                   	ret    
80102b92:	66 90                	xchg   %ax,%ax
80102b94:	66 90                	xchg   %ax,%ax
80102b96:	66 90                	xchg   %ax,%ax
80102b98:	66 90                	xchg   %ax,%ax
80102b9a:	66 90                	xchg   %ax,%ax
80102b9c:	66 90                	xchg   %ax,%ax
80102b9e:	66 90                	xchg   %ax,%ax

80102ba0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ba0:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102ba6:	85 c9                	test   %ecx,%ecx
80102ba8:	0f 8e 8a 00 00 00    	jle    80102c38 <install_trans+0x98>
{
80102bae:	55                   	push   %ebp
80102baf:	89 e5                	mov    %esp,%ebp
80102bb1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bb2:	31 ff                	xor    %edi,%edi
{
80102bb4:	56                   	push   %esi
80102bb5:	53                   	push   %ebx
80102bb6:	83 ec 0c             	sub    $0xc,%esp
80102bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bc0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102bc5:	83 ec 08             	sub    $0x8,%esp
80102bc8:	01 f8                	add    %edi,%eax
80102bca:	83 c0 01             	add    $0x1,%eax
80102bcd:	50                   	push   %eax
80102bce:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102bd4:	e8 f7 d4 ff ff       	call   801000d0 <bread>
80102bd9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdb:	58                   	pop    %eax
80102bdc:	5a                   	pop    %edx
80102bdd:	ff 34 bd cc 26 11 80 	pushl  -0x7feed934(,%edi,4)
80102be4:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102bea:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bed:	e8 de d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bf5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bfa:	68 00 02 00 00       	push   $0x200
80102bff:	50                   	push   %eax
80102c00:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c03:	50                   	push   %eax
80102c04:	e8 a7 1b 00 00       	call   801047b0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c09:	89 1c 24             	mov    %ebx,(%esp)
80102c0c:	e8 9f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c11:	89 34 24             	mov    %esi,(%esp)
80102c14:	e8 d7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c19:	89 1c 24             	mov    %ebx,(%esp)
80102c1c:	e8 cf d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c21:	83 c4 10             	add    $0x10,%esp
80102c24:	39 3d c8 26 11 80    	cmp    %edi,0x801126c8
80102c2a:	7f 94                	jg     80102bc0 <install_trans+0x20>
  }
}
80102c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c2f:	5b                   	pop    %ebx
80102c30:	5e                   	pop    %esi
80102c31:	5f                   	pop    %edi
80102c32:	5d                   	pop    %ebp
80102c33:	c3                   	ret    
80102c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c38:	c3                   	ret    
80102c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	53                   	push   %ebx
80102c44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c47:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102c4d:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c53:	e8 78 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c58:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c5b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c5d:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102c62:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c65:	85 c0                	test   %eax,%eax
80102c67:	7e 19                	jle    80102c82 <write_head+0x42>
80102c69:	31 d2                	xor    %edx,%edx
80102c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c6f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c70:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102c77:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c7b:	83 c2 01             	add    $0x1,%edx
80102c7e:	39 d0                	cmp    %edx,%eax
80102c80:	75 ee                	jne    80102c70 <write_head+0x30>
  }
  bwrite(buf);
80102c82:	83 ec 0c             	sub    $0xc,%esp
80102c85:	53                   	push   %ebx
80102c86:	e8 25 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c8b:	89 1c 24             	mov    %ebx,(%esp)
80102c8e:	e8 5d d5 ff ff       	call   801001f0 <brelse>
}
80102c93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c96:	83 c4 10             	add    $0x10,%esp
80102c99:	c9                   	leave  
80102c9a:	c3                   	ret    
80102c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c9f:	90                   	nop

80102ca0 <initlog>:
{
80102ca0:	f3 0f 1e fb          	endbr32 
80102ca4:	55                   	push   %ebp
80102ca5:	89 e5                	mov    %esp,%ebp
80102ca7:	53                   	push   %ebx
80102ca8:	83 ec 2c             	sub    $0x2c,%esp
80102cab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cae:	68 80 76 10 80       	push   $0x80107680
80102cb3:	68 80 26 11 80       	push   $0x80112680
80102cb8:	e8 c3 17 00 00       	call   80104480 <initlock>
  readsb(dev, &sb);
80102cbd:	58                   	pop    %eax
80102cbe:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cc1:	5a                   	pop    %edx
80102cc2:	50                   	push   %eax
80102cc3:	53                   	push   %ebx
80102cc4:	e8 47 e8 ff ff       	call   80101510 <readsb>
  log.start = sb.logstart;
80102cc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ccc:	59                   	pop    %ecx
  log.dev = dev;
80102ccd:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102cd3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cd6:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102cdb:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  struct buf *buf = bread(log.dev, log.start);
80102ce1:	5a                   	pop    %edx
80102ce2:	50                   	push   %eax
80102ce3:	53                   	push   %ebx
80102ce4:	e8 e7 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ce9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102cec:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102cef:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102cf5:	85 c9                	test   %ecx,%ecx
80102cf7:	7e 19                	jle    80102d12 <initlog+0x72>
80102cf9:	31 d2                	xor    %edx,%edx
80102cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cff:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d00:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102d04:	89 1c 95 cc 26 11 80 	mov    %ebx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d0b:	83 c2 01             	add    $0x1,%edx
80102d0e:	39 d1                	cmp    %edx,%ecx
80102d10:	75 ee                	jne    80102d00 <initlog+0x60>
  brelse(buf);
80102d12:	83 ec 0c             	sub    $0xc,%esp
80102d15:	50                   	push   %eax
80102d16:	e8 d5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d1b:	e8 80 fe ff ff       	call   80102ba0 <install_trans>
  log.lh.n = 0;
80102d20:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102d27:	00 00 00 
  write_head(); // clear the log
80102d2a:	e8 11 ff ff ff       	call   80102c40 <write_head>
}
80102d2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d32:	83 c4 10             	add    $0x10,%esp
80102d35:	c9                   	leave  
80102d36:	c3                   	ret    
80102d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d3e:	66 90                	xchg   %ax,%ax

80102d40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d40:	f3 0f 1e fb          	endbr32 
80102d44:	55                   	push   %ebp
80102d45:	89 e5                	mov    %esp,%ebp
80102d47:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d4a:	68 80 26 11 80       	push   $0x80112680
80102d4f:	e8 ac 18 00 00       	call   80104600 <acquire>
80102d54:	83 c4 10             	add    $0x10,%esp
80102d57:	eb 1c                	jmp    80102d75 <begin_op+0x35>
80102d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d60:	83 ec 08             	sub    $0x8,%esp
80102d63:	68 80 26 11 80       	push   $0x80112680
80102d68:	68 80 26 11 80       	push   $0x80112680
80102d6d:	e8 ee 11 00 00       	call   80103f60 <sleep>
80102d72:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d75:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102d7a:	85 c0                	test   %eax,%eax
80102d7c:	75 e2                	jne    80102d60 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d7e:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d83:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d89:	83 c0 01             	add    $0x1,%eax
80102d8c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d8f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d92:	83 fa 1e             	cmp    $0x1e,%edx
80102d95:	7f c9                	jg     80102d60 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d97:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d9a:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102d9f:	68 80 26 11 80       	push   $0x80112680
80102da4:	e8 17 19 00 00       	call   801046c0 <release>
      break;
    }
  }
}
80102da9:	83 c4 10             	add    $0x10,%esp
80102dac:	c9                   	leave  
80102dad:	c3                   	ret    
80102dae:	66 90                	xchg   %ax,%ax

80102db0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102db0:	f3 0f 1e fb          	endbr32 
80102db4:	55                   	push   %ebp
80102db5:	89 e5                	mov    %esp,%ebp
80102db7:	57                   	push   %edi
80102db8:	56                   	push   %esi
80102db9:	53                   	push   %ebx
80102dba:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dbd:	68 80 26 11 80       	push   $0x80112680
80102dc2:	e8 39 18 00 00       	call   80104600 <acquire>
  log.outstanding -= 1;
80102dc7:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102dcc:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102dd2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dd5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102dd8:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102dde:	85 f6                	test   %esi,%esi
80102de0:	0f 85 1e 01 00 00    	jne    80102f04 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102de6:	85 db                	test   %ebx,%ebx
80102de8:	0f 85 f2 00 00 00    	jne    80102ee0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dee:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102df5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102df8:	83 ec 0c             	sub    $0xc,%esp
80102dfb:	68 80 26 11 80       	push   $0x80112680
80102e00:	e8 bb 18 00 00       	call   801046c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e05:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102e0b:	83 c4 10             	add    $0x10,%esp
80102e0e:	85 c9                	test   %ecx,%ecx
80102e10:	7f 3e                	jg     80102e50 <end_op+0xa0>
    acquire(&log.lock);
80102e12:	83 ec 0c             	sub    $0xc,%esp
80102e15:	68 80 26 11 80       	push   $0x80112680
80102e1a:	e8 e1 17 00 00       	call   80104600 <acquire>
    wakeup(&log);
80102e1f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102e26:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102e2d:	00 00 00 
    wakeup(&log);
80102e30:	e8 eb 12 00 00       	call   80104120 <wakeup>
    release(&log.lock);
80102e35:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e3c:	e8 7f 18 00 00       	call   801046c0 <release>
80102e41:	83 c4 10             	add    $0x10,%esp
}
80102e44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e47:	5b                   	pop    %ebx
80102e48:	5e                   	pop    %esi
80102e49:	5f                   	pop    %edi
80102e4a:	5d                   	pop    %ebp
80102e4b:	c3                   	ret    
80102e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e50:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102e55:	83 ec 08             	sub    $0x8,%esp
80102e58:	01 d8                	add    %ebx,%eax
80102e5a:	83 c0 01             	add    $0x1,%eax
80102e5d:	50                   	push   %eax
80102e5e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102e64:	e8 67 d2 ff ff       	call   801000d0 <bread>
80102e69:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e6b:	58                   	pop    %eax
80102e6c:	5a                   	pop    %edx
80102e6d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102e74:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e7d:	e8 4e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e82:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e85:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e87:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e8a:	68 00 02 00 00       	push   $0x200
80102e8f:	50                   	push   %eax
80102e90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e93:	50                   	push   %eax
80102e94:	e8 17 19 00 00       	call   801047b0 <memmove>
    bwrite(to);  // write the log
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 0f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ea1:	89 3c 24             	mov    %edi,(%esp)
80102ea4:	e8 47 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ea9:	89 34 24             	mov    %esi,(%esp)
80102eac:	e8 3f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102eb1:	83 c4 10             	add    $0x10,%esp
80102eb4:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102eba:	7c 94                	jl     80102e50 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ebc:	e8 7f fd ff ff       	call   80102c40 <write_head>
    install_trans(); // Now install writes to home locations
80102ec1:	e8 da fc ff ff       	call   80102ba0 <install_trans>
    log.lh.n = 0;
80102ec6:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102ecd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ed0:	e8 6b fd ff ff       	call   80102c40 <write_head>
80102ed5:	e9 38 ff ff ff       	jmp    80102e12 <end_op+0x62>
80102eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ee0:	83 ec 0c             	sub    $0xc,%esp
80102ee3:	68 80 26 11 80       	push   $0x80112680
80102ee8:	e8 33 12 00 00       	call   80104120 <wakeup>
  release(&log.lock);
80102eed:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ef4:	e8 c7 17 00 00       	call   801046c0 <release>
80102ef9:	83 c4 10             	add    $0x10,%esp
}
80102efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eff:	5b                   	pop    %ebx
80102f00:	5e                   	pop    %esi
80102f01:	5f                   	pop    %edi
80102f02:	5d                   	pop    %ebp
80102f03:	c3                   	ret    
    panic("log.committing");
80102f04:	83 ec 0c             	sub    $0xc,%esp
80102f07:	68 84 76 10 80       	push   $0x80107684
80102f0c:	e8 7f d4 ff ff       	call   80100390 <panic>
80102f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f1f:	90                   	nop

80102f20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f20:	f3 0f 1e fb          	endbr32 
80102f24:	55                   	push   %ebp
80102f25:	89 e5                	mov    %esp,%ebp
80102f27:	53                   	push   %ebx
80102f28:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f2b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102f31:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f34:	83 fa 1d             	cmp    $0x1d,%edx
80102f37:	0f 8f 91 00 00 00    	jg     80102fce <log_write+0xae>
80102f3d:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102f42:	83 e8 01             	sub    $0x1,%eax
80102f45:	39 c2                	cmp    %eax,%edx
80102f47:	0f 8d 81 00 00 00    	jge    80102fce <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f4d:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102f52:	85 c0                	test   %eax,%eax
80102f54:	0f 8e 81 00 00 00    	jle    80102fdb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f5a:	83 ec 0c             	sub    $0xc,%esp
80102f5d:	68 80 26 11 80       	push   $0x80112680
80102f62:	e8 99 16 00 00       	call   80104600 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f67:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102f6d:	83 c4 10             	add    $0x10,%esp
80102f70:	85 d2                	test   %edx,%edx
80102f72:	7e 4e                	jle    80102fc2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f74:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f77:	31 c0                	xor    %eax,%eax
80102f79:	eb 0c                	jmp    80102f87 <log_write+0x67>
80102f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f7f:	90                   	nop
80102f80:	83 c0 01             	add    $0x1,%eax
80102f83:	39 c2                	cmp    %eax,%edx
80102f85:	74 29                	je     80102fb0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f87:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102f8e:	75 f0                	jne    80102f80 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f90:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102f97:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f9d:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102fa4:	c9                   	leave  
  release(&log.lock);
80102fa5:	e9 16 17 00 00       	jmp    801046c0 <release>
80102faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fb0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
    log.lh.n++;
80102fb7:	83 c2 01             	add    $0x1,%edx
80102fba:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
80102fc0:	eb d5                	jmp    80102f97 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80102fc2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fc5:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102fca:	75 cb                	jne    80102f97 <log_write+0x77>
80102fcc:	eb e9                	jmp    80102fb7 <log_write+0x97>
    panic("too big a transaction");
80102fce:	83 ec 0c             	sub    $0xc,%esp
80102fd1:	68 93 76 10 80       	push   $0x80107693
80102fd6:	e8 b5 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fdb:	83 ec 0c             	sub    $0xc,%esp
80102fde:	68 a9 76 10 80       	push   $0x801076a9
80102fe3:	e8 a8 d3 ff ff       	call   80100390 <panic>
80102fe8:	66 90                	xchg   %ax,%ax
80102fea:	66 90                	xchg   %ax,%ax
80102fec:	66 90                	xchg   %ax,%ax
80102fee:	66 90                	xchg   %ax,%ax

80102ff0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	53                   	push   %ebx
80102ff4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102ff7:	e8 64 09 00 00       	call   80103960 <cpuid>
80102ffc:	89 c3                	mov    %eax,%ebx
80102ffe:	e8 5d 09 00 00       	call   80103960 <cpuid>
80103003:	83 ec 04             	sub    $0x4,%esp
80103006:	53                   	push   %ebx
80103007:	50                   	push   %eax
80103008:	68 c4 76 10 80       	push   $0x801076c4
8010300d:	e8 9e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103012:	e8 f9 29 00 00       	call   80105a10 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103017:	e8 d4 08 00 00       	call   801038f0 <mycpu>
8010301c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010301e:	b8 01 00 00 00       	mov    $0x1,%eax
80103023:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010302a:	e8 21 0c 00 00       	call   80103c50 <scheduler>
8010302f:	90                   	nop

80103030 <mpenter>:
{
80103030:	f3 0f 1e fb          	endbr32 
80103034:	55                   	push   %ebp
80103035:	89 e5                	mov    %esp,%ebp
80103037:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010303a:	e8 a1 3a 00 00       	call   80106ae0 <switchkvm>
  seginit();
8010303f:	e8 0c 3a 00 00       	call   80106a50 <seginit>
  lapicinit();
80103044:	e8 67 f7 ff ff       	call   801027b0 <lapicinit>
  mpmain();
80103049:	e8 a2 ff ff ff       	call   80102ff0 <mpmain>
8010304e:	66 90                	xchg   %ax,%ax

80103050 <main>:
{
80103050:	f3 0f 1e fb          	endbr32 
80103054:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103058:	83 e4 f0             	and    $0xfffffff0,%esp
8010305b:	ff 71 fc             	pushl  -0x4(%ecx)
8010305e:	55                   	push   %ebp
8010305f:	89 e5                	mov    %esp,%ebp
80103061:	53                   	push   %ebx
80103062:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103063:	83 ec 08             	sub    $0x8,%esp
80103066:	68 00 00 40 80       	push   $0x80400000
8010306b:	68 a8 55 11 80       	push   $0x801155a8
80103070:	e8 fb f4 ff ff       	call   80102570 <kinit1>
  kvmalloc();      // kernel page table
80103075:	e8 46 3f 00 00       	call   80106fc0 <kvmalloc>
  mpinit();        // detect other processors
8010307a:	e8 81 01 00 00       	call   80103200 <mpinit>
  lapicinit();     // interrupt controller
8010307f:	e8 2c f7 ff ff       	call   801027b0 <lapicinit>
  seginit();       // segment descriptors
80103084:	e8 c7 39 00 00       	call   80106a50 <seginit>
  picinit();       // disable pic
80103089:	e8 52 03 00 00       	call   801033e0 <picinit>
  ioapicinit();    // another interrupt controller
8010308e:	e8 fd f2 ff ff       	call   80102390 <ioapicinit>
  consoleinit();   // console hardware
80103093:	e8 98 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103098:	e8 73 2c 00 00       	call   80105d10 <uartinit>
  pinit();         // process table
8010309d:	e8 2e 08 00 00       	call   801038d0 <pinit>
  tvinit();        // trap vectors
801030a2:	e8 e9 28 00 00       	call   80105990 <tvinit>
  binit();         // buffer cache
801030a7:	e8 94 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030ac:	e8 3f dd ff ff       	call   80100df0 <fileinit>
  ideinit();       // disk 
801030b1:	e8 aa f0 ff ff       	call   80102160 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030b6:	83 c4 0c             	add    $0xc,%esp
801030b9:	68 8a 00 00 00       	push   $0x8a
801030be:	68 8c a4 10 80       	push   $0x8010a48c
801030c3:	68 00 70 00 80       	push   $0x80007000
801030c8:	e8 e3 16 00 00       	call   801047b0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030cd:	83 c4 10             	add    $0x10,%esp
801030d0:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
801030d7:	00 00 00 
801030da:	05 80 27 11 80       	add    $0x80112780,%eax
801030df:	3d 80 27 11 80       	cmp    $0x80112780,%eax
801030e4:	76 7a                	jbe    80103160 <main+0x110>
801030e6:	bb 80 27 11 80       	mov    $0x80112780,%ebx
801030eb:	eb 1c                	jmp    80103109 <main+0xb9>
801030ed:	8d 76 00             	lea    0x0(%esi),%esi
801030f0:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
801030f7:	00 00 00 
801030fa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103100:	05 80 27 11 80       	add    $0x80112780,%eax
80103105:	39 c3                	cmp    %eax,%ebx
80103107:	73 57                	jae    80103160 <main+0x110>
    if(c == mycpu())  // We've started already.
80103109:	e8 e2 07 00 00       	call   801038f0 <mycpu>
8010310e:	39 c3                	cmp    %eax,%ebx
80103110:	74 de                	je     801030f0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103112:	e8 29 f5 ff ff       	call   80102640 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103117:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010311a:	c7 05 f8 6f 00 80 30 	movl   $0x80103030,0x80006ff8
80103121:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103124:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010312b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010312e:	05 00 10 00 00       	add    $0x1000,%eax
80103133:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103138:	0f b6 03             	movzbl (%ebx),%eax
8010313b:	68 00 70 00 00       	push   $0x7000
80103140:	50                   	push   %eax
80103141:	e8 ba f7 ff ff       	call   80102900 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103146:	83 c4 10             	add    $0x10,%esp
80103149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103150:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103156:	85 c0                	test   %eax,%eax
80103158:	74 f6                	je     80103150 <main+0x100>
8010315a:	eb 94                	jmp    801030f0 <main+0xa0>
8010315c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103160:	83 ec 08             	sub    $0x8,%esp
80103163:	68 00 00 00 8e       	push   $0x8e000000
80103168:	68 00 00 40 80       	push   $0x80400000
8010316d:	e8 6e f4 ff ff       	call   801025e0 <kinit2>
  userinit();      // first user process
80103172:	e8 39 08 00 00       	call   801039b0 <userinit>
  mpmain();        // finish this processor's setup
80103177:	e8 74 fe ff ff       	call   80102ff0 <mpmain>
8010317c:	66 90                	xchg   %ax,%ax
8010317e:	66 90                	xchg   %ax,%ax

80103180 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103180:	55                   	push   %ebp
80103181:	89 e5                	mov    %esp,%ebp
80103183:	57                   	push   %edi
80103184:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103185:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010318b:	53                   	push   %ebx
  e = addr+len;
8010318c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010318f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103192:	39 de                	cmp    %ebx,%esi
80103194:	72 10                	jb     801031a6 <mpsearch1+0x26>
80103196:	eb 50                	jmp    801031e8 <mpsearch1+0x68>
80103198:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010319f:	90                   	nop
801031a0:	89 fe                	mov    %edi,%esi
801031a2:	39 fb                	cmp    %edi,%ebx
801031a4:	76 42                	jbe    801031e8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031a6:	83 ec 04             	sub    $0x4,%esp
801031a9:	8d 7e 10             	lea    0x10(%esi),%edi
801031ac:	6a 04                	push   $0x4
801031ae:	68 d8 76 10 80       	push   $0x801076d8
801031b3:	56                   	push   %esi
801031b4:	e8 a7 15 00 00       	call   80104760 <memcmp>
801031b9:	83 c4 10             	add    $0x10,%esp
801031bc:	85 c0                	test   %eax,%eax
801031be:	75 e0                	jne    801031a0 <mpsearch1+0x20>
801031c0:	89 f2                	mov    %esi,%edx
801031c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031c8:	0f b6 0a             	movzbl (%edx),%ecx
801031cb:	83 c2 01             	add    $0x1,%edx
801031ce:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031d0:	39 fa                	cmp    %edi,%edx
801031d2:	75 f4                	jne    801031c8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031d4:	84 c0                	test   %al,%al
801031d6:	75 c8                	jne    801031a0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031db:	89 f0                	mov    %esi,%eax
801031dd:	5b                   	pop    %ebx
801031de:	5e                   	pop    %esi
801031df:	5f                   	pop    %edi
801031e0:	5d                   	pop    %ebp
801031e1:	c3                   	ret    
801031e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031eb:	31 f6                	xor    %esi,%esi
}
801031ed:	5b                   	pop    %ebx
801031ee:	89 f0                	mov    %esi,%eax
801031f0:	5e                   	pop    %esi
801031f1:	5f                   	pop    %edi
801031f2:	5d                   	pop    %ebp
801031f3:	c3                   	ret    
801031f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031ff:	90                   	nop

80103200 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103200:	f3 0f 1e fb          	endbr32 
80103204:	55                   	push   %ebp
80103205:	89 e5                	mov    %esp,%ebp
80103207:	57                   	push   %edi
80103208:	56                   	push   %esi
80103209:	53                   	push   %ebx
8010320a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010320d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103214:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010321b:	c1 e0 08             	shl    $0x8,%eax
8010321e:	09 d0                	or     %edx,%eax
80103220:	c1 e0 04             	shl    $0x4,%eax
80103223:	75 1b                	jne    80103240 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103225:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010322c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103233:	c1 e0 08             	shl    $0x8,%eax
80103236:	09 d0                	or     %edx,%eax
80103238:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010323b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103240:	ba 00 04 00 00       	mov    $0x400,%edx
80103245:	e8 36 ff ff ff       	call   80103180 <mpsearch1>
8010324a:	89 c6                	mov    %eax,%esi
8010324c:	85 c0                	test   %eax,%eax
8010324e:	0f 84 4c 01 00 00    	je     801033a0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103254:	8b 5e 04             	mov    0x4(%esi),%ebx
80103257:	85 db                	test   %ebx,%ebx
80103259:	0f 84 61 01 00 00    	je     801033c0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010325f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103262:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103268:	6a 04                	push   $0x4
8010326a:	68 dd 76 10 80       	push   $0x801076dd
8010326f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103270:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103273:	e8 e8 14 00 00       	call   80104760 <memcmp>
80103278:	83 c4 10             	add    $0x10,%esp
8010327b:	85 c0                	test   %eax,%eax
8010327d:	0f 85 3d 01 00 00    	jne    801033c0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103283:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010328a:	3c 01                	cmp    $0x1,%al
8010328c:	74 08                	je     80103296 <mpinit+0x96>
8010328e:	3c 04                	cmp    $0x4,%al
80103290:	0f 85 2a 01 00 00    	jne    801033c0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103296:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010329d:	66 85 d2             	test   %dx,%dx
801032a0:	74 26                	je     801032c8 <mpinit+0xc8>
801032a2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801032a5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801032a7:	31 d2                	xor    %edx,%edx
801032a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032b0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801032b7:	83 c0 01             	add    $0x1,%eax
801032ba:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032bc:	39 f8                	cmp    %edi,%eax
801032be:	75 f0                	jne    801032b0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801032c0:	84 d2                	test   %dl,%dl
801032c2:	0f 85 f8 00 00 00    	jne    801033c0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032c8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032ce:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032d3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801032d9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801032e0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032e5:	03 55 e4             	add    -0x1c(%ebp),%edx
801032e8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032ef:	90                   	nop
801032f0:	39 c2                	cmp    %eax,%edx
801032f2:	76 15                	jbe    80103309 <mpinit+0x109>
    switch(*p){
801032f4:	0f b6 08             	movzbl (%eax),%ecx
801032f7:	80 f9 02             	cmp    $0x2,%cl
801032fa:	74 5c                	je     80103358 <mpinit+0x158>
801032fc:	77 42                	ja     80103340 <mpinit+0x140>
801032fe:	84 c9                	test   %cl,%cl
80103300:	74 6e                	je     80103370 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103302:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103305:	39 c2                	cmp    %eax,%edx
80103307:	77 eb                	ja     801032f4 <mpinit+0xf4>
80103309:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010330c:	85 db                	test   %ebx,%ebx
8010330e:	0f 84 b9 00 00 00    	je     801033cd <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103314:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103318:	74 15                	je     8010332f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010331a:	b8 70 00 00 00       	mov    $0x70,%eax
8010331f:	ba 22 00 00 00       	mov    $0x22,%edx
80103324:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103325:	ba 23 00 00 00       	mov    $0x23,%edx
8010332a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010332b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010332e:	ee                   	out    %al,(%dx)
  }
}
8010332f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103332:	5b                   	pop    %ebx
80103333:	5e                   	pop    %esi
80103334:	5f                   	pop    %edi
80103335:	5d                   	pop    %ebp
80103336:	c3                   	ret    
80103337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010333e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103340:	83 e9 03             	sub    $0x3,%ecx
80103343:	80 f9 01             	cmp    $0x1,%cl
80103346:	76 ba                	jbe    80103302 <mpinit+0x102>
80103348:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010334f:	eb 9f                	jmp    801032f0 <mpinit+0xf0>
80103351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103358:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010335c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010335f:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
80103365:	eb 89                	jmp    801032f0 <mpinit+0xf0>
80103367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010336e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103370:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
80103376:	83 f9 07             	cmp    $0x7,%ecx
80103379:	7f 19                	jg     80103394 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103381:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103385:	83 c1 01             	add    $0x1,%ecx
80103388:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010338e:	88 9f 80 27 11 80    	mov    %bl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
80103394:	83 c0 14             	add    $0x14,%eax
      continue;
80103397:	e9 54 ff ff ff       	jmp    801032f0 <mpinit+0xf0>
8010339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801033a0:	ba 00 00 01 00       	mov    $0x10000,%edx
801033a5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033aa:	e8 d1 fd ff ff       	call   80103180 <mpsearch1>
801033af:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033b1:	85 c0                	test   %eax,%eax
801033b3:	0f 85 9b fe ff ff    	jne    80103254 <mpinit+0x54>
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033c0:	83 ec 0c             	sub    $0xc,%esp
801033c3:	68 e2 76 10 80       	push   $0x801076e2
801033c8:	e8 c3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033cd:	83 ec 0c             	sub    $0xc,%esp
801033d0:	68 fc 76 10 80       	push   $0x801076fc
801033d5:	e8 b6 cf ff ff       	call   80100390 <panic>
801033da:	66 90                	xchg   %ax,%ax
801033dc:	66 90                	xchg   %ax,%ax
801033de:	66 90                	xchg   %ax,%ax

801033e0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801033e0:	f3 0f 1e fb          	endbr32 
801033e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033e9:	ba 21 00 00 00       	mov    $0x21,%edx
801033ee:	ee                   	out    %al,(%dx)
801033ef:	ba a1 00 00 00       	mov    $0xa1,%edx
801033f4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801033f5:	c3                   	ret    
801033f6:	66 90                	xchg   %ax,%ax
801033f8:	66 90                	xchg   %ax,%ax
801033fa:	66 90                	xchg   %ax,%ax
801033fc:	66 90                	xchg   %ax,%ax
801033fe:	66 90                	xchg   %ax,%ax

80103400 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103400:	f3 0f 1e fb          	endbr32 
80103404:	55                   	push   %ebp
80103405:	89 e5                	mov    %esp,%ebp
80103407:	57                   	push   %edi
80103408:	56                   	push   %esi
80103409:	53                   	push   %ebx
8010340a:	83 ec 0c             	sub    $0xc,%esp
8010340d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103410:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103413:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103419:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010341f:	e8 ec d9 ff ff       	call   80100e10 <filealloc>
80103424:	89 03                	mov    %eax,(%ebx)
80103426:	85 c0                	test   %eax,%eax
80103428:	0f 84 ac 00 00 00    	je     801034da <pipealloc+0xda>
8010342e:	e8 dd d9 ff ff       	call   80100e10 <filealloc>
80103433:	89 06                	mov    %eax,(%esi)
80103435:	85 c0                	test   %eax,%eax
80103437:	0f 84 8b 00 00 00    	je     801034c8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010343d:	e8 fe f1 ff ff       	call   80102640 <kalloc>
80103442:	89 c7                	mov    %eax,%edi
80103444:	85 c0                	test   %eax,%eax
80103446:	0f 84 b4 00 00 00    	je     80103500 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010344c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103453:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103456:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103459:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103460:	00 00 00 
  p->nwrite = 0;
80103463:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010346a:	00 00 00 
  p->nread = 0;
8010346d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103474:	00 00 00 
  initlock(&p->lock, "pipe");
80103477:	68 1b 77 10 80       	push   $0x8010771b
8010347c:	50                   	push   %eax
8010347d:	e8 fe 0f 00 00       	call   80104480 <initlock>
  (*f0)->type = FD_PIPE;
80103482:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103484:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103487:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010348d:	8b 03                	mov    (%ebx),%eax
8010348f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103493:	8b 03                	mov    (%ebx),%eax
80103495:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103499:	8b 03                	mov    (%ebx),%eax
8010349b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010349e:	8b 06                	mov    (%esi),%eax
801034a0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034a6:	8b 06                	mov    (%esi),%eax
801034a8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034ac:	8b 06                	mov    (%esi),%eax
801034ae:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034b2:	8b 06                	mov    (%esi),%eax
801034b4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034ba:	31 c0                	xor    %eax,%eax
}
801034bc:	5b                   	pop    %ebx
801034bd:	5e                   	pop    %esi
801034be:	5f                   	pop    %edi
801034bf:	5d                   	pop    %ebp
801034c0:	c3                   	ret    
801034c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034c8:	8b 03                	mov    (%ebx),%eax
801034ca:	85 c0                	test   %eax,%eax
801034cc:	74 1e                	je     801034ec <pipealloc+0xec>
    fileclose(*f0);
801034ce:	83 ec 0c             	sub    $0xc,%esp
801034d1:	50                   	push   %eax
801034d2:	e8 f9 d9 ff ff       	call   80100ed0 <fileclose>
801034d7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034da:	8b 06                	mov    (%esi),%eax
801034dc:	85 c0                	test   %eax,%eax
801034de:	74 0c                	je     801034ec <pipealloc+0xec>
    fileclose(*f1);
801034e0:	83 ec 0c             	sub    $0xc,%esp
801034e3:	50                   	push   %eax
801034e4:	e8 e7 d9 ff ff       	call   80100ed0 <fileclose>
801034e9:	83 c4 10             	add    $0x10,%esp
}
801034ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801034ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034f4:	5b                   	pop    %ebx
801034f5:	5e                   	pop    %esi
801034f6:	5f                   	pop    %edi
801034f7:	5d                   	pop    %ebp
801034f8:	c3                   	ret    
801034f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103500:	8b 03                	mov    (%ebx),%eax
80103502:	85 c0                	test   %eax,%eax
80103504:	75 c8                	jne    801034ce <pipealloc+0xce>
80103506:	eb d2                	jmp    801034da <pipealloc+0xda>
80103508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010350f:	90                   	nop

80103510 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103510:	f3 0f 1e fb          	endbr32 
80103514:	55                   	push   %ebp
80103515:	89 e5                	mov    %esp,%ebp
80103517:	56                   	push   %esi
80103518:	53                   	push   %ebx
80103519:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010351c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010351f:	83 ec 0c             	sub    $0xc,%esp
80103522:	53                   	push   %ebx
80103523:	e8 d8 10 00 00       	call   80104600 <acquire>
  if(writable){
80103528:	83 c4 10             	add    $0x10,%esp
8010352b:	85 f6                	test   %esi,%esi
8010352d:	74 41                	je     80103570 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010352f:	83 ec 0c             	sub    $0xc,%esp
80103532:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103538:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010353f:	00 00 00 
    wakeup(&p->nread);
80103542:	50                   	push   %eax
80103543:	e8 d8 0b 00 00       	call   80104120 <wakeup>
80103548:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010354b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103551:	85 d2                	test   %edx,%edx
80103553:	75 0a                	jne    8010355f <pipeclose+0x4f>
80103555:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010355b:	85 c0                	test   %eax,%eax
8010355d:	74 31                	je     80103590 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010355f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103562:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103565:	5b                   	pop    %ebx
80103566:	5e                   	pop    %esi
80103567:	5d                   	pop    %ebp
    release(&p->lock);
80103568:	e9 53 11 00 00       	jmp    801046c0 <release>
8010356d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103570:	83 ec 0c             	sub    $0xc,%esp
80103573:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103579:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103580:	00 00 00 
    wakeup(&p->nwrite);
80103583:	50                   	push   %eax
80103584:	e8 97 0b 00 00       	call   80104120 <wakeup>
80103589:	83 c4 10             	add    $0x10,%esp
8010358c:	eb bd                	jmp    8010354b <pipeclose+0x3b>
8010358e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 27 11 00 00       	call   801046c0 <release>
    kfree((char*)p);
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 d6 ee ff ff       	jmp    80102480 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035b0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035b0:	f3 0f 1e fb          	endbr32 
801035b4:	55                   	push   %ebp
801035b5:	89 e5                	mov    %esp,%ebp
801035b7:	57                   	push   %edi
801035b8:	56                   	push   %esi
801035b9:	53                   	push   %ebx
801035ba:	83 ec 28             	sub    $0x28,%esp
801035bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035c0:	53                   	push   %ebx
801035c1:	e8 3a 10 00 00       	call   80104600 <acquire>
  for(i = 0; i < n; i++){
801035c6:	8b 45 10             	mov    0x10(%ebp),%eax
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	85 c0                	test   %eax,%eax
801035ce:	0f 8e bc 00 00 00    	jle    80103690 <pipewrite+0xe0>
801035d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801035d7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035dd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035e6:	03 45 10             	add    0x10(%ebp),%eax
801035e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035ec:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035f2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f8:	89 ca                	mov    %ecx,%edx
801035fa:	05 00 02 00 00       	add    $0x200,%eax
801035ff:	39 c1                	cmp    %eax,%ecx
80103601:	74 3b                	je     8010363e <pipewrite+0x8e>
80103603:	eb 63                	jmp    80103668 <pipewrite+0xb8>
80103605:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103608:	e8 73 03 00 00       	call   80103980 <myproc>
8010360d:	8b 48 24             	mov    0x24(%eax),%ecx
80103610:	85 c9                	test   %ecx,%ecx
80103612:	75 34                	jne    80103648 <pipewrite+0x98>
      wakeup(&p->nread);
80103614:	83 ec 0c             	sub    $0xc,%esp
80103617:	57                   	push   %edi
80103618:	e8 03 0b 00 00       	call   80104120 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010361d:	58                   	pop    %eax
8010361e:	5a                   	pop    %edx
8010361f:	53                   	push   %ebx
80103620:	56                   	push   %esi
80103621:	e8 3a 09 00 00       	call   80103f60 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103626:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010362c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103632:	83 c4 10             	add    $0x10,%esp
80103635:	05 00 02 00 00       	add    $0x200,%eax
8010363a:	39 c2                	cmp    %eax,%edx
8010363c:	75 2a                	jne    80103668 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010363e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103644:	85 c0                	test   %eax,%eax
80103646:	75 c0                	jne    80103608 <pipewrite+0x58>
        release(&p->lock);
80103648:	83 ec 0c             	sub    $0xc,%esp
8010364b:	53                   	push   %ebx
8010364c:	e8 6f 10 00 00       	call   801046c0 <release>
        return -1;
80103651:	83 c4 10             	add    $0x10,%esp
80103654:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103659:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010365c:	5b                   	pop    %ebx
8010365d:	5e                   	pop    %esi
8010365e:	5f                   	pop    %edi
8010365f:	5d                   	pop    %ebp
80103660:	c3                   	ret    
80103661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103668:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010366b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010366e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103674:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010367a:	0f b6 06             	movzbl (%esi),%eax
8010367d:	83 c6 01             	add    $0x1,%esi
80103680:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103683:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103687:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010368a:	0f 85 5c ff ff ff    	jne    801035ec <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103690:	83 ec 0c             	sub    $0xc,%esp
80103693:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103699:	50                   	push   %eax
8010369a:	e8 81 0a 00 00       	call   80104120 <wakeup>
  release(&p->lock);
8010369f:	89 1c 24             	mov    %ebx,(%esp)
801036a2:	e8 19 10 00 00       	call   801046c0 <release>
  return n;
801036a7:	8b 45 10             	mov    0x10(%ebp),%eax
801036aa:	83 c4 10             	add    $0x10,%esp
801036ad:	eb aa                	jmp    80103659 <pipewrite+0xa9>
801036af:	90                   	nop

801036b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036b0:	f3 0f 1e fb          	endbr32 
801036b4:	55                   	push   %ebp
801036b5:	89 e5                	mov    %esp,%ebp
801036b7:	57                   	push   %edi
801036b8:	56                   	push   %esi
801036b9:	53                   	push   %ebx
801036ba:	83 ec 18             	sub    $0x18,%esp
801036bd:	8b 75 08             	mov    0x8(%ebp),%esi
801036c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036c3:	56                   	push   %esi
801036c4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036ca:	e8 31 0f 00 00       	call   80104600 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036cf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036d5:	83 c4 10             	add    $0x10,%esp
801036d8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036de:	74 33                	je     80103713 <piperead+0x63>
801036e0:	eb 3b                	jmp    8010371d <piperead+0x6d>
801036e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801036e8:	e8 93 02 00 00       	call   80103980 <myproc>
801036ed:	8b 48 24             	mov    0x24(%eax),%ecx
801036f0:	85 c9                	test   %ecx,%ecx
801036f2:	0f 85 88 00 00 00    	jne    80103780 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036f8:	83 ec 08             	sub    $0x8,%esp
801036fb:	56                   	push   %esi
801036fc:	53                   	push   %ebx
801036fd:	e8 5e 08 00 00       	call   80103f60 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103702:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103708:	83 c4 10             	add    $0x10,%esp
8010370b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103711:	75 0a                	jne    8010371d <piperead+0x6d>
80103713:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103719:	85 c0                	test   %eax,%eax
8010371b:	75 cb                	jne    801036e8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010371d:	8b 55 10             	mov    0x10(%ebp),%edx
80103720:	31 db                	xor    %ebx,%ebx
80103722:	85 d2                	test   %edx,%edx
80103724:	7f 28                	jg     8010374e <piperead+0x9e>
80103726:	eb 34                	jmp    8010375c <piperead+0xac>
80103728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010372f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103730:	8d 48 01             	lea    0x1(%eax),%ecx
80103733:	25 ff 01 00 00       	and    $0x1ff,%eax
80103738:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010373e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103743:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103746:	83 c3 01             	add    $0x1,%ebx
80103749:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010374c:	74 0e                	je     8010375c <piperead+0xac>
    if(p->nread == p->nwrite)
8010374e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103754:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010375a:	75 d4                	jne    80103730 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010375c:	83 ec 0c             	sub    $0xc,%esp
8010375f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103765:	50                   	push   %eax
80103766:	e8 b5 09 00 00       	call   80104120 <wakeup>
  release(&p->lock);
8010376b:	89 34 24             	mov    %esi,(%esp)
8010376e:	e8 4d 0f 00 00       	call   801046c0 <release>
  return i;
80103773:	83 c4 10             	add    $0x10,%esp
}
80103776:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103779:	89 d8                	mov    %ebx,%eax
8010377b:	5b                   	pop    %ebx
8010377c:	5e                   	pop    %esi
8010377d:	5f                   	pop    %edi
8010377e:	5d                   	pop    %ebp
8010377f:	c3                   	ret    
      release(&p->lock);
80103780:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103783:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103788:	56                   	push   %esi
80103789:	e8 32 0f 00 00       	call   801046c0 <release>
      return -1;
8010378e:	83 c4 10             	add    $0x10,%esp
}
80103791:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103794:	89 d8                	mov    %ebx,%eax
80103796:	5b                   	pop    %ebx
80103797:	5e                   	pop    %esi
80103798:	5f                   	pop    %edi
80103799:	5d                   	pop    %ebp
8010379a:	c3                   	ret    
8010379b:	66 90                	xchg   %ax,%ax
8010379d:	66 90                	xchg   %ax,%ax
8010379f:	90                   	nop

801037a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037a4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801037a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037ac:	68 20 2d 11 80       	push   $0x80112d20
801037b1:	e8 4a 0e 00 00       	call   80104600 <acquire>
801037b6:	83 c4 10             	add    $0x10,%esp
801037b9:	eb 14                	jmp    801037cf <allocproc+0x2f>
801037bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037bf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037c0:	83 eb 80             	sub    $0xffffff80,%ebx
801037c3:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801037c9:	0f 84 81 00 00 00    	je     80103850 <allocproc+0xb0>
    if(p->state == UNUSED)
801037cf:	8b 43 0c             	mov    0xc(%ebx),%eax
801037d2:	85 c0                	test   %eax,%eax
801037d4:	75 ea                	jne    801037c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037d6:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801037db:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037de:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801037e5:	89 43 10             	mov    %eax,0x10(%ebx)
801037e8:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801037eb:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
801037f0:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
801037f6:	e8 c5 0e 00 00       	call   801046c0 <release>
  p->priority = 10;
801037fb:	c7 43 7c 0a 00 00 00 	movl   $0xa,0x7c(%ebx)
  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103802:	e8 39 ee ff ff       	call   80102640 <kalloc>
80103807:	83 c4 10             	add    $0x10,%esp
8010380a:	89 43 08             	mov    %eax,0x8(%ebx)
8010380d:	85 c0                	test   %eax,%eax
8010380f:	74 58                	je     80103869 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103811:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103817:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010381a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010381f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103822:	c7 40 14 77 59 10 80 	movl   $0x80105977,0x14(%eax)
  p->context = (struct context*)sp;
80103829:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010382c:	6a 14                	push   $0x14
8010382e:	6a 00                	push   $0x0
80103830:	50                   	push   %eax
80103831:	e8 da 0e 00 00       	call   80104710 <memset>
  p->context->eip = (uint)forkret;
80103836:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103839:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010383c:	c7 40 10 80 38 10 80 	movl   $0x80103880,0x10(%eax)
}
80103843:	89 d8                	mov    %ebx,%eax
80103845:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103848:	c9                   	leave  
80103849:	c3                   	ret    
8010384a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103850:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103853:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103855:	68 20 2d 11 80       	push   $0x80112d20
8010385a:	e8 61 0e 00 00       	call   801046c0 <release>
}
8010385f:	89 d8                	mov    %ebx,%eax
  return 0;
80103861:	83 c4 10             	add    $0x10,%esp
}
80103864:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103867:	c9                   	leave  
80103868:	c3                   	ret    
    p->state = UNUSED;
80103869:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103870:	31 db                	xor    %ebx,%ebx
}
80103872:	89 d8                	mov    %ebx,%eax
80103874:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103877:	c9                   	leave  
80103878:	c3                   	ret    
80103879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103880 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103880:	f3 0f 1e fb          	endbr32 
80103884:	55                   	push   %ebp
80103885:	89 e5                	mov    %esp,%ebp
80103887:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010388a:	68 20 2d 11 80       	push   $0x80112d20
8010388f:	e8 2c 0e 00 00       	call   801046c0 <release>

  if (first) {
80103894:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103899:	83 c4 10             	add    $0x10,%esp
8010389c:	85 c0                	test   %eax,%eax
8010389e:	75 08                	jne    801038a8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038a0:	c9                   	leave  
801038a1:	c3                   	ret    
801038a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
801038a8:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801038af:	00 00 00 
    iinit(ROOTDEV);
801038b2:	83 ec 0c             	sub    $0xc,%esp
801038b5:	6a 01                	push   $0x1
801038b7:	e8 94 dc ff ff       	call   80101550 <iinit>
    initlog(ROOTDEV);
801038bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038c3:	e8 d8 f3 ff ff       	call   80102ca0 <initlog>
}
801038c8:	83 c4 10             	add    $0x10,%esp
801038cb:	c9                   	leave  
801038cc:	c3                   	ret    
801038cd:	8d 76 00             	lea    0x0(%esi),%esi

801038d0 <pinit>:
{
801038d0:	f3 0f 1e fb          	endbr32 
801038d4:	55                   	push   %ebp
801038d5:	89 e5                	mov    %esp,%ebp
801038d7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038da:	68 20 77 10 80       	push   $0x80107720
801038df:	68 20 2d 11 80       	push   $0x80112d20
801038e4:	e8 97 0b 00 00       	call   80104480 <initlock>
}
801038e9:	83 c4 10             	add    $0x10,%esp
801038ec:	c9                   	leave  
801038ed:	c3                   	ret    
801038ee:	66 90                	xchg   %ax,%ax

801038f0 <mycpu>:
{
801038f0:	f3 0f 1e fb          	endbr32 
801038f4:	55                   	push   %ebp
801038f5:	89 e5                	mov    %esp,%ebp
801038f7:	56                   	push   %esi
801038f8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801038f9:	9c                   	pushf  
801038fa:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801038fb:	f6 c4 02             	test   $0x2,%ah
801038fe:	75 4a                	jne    8010394a <mycpu+0x5a>
  apicid = lapicid();
80103900:	e8 ab ef ff ff       	call   801028b0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103905:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
  apicid = lapicid();
8010390b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010390d:	85 f6                	test   %esi,%esi
8010390f:	7e 2c                	jle    8010393d <mycpu+0x4d>
80103911:	31 d2                	xor    %edx,%edx
80103913:	eb 0a                	jmp    8010391f <mycpu+0x2f>
80103915:	8d 76 00             	lea    0x0(%esi),%esi
80103918:	83 c2 01             	add    $0x1,%edx
8010391b:	39 f2                	cmp    %esi,%edx
8010391d:	74 1e                	je     8010393d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010391f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103925:	0f b6 81 80 27 11 80 	movzbl -0x7feed880(%ecx),%eax
8010392c:	39 d8                	cmp    %ebx,%eax
8010392e:	75 e8                	jne    80103918 <mycpu+0x28>
}
80103930:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103933:	8d 81 80 27 11 80    	lea    -0x7feed880(%ecx),%eax
}
80103939:	5b                   	pop    %ebx
8010393a:	5e                   	pop    %esi
8010393b:	5d                   	pop    %ebp
8010393c:	c3                   	ret    
  panic("unknown apicid\n");
8010393d:	83 ec 0c             	sub    $0xc,%esp
80103940:	68 27 77 10 80       	push   $0x80107727
80103945:	e8 46 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010394a:	83 ec 0c             	sub    $0xc,%esp
8010394d:	68 04 78 10 80       	push   $0x80107804
80103952:	e8 39 ca ff ff       	call   80100390 <panic>
80103957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010395e:	66 90                	xchg   %ax,%ax

80103960 <cpuid>:
cpuid() {
80103960:	f3 0f 1e fb          	endbr32 
80103964:	55                   	push   %ebp
80103965:	89 e5                	mov    %esp,%ebp
80103967:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010396a:	e8 81 ff ff ff       	call   801038f0 <mycpu>
}
8010396f:	c9                   	leave  
  return mycpu()-cpus;
80103970:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103975:	c1 f8 04             	sar    $0x4,%eax
80103978:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010397e:	c3                   	ret    
8010397f:	90                   	nop

80103980 <myproc>:
myproc(void) {
80103980:	f3 0f 1e fb          	endbr32 
80103984:	55                   	push   %ebp
80103985:	89 e5                	mov    %esp,%ebp
80103987:	53                   	push   %ebx
80103988:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010398b:	e8 70 0b 00 00       	call   80104500 <pushcli>
  c = mycpu();
80103990:	e8 5b ff ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103995:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010399b:	e8 b0 0b 00 00       	call   80104550 <popcli>
}
801039a0:	83 c4 04             	add    $0x4,%esp
801039a3:	89 d8                	mov    %ebx,%eax
801039a5:	5b                   	pop    %ebx
801039a6:	5d                   	pop    %ebp
801039a7:	c3                   	ret    
801039a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039af:	90                   	nop

801039b0 <userinit>:
{
801039b0:	f3 0f 1e fb          	endbr32 
801039b4:	55                   	push   %ebp
801039b5:	89 e5                	mov    %esp,%ebp
801039b7:	53                   	push   %ebx
801039b8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039bb:	e8 e0 fd ff ff       	call   801037a0 <allocproc>
801039c0:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039c2:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801039c7:	e8 74 35 00 00       	call   80106f40 <setupkvm>
801039cc:	89 43 04             	mov    %eax,0x4(%ebx)
801039cf:	85 c0                	test   %eax,%eax
801039d1:	0f 84 bd 00 00 00    	je     80103a94 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039d7:	83 ec 04             	sub    $0x4,%esp
801039da:	68 2c 00 00 00       	push   $0x2c
801039df:	68 60 a4 10 80       	push   $0x8010a460
801039e4:	50                   	push   %eax
801039e5:	e8 26 32 00 00       	call   80106c10 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039ea:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039ed:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039f3:	6a 4c                	push   $0x4c
801039f5:	6a 00                	push   $0x0
801039f7:	ff 73 18             	pushl  0x18(%ebx)
801039fa:	e8 11 0d 00 00       	call   80104710 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039ff:	8b 43 18             	mov    0x18(%ebx),%eax
80103a02:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a07:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a0a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a0f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a13:	8b 43 18             	mov    0x18(%ebx),%eax
80103a16:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a1a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a1d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a21:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a25:	8b 43 18             	mov    0x18(%ebx),%eax
80103a28:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a2c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a30:	8b 43 18             	mov    0x18(%ebx),%eax
80103a33:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a3a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a3d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a44:	8b 43 18             	mov    0x18(%ebx),%eax
80103a47:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a4e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a51:	6a 10                	push   $0x10
80103a53:	68 50 77 10 80       	push   $0x80107750
80103a58:	50                   	push   %eax
80103a59:	e8 72 0e 00 00       	call   801048d0 <safestrcpy>
  p->cwd = namei("/");
80103a5e:	c7 04 24 59 77 10 80 	movl   $0x80107759,(%esp)
80103a65:	e8 d6 e5 ff ff       	call   80102040 <namei>
80103a6a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a6d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a74:	e8 87 0b 00 00       	call   80104600 <acquire>
  p->state = RUNNABLE;
80103a79:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a80:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a87:	e8 34 0c 00 00       	call   801046c0 <release>
}
80103a8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a8f:	83 c4 10             	add    $0x10,%esp
80103a92:	c9                   	leave  
80103a93:	c3                   	ret    
    panic("userinit: out of memory?");
80103a94:	83 ec 0c             	sub    $0xc,%esp
80103a97:	68 37 77 10 80       	push   $0x80107737
80103a9c:	e8 ef c8 ff ff       	call   80100390 <panic>
80103aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aaf:	90                   	nop

80103ab0 <growproc>:
{
80103ab0:	f3 0f 1e fb          	endbr32 
80103ab4:	55                   	push   %ebp
80103ab5:	89 e5                	mov    %esp,%ebp
80103ab7:	56                   	push   %esi
80103ab8:	53                   	push   %ebx
80103ab9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103abc:	e8 3f 0a 00 00       	call   80104500 <pushcli>
  c = mycpu();
80103ac1:	e8 2a fe ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103ac6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103acc:	e8 7f 0a 00 00       	call   80104550 <popcli>
  sz = curproc->sz;
80103ad1:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103ad3:	85 f6                	test   %esi,%esi
80103ad5:	7f 19                	jg     80103af0 <growproc+0x40>
  } else if(n < 0){
80103ad7:	75 37                	jne    80103b10 <growproc+0x60>
  switchuvm(curproc);
80103ad9:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103adc:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103ade:	53                   	push   %ebx
80103adf:	e8 1c 30 00 00       	call   80106b00 <switchuvm>
  return 0;
80103ae4:	83 c4 10             	add    $0x10,%esp
80103ae7:	31 c0                	xor    %eax,%eax
}
80103ae9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103aec:	5b                   	pop    %ebx
80103aed:	5e                   	pop    %esi
80103aee:	5d                   	pop    %ebp
80103aef:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103af0:	83 ec 04             	sub    $0x4,%esp
80103af3:	01 c6                	add    %eax,%esi
80103af5:	56                   	push   %esi
80103af6:	50                   	push   %eax
80103af7:	ff 73 04             	pushl  0x4(%ebx)
80103afa:	e8 61 32 00 00       	call   80106d60 <allocuvm>
80103aff:	83 c4 10             	add    $0x10,%esp
80103b02:	85 c0                	test   %eax,%eax
80103b04:	75 d3                	jne    80103ad9 <growproc+0x29>
      return -1;
80103b06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b0b:	eb dc                	jmp    80103ae9 <growproc+0x39>
80103b0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b10:	83 ec 04             	sub    $0x4,%esp
80103b13:	01 c6                	add    %eax,%esi
80103b15:	56                   	push   %esi
80103b16:	50                   	push   %eax
80103b17:	ff 73 04             	pushl  0x4(%ebx)
80103b1a:	e8 71 33 00 00       	call   80106e90 <deallocuvm>
80103b1f:	83 c4 10             	add    $0x10,%esp
80103b22:	85 c0                	test   %eax,%eax
80103b24:	75 b3                	jne    80103ad9 <growproc+0x29>
80103b26:	eb de                	jmp    80103b06 <growproc+0x56>
80103b28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b2f:	90                   	nop

80103b30 <fork>:
{
80103b30:	f3 0f 1e fb          	endbr32 
80103b34:	55                   	push   %ebp
80103b35:	89 e5                	mov    %esp,%ebp
80103b37:	57                   	push   %edi
80103b38:	56                   	push   %esi
80103b39:	53                   	push   %ebx
80103b3a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b3d:	e8 be 09 00 00       	call   80104500 <pushcli>
  c = mycpu();
80103b42:	e8 a9 fd ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103b47:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b4d:	e8 fe 09 00 00       	call   80104550 <popcli>
  if((np = allocproc()) == 0){
80103b52:	e8 49 fc ff ff       	call   801037a0 <allocproc>
80103b57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b5a:	85 c0                	test   %eax,%eax
80103b5c:	0f 84 bb 00 00 00    	je     80103c1d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b62:	83 ec 08             	sub    $0x8,%esp
80103b65:	ff 33                	pushl  (%ebx)
80103b67:	89 c7                	mov    %eax,%edi
80103b69:	ff 73 04             	pushl  0x4(%ebx)
80103b6c:	e8 9f 34 00 00       	call   80107010 <copyuvm>
80103b71:	83 c4 10             	add    $0x10,%esp
80103b74:	89 47 04             	mov    %eax,0x4(%edi)
80103b77:	85 c0                	test   %eax,%eax
80103b79:	0f 84 a5 00 00 00    	je     80103c24 <fork+0xf4>
  np->sz = curproc->sz;
80103b7f:	8b 03                	mov    (%ebx),%eax
80103b81:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b84:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b86:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b89:	89 c8                	mov    %ecx,%eax
80103b8b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b8e:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b93:	8b 73 18             	mov    0x18(%ebx),%esi
80103b96:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b98:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b9a:	8b 40 18             	mov    0x18(%eax),%eax
80103b9d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103ba8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103bac:	85 c0                	test   %eax,%eax
80103bae:	74 13                	je     80103bc3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103bb0:	83 ec 0c             	sub    $0xc,%esp
80103bb3:	50                   	push   %eax
80103bb4:	e8 c7 d2 ff ff       	call   80100e80 <filedup>
80103bb9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bbc:	83 c4 10             	add    $0x10,%esp
80103bbf:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bc3:	83 c6 01             	add    $0x1,%esi
80103bc6:	83 fe 10             	cmp    $0x10,%esi
80103bc9:	75 dd                	jne    80103ba8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103bcb:	83 ec 0c             	sub    $0xc,%esp
80103bce:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bd1:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bd4:	e8 67 db ff ff       	call   80101740 <idup>
80103bd9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bdc:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bdf:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103be2:	8d 47 6c             	lea    0x6c(%edi),%eax
80103be5:	6a 10                	push   $0x10
80103be7:	53                   	push   %ebx
80103be8:	50                   	push   %eax
80103be9:	e8 e2 0c 00 00       	call   801048d0 <safestrcpy>
  pid = np->pid;
80103bee:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103bf1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bf8:	e8 03 0a 00 00       	call   80104600 <acquire>
  np->state = RUNNABLE;
80103bfd:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c04:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c0b:	e8 b0 0a 00 00       	call   801046c0 <release>
  return pid;
80103c10:	83 c4 10             	add    $0x10,%esp
}
80103c13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c16:	89 d8                	mov    %ebx,%eax
80103c18:	5b                   	pop    %ebx
80103c19:	5e                   	pop    %esi
80103c1a:	5f                   	pop    %edi
80103c1b:	5d                   	pop    %ebp
80103c1c:	c3                   	ret    
    return -1;
80103c1d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c22:	eb ef                	jmp    80103c13 <fork+0xe3>
    kfree(np->kstack);
80103c24:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c27:	83 ec 0c             	sub    $0xc,%esp
80103c2a:	ff 73 08             	pushl  0x8(%ebx)
80103c2d:	e8 4e e8 ff ff       	call   80102480 <kfree>
    np->kstack = 0;
80103c32:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c39:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c3c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c43:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c48:	eb c9                	jmp    80103c13 <fork+0xe3>
80103c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c50 <scheduler>:
{
80103c50:	f3 0f 1e fb          	endbr32 
80103c54:	55                   	push   %ebp
80103c55:	89 e5                	mov    %esp,%ebp
80103c57:	57                   	push   %edi
80103c58:	56                   	push   %esi
80103c59:	53                   	push   %ebx
80103c5a:	83 ec 0c             	sub    $0xc,%esp
	struct cpu *c = mycpu();
80103c5d:	e8 8e fc ff ff       	call   801038f0 <mycpu>
	c->proc = 0;
80103c62:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c69:	00 00 00 
	struct cpu *c = mycpu();
80103c6c:	89 c3                	mov    %eax,%ebx
	c->proc = 0;
80103c6e:	8d 70 04             	lea    0x4(%eax),%esi
80103c71:	eb 20                	jmp    80103c93 <scheduler+0x43>
80103c73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c77:	90                   	nop
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c78:	83 ef 80             	sub    $0xffffff80,%edi
80103c7b:	81 ff 54 4d 11 80    	cmp    $0x80114d54,%edi
80103c81:	72 26                	jb     80103ca9 <scheduler+0x59>
		release(&ptable.lock);
80103c83:	83 ec 0c             	sub    $0xc,%esp
80103c86:	68 20 2d 11 80       	push   $0x80112d20
80103c8b:	e8 30 0a 00 00       	call   801046c0 <release>
		sti();
80103c90:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
80103c93:	fb                   	sti    
		acquire(&ptable.lock);
80103c94:	83 ec 0c             	sub    $0xc,%esp
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c97:	bf 54 2d 11 80       	mov    $0x80112d54,%edi
		acquire(&ptable.lock);
80103c9c:	68 20 2d 11 80       	push   $0x80112d20
80103ca1:	e8 5a 09 00 00       	call   80104600 <acquire>
80103ca6:	83 c4 10             	add    $0x10,%esp
			if(p->state != RUNNABLE)
80103ca9:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80103cad:	75 c9                	jne    80103c78 <scheduler+0x28>
			for(p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
80103caf:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
				if((p1->state == RUNNABLE) && ( highP->priority > p1->priority ))//higher value, 	lower priority
80103cb8:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103cbc:	75 09                	jne    80103cc7 <scheduler+0x77>
80103cbe:	8b 50 7c             	mov    0x7c(%eax),%edx
80103cc1:	39 57 7c             	cmp    %edx,0x7c(%edi)
80103cc4:	0f 4f f8             	cmovg  %eax,%edi
			for(p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
80103cc7:	83 e8 80             	sub    $0xffffff80,%eax
80103cca:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103ccf:	75 e7                	jne    80103cb8 <scheduler+0x68>
				switchuvm(p);
80103cd1:	83 ec 0c             	sub    $0xc,%esp
				c->proc = p;
80103cd4:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
				switchuvm(p);
80103cda:	57                   	push   %edi
80103cdb:	e8 20 2e 00 00       	call   80106b00 <switchuvm>
				p->state = RUNNING;
80103ce0:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
				swtch(&(c->scheduler), p->context);
80103ce7:	58                   	pop    %eax
80103ce8:	5a                   	pop    %edx
80103ce9:	ff 77 1c             	pushl  0x1c(%edi)
80103cec:	56                   	push   %esi
80103ced:	e8 41 0c 00 00       	call   80104933 <swtch>
				switchkvm();
80103cf2:	e8 e9 2d 00 00       	call   80106ae0 <switchkvm>
				c->proc = 0;
80103cf7:	83 c4 10             	add    $0x10,%esp
80103cfa:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103d01:	00 00 00 
80103d04:	e9 6f ff ff ff       	jmp    80103c78 <scheduler+0x28>
80103d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d10 <sched>:
{
80103d10:	f3 0f 1e fb          	endbr32 
80103d14:	55                   	push   %ebp
80103d15:	89 e5                	mov    %esp,%ebp
80103d17:	56                   	push   %esi
80103d18:	53                   	push   %ebx
  pushcli();
80103d19:	e8 e2 07 00 00       	call   80104500 <pushcli>
  c = mycpu();
80103d1e:	e8 cd fb ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103d23:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d29:	e8 22 08 00 00       	call   80104550 <popcli>
  if(!holding(&ptable.lock))
80103d2e:	83 ec 0c             	sub    $0xc,%esp
80103d31:	68 20 2d 11 80       	push   $0x80112d20
80103d36:	e8 75 08 00 00       	call   801045b0 <holding>
80103d3b:	83 c4 10             	add    $0x10,%esp
80103d3e:	85 c0                	test   %eax,%eax
80103d40:	74 4f                	je     80103d91 <sched+0x81>
  if(mycpu()->ncli != 1)
80103d42:	e8 a9 fb ff ff       	call   801038f0 <mycpu>
80103d47:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d4e:	75 68                	jne    80103db8 <sched+0xa8>
  if(p->state == RUNNING)
80103d50:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d54:	74 55                	je     80103dab <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d56:	9c                   	pushf  
80103d57:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d58:	f6 c4 02             	test   $0x2,%ah
80103d5b:	75 41                	jne    80103d9e <sched+0x8e>
  intena = mycpu()->intena;
80103d5d:	e8 8e fb ff ff       	call   801038f0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d62:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d65:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d6b:	e8 80 fb ff ff       	call   801038f0 <mycpu>
80103d70:	83 ec 08             	sub    $0x8,%esp
80103d73:	ff 70 04             	pushl  0x4(%eax)
80103d76:	53                   	push   %ebx
80103d77:	e8 b7 0b 00 00       	call   80104933 <swtch>
  mycpu()->intena = intena;
80103d7c:	e8 6f fb ff ff       	call   801038f0 <mycpu>
}
80103d81:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d84:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d8d:	5b                   	pop    %ebx
80103d8e:	5e                   	pop    %esi
80103d8f:	5d                   	pop    %ebp
80103d90:	c3                   	ret    
    panic("sched ptable.lock");
80103d91:	83 ec 0c             	sub    $0xc,%esp
80103d94:	68 5b 77 10 80       	push   $0x8010775b
80103d99:	e8 f2 c5 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103d9e:	83 ec 0c             	sub    $0xc,%esp
80103da1:	68 87 77 10 80       	push   $0x80107787
80103da6:	e8 e5 c5 ff ff       	call   80100390 <panic>
    panic("sched running");
80103dab:	83 ec 0c             	sub    $0xc,%esp
80103dae:	68 79 77 10 80       	push   $0x80107779
80103db3:	e8 d8 c5 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103db8:	83 ec 0c             	sub    $0xc,%esp
80103dbb:	68 6d 77 10 80       	push   $0x8010776d
80103dc0:	e8 cb c5 ff ff       	call   80100390 <panic>
80103dc5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103dd0 <exit>:
{
80103dd0:	f3 0f 1e fb          	endbr32 
80103dd4:	55                   	push   %ebp
80103dd5:	89 e5                	mov    %esp,%ebp
80103dd7:	57                   	push   %edi
80103dd8:	56                   	push   %esi
80103dd9:	53                   	push   %ebx
80103dda:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103ddd:	e8 1e 07 00 00       	call   80104500 <pushcli>
  c = mycpu();
80103de2:	e8 09 fb ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103de7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ded:	e8 5e 07 00 00       	call   80104550 <popcli>
  if(curproc == initproc)
80103df2:	8d 5e 28             	lea    0x28(%esi),%ebx
80103df5:	8d 7e 68             	lea    0x68(%esi),%edi
80103df8:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103dfe:	0f 84 f3 00 00 00    	je     80103ef7 <exit+0x127>
80103e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80103e08:	8b 03                	mov    (%ebx),%eax
80103e0a:	85 c0                	test   %eax,%eax
80103e0c:	74 12                	je     80103e20 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80103e0e:	83 ec 0c             	sub    $0xc,%esp
80103e11:	50                   	push   %eax
80103e12:	e8 b9 d0 ff ff       	call   80100ed0 <fileclose>
      curproc->ofile[fd] = 0;
80103e17:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103e1d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e20:	83 c3 04             	add    $0x4,%ebx
80103e23:	39 df                	cmp    %ebx,%edi
80103e25:	75 e1                	jne    80103e08 <exit+0x38>
  begin_op();
80103e27:	e8 14 ef ff ff       	call   80102d40 <begin_op>
  iput(curproc->cwd);
80103e2c:	83 ec 0c             	sub    $0xc,%esp
80103e2f:	ff 76 68             	pushl  0x68(%esi)
80103e32:	e8 69 da ff ff       	call   801018a0 <iput>
  end_op();
80103e37:	e8 74 ef ff ff       	call   80102db0 <end_op>
  curproc->cwd = 0;
80103e3c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103e43:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e4a:	e8 b1 07 00 00       	call   80104600 <acquire>
  wakeup1(curproc->parent);
80103e4f:	8b 56 14             	mov    0x14(%esi),%edx
80103e52:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e55:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e5a:	eb 0e                	jmp    80103e6a <exit+0x9a>
80103e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e60:	83 e8 80             	sub    $0xffffff80,%eax
80103e63:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103e68:	74 1c                	je     80103e86 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
80103e6a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e6e:	75 f0                	jne    80103e60 <exit+0x90>
80103e70:	3b 50 20             	cmp    0x20(%eax),%edx
80103e73:	75 eb                	jne    80103e60 <exit+0x90>
      p->state = RUNNABLE;
80103e75:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e7c:	83 e8 80             	sub    $0xffffff80,%eax
80103e7f:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103e84:	75 e4                	jne    80103e6a <exit+0x9a>
      p->parent = initproc;
80103e86:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e8c:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103e91:	eb 10                	jmp    80103ea3 <exit+0xd3>
80103e93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e97:	90                   	nop
80103e98:	83 ea 80             	sub    $0xffffff80,%edx
80103e9b:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103ea1:	74 3b                	je     80103ede <exit+0x10e>
    if(p->parent == curproc){
80103ea3:	39 72 14             	cmp    %esi,0x14(%edx)
80103ea6:	75 f0                	jne    80103e98 <exit+0xc8>
      if(p->state == ZOMBIE)
80103ea8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103eac:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103eaf:	75 e7                	jne    80103e98 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103eb1:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103eb6:	eb 12                	jmp    80103eca <exit+0xfa>
80103eb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ebf:	90                   	nop
80103ec0:	83 e8 80             	sub    $0xffffff80,%eax
80103ec3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103ec8:	74 ce                	je     80103e98 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
80103eca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ece:	75 f0                	jne    80103ec0 <exit+0xf0>
80103ed0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103ed3:	75 eb                	jne    80103ec0 <exit+0xf0>
      p->state = RUNNABLE;
80103ed5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103edc:	eb e2                	jmp    80103ec0 <exit+0xf0>
  curproc->state = ZOMBIE;
80103ede:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103ee5:	e8 26 fe ff ff       	call   80103d10 <sched>
  panic("zombie exit");
80103eea:	83 ec 0c             	sub    $0xc,%esp
80103eed:	68 a8 77 10 80       	push   $0x801077a8
80103ef2:	e8 99 c4 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103ef7:	83 ec 0c             	sub    $0xc,%esp
80103efa:	68 9b 77 10 80       	push   $0x8010779b
80103eff:	e8 8c c4 ff ff       	call   80100390 <panic>
80103f04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f0f:	90                   	nop

80103f10 <yield>:
{
80103f10:	f3 0f 1e fb          	endbr32 
80103f14:	55                   	push   %ebp
80103f15:	89 e5                	mov    %esp,%ebp
80103f17:	53                   	push   %ebx
80103f18:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103f1b:	68 20 2d 11 80       	push   $0x80112d20
80103f20:	e8 db 06 00 00       	call   80104600 <acquire>
  pushcli();
80103f25:	e8 d6 05 00 00       	call   80104500 <pushcli>
  c = mycpu();
80103f2a:	e8 c1 f9 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103f2f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f35:	e8 16 06 00 00       	call   80104550 <popcli>
  myproc()->state = RUNNABLE;
80103f3a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103f41:	e8 ca fd ff ff       	call   80103d10 <sched>
  release(&ptable.lock);
80103f46:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f4d:	e8 6e 07 00 00       	call   801046c0 <release>
}
80103f52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f55:	83 c4 10             	add    $0x10,%esp
80103f58:	c9                   	leave  
80103f59:	c3                   	ret    
80103f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f60 <sleep>:
{
80103f60:	f3 0f 1e fb          	endbr32 
80103f64:	55                   	push   %ebp
80103f65:	89 e5                	mov    %esp,%ebp
80103f67:	57                   	push   %edi
80103f68:	56                   	push   %esi
80103f69:	53                   	push   %ebx
80103f6a:	83 ec 0c             	sub    $0xc,%esp
80103f6d:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f70:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103f73:	e8 88 05 00 00       	call   80104500 <pushcli>
  c = mycpu();
80103f78:	e8 73 f9 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103f7d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f83:	e8 c8 05 00 00       	call   80104550 <popcli>
  if(p == 0)
80103f88:	85 db                	test   %ebx,%ebx
80103f8a:	0f 84 83 00 00 00    	je     80104013 <sleep+0xb3>
  if(lk == 0)
80103f90:	85 f6                	test   %esi,%esi
80103f92:	74 72                	je     80104006 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103f94:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103f9a:	74 4c                	je     80103fe8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103f9c:	83 ec 0c             	sub    $0xc,%esp
80103f9f:	68 20 2d 11 80       	push   $0x80112d20
80103fa4:	e8 57 06 00 00       	call   80104600 <acquire>
    release(lk);
80103fa9:	89 34 24             	mov    %esi,(%esp)
80103fac:	e8 0f 07 00 00       	call   801046c0 <release>
  p->chan = chan;
80103fb1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103fb4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103fbb:	e8 50 fd ff ff       	call   80103d10 <sched>
  p->chan = 0;
80103fc0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103fc7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fce:	e8 ed 06 00 00       	call   801046c0 <release>
    acquire(lk);
80103fd3:	89 75 08             	mov    %esi,0x8(%ebp)
80103fd6:	83 c4 10             	add    $0x10,%esp
}
80103fd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fdc:	5b                   	pop    %ebx
80103fdd:	5e                   	pop    %esi
80103fde:	5f                   	pop    %edi
80103fdf:	5d                   	pop    %ebp
    acquire(lk);
80103fe0:	e9 1b 06 00 00       	jmp    80104600 <acquire>
80103fe5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80103fe8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103feb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103ff2:	e8 19 fd ff ff       	call   80103d10 <sched>
  p->chan = 0;
80103ff7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103ffe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104001:	5b                   	pop    %ebx
80104002:	5e                   	pop    %esi
80104003:	5f                   	pop    %edi
80104004:	5d                   	pop    %ebp
80104005:	c3                   	ret    
    panic("sleep without lk");
80104006:	83 ec 0c             	sub    $0xc,%esp
80104009:	68 ba 77 10 80       	push   $0x801077ba
8010400e:	e8 7d c3 ff ff       	call   80100390 <panic>
    panic("sleep");
80104013:	83 ec 0c             	sub    $0xc,%esp
80104016:	68 b4 77 10 80       	push   $0x801077b4
8010401b:	e8 70 c3 ff ff       	call   80100390 <panic>

80104020 <wait>:
{
80104020:	f3 0f 1e fb          	endbr32 
80104024:	55                   	push   %ebp
80104025:	89 e5                	mov    %esp,%ebp
80104027:	56                   	push   %esi
80104028:	53                   	push   %ebx
  pushcli();
80104029:	e8 d2 04 00 00       	call   80104500 <pushcli>
  c = mycpu();
8010402e:	e8 bd f8 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80104033:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104039:	e8 12 05 00 00       	call   80104550 <popcli>
  acquire(&ptable.lock);
8010403e:	83 ec 0c             	sub    $0xc,%esp
80104041:	68 20 2d 11 80       	push   $0x80112d20
80104046:	e8 b5 05 00 00       	call   80104600 <acquire>
8010404b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010404e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104050:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80104055:	eb 14                	jmp    8010406b <wait+0x4b>
80104057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010405e:	66 90                	xchg   %ax,%ax
80104060:	83 eb 80             	sub    $0xffffff80,%ebx
80104063:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80104069:	74 1b                	je     80104086 <wait+0x66>
      if(p->parent != curproc)
8010406b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010406e:	75 f0                	jne    80104060 <wait+0x40>
      if(p->state == ZOMBIE){
80104070:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104074:	74 32                	je     801040a8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104076:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80104079:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010407e:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80104084:	75 e5                	jne    8010406b <wait+0x4b>
    if(!havekids || curproc->killed){
80104086:	85 c0                	test   %eax,%eax
80104088:	74 74                	je     801040fe <wait+0xde>
8010408a:	8b 46 24             	mov    0x24(%esi),%eax
8010408d:	85 c0                	test   %eax,%eax
8010408f:	75 6d                	jne    801040fe <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104091:	83 ec 08             	sub    $0x8,%esp
80104094:	68 20 2d 11 80       	push   $0x80112d20
80104099:	56                   	push   %esi
8010409a:	e8 c1 fe ff ff       	call   80103f60 <sleep>
    havekids = 0;
8010409f:	83 c4 10             	add    $0x10,%esp
801040a2:	eb aa                	jmp    8010404e <wait+0x2e>
801040a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
801040a8:	83 ec 0c             	sub    $0xc,%esp
801040ab:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801040ae:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040b1:	e8 ca e3 ff ff       	call   80102480 <kfree>
        freevm(p->pgdir);
801040b6:	5a                   	pop    %edx
801040b7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801040ba:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040c1:	e8 fa 2d 00 00       	call   80106ec0 <freevm>
        release(&ptable.lock);
801040c6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
801040cd:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040d4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040db:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801040df:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801040e6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801040ed:	e8 ce 05 00 00       	call   801046c0 <release>
        return pid;
801040f2:	83 c4 10             	add    $0x10,%esp
}
801040f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040f8:	89 f0                	mov    %esi,%eax
801040fa:	5b                   	pop    %ebx
801040fb:	5e                   	pop    %esi
801040fc:	5d                   	pop    %ebp
801040fd:	c3                   	ret    
      release(&ptable.lock);
801040fe:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104101:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104106:	68 20 2d 11 80       	push   $0x80112d20
8010410b:	e8 b0 05 00 00       	call   801046c0 <release>
      return -1;
80104110:	83 c4 10             	add    $0x10,%esp
80104113:	eb e0                	jmp    801040f5 <wait+0xd5>
80104115:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010411c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104120 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104120:	f3 0f 1e fb          	endbr32 
80104124:	55                   	push   %ebp
80104125:	89 e5                	mov    %esp,%ebp
80104127:	53                   	push   %ebx
80104128:	83 ec 10             	sub    $0x10,%esp
8010412b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010412e:	68 20 2d 11 80       	push   $0x80112d20
80104133:	e8 c8 04 00 00       	call   80104600 <acquire>
80104138:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010413b:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104140:	eb 10                	jmp    80104152 <wakeup+0x32>
80104142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104148:	83 e8 80             	sub    $0xffffff80,%eax
8010414b:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104150:	74 1c                	je     8010416e <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
80104152:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104156:	75 f0                	jne    80104148 <wakeup+0x28>
80104158:	3b 58 20             	cmp    0x20(%eax),%ebx
8010415b:	75 eb                	jne    80104148 <wakeup+0x28>
      p->state = RUNNABLE;
8010415d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104164:	83 e8 80             	sub    $0xffffff80,%eax
80104167:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
8010416c:	75 e4                	jne    80104152 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
8010416e:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104175:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104178:	c9                   	leave  
  release(&ptable.lock);
80104179:	e9 42 05 00 00       	jmp    801046c0 <release>
8010417e:	66 90                	xchg   %ax,%ax

80104180 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104180:	f3 0f 1e fb          	endbr32 
80104184:	55                   	push   %ebp
80104185:	89 e5                	mov    %esp,%ebp
80104187:	53                   	push   %ebx
80104188:	83 ec 10             	sub    $0x10,%esp
8010418b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010418e:	68 20 2d 11 80       	push   $0x80112d20
80104193:	e8 68 04 00 00       	call   80104600 <acquire>
80104198:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010419b:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801041a0:	eb 10                	jmp    801041b2 <kill+0x32>
801041a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801041a8:	83 e8 80             	sub    $0xffffff80,%eax
801041ab:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
801041b0:	74 36                	je     801041e8 <kill+0x68>
    if(p->pid == pid){
801041b2:	39 58 10             	cmp    %ebx,0x10(%eax)
801041b5:	75 f1                	jne    801041a8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041b7:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041bb:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041c2:	75 07                	jne    801041cb <kill+0x4b>
        p->state = RUNNABLE;
801041c4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041cb:	83 ec 0c             	sub    $0xc,%esp
801041ce:	68 20 2d 11 80       	push   $0x80112d20
801041d3:	e8 e8 04 00 00       	call   801046c0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801041d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801041db:	83 c4 10             	add    $0x10,%esp
801041de:	31 c0                	xor    %eax,%eax
}
801041e0:	c9                   	leave  
801041e1:	c3                   	ret    
801041e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801041e8:	83 ec 0c             	sub    $0xc,%esp
801041eb:	68 20 2d 11 80       	push   $0x80112d20
801041f0:	e8 cb 04 00 00       	call   801046c0 <release>
}
801041f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801041f8:	83 c4 10             	add    $0x10,%esp
801041fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104200:	c9                   	leave  
80104201:	c3                   	ret    
80104202:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104210 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104210:	f3 0f 1e fb          	endbr32 
80104214:	55                   	push   %ebp
80104215:	89 e5                	mov    %esp,%ebp
80104217:	57                   	push   %edi
80104218:	56                   	push   %esi
80104219:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010421c:	53                   	push   %ebx
8010421d:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80104222:	83 ec 3c             	sub    $0x3c,%esp
80104225:	eb 28                	jmp    8010424f <procdump+0x3f>
80104227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010422e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104230:	83 ec 0c             	sub    $0xc,%esp
80104233:	68 3f 7b 10 80       	push   $0x80107b3f
80104238:	e8 73 c4 ff ff       	call   801006b0 <cprintf>
8010423d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104240:	83 eb 80             	sub    $0xffffff80,%ebx
80104243:	81 fb c0 4d 11 80    	cmp    $0x80114dc0,%ebx
80104249:	0f 84 81 00 00 00    	je     801042d0 <procdump+0xc0>
    if(p->state == UNUSED)
8010424f:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104252:	85 c0                	test   %eax,%eax
80104254:	74 ea                	je     80104240 <procdump+0x30>
      state = "???";
80104256:	ba cb 77 10 80       	mov    $0x801077cb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010425b:	83 f8 05             	cmp    $0x5,%eax
8010425e:	77 11                	ja     80104271 <procdump+0x61>
80104260:	8b 14 85 2c 78 10 80 	mov    -0x7fef87d4(,%eax,4),%edx
      state = "???";
80104267:	b8 cb 77 10 80       	mov    $0x801077cb,%eax
8010426c:	85 d2                	test   %edx,%edx
8010426e:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104271:	53                   	push   %ebx
80104272:	52                   	push   %edx
80104273:	ff 73 a4             	pushl  -0x5c(%ebx)
80104276:	68 cf 77 10 80       	push   $0x801077cf
8010427b:	e8 30 c4 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104280:	83 c4 10             	add    $0x10,%esp
80104283:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104287:	75 a7                	jne    80104230 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104289:	83 ec 08             	sub    $0x8,%esp
8010428c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010428f:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104292:	50                   	push   %eax
80104293:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104296:	8b 40 0c             	mov    0xc(%eax),%eax
80104299:	83 c0 08             	add    $0x8,%eax
8010429c:	50                   	push   %eax
8010429d:	e8 fe 01 00 00       	call   801044a0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801042a2:	83 c4 10             	add    $0x10,%esp
801042a5:	8d 76 00             	lea    0x0(%esi),%esi
801042a8:	8b 17                	mov    (%edi),%edx
801042aa:	85 d2                	test   %edx,%edx
801042ac:	74 82                	je     80104230 <procdump+0x20>
        cprintf(" %p", pc[i]);
801042ae:	83 ec 08             	sub    $0x8,%esp
801042b1:	83 c7 04             	add    $0x4,%edi
801042b4:	52                   	push   %edx
801042b5:	68 21 72 10 80       	push   $0x80107221
801042ba:	e8 f1 c3 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042bf:	83 c4 10             	add    $0x10,%esp
801042c2:	39 fe                	cmp    %edi,%esi
801042c4:	75 e2                	jne    801042a8 <procdump+0x98>
801042c6:	e9 65 ff ff ff       	jmp    80104230 <procdump+0x20>
801042cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042cf:	90                   	nop
  }
}
801042d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042d3:	5b                   	pop    %ebx
801042d4:	5e                   	pop    %esi
801042d5:	5f                   	pop    %edi
801042d6:	5d                   	pop    %ebp
801042d7:	c3                   	ret    
801042d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042df:	90                   	nop

801042e0 <chpr>:
//change or assign priority to the process
int chpr ( int pid, int priority )
{
801042e0:	f3 0f 1e fb          	endbr32 
801042e4:	55                   	push   %ebp
801042e5:	89 e5                	mov    %esp,%ebp
801042e7:	53                   	push   %ebx
801042e8:	83 ec 10             	sub    $0x10,%esp
801042eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
struct proc *p;
acquire(&ptable.lock);
801042ee:	68 20 2d 11 80       	push   $0x80112d20
801042f3:	e8 08 03 00 00       	call   80104600 <acquire>
801042f8:	83 c4 10             	add    $0x10,%esp
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042fb:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104300:	eb 10                	jmp    80104312 <chpr+0x32>
80104302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104308:	83 e8 80             	sub    $0xffffff80,%eax
8010430b:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104310:	74 0b                	je     8010431d <chpr+0x3d>
if(p->pid == pid){
80104312:	39 58 10             	cmp    %ebx,0x10(%eax)
80104315:	75 f1                	jne    80104308 <chpr+0x28>
p->priority = priority;
80104317:	8b 55 0c             	mov    0xc(%ebp),%edx
8010431a:	89 50 7c             	mov    %edx,0x7c(%eax)
break;
}
}
release(&ptable.lock);
8010431d:	83 ec 0c             	sub    $0xc,%esp
80104320:	68 20 2d 11 80       	push   $0x80112d20
80104325:	e8 96 03 00 00       	call   801046c0 <release>
return pid;
}
8010432a:	89 d8                	mov    %ebx,%eax
8010432c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010432f:	c9                   	leave  
80104330:	c3                   	ret    
80104331:	66 90                	xchg   %ax,%ax
80104333:	66 90                	xchg   %ax,%ax
80104335:	66 90                	xchg   %ax,%ax
80104337:	66 90                	xchg   %ax,%ax
80104339:	66 90                	xchg   %ax,%ax
8010433b:	66 90                	xchg   %ax,%ax
8010433d:	66 90                	xchg   %ax,%ax
8010433f:	90                   	nop

80104340 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104340:	f3 0f 1e fb          	endbr32 
80104344:	55                   	push   %ebp
80104345:	89 e5                	mov    %esp,%ebp
80104347:	53                   	push   %ebx
80104348:	83 ec 0c             	sub    $0xc,%esp
8010434b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010434e:	68 44 78 10 80       	push   $0x80107844
80104353:	8d 43 04             	lea    0x4(%ebx),%eax
80104356:	50                   	push   %eax
80104357:	e8 24 01 00 00       	call   80104480 <initlock>
  lk->name = name;
8010435c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010435f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104365:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104368:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010436f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104372:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104375:	c9                   	leave  
80104376:	c3                   	ret    
80104377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010437e:	66 90                	xchg   %ax,%ax

80104380 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104380:	f3 0f 1e fb          	endbr32 
80104384:	55                   	push   %ebp
80104385:	89 e5                	mov    %esp,%ebp
80104387:	56                   	push   %esi
80104388:	53                   	push   %ebx
80104389:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010438c:	8d 73 04             	lea    0x4(%ebx),%esi
8010438f:	83 ec 0c             	sub    $0xc,%esp
80104392:	56                   	push   %esi
80104393:	e8 68 02 00 00       	call   80104600 <acquire>
  while (lk->locked) {
80104398:	8b 13                	mov    (%ebx),%edx
8010439a:	83 c4 10             	add    $0x10,%esp
8010439d:	85 d2                	test   %edx,%edx
8010439f:	74 1a                	je     801043bb <acquiresleep+0x3b>
801043a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801043a8:	83 ec 08             	sub    $0x8,%esp
801043ab:	56                   	push   %esi
801043ac:	53                   	push   %ebx
801043ad:	e8 ae fb ff ff       	call   80103f60 <sleep>
  while (lk->locked) {
801043b2:	8b 03                	mov    (%ebx),%eax
801043b4:	83 c4 10             	add    $0x10,%esp
801043b7:	85 c0                	test   %eax,%eax
801043b9:	75 ed                	jne    801043a8 <acquiresleep+0x28>
  }
  lk->locked = 1;
801043bb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801043c1:	e8 ba f5 ff ff       	call   80103980 <myproc>
801043c6:	8b 40 10             	mov    0x10(%eax),%eax
801043c9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801043cc:	89 75 08             	mov    %esi,0x8(%ebp)
}
801043cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043d2:	5b                   	pop    %ebx
801043d3:	5e                   	pop    %esi
801043d4:	5d                   	pop    %ebp
  release(&lk->lk);
801043d5:	e9 e6 02 00 00       	jmp    801046c0 <release>
801043da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043e0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801043e0:	f3 0f 1e fb          	endbr32 
801043e4:	55                   	push   %ebp
801043e5:	89 e5                	mov    %esp,%ebp
801043e7:	56                   	push   %esi
801043e8:	53                   	push   %ebx
801043e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043ec:	8d 73 04             	lea    0x4(%ebx),%esi
801043ef:	83 ec 0c             	sub    $0xc,%esp
801043f2:	56                   	push   %esi
801043f3:	e8 08 02 00 00       	call   80104600 <acquire>
  lk->locked = 0;
801043f8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801043fe:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104405:	89 1c 24             	mov    %ebx,(%esp)
80104408:	e8 13 fd ff ff       	call   80104120 <wakeup>
  release(&lk->lk);
8010440d:	89 75 08             	mov    %esi,0x8(%ebp)
80104410:	83 c4 10             	add    $0x10,%esp
}
80104413:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104416:	5b                   	pop    %ebx
80104417:	5e                   	pop    %esi
80104418:	5d                   	pop    %ebp
  release(&lk->lk);
80104419:	e9 a2 02 00 00       	jmp    801046c0 <release>
8010441e:	66 90                	xchg   %ax,%ax

80104420 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104420:	f3 0f 1e fb          	endbr32 
80104424:	55                   	push   %ebp
80104425:	89 e5                	mov    %esp,%ebp
80104427:	57                   	push   %edi
80104428:	31 ff                	xor    %edi,%edi
8010442a:	56                   	push   %esi
8010442b:	53                   	push   %ebx
8010442c:	83 ec 18             	sub    $0x18,%esp
8010442f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104432:	8d 73 04             	lea    0x4(%ebx),%esi
80104435:	56                   	push   %esi
80104436:	e8 c5 01 00 00       	call   80104600 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
8010443b:	8b 03                	mov    (%ebx),%eax
8010443d:	83 c4 10             	add    $0x10,%esp
80104440:	85 c0                	test   %eax,%eax
80104442:	75 1c                	jne    80104460 <holdingsleep+0x40>
  release(&lk->lk);
80104444:	83 ec 0c             	sub    $0xc,%esp
80104447:	56                   	push   %esi
80104448:	e8 73 02 00 00       	call   801046c0 <release>
  return r;
}
8010444d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104450:	89 f8                	mov    %edi,%eax
80104452:	5b                   	pop    %ebx
80104453:	5e                   	pop    %esi
80104454:	5f                   	pop    %edi
80104455:	5d                   	pop    %ebp
80104456:	c3                   	ret    
80104457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010445e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104460:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104463:	e8 18 f5 ff ff       	call   80103980 <myproc>
80104468:	39 58 10             	cmp    %ebx,0x10(%eax)
8010446b:	0f 94 c0             	sete   %al
8010446e:	0f b6 c0             	movzbl %al,%eax
80104471:	89 c7                	mov    %eax,%edi
80104473:	eb cf                	jmp    80104444 <holdingsleep+0x24>
80104475:	66 90                	xchg   %ax,%ax
80104477:	66 90                	xchg   %ax,%ax
80104479:	66 90                	xchg   %ax,%ax
8010447b:	66 90                	xchg   %ax,%ax
8010447d:	66 90                	xchg   %ax,%ax
8010447f:	90                   	nop

80104480 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104480:	f3 0f 1e fb          	endbr32 
80104484:	55                   	push   %ebp
80104485:	89 e5                	mov    %esp,%ebp
80104487:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010448a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010448d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104493:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104496:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010449d:	5d                   	pop    %ebp
8010449e:	c3                   	ret    
8010449f:	90                   	nop

801044a0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801044a0:	f3 0f 1e fb          	endbr32 
801044a4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801044a5:	31 d2                	xor    %edx,%edx
{
801044a7:	89 e5                	mov    %esp,%ebp
801044a9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801044aa:	8b 45 08             	mov    0x8(%ebp),%eax
{
801044ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801044b0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801044b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044b7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801044b8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801044be:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801044c4:	77 1a                	ja     801044e0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
801044c6:	8b 58 04             	mov    0x4(%eax),%ebx
801044c9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801044cc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801044cf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801044d1:	83 fa 0a             	cmp    $0xa,%edx
801044d4:	75 e2                	jne    801044b8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801044d6:	5b                   	pop    %ebx
801044d7:	5d                   	pop    %ebp
801044d8:	c3                   	ret    
801044d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801044e0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801044e3:	8d 51 28             	lea    0x28(%ecx),%edx
801044e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ed:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801044f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801044f6:	83 c0 04             	add    $0x4,%eax
801044f9:	39 d0                	cmp    %edx,%eax
801044fb:	75 f3                	jne    801044f0 <getcallerpcs+0x50>
}
801044fd:	5b                   	pop    %ebx
801044fe:	5d                   	pop    %ebp
801044ff:	c3                   	ret    

80104500 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104500:	f3 0f 1e fb          	endbr32 
80104504:	55                   	push   %ebp
80104505:	89 e5                	mov    %esp,%ebp
80104507:	53                   	push   %ebx
80104508:	83 ec 04             	sub    $0x4,%esp
8010450b:	9c                   	pushf  
8010450c:	5b                   	pop    %ebx
  asm volatile("cli");
8010450d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010450e:	e8 dd f3 ff ff       	call   801038f0 <mycpu>
80104513:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104519:	85 c0                	test   %eax,%eax
8010451b:	74 13                	je     80104530 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010451d:	e8 ce f3 ff ff       	call   801038f0 <mycpu>
80104522:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104529:	83 c4 04             	add    $0x4,%esp
8010452c:	5b                   	pop    %ebx
8010452d:	5d                   	pop    %ebp
8010452e:	c3                   	ret    
8010452f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104530:	e8 bb f3 ff ff       	call   801038f0 <mycpu>
80104535:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010453b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104541:	eb da                	jmp    8010451d <pushcli+0x1d>
80104543:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010454a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104550 <popcli>:

void
popcli(void)
{
80104550:	f3 0f 1e fb          	endbr32 
80104554:	55                   	push   %ebp
80104555:	89 e5                	mov    %esp,%ebp
80104557:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010455a:	9c                   	pushf  
8010455b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010455c:	f6 c4 02             	test   $0x2,%ah
8010455f:	75 31                	jne    80104592 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104561:	e8 8a f3 ff ff       	call   801038f0 <mycpu>
80104566:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
8010456d:	78 30                	js     8010459f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010456f:	e8 7c f3 ff ff       	call   801038f0 <mycpu>
80104574:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010457a:	85 d2                	test   %edx,%edx
8010457c:	74 02                	je     80104580 <popcli+0x30>
    sti();
}
8010457e:	c9                   	leave  
8010457f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104580:	e8 6b f3 ff ff       	call   801038f0 <mycpu>
80104585:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010458b:	85 c0                	test   %eax,%eax
8010458d:	74 ef                	je     8010457e <popcli+0x2e>
  asm volatile("sti");
8010458f:	fb                   	sti    
}
80104590:	c9                   	leave  
80104591:	c3                   	ret    
    panic("popcli - interruptible");
80104592:	83 ec 0c             	sub    $0xc,%esp
80104595:	68 4f 78 10 80       	push   $0x8010784f
8010459a:	e8 f1 bd ff ff       	call   80100390 <panic>
    panic("popcli");
8010459f:	83 ec 0c             	sub    $0xc,%esp
801045a2:	68 66 78 10 80       	push   $0x80107866
801045a7:	e8 e4 bd ff ff       	call   80100390 <panic>
801045ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045b0 <holding>:
{
801045b0:	f3 0f 1e fb          	endbr32 
801045b4:	55                   	push   %ebp
801045b5:	89 e5                	mov    %esp,%ebp
801045b7:	56                   	push   %esi
801045b8:	53                   	push   %ebx
801045b9:	8b 75 08             	mov    0x8(%ebp),%esi
801045bc:	31 db                	xor    %ebx,%ebx
  pushcli();
801045be:	e8 3d ff ff ff       	call   80104500 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801045c3:	8b 06                	mov    (%esi),%eax
801045c5:	85 c0                	test   %eax,%eax
801045c7:	75 0f                	jne    801045d8 <holding+0x28>
  popcli();
801045c9:	e8 82 ff ff ff       	call   80104550 <popcli>
}
801045ce:	89 d8                	mov    %ebx,%eax
801045d0:	5b                   	pop    %ebx
801045d1:	5e                   	pop    %esi
801045d2:	5d                   	pop    %ebp
801045d3:	c3                   	ret    
801045d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
801045d8:	8b 5e 08             	mov    0x8(%esi),%ebx
801045db:	e8 10 f3 ff ff       	call   801038f0 <mycpu>
801045e0:	39 c3                	cmp    %eax,%ebx
801045e2:	0f 94 c3             	sete   %bl
  popcli();
801045e5:	e8 66 ff ff ff       	call   80104550 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801045ea:	0f b6 db             	movzbl %bl,%ebx
}
801045ed:	89 d8                	mov    %ebx,%eax
801045ef:	5b                   	pop    %ebx
801045f0:	5e                   	pop    %esi
801045f1:	5d                   	pop    %ebp
801045f2:	c3                   	ret    
801045f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104600 <acquire>:
{
80104600:	f3 0f 1e fb          	endbr32 
80104604:	55                   	push   %ebp
80104605:	89 e5                	mov    %esp,%ebp
80104607:	56                   	push   %esi
80104608:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104609:	e8 f2 fe ff ff       	call   80104500 <pushcli>
  if(holding(lk))
8010460e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104611:	83 ec 0c             	sub    $0xc,%esp
80104614:	53                   	push   %ebx
80104615:	e8 96 ff ff ff       	call   801045b0 <holding>
8010461a:	83 c4 10             	add    $0x10,%esp
8010461d:	85 c0                	test   %eax,%eax
8010461f:	0f 85 7f 00 00 00    	jne    801046a4 <acquire+0xa4>
80104625:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104627:	ba 01 00 00 00       	mov    $0x1,%edx
8010462c:	eb 05                	jmp    80104633 <acquire+0x33>
8010462e:	66 90                	xchg   %ax,%ax
80104630:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104633:	89 d0                	mov    %edx,%eax
80104635:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104638:	85 c0                	test   %eax,%eax
8010463a:	75 f4                	jne    80104630 <acquire+0x30>
  __sync_synchronize();
8010463c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104641:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104644:	e8 a7 f2 ff ff       	call   801038f0 <mycpu>
80104649:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010464c:	89 e8                	mov    %ebp,%eax
8010464e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104650:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104656:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010465c:	77 22                	ja     80104680 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010465e:	8b 50 04             	mov    0x4(%eax),%edx
80104661:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104665:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104668:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010466a:	83 fe 0a             	cmp    $0xa,%esi
8010466d:	75 e1                	jne    80104650 <acquire+0x50>
}
8010466f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104672:	5b                   	pop    %ebx
80104673:	5e                   	pop    %esi
80104674:	5d                   	pop    %ebp
80104675:	c3                   	ret    
80104676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010467d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104680:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104684:	83 c3 34             	add    $0x34,%ebx
80104687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010468e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104690:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104696:	83 c0 04             	add    $0x4,%eax
80104699:	39 d8                	cmp    %ebx,%eax
8010469b:	75 f3                	jne    80104690 <acquire+0x90>
}
8010469d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046a0:	5b                   	pop    %ebx
801046a1:	5e                   	pop    %esi
801046a2:	5d                   	pop    %ebp
801046a3:	c3                   	ret    
    panic("acquire");
801046a4:	83 ec 0c             	sub    $0xc,%esp
801046a7:	68 6d 78 10 80       	push   $0x8010786d
801046ac:	e8 df bc ff ff       	call   80100390 <panic>
801046b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046bf:	90                   	nop

801046c0 <release>:
{
801046c0:	f3 0f 1e fb          	endbr32 
801046c4:	55                   	push   %ebp
801046c5:	89 e5                	mov    %esp,%ebp
801046c7:	53                   	push   %ebx
801046c8:	83 ec 10             	sub    $0x10,%esp
801046cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801046ce:	53                   	push   %ebx
801046cf:	e8 dc fe ff ff       	call   801045b0 <holding>
801046d4:	83 c4 10             	add    $0x10,%esp
801046d7:	85 c0                	test   %eax,%eax
801046d9:	74 22                	je     801046fd <release+0x3d>
  lk->pcs[0] = 0;
801046db:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801046e2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801046e9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801046ee:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801046f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046f7:	c9                   	leave  
  popcli();
801046f8:	e9 53 fe ff ff       	jmp    80104550 <popcli>
    panic("release");
801046fd:	83 ec 0c             	sub    $0xc,%esp
80104700:	68 75 78 10 80       	push   $0x80107875
80104705:	e8 86 bc ff ff       	call   80100390 <panic>
8010470a:	66 90                	xchg   %ax,%ax
8010470c:	66 90                	xchg   %ax,%ax
8010470e:	66 90                	xchg   %ax,%ax

80104710 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104710:	f3 0f 1e fb          	endbr32 
80104714:	55                   	push   %ebp
80104715:	89 e5                	mov    %esp,%ebp
80104717:	57                   	push   %edi
80104718:	8b 55 08             	mov    0x8(%ebp),%edx
8010471b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010471e:	53                   	push   %ebx
8010471f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104722:	89 d7                	mov    %edx,%edi
80104724:	09 cf                	or     %ecx,%edi
80104726:	83 e7 03             	and    $0x3,%edi
80104729:	75 25                	jne    80104750 <memset+0x40>
    c &= 0xFF;
8010472b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010472e:	c1 e0 18             	shl    $0x18,%eax
80104731:	89 fb                	mov    %edi,%ebx
80104733:	c1 e9 02             	shr    $0x2,%ecx
80104736:	c1 e3 10             	shl    $0x10,%ebx
80104739:	09 d8                	or     %ebx,%eax
8010473b:	09 f8                	or     %edi,%eax
8010473d:	c1 e7 08             	shl    $0x8,%edi
80104740:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104742:	89 d7                	mov    %edx,%edi
80104744:	fc                   	cld    
80104745:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104747:	5b                   	pop    %ebx
80104748:	89 d0                	mov    %edx,%eax
8010474a:	5f                   	pop    %edi
8010474b:	5d                   	pop    %ebp
8010474c:	c3                   	ret    
8010474d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104750:	89 d7                	mov    %edx,%edi
80104752:	fc                   	cld    
80104753:	f3 aa                	rep stos %al,%es:(%edi)
80104755:	5b                   	pop    %ebx
80104756:	89 d0                	mov    %edx,%eax
80104758:	5f                   	pop    %edi
80104759:	5d                   	pop    %ebp
8010475a:	c3                   	ret    
8010475b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010475f:	90                   	nop

80104760 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104760:	f3 0f 1e fb          	endbr32 
80104764:	55                   	push   %ebp
80104765:	89 e5                	mov    %esp,%ebp
80104767:	56                   	push   %esi
80104768:	8b 75 10             	mov    0x10(%ebp),%esi
8010476b:	8b 55 08             	mov    0x8(%ebp),%edx
8010476e:	53                   	push   %ebx
8010476f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104772:	85 f6                	test   %esi,%esi
80104774:	74 2a                	je     801047a0 <memcmp+0x40>
80104776:	01 c6                	add    %eax,%esi
80104778:	eb 10                	jmp    8010478a <memcmp+0x2a>
8010477a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104780:	83 c0 01             	add    $0x1,%eax
80104783:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104786:	39 f0                	cmp    %esi,%eax
80104788:	74 16                	je     801047a0 <memcmp+0x40>
    if(*s1 != *s2)
8010478a:	0f b6 0a             	movzbl (%edx),%ecx
8010478d:	0f b6 18             	movzbl (%eax),%ebx
80104790:	38 d9                	cmp    %bl,%cl
80104792:	74 ec                	je     80104780 <memcmp+0x20>
      return *s1 - *s2;
80104794:	0f b6 c1             	movzbl %cl,%eax
80104797:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104799:	5b                   	pop    %ebx
8010479a:	5e                   	pop    %esi
8010479b:	5d                   	pop    %ebp
8010479c:	c3                   	ret    
8010479d:	8d 76 00             	lea    0x0(%esi),%esi
801047a0:	5b                   	pop    %ebx
  return 0;
801047a1:	31 c0                	xor    %eax,%eax
}
801047a3:	5e                   	pop    %esi
801047a4:	5d                   	pop    %ebp
801047a5:	c3                   	ret    
801047a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ad:	8d 76 00             	lea    0x0(%esi),%esi

801047b0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801047b0:	f3 0f 1e fb          	endbr32 
801047b4:	55                   	push   %ebp
801047b5:	89 e5                	mov    %esp,%ebp
801047b7:	57                   	push   %edi
801047b8:	8b 55 08             	mov    0x8(%ebp),%edx
801047bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047be:	56                   	push   %esi
801047bf:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801047c2:	39 d6                	cmp    %edx,%esi
801047c4:	73 2a                	jae    801047f0 <memmove+0x40>
801047c6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801047c9:	39 fa                	cmp    %edi,%edx
801047cb:	73 23                	jae    801047f0 <memmove+0x40>
801047cd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801047d0:	85 c9                	test   %ecx,%ecx
801047d2:	74 13                	je     801047e7 <memmove+0x37>
801047d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
801047d8:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801047dc:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801047df:	83 e8 01             	sub    $0x1,%eax
801047e2:	83 f8 ff             	cmp    $0xffffffff,%eax
801047e5:	75 f1                	jne    801047d8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801047e7:	5e                   	pop    %esi
801047e8:	89 d0                	mov    %edx,%eax
801047ea:	5f                   	pop    %edi
801047eb:	5d                   	pop    %ebp
801047ec:	c3                   	ret    
801047ed:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
801047f0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801047f3:	89 d7                	mov    %edx,%edi
801047f5:	85 c9                	test   %ecx,%ecx
801047f7:	74 ee                	je     801047e7 <memmove+0x37>
801047f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104800:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104801:	39 f0                	cmp    %esi,%eax
80104803:	75 fb                	jne    80104800 <memmove+0x50>
}
80104805:	5e                   	pop    %esi
80104806:	89 d0                	mov    %edx,%eax
80104808:	5f                   	pop    %edi
80104809:	5d                   	pop    %ebp
8010480a:	c3                   	ret    
8010480b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010480f:	90                   	nop

80104810 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104810:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104814:	eb 9a                	jmp    801047b0 <memmove>
80104816:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010481d:	8d 76 00             	lea    0x0(%esi),%esi

80104820 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104820:	f3 0f 1e fb          	endbr32 
80104824:	55                   	push   %ebp
80104825:	89 e5                	mov    %esp,%ebp
80104827:	56                   	push   %esi
80104828:	8b 75 10             	mov    0x10(%ebp),%esi
8010482b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010482e:	53                   	push   %ebx
8010482f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104832:	85 f6                	test   %esi,%esi
80104834:	74 32                	je     80104868 <strncmp+0x48>
80104836:	01 c6                	add    %eax,%esi
80104838:	eb 14                	jmp    8010484e <strncmp+0x2e>
8010483a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104840:	38 da                	cmp    %bl,%dl
80104842:	75 14                	jne    80104858 <strncmp+0x38>
    n--, p++, q++;
80104844:	83 c0 01             	add    $0x1,%eax
80104847:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010484a:	39 f0                	cmp    %esi,%eax
8010484c:	74 1a                	je     80104868 <strncmp+0x48>
8010484e:	0f b6 11             	movzbl (%ecx),%edx
80104851:	0f b6 18             	movzbl (%eax),%ebx
80104854:	84 d2                	test   %dl,%dl
80104856:	75 e8                	jne    80104840 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104858:	0f b6 c2             	movzbl %dl,%eax
8010485b:	29 d8                	sub    %ebx,%eax
}
8010485d:	5b                   	pop    %ebx
8010485e:	5e                   	pop    %esi
8010485f:	5d                   	pop    %ebp
80104860:	c3                   	ret    
80104861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104868:	5b                   	pop    %ebx
    return 0;
80104869:	31 c0                	xor    %eax,%eax
}
8010486b:	5e                   	pop    %esi
8010486c:	5d                   	pop    %ebp
8010486d:	c3                   	ret    
8010486e:	66 90                	xchg   %ax,%ax

80104870 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104870:	f3 0f 1e fb          	endbr32 
80104874:	55                   	push   %ebp
80104875:	89 e5                	mov    %esp,%ebp
80104877:	57                   	push   %edi
80104878:	56                   	push   %esi
80104879:	8b 75 08             	mov    0x8(%ebp),%esi
8010487c:	53                   	push   %ebx
8010487d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104880:	89 f2                	mov    %esi,%edx
80104882:	eb 1b                	jmp    8010489f <strncpy+0x2f>
80104884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104888:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010488c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010488f:	83 c2 01             	add    $0x1,%edx
80104892:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104896:	89 f9                	mov    %edi,%ecx
80104898:	88 4a ff             	mov    %cl,-0x1(%edx)
8010489b:	84 c9                	test   %cl,%cl
8010489d:	74 09                	je     801048a8 <strncpy+0x38>
8010489f:	89 c3                	mov    %eax,%ebx
801048a1:	83 e8 01             	sub    $0x1,%eax
801048a4:	85 db                	test   %ebx,%ebx
801048a6:	7f e0                	jg     80104888 <strncpy+0x18>
    ;
  while(n-- > 0)
801048a8:	89 d1                	mov    %edx,%ecx
801048aa:	85 c0                	test   %eax,%eax
801048ac:	7e 15                	jle    801048c3 <strncpy+0x53>
801048ae:	66 90                	xchg   %ax,%ax
    *s++ = 0;
801048b0:	83 c1 01             	add    $0x1,%ecx
801048b3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801048b7:	89 c8                	mov    %ecx,%eax
801048b9:	f7 d0                	not    %eax
801048bb:	01 d0                	add    %edx,%eax
801048bd:	01 d8                	add    %ebx,%eax
801048bf:	85 c0                	test   %eax,%eax
801048c1:	7f ed                	jg     801048b0 <strncpy+0x40>
  return os;
}
801048c3:	5b                   	pop    %ebx
801048c4:	89 f0                	mov    %esi,%eax
801048c6:	5e                   	pop    %esi
801048c7:	5f                   	pop    %edi
801048c8:	5d                   	pop    %ebp
801048c9:	c3                   	ret    
801048ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048d0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801048d0:	f3 0f 1e fb          	endbr32 
801048d4:	55                   	push   %ebp
801048d5:	89 e5                	mov    %esp,%ebp
801048d7:	56                   	push   %esi
801048d8:	8b 55 10             	mov    0x10(%ebp),%edx
801048db:	8b 75 08             	mov    0x8(%ebp),%esi
801048de:	53                   	push   %ebx
801048df:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801048e2:	85 d2                	test   %edx,%edx
801048e4:	7e 21                	jle    80104907 <safestrcpy+0x37>
801048e6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801048ea:	89 f2                	mov    %esi,%edx
801048ec:	eb 12                	jmp    80104900 <safestrcpy+0x30>
801048ee:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801048f0:	0f b6 08             	movzbl (%eax),%ecx
801048f3:	83 c0 01             	add    $0x1,%eax
801048f6:	83 c2 01             	add    $0x1,%edx
801048f9:	88 4a ff             	mov    %cl,-0x1(%edx)
801048fc:	84 c9                	test   %cl,%cl
801048fe:	74 04                	je     80104904 <safestrcpy+0x34>
80104900:	39 d8                	cmp    %ebx,%eax
80104902:	75 ec                	jne    801048f0 <safestrcpy+0x20>
    ;
  *s = 0;
80104904:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104907:	89 f0                	mov    %esi,%eax
80104909:	5b                   	pop    %ebx
8010490a:	5e                   	pop    %esi
8010490b:	5d                   	pop    %ebp
8010490c:	c3                   	ret    
8010490d:	8d 76 00             	lea    0x0(%esi),%esi

80104910 <strlen>:

int
strlen(const char *s)
{
80104910:	f3 0f 1e fb          	endbr32 
80104914:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104915:	31 c0                	xor    %eax,%eax
{
80104917:	89 e5                	mov    %esp,%ebp
80104919:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010491c:	80 3a 00             	cmpb   $0x0,(%edx)
8010491f:	74 10                	je     80104931 <strlen+0x21>
80104921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104928:	83 c0 01             	add    $0x1,%eax
8010492b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010492f:	75 f7                	jne    80104928 <strlen+0x18>
    ;
  return n;
}
80104931:	5d                   	pop    %ebp
80104932:	c3                   	ret    

80104933 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104933:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104937:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010493b:	55                   	push   %ebp
  pushl %ebx
8010493c:	53                   	push   %ebx
  pushl %esi
8010493d:	56                   	push   %esi
  pushl %edi
8010493e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010493f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104941:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104943:	5f                   	pop    %edi
  popl %esi
80104944:	5e                   	pop    %esi
  popl %ebx
80104945:	5b                   	pop    %ebx
  popl %ebp
80104946:	5d                   	pop    %ebp
  ret
80104947:	c3                   	ret    
80104948:	66 90                	xchg   %ax,%ax
8010494a:	66 90                	xchg   %ax,%ax
8010494c:	66 90                	xchg   %ax,%ax
8010494e:	66 90                	xchg   %ax,%ax

80104950 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104950:	f3 0f 1e fb          	endbr32 
80104954:	55                   	push   %ebp
80104955:	89 e5                	mov    %esp,%ebp
80104957:	53                   	push   %ebx
80104958:	83 ec 04             	sub    $0x4,%esp
8010495b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010495e:	e8 1d f0 ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104963:	8b 00                	mov    (%eax),%eax
80104965:	39 d8                	cmp    %ebx,%eax
80104967:	76 17                	jbe    80104980 <fetchint+0x30>
80104969:	8d 53 04             	lea    0x4(%ebx),%edx
8010496c:	39 d0                	cmp    %edx,%eax
8010496e:	72 10                	jb     80104980 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104970:	8b 45 0c             	mov    0xc(%ebp),%eax
80104973:	8b 13                	mov    (%ebx),%edx
80104975:	89 10                	mov    %edx,(%eax)
  return 0;
80104977:	31 c0                	xor    %eax,%eax
}
80104979:	83 c4 04             	add    $0x4,%esp
8010497c:	5b                   	pop    %ebx
8010497d:	5d                   	pop    %ebp
8010497e:	c3                   	ret    
8010497f:	90                   	nop
    return -1;
80104980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104985:	eb f2                	jmp    80104979 <fetchint+0x29>
80104987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010498e:	66 90                	xchg   %ax,%ax

80104990 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104990:	f3 0f 1e fb          	endbr32 
80104994:	55                   	push   %ebp
80104995:	89 e5                	mov    %esp,%ebp
80104997:	53                   	push   %ebx
80104998:	83 ec 04             	sub    $0x4,%esp
8010499b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010499e:	e8 dd ef ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz)
801049a3:	39 18                	cmp    %ebx,(%eax)
801049a5:	76 31                	jbe    801049d8 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
801049a7:	8b 55 0c             	mov    0xc(%ebp),%edx
801049aa:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801049ac:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801049ae:	39 d3                	cmp    %edx,%ebx
801049b0:	73 26                	jae    801049d8 <fetchstr+0x48>
801049b2:	89 d8                	mov    %ebx,%eax
801049b4:	eb 11                	jmp    801049c7 <fetchstr+0x37>
801049b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049bd:	8d 76 00             	lea    0x0(%esi),%esi
801049c0:	83 c0 01             	add    $0x1,%eax
801049c3:	39 c2                	cmp    %eax,%edx
801049c5:	76 11                	jbe    801049d8 <fetchstr+0x48>
    if(*s == 0)
801049c7:	80 38 00             	cmpb   $0x0,(%eax)
801049ca:	75 f4                	jne    801049c0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
801049cc:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
801049cf:	29 d8                	sub    %ebx,%eax
}
801049d1:	5b                   	pop    %ebx
801049d2:	5d                   	pop    %ebp
801049d3:	c3                   	ret    
801049d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049d8:	83 c4 04             	add    $0x4,%esp
    return -1;
801049db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049e0:	5b                   	pop    %ebx
801049e1:	5d                   	pop    %ebp
801049e2:	c3                   	ret    
801049e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049f0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801049f0:	f3 0f 1e fb          	endbr32 
801049f4:	55                   	push   %ebp
801049f5:	89 e5                	mov    %esp,%ebp
801049f7:	56                   	push   %esi
801049f8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049f9:	e8 82 ef ff ff       	call   80103980 <myproc>
801049fe:	8b 55 08             	mov    0x8(%ebp),%edx
80104a01:	8b 40 18             	mov    0x18(%eax),%eax
80104a04:	8b 40 44             	mov    0x44(%eax),%eax
80104a07:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a0a:	e8 71 ef ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a0f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a12:	8b 00                	mov    (%eax),%eax
80104a14:	39 c6                	cmp    %eax,%esi
80104a16:	73 18                	jae    80104a30 <argint+0x40>
80104a18:	8d 53 08             	lea    0x8(%ebx),%edx
80104a1b:	39 d0                	cmp    %edx,%eax
80104a1d:	72 11                	jb     80104a30 <argint+0x40>
  *ip = *(int*)(addr);
80104a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a22:	8b 53 04             	mov    0x4(%ebx),%edx
80104a25:	89 10                	mov    %edx,(%eax)
  return 0;
80104a27:	31 c0                	xor    %eax,%eax
}
80104a29:	5b                   	pop    %ebx
80104a2a:	5e                   	pop    %esi
80104a2b:	5d                   	pop    %ebp
80104a2c:	c3                   	ret    
80104a2d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a35:	eb f2                	jmp    80104a29 <argint+0x39>
80104a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a3e:	66 90                	xchg   %ax,%ax

80104a40 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104a40:	f3 0f 1e fb          	endbr32 
80104a44:	55                   	push   %ebp
80104a45:	89 e5                	mov    %esp,%ebp
80104a47:	56                   	push   %esi
80104a48:	53                   	push   %ebx
80104a49:	83 ec 10             	sub    $0x10,%esp
80104a4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104a4f:	e8 2c ef ff ff       	call   80103980 <myproc>
 
  if(argint(n, &i) < 0)
80104a54:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104a57:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104a59:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a5c:	50                   	push   %eax
80104a5d:	ff 75 08             	pushl  0x8(%ebp)
80104a60:	e8 8b ff ff ff       	call   801049f0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a65:	83 c4 10             	add    $0x10,%esp
80104a68:	85 c0                	test   %eax,%eax
80104a6a:	78 24                	js     80104a90 <argptr+0x50>
80104a6c:	85 db                	test   %ebx,%ebx
80104a6e:	78 20                	js     80104a90 <argptr+0x50>
80104a70:	8b 16                	mov    (%esi),%edx
80104a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a75:	39 c2                	cmp    %eax,%edx
80104a77:	76 17                	jbe    80104a90 <argptr+0x50>
80104a79:	01 c3                	add    %eax,%ebx
80104a7b:	39 da                	cmp    %ebx,%edx
80104a7d:	72 11                	jb     80104a90 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104a7f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a82:	89 02                	mov    %eax,(%edx)
  return 0;
80104a84:	31 c0                	xor    %eax,%eax
}
80104a86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a89:	5b                   	pop    %ebx
80104a8a:	5e                   	pop    %esi
80104a8b:	5d                   	pop    %ebp
80104a8c:	c3                   	ret    
80104a8d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a95:	eb ef                	jmp    80104a86 <argptr+0x46>
80104a97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a9e:	66 90                	xchg   %ax,%ax

80104aa0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104aa0:	f3 0f 1e fb          	endbr32 
80104aa4:	55                   	push   %ebp
80104aa5:	89 e5                	mov    %esp,%ebp
80104aa7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104aaa:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104aad:	50                   	push   %eax
80104aae:	ff 75 08             	pushl  0x8(%ebp)
80104ab1:	e8 3a ff ff ff       	call   801049f0 <argint>
80104ab6:	83 c4 10             	add    $0x10,%esp
80104ab9:	85 c0                	test   %eax,%eax
80104abb:	78 13                	js     80104ad0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104abd:	83 ec 08             	sub    $0x8,%esp
80104ac0:	ff 75 0c             	pushl  0xc(%ebp)
80104ac3:	ff 75 f4             	pushl  -0xc(%ebp)
80104ac6:	e8 c5 fe ff ff       	call   80104990 <fetchstr>
80104acb:	83 c4 10             	add    $0x10,%esp
}
80104ace:	c9                   	leave  
80104acf:	c3                   	ret    
80104ad0:	c9                   	leave  
    return -1;
80104ad1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ad6:	c3                   	ret    
80104ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ade:	66 90                	xchg   %ax,%ax

80104ae0 <syscall>:
[SYS_chpr]    sys_chpr,
};

void
syscall(void)
{
80104ae0:	f3 0f 1e fb          	endbr32 
80104ae4:	55                   	push   %ebp
80104ae5:	89 e5                	mov    %esp,%ebp
80104ae7:	53                   	push   %ebx
80104ae8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104aeb:	e8 90 ee ff ff       	call   80103980 <myproc>
80104af0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104af2:	8b 40 18             	mov    0x18(%eax),%eax
80104af5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104af8:	8d 50 ff             	lea    -0x1(%eax),%edx
80104afb:	83 fa 16             	cmp    $0x16,%edx
80104afe:	77 20                	ja     80104b20 <syscall+0x40>
80104b00:	8b 14 85 a0 78 10 80 	mov    -0x7fef8760(,%eax,4),%edx
80104b07:	85 d2                	test   %edx,%edx
80104b09:	74 15                	je     80104b20 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104b0b:	ff d2                	call   *%edx
80104b0d:	89 c2                	mov    %eax,%edx
80104b0f:	8b 43 18             	mov    0x18(%ebx),%eax
80104b12:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104b15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b18:	c9                   	leave  
80104b19:	c3                   	ret    
80104b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104b20:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104b21:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104b24:	50                   	push   %eax
80104b25:	ff 73 10             	pushl  0x10(%ebx)
80104b28:	68 7d 78 10 80       	push   $0x8010787d
80104b2d:	e8 7e bb ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104b32:	8b 43 18             	mov    0x18(%ebx),%eax
80104b35:	83 c4 10             	add    $0x10,%esp
80104b38:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104b3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b42:	c9                   	leave  
80104b43:	c3                   	ret    
80104b44:	66 90                	xchg   %ax,%ax
80104b46:	66 90                	xchg   %ax,%ax
80104b48:	66 90                	xchg   %ax,%ax
80104b4a:	66 90                	xchg   %ax,%ax
80104b4c:	66 90                	xchg   %ax,%ax
80104b4e:	66 90                	xchg   %ax,%ax

80104b50 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	57                   	push   %edi
80104b54:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b55:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104b58:	53                   	push   %ebx
80104b59:	83 ec 34             	sub    $0x34,%esp
80104b5c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104b5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104b62:	57                   	push   %edi
80104b63:	50                   	push   %eax
{
80104b64:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104b67:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104b6a:	e8 f1 d4 ff ff       	call   80102060 <nameiparent>
80104b6f:	83 c4 10             	add    $0x10,%esp
80104b72:	85 c0                	test   %eax,%eax
80104b74:	0f 84 46 01 00 00    	je     80104cc0 <create+0x170>
    return 0;
  ilock(dp);
80104b7a:	83 ec 0c             	sub    $0xc,%esp
80104b7d:	89 c3                	mov    %eax,%ebx
80104b7f:	50                   	push   %eax
80104b80:	e8 eb cb ff ff       	call   80101770 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104b85:	83 c4 0c             	add    $0xc,%esp
80104b88:	6a 00                	push   $0x0
80104b8a:	57                   	push   %edi
80104b8b:	53                   	push   %ebx
80104b8c:	e8 2f d1 ff ff       	call   80101cc0 <dirlookup>
80104b91:	83 c4 10             	add    $0x10,%esp
80104b94:	89 c6                	mov    %eax,%esi
80104b96:	85 c0                	test   %eax,%eax
80104b98:	74 56                	je     80104bf0 <create+0xa0>
    iunlockput(dp);
80104b9a:	83 ec 0c             	sub    $0xc,%esp
80104b9d:	53                   	push   %ebx
80104b9e:	e8 6d ce ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104ba3:	89 34 24             	mov    %esi,(%esp)
80104ba6:	e8 c5 cb ff ff       	call   80101770 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104bab:	83 c4 10             	add    $0x10,%esp
80104bae:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104bb3:	75 1b                	jne    80104bd0 <create+0x80>
80104bb5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104bba:	75 14                	jne    80104bd0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104bbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bbf:	89 f0                	mov    %esi,%eax
80104bc1:	5b                   	pop    %ebx
80104bc2:	5e                   	pop    %esi
80104bc3:	5f                   	pop    %edi
80104bc4:	5d                   	pop    %ebp
80104bc5:	c3                   	ret    
80104bc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bcd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104bd0:	83 ec 0c             	sub    $0xc,%esp
80104bd3:	56                   	push   %esi
    return 0;
80104bd4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104bd6:	e8 35 ce ff ff       	call   80101a10 <iunlockput>
    return 0;
80104bdb:	83 c4 10             	add    $0x10,%esp
}
80104bde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104be1:	89 f0                	mov    %esi,%eax
80104be3:	5b                   	pop    %ebx
80104be4:	5e                   	pop    %esi
80104be5:	5f                   	pop    %edi
80104be6:	5d                   	pop    %ebp
80104be7:	c3                   	ret    
80104be8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bef:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104bf0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104bf4:	83 ec 08             	sub    $0x8,%esp
80104bf7:	50                   	push   %eax
80104bf8:	ff 33                	pushl  (%ebx)
80104bfa:	e8 f1 c9 ff ff       	call   801015f0 <ialloc>
80104bff:	83 c4 10             	add    $0x10,%esp
80104c02:	89 c6                	mov    %eax,%esi
80104c04:	85 c0                	test   %eax,%eax
80104c06:	0f 84 cd 00 00 00    	je     80104cd9 <create+0x189>
  ilock(ip);
80104c0c:	83 ec 0c             	sub    $0xc,%esp
80104c0f:	50                   	push   %eax
80104c10:	e8 5b cb ff ff       	call   80101770 <ilock>
  ip->major = major;
80104c15:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104c19:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104c1d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104c21:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104c25:	b8 01 00 00 00       	mov    $0x1,%eax
80104c2a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104c2e:	89 34 24             	mov    %esi,(%esp)
80104c31:	e8 7a ca ff ff       	call   801016b0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104c36:	83 c4 10             	add    $0x10,%esp
80104c39:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104c3e:	74 30                	je     80104c70 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104c40:	83 ec 04             	sub    $0x4,%esp
80104c43:	ff 76 04             	pushl  0x4(%esi)
80104c46:	57                   	push   %edi
80104c47:	53                   	push   %ebx
80104c48:	e8 33 d3 ff ff       	call   80101f80 <dirlink>
80104c4d:	83 c4 10             	add    $0x10,%esp
80104c50:	85 c0                	test   %eax,%eax
80104c52:	78 78                	js     80104ccc <create+0x17c>
  iunlockput(dp);
80104c54:	83 ec 0c             	sub    $0xc,%esp
80104c57:	53                   	push   %ebx
80104c58:	e8 b3 cd ff ff       	call   80101a10 <iunlockput>
  return ip;
80104c5d:	83 c4 10             	add    $0x10,%esp
}
80104c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c63:	89 f0                	mov    %esi,%eax
80104c65:	5b                   	pop    %ebx
80104c66:	5e                   	pop    %esi
80104c67:	5f                   	pop    %edi
80104c68:	5d                   	pop    %ebp
80104c69:	c3                   	ret    
80104c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104c70:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104c73:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104c78:	53                   	push   %ebx
80104c79:	e8 32 ca ff ff       	call   801016b0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c7e:	83 c4 0c             	add    $0xc,%esp
80104c81:	ff 76 04             	pushl  0x4(%esi)
80104c84:	68 1c 79 10 80       	push   $0x8010791c
80104c89:	56                   	push   %esi
80104c8a:	e8 f1 d2 ff ff       	call   80101f80 <dirlink>
80104c8f:	83 c4 10             	add    $0x10,%esp
80104c92:	85 c0                	test   %eax,%eax
80104c94:	78 18                	js     80104cae <create+0x15e>
80104c96:	83 ec 04             	sub    $0x4,%esp
80104c99:	ff 73 04             	pushl  0x4(%ebx)
80104c9c:	68 1b 79 10 80       	push   $0x8010791b
80104ca1:	56                   	push   %esi
80104ca2:	e8 d9 d2 ff ff       	call   80101f80 <dirlink>
80104ca7:	83 c4 10             	add    $0x10,%esp
80104caa:	85 c0                	test   %eax,%eax
80104cac:	79 92                	jns    80104c40 <create+0xf0>
      panic("create dots");
80104cae:	83 ec 0c             	sub    $0xc,%esp
80104cb1:	68 0f 79 10 80       	push   $0x8010790f
80104cb6:	e8 d5 b6 ff ff       	call   80100390 <panic>
80104cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cbf:	90                   	nop
}
80104cc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104cc3:	31 f6                	xor    %esi,%esi
}
80104cc5:	5b                   	pop    %ebx
80104cc6:	89 f0                	mov    %esi,%eax
80104cc8:	5e                   	pop    %esi
80104cc9:	5f                   	pop    %edi
80104cca:	5d                   	pop    %ebp
80104ccb:	c3                   	ret    
    panic("create: dirlink");
80104ccc:	83 ec 0c             	sub    $0xc,%esp
80104ccf:	68 1e 79 10 80       	push   $0x8010791e
80104cd4:	e8 b7 b6 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104cd9:	83 ec 0c             	sub    $0xc,%esp
80104cdc:	68 00 79 10 80       	push   $0x80107900
80104ce1:	e8 aa b6 ff ff       	call   80100390 <panic>
80104ce6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ced:	8d 76 00             	lea    0x0(%esi),%esi

80104cf0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	56                   	push   %esi
80104cf4:	89 d6                	mov    %edx,%esi
80104cf6:	53                   	push   %ebx
80104cf7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104cf9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104cfc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104cff:	50                   	push   %eax
80104d00:	6a 00                	push   $0x0
80104d02:	e8 e9 fc ff ff       	call   801049f0 <argint>
80104d07:	83 c4 10             	add    $0x10,%esp
80104d0a:	85 c0                	test   %eax,%eax
80104d0c:	78 2a                	js     80104d38 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d0e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d12:	77 24                	ja     80104d38 <argfd.constprop.0+0x48>
80104d14:	e8 67 ec ff ff       	call   80103980 <myproc>
80104d19:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d1c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104d20:	85 c0                	test   %eax,%eax
80104d22:	74 14                	je     80104d38 <argfd.constprop.0+0x48>
  if(pfd)
80104d24:	85 db                	test   %ebx,%ebx
80104d26:	74 02                	je     80104d2a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104d28:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104d2a:	89 06                	mov    %eax,(%esi)
  return 0;
80104d2c:	31 c0                	xor    %eax,%eax
}
80104d2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d31:	5b                   	pop    %ebx
80104d32:	5e                   	pop    %esi
80104d33:	5d                   	pop    %ebp
80104d34:	c3                   	ret    
80104d35:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104d38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d3d:	eb ef                	jmp    80104d2e <argfd.constprop.0+0x3e>
80104d3f:	90                   	nop

80104d40 <sys_dup>:
{
80104d40:	f3 0f 1e fb          	endbr32 
80104d44:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104d45:	31 c0                	xor    %eax,%eax
{
80104d47:	89 e5                	mov    %esp,%ebp
80104d49:	56                   	push   %esi
80104d4a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104d4b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104d4e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104d51:	e8 9a ff ff ff       	call   80104cf0 <argfd.constprop.0>
80104d56:	85 c0                	test   %eax,%eax
80104d58:	78 1e                	js     80104d78 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104d5a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104d5d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104d5f:	e8 1c ec ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80104d68:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104d6c:	85 d2                	test   %edx,%edx
80104d6e:	74 20                	je     80104d90 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80104d70:	83 c3 01             	add    $0x1,%ebx
80104d73:	83 fb 10             	cmp    $0x10,%ebx
80104d76:	75 f0                	jne    80104d68 <sys_dup+0x28>
}
80104d78:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104d7b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104d80:	89 d8                	mov    %ebx,%eax
80104d82:	5b                   	pop    %ebx
80104d83:	5e                   	pop    %esi
80104d84:	5d                   	pop    %ebp
80104d85:	c3                   	ret    
80104d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d8d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104d90:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104d94:	83 ec 0c             	sub    $0xc,%esp
80104d97:	ff 75 f4             	pushl  -0xc(%ebp)
80104d9a:	e8 e1 c0 ff ff       	call   80100e80 <filedup>
  return fd;
80104d9f:	83 c4 10             	add    $0x10,%esp
}
80104da2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104da5:	89 d8                	mov    %ebx,%eax
80104da7:	5b                   	pop    %ebx
80104da8:	5e                   	pop    %esi
80104da9:	5d                   	pop    %ebp
80104daa:	c3                   	ret    
80104dab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104daf:	90                   	nop

80104db0 <sys_read>:
{
80104db0:	f3 0f 1e fb          	endbr32 
80104db4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104db5:	31 c0                	xor    %eax,%eax
{
80104db7:	89 e5                	mov    %esp,%ebp
80104db9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104dbc:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104dbf:	e8 2c ff ff ff       	call   80104cf0 <argfd.constprop.0>
80104dc4:	85 c0                	test   %eax,%eax
80104dc6:	78 48                	js     80104e10 <sys_read+0x60>
80104dc8:	83 ec 08             	sub    $0x8,%esp
80104dcb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104dce:	50                   	push   %eax
80104dcf:	6a 02                	push   $0x2
80104dd1:	e8 1a fc ff ff       	call   801049f0 <argint>
80104dd6:	83 c4 10             	add    $0x10,%esp
80104dd9:	85 c0                	test   %eax,%eax
80104ddb:	78 33                	js     80104e10 <sys_read+0x60>
80104ddd:	83 ec 04             	sub    $0x4,%esp
80104de0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104de3:	ff 75 f0             	pushl  -0x10(%ebp)
80104de6:	50                   	push   %eax
80104de7:	6a 01                	push   $0x1
80104de9:	e8 52 fc ff ff       	call   80104a40 <argptr>
80104dee:	83 c4 10             	add    $0x10,%esp
80104df1:	85 c0                	test   %eax,%eax
80104df3:	78 1b                	js     80104e10 <sys_read+0x60>
  return fileread(f, p, n);
80104df5:	83 ec 04             	sub    $0x4,%esp
80104df8:	ff 75 f0             	pushl  -0x10(%ebp)
80104dfb:	ff 75 f4             	pushl  -0xc(%ebp)
80104dfe:	ff 75 ec             	pushl  -0x14(%ebp)
80104e01:	e8 fa c1 ff ff       	call   80101000 <fileread>
80104e06:	83 c4 10             	add    $0x10,%esp
}
80104e09:	c9                   	leave  
80104e0a:	c3                   	ret    
80104e0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e0f:	90                   	nop
80104e10:	c9                   	leave  
    return -1;
80104e11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e16:	c3                   	ret    
80104e17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1e:	66 90                	xchg   %ax,%ax

80104e20 <sys_write>:
{
80104e20:	f3 0f 1e fb          	endbr32 
80104e24:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e25:	31 c0                	xor    %eax,%eax
{
80104e27:	89 e5                	mov    %esp,%ebp
80104e29:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e2c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e2f:	e8 bc fe ff ff       	call   80104cf0 <argfd.constprop.0>
80104e34:	85 c0                	test   %eax,%eax
80104e36:	78 48                	js     80104e80 <sys_write+0x60>
80104e38:	83 ec 08             	sub    $0x8,%esp
80104e3b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e3e:	50                   	push   %eax
80104e3f:	6a 02                	push   $0x2
80104e41:	e8 aa fb ff ff       	call   801049f0 <argint>
80104e46:	83 c4 10             	add    $0x10,%esp
80104e49:	85 c0                	test   %eax,%eax
80104e4b:	78 33                	js     80104e80 <sys_write+0x60>
80104e4d:	83 ec 04             	sub    $0x4,%esp
80104e50:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e53:	ff 75 f0             	pushl  -0x10(%ebp)
80104e56:	50                   	push   %eax
80104e57:	6a 01                	push   $0x1
80104e59:	e8 e2 fb ff ff       	call   80104a40 <argptr>
80104e5e:	83 c4 10             	add    $0x10,%esp
80104e61:	85 c0                	test   %eax,%eax
80104e63:	78 1b                	js     80104e80 <sys_write+0x60>
  return filewrite(f, p, n);
80104e65:	83 ec 04             	sub    $0x4,%esp
80104e68:	ff 75 f0             	pushl  -0x10(%ebp)
80104e6b:	ff 75 f4             	pushl  -0xc(%ebp)
80104e6e:	ff 75 ec             	pushl  -0x14(%ebp)
80104e71:	e8 2a c2 ff ff       	call   801010a0 <filewrite>
80104e76:	83 c4 10             	add    $0x10,%esp
}
80104e79:	c9                   	leave  
80104e7a:	c3                   	ret    
80104e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e7f:	90                   	nop
80104e80:	c9                   	leave  
    return -1;
80104e81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e86:	c3                   	ret    
80104e87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e8e:	66 90                	xchg   %ax,%ax

80104e90 <sys_close>:
{
80104e90:	f3 0f 1e fb          	endbr32 
80104e94:	55                   	push   %ebp
80104e95:	89 e5                	mov    %esp,%ebp
80104e97:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104e9a:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104e9d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ea0:	e8 4b fe ff ff       	call   80104cf0 <argfd.constprop.0>
80104ea5:	85 c0                	test   %eax,%eax
80104ea7:	78 27                	js     80104ed0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104ea9:	e8 d2 ea ff ff       	call   80103980 <myproc>
80104eae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104eb1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104eb4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104ebb:	00 
  fileclose(f);
80104ebc:	ff 75 f4             	pushl  -0xc(%ebp)
80104ebf:	e8 0c c0 ff ff       	call   80100ed0 <fileclose>
  return 0;
80104ec4:	83 c4 10             	add    $0x10,%esp
80104ec7:	31 c0                	xor    %eax,%eax
}
80104ec9:	c9                   	leave  
80104eca:	c3                   	ret    
80104ecb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ecf:	90                   	nop
80104ed0:	c9                   	leave  
    return -1;
80104ed1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ed6:	c3                   	ret    
80104ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ede:	66 90                	xchg   %ax,%ax

80104ee0 <sys_fstat>:
{
80104ee0:	f3 0f 1e fb          	endbr32 
80104ee4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ee5:	31 c0                	xor    %eax,%eax
{
80104ee7:	89 e5                	mov    %esp,%ebp
80104ee9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104eec:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104eef:	e8 fc fd ff ff       	call   80104cf0 <argfd.constprop.0>
80104ef4:	85 c0                	test   %eax,%eax
80104ef6:	78 30                	js     80104f28 <sys_fstat+0x48>
80104ef8:	83 ec 04             	sub    $0x4,%esp
80104efb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104efe:	6a 14                	push   $0x14
80104f00:	50                   	push   %eax
80104f01:	6a 01                	push   $0x1
80104f03:	e8 38 fb ff ff       	call   80104a40 <argptr>
80104f08:	83 c4 10             	add    $0x10,%esp
80104f0b:	85 c0                	test   %eax,%eax
80104f0d:	78 19                	js     80104f28 <sys_fstat+0x48>
  return filestat(f, st);
80104f0f:	83 ec 08             	sub    $0x8,%esp
80104f12:	ff 75 f4             	pushl  -0xc(%ebp)
80104f15:	ff 75 f0             	pushl  -0x10(%ebp)
80104f18:	e8 93 c0 ff ff       	call   80100fb0 <filestat>
80104f1d:	83 c4 10             	add    $0x10,%esp
}
80104f20:	c9                   	leave  
80104f21:	c3                   	ret    
80104f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f28:	c9                   	leave  
    return -1;
80104f29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f2e:	c3                   	ret    
80104f2f:	90                   	nop

80104f30 <sys_link>:
{
80104f30:	f3 0f 1e fb          	endbr32 
80104f34:	55                   	push   %ebp
80104f35:	89 e5                	mov    %esp,%ebp
80104f37:	57                   	push   %edi
80104f38:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f39:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104f3c:	53                   	push   %ebx
80104f3d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f40:	50                   	push   %eax
80104f41:	6a 00                	push   $0x0
80104f43:	e8 58 fb ff ff       	call   80104aa0 <argstr>
80104f48:	83 c4 10             	add    $0x10,%esp
80104f4b:	85 c0                	test   %eax,%eax
80104f4d:	0f 88 ff 00 00 00    	js     80105052 <sys_link+0x122>
80104f53:	83 ec 08             	sub    $0x8,%esp
80104f56:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f59:	50                   	push   %eax
80104f5a:	6a 01                	push   $0x1
80104f5c:	e8 3f fb ff ff       	call   80104aa0 <argstr>
80104f61:	83 c4 10             	add    $0x10,%esp
80104f64:	85 c0                	test   %eax,%eax
80104f66:	0f 88 e6 00 00 00    	js     80105052 <sys_link+0x122>
  begin_op();
80104f6c:	e8 cf dd ff ff       	call   80102d40 <begin_op>
  if((ip = namei(old)) == 0){
80104f71:	83 ec 0c             	sub    $0xc,%esp
80104f74:	ff 75 d4             	pushl  -0x2c(%ebp)
80104f77:	e8 c4 d0 ff ff       	call   80102040 <namei>
80104f7c:	83 c4 10             	add    $0x10,%esp
80104f7f:	89 c3                	mov    %eax,%ebx
80104f81:	85 c0                	test   %eax,%eax
80104f83:	0f 84 e8 00 00 00    	je     80105071 <sys_link+0x141>
  ilock(ip);
80104f89:	83 ec 0c             	sub    $0xc,%esp
80104f8c:	50                   	push   %eax
80104f8d:	e8 de c7 ff ff       	call   80101770 <ilock>
  if(ip->type == T_DIR){
80104f92:	83 c4 10             	add    $0x10,%esp
80104f95:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f9a:	0f 84 b9 00 00 00    	je     80105059 <sys_link+0x129>
  iupdate(ip);
80104fa0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104fa3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104fa8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104fab:	53                   	push   %ebx
80104fac:	e8 ff c6 ff ff       	call   801016b0 <iupdate>
  iunlock(ip);
80104fb1:	89 1c 24             	mov    %ebx,(%esp)
80104fb4:	e8 97 c8 ff ff       	call   80101850 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104fb9:	58                   	pop    %eax
80104fba:	5a                   	pop    %edx
80104fbb:	57                   	push   %edi
80104fbc:	ff 75 d0             	pushl  -0x30(%ebp)
80104fbf:	e8 9c d0 ff ff       	call   80102060 <nameiparent>
80104fc4:	83 c4 10             	add    $0x10,%esp
80104fc7:	89 c6                	mov    %eax,%esi
80104fc9:	85 c0                	test   %eax,%eax
80104fcb:	74 5f                	je     8010502c <sys_link+0xfc>
  ilock(dp);
80104fcd:	83 ec 0c             	sub    $0xc,%esp
80104fd0:	50                   	push   %eax
80104fd1:	e8 9a c7 ff ff       	call   80101770 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104fd6:	8b 03                	mov    (%ebx),%eax
80104fd8:	83 c4 10             	add    $0x10,%esp
80104fdb:	39 06                	cmp    %eax,(%esi)
80104fdd:	75 41                	jne    80105020 <sys_link+0xf0>
80104fdf:	83 ec 04             	sub    $0x4,%esp
80104fe2:	ff 73 04             	pushl  0x4(%ebx)
80104fe5:	57                   	push   %edi
80104fe6:	56                   	push   %esi
80104fe7:	e8 94 cf ff ff       	call   80101f80 <dirlink>
80104fec:	83 c4 10             	add    $0x10,%esp
80104fef:	85 c0                	test   %eax,%eax
80104ff1:	78 2d                	js     80105020 <sys_link+0xf0>
  iunlockput(dp);
80104ff3:	83 ec 0c             	sub    $0xc,%esp
80104ff6:	56                   	push   %esi
80104ff7:	e8 14 ca ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80104ffc:	89 1c 24             	mov    %ebx,(%esp)
80104fff:	e8 9c c8 ff ff       	call   801018a0 <iput>
  end_op();
80105004:	e8 a7 dd ff ff       	call   80102db0 <end_op>
  return 0;
80105009:	83 c4 10             	add    $0x10,%esp
8010500c:	31 c0                	xor    %eax,%eax
}
8010500e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105011:	5b                   	pop    %ebx
80105012:	5e                   	pop    %esi
80105013:	5f                   	pop    %edi
80105014:	5d                   	pop    %ebp
80105015:	c3                   	ret    
80105016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010501d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105020:	83 ec 0c             	sub    $0xc,%esp
80105023:	56                   	push   %esi
80105024:	e8 e7 c9 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105029:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010502c:	83 ec 0c             	sub    $0xc,%esp
8010502f:	53                   	push   %ebx
80105030:	e8 3b c7 ff ff       	call   80101770 <ilock>
  ip->nlink--;
80105035:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010503a:	89 1c 24             	mov    %ebx,(%esp)
8010503d:	e8 6e c6 ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
80105042:	89 1c 24             	mov    %ebx,(%esp)
80105045:	e8 c6 c9 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010504a:	e8 61 dd ff ff       	call   80102db0 <end_op>
  return -1;
8010504f:	83 c4 10             	add    $0x10,%esp
80105052:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105057:	eb b5                	jmp    8010500e <sys_link+0xde>
    iunlockput(ip);
80105059:	83 ec 0c             	sub    $0xc,%esp
8010505c:	53                   	push   %ebx
8010505d:	e8 ae c9 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105062:	e8 49 dd ff ff       	call   80102db0 <end_op>
    return -1;
80105067:	83 c4 10             	add    $0x10,%esp
8010506a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010506f:	eb 9d                	jmp    8010500e <sys_link+0xde>
    end_op();
80105071:	e8 3a dd ff ff       	call   80102db0 <end_op>
    return -1;
80105076:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010507b:	eb 91                	jmp    8010500e <sys_link+0xde>
8010507d:	8d 76 00             	lea    0x0(%esi),%esi

80105080 <sys_unlink>:
{
80105080:	f3 0f 1e fb          	endbr32 
80105084:	55                   	push   %ebp
80105085:	89 e5                	mov    %esp,%ebp
80105087:	57                   	push   %edi
80105088:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105089:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010508c:	53                   	push   %ebx
8010508d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105090:	50                   	push   %eax
80105091:	6a 00                	push   $0x0
80105093:	e8 08 fa ff ff       	call   80104aa0 <argstr>
80105098:	83 c4 10             	add    $0x10,%esp
8010509b:	85 c0                	test   %eax,%eax
8010509d:	0f 88 7d 01 00 00    	js     80105220 <sys_unlink+0x1a0>
  begin_op();
801050a3:	e8 98 dc ff ff       	call   80102d40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801050a8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801050ab:	83 ec 08             	sub    $0x8,%esp
801050ae:	53                   	push   %ebx
801050af:	ff 75 c0             	pushl  -0x40(%ebp)
801050b2:	e8 a9 cf ff ff       	call   80102060 <nameiparent>
801050b7:	83 c4 10             	add    $0x10,%esp
801050ba:	89 c6                	mov    %eax,%esi
801050bc:	85 c0                	test   %eax,%eax
801050be:	0f 84 66 01 00 00    	je     8010522a <sys_unlink+0x1aa>
  ilock(dp);
801050c4:	83 ec 0c             	sub    $0xc,%esp
801050c7:	50                   	push   %eax
801050c8:	e8 a3 c6 ff ff       	call   80101770 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801050cd:	58                   	pop    %eax
801050ce:	5a                   	pop    %edx
801050cf:	68 1c 79 10 80       	push   $0x8010791c
801050d4:	53                   	push   %ebx
801050d5:	e8 c6 cb ff ff       	call   80101ca0 <namecmp>
801050da:	83 c4 10             	add    $0x10,%esp
801050dd:	85 c0                	test   %eax,%eax
801050df:	0f 84 03 01 00 00    	je     801051e8 <sys_unlink+0x168>
801050e5:	83 ec 08             	sub    $0x8,%esp
801050e8:	68 1b 79 10 80       	push   $0x8010791b
801050ed:	53                   	push   %ebx
801050ee:	e8 ad cb ff ff       	call   80101ca0 <namecmp>
801050f3:	83 c4 10             	add    $0x10,%esp
801050f6:	85 c0                	test   %eax,%eax
801050f8:	0f 84 ea 00 00 00    	je     801051e8 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
801050fe:	83 ec 04             	sub    $0x4,%esp
80105101:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105104:	50                   	push   %eax
80105105:	53                   	push   %ebx
80105106:	56                   	push   %esi
80105107:	e8 b4 cb ff ff       	call   80101cc0 <dirlookup>
8010510c:	83 c4 10             	add    $0x10,%esp
8010510f:	89 c3                	mov    %eax,%ebx
80105111:	85 c0                	test   %eax,%eax
80105113:	0f 84 cf 00 00 00    	je     801051e8 <sys_unlink+0x168>
  ilock(ip);
80105119:	83 ec 0c             	sub    $0xc,%esp
8010511c:	50                   	push   %eax
8010511d:	e8 4e c6 ff ff       	call   80101770 <ilock>
  if(ip->nlink < 1)
80105122:	83 c4 10             	add    $0x10,%esp
80105125:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010512a:	0f 8e 23 01 00 00    	jle    80105253 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105130:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105135:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105138:	74 66                	je     801051a0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010513a:	83 ec 04             	sub    $0x4,%esp
8010513d:	6a 10                	push   $0x10
8010513f:	6a 00                	push   $0x0
80105141:	57                   	push   %edi
80105142:	e8 c9 f5 ff ff       	call   80104710 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105147:	6a 10                	push   $0x10
80105149:	ff 75 c4             	pushl  -0x3c(%ebp)
8010514c:	57                   	push   %edi
8010514d:	56                   	push   %esi
8010514e:	e8 1d ca ff ff       	call   80101b70 <writei>
80105153:	83 c4 20             	add    $0x20,%esp
80105156:	83 f8 10             	cmp    $0x10,%eax
80105159:	0f 85 e7 00 00 00    	jne    80105246 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010515f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105164:	0f 84 96 00 00 00    	je     80105200 <sys_unlink+0x180>
  iunlockput(dp);
8010516a:	83 ec 0c             	sub    $0xc,%esp
8010516d:	56                   	push   %esi
8010516e:	e8 9d c8 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
80105173:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105178:	89 1c 24             	mov    %ebx,(%esp)
8010517b:	e8 30 c5 ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
80105180:	89 1c 24             	mov    %ebx,(%esp)
80105183:	e8 88 c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105188:	e8 23 dc ff ff       	call   80102db0 <end_op>
  return 0;
8010518d:	83 c4 10             	add    $0x10,%esp
80105190:	31 c0                	xor    %eax,%eax
}
80105192:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105195:	5b                   	pop    %ebx
80105196:	5e                   	pop    %esi
80105197:	5f                   	pop    %edi
80105198:	5d                   	pop    %ebp
80105199:	c3                   	ret    
8010519a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801051a0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801051a4:	76 94                	jbe    8010513a <sys_unlink+0xba>
801051a6:	ba 20 00 00 00       	mov    $0x20,%edx
801051ab:	eb 0b                	jmp    801051b8 <sys_unlink+0x138>
801051ad:	8d 76 00             	lea    0x0(%esi),%esi
801051b0:	83 c2 10             	add    $0x10,%edx
801051b3:	39 53 58             	cmp    %edx,0x58(%ebx)
801051b6:	76 82                	jbe    8010513a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051b8:	6a 10                	push   $0x10
801051ba:	52                   	push   %edx
801051bb:	57                   	push   %edi
801051bc:	53                   	push   %ebx
801051bd:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801051c0:	e8 ab c8 ff ff       	call   80101a70 <readi>
801051c5:	83 c4 10             	add    $0x10,%esp
801051c8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801051cb:	83 f8 10             	cmp    $0x10,%eax
801051ce:	75 69                	jne    80105239 <sys_unlink+0x1b9>
    if(de.inum != 0)
801051d0:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801051d5:	74 d9                	je     801051b0 <sys_unlink+0x130>
    iunlockput(ip);
801051d7:	83 ec 0c             	sub    $0xc,%esp
801051da:	53                   	push   %ebx
801051db:	e8 30 c8 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801051e0:	83 c4 10             	add    $0x10,%esp
801051e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051e7:	90                   	nop
  iunlockput(dp);
801051e8:	83 ec 0c             	sub    $0xc,%esp
801051eb:	56                   	push   %esi
801051ec:	e8 1f c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
801051f1:	e8 ba db ff ff       	call   80102db0 <end_op>
  return -1;
801051f6:	83 c4 10             	add    $0x10,%esp
801051f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051fe:	eb 92                	jmp    80105192 <sys_unlink+0x112>
    iupdate(dp);
80105200:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105203:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105208:	56                   	push   %esi
80105209:	e8 a2 c4 ff ff       	call   801016b0 <iupdate>
8010520e:	83 c4 10             	add    $0x10,%esp
80105211:	e9 54 ff ff ff       	jmp    8010516a <sys_unlink+0xea>
80105216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010521d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105225:	e9 68 ff ff ff       	jmp    80105192 <sys_unlink+0x112>
    end_op();
8010522a:	e8 81 db ff ff       	call   80102db0 <end_op>
    return -1;
8010522f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105234:	e9 59 ff ff ff       	jmp    80105192 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105239:	83 ec 0c             	sub    $0xc,%esp
8010523c:	68 40 79 10 80       	push   $0x80107940
80105241:	e8 4a b1 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105246:	83 ec 0c             	sub    $0xc,%esp
80105249:	68 52 79 10 80       	push   $0x80107952
8010524e:	e8 3d b1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105253:	83 ec 0c             	sub    $0xc,%esp
80105256:	68 2e 79 10 80       	push   $0x8010792e
8010525b:	e8 30 b1 ff ff       	call   80100390 <panic>

80105260 <sys_open>:

int
sys_open(void)
{
80105260:	f3 0f 1e fb          	endbr32 
80105264:	55                   	push   %ebp
80105265:	89 e5                	mov    %esp,%ebp
80105267:	57                   	push   %edi
80105268:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105269:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010526c:	53                   	push   %ebx
8010526d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105270:	50                   	push   %eax
80105271:	6a 00                	push   $0x0
80105273:	e8 28 f8 ff ff       	call   80104aa0 <argstr>
80105278:	83 c4 10             	add    $0x10,%esp
8010527b:	85 c0                	test   %eax,%eax
8010527d:	0f 88 8a 00 00 00    	js     8010530d <sys_open+0xad>
80105283:	83 ec 08             	sub    $0x8,%esp
80105286:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105289:	50                   	push   %eax
8010528a:	6a 01                	push   $0x1
8010528c:	e8 5f f7 ff ff       	call   801049f0 <argint>
80105291:	83 c4 10             	add    $0x10,%esp
80105294:	85 c0                	test   %eax,%eax
80105296:	78 75                	js     8010530d <sys_open+0xad>
    return -1;

  begin_op();
80105298:	e8 a3 da ff ff       	call   80102d40 <begin_op>

  if(omode & O_CREATE){
8010529d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801052a1:	75 75                	jne    80105318 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801052a3:	83 ec 0c             	sub    $0xc,%esp
801052a6:	ff 75 e0             	pushl  -0x20(%ebp)
801052a9:	e8 92 cd ff ff       	call   80102040 <namei>
801052ae:	83 c4 10             	add    $0x10,%esp
801052b1:	89 c6                	mov    %eax,%esi
801052b3:	85 c0                	test   %eax,%eax
801052b5:	74 7e                	je     80105335 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801052b7:	83 ec 0c             	sub    $0xc,%esp
801052ba:	50                   	push   %eax
801052bb:	e8 b0 c4 ff ff       	call   80101770 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801052c0:	83 c4 10             	add    $0x10,%esp
801052c3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801052c8:	0f 84 c2 00 00 00    	je     80105390 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801052ce:	e8 3d bb ff ff       	call   80100e10 <filealloc>
801052d3:	89 c7                	mov    %eax,%edi
801052d5:	85 c0                	test   %eax,%eax
801052d7:	74 23                	je     801052fc <sys_open+0x9c>
  struct proc *curproc = myproc();
801052d9:	e8 a2 e6 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801052de:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801052e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801052e4:	85 d2                	test   %edx,%edx
801052e6:	74 60                	je     80105348 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801052e8:	83 c3 01             	add    $0x1,%ebx
801052eb:	83 fb 10             	cmp    $0x10,%ebx
801052ee:	75 f0                	jne    801052e0 <sys_open+0x80>
    if(f)
      fileclose(f);
801052f0:	83 ec 0c             	sub    $0xc,%esp
801052f3:	57                   	push   %edi
801052f4:	e8 d7 bb ff ff       	call   80100ed0 <fileclose>
801052f9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801052fc:	83 ec 0c             	sub    $0xc,%esp
801052ff:	56                   	push   %esi
80105300:	e8 0b c7 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105305:	e8 a6 da ff ff       	call   80102db0 <end_op>
    return -1;
8010530a:	83 c4 10             	add    $0x10,%esp
8010530d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105312:	eb 6d                	jmp    80105381 <sys_open+0x121>
80105314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105318:	83 ec 0c             	sub    $0xc,%esp
8010531b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010531e:	31 c9                	xor    %ecx,%ecx
80105320:	ba 02 00 00 00       	mov    $0x2,%edx
80105325:	6a 00                	push   $0x0
80105327:	e8 24 f8 ff ff       	call   80104b50 <create>
    if(ip == 0){
8010532c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010532f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105331:	85 c0                	test   %eax,%eax
80105333:	75 99                	jne    801052ce <sys_open+0x6e>
      end_op();
80105335:	e8 76 da ff ff       	call   80102db0 <end_op>
      return -1;
8010533a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010533f:	eb 40                	jmp    80105381 <sys_open+0x121>
80105341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105348:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010534b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010534f:	56                   	push   %esi
80105350:	e8 fb c4 ff ff       	call   80101850 <iunlock>
  end_op();
80105355:	e8 56 da ff ff       	call   80102db0 <end_op>

  f->type = FD_INODE;
8010535a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105360:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105363:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105366:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105369:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010536b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105372:	f7 d0                	not    %eax
80105374:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105377:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010537a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010537d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105381:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105384:	89 d8                	mov    %ebx,%eax
80105386:	5b                   	pop    %ebx
80105387:	5e                   	pop    %esi
80105388:	5f                   	pop    %edi
80105389:	5d                   	pop    %ebp
8010538a:	c3                   	ret    
8010538b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010538f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105390:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105393:	85 c9                	test   %ecx,%ecx
80105395:	0f 84 33 ff ff ff    	je     801052ce <sys_open+0x6e>
8010539b:	e9 5c ff ff ff       	jmp    801052fc <sys_open+0x9c>

801053a0 <sys_mkdir>:

int
sys_mkdir(void)
{
801053a0:	f3 0f 1e fb          	endbr32 
801053a4:	55                   	push   %ebp
801053a5:	89 e5                	mov    %esp,%ebp
801053a7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801053aa:	e8 91 d9 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801053af:	83 ec 08             	sub    $0x8,%esp
801053b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053b5:	50                   	push   %eax
801053b6:	6a 00                	push   $0x0
801053b8:	e8 e3 f6 ff ff       	call   80104aa0 <argstr>
801053bd:	83 c4 10             	add    $0x10,%esp
801053c0:	85 c0                	test   %eax,%eax
801053c2:	78 34                	js     801053f8 <sys_mkdir+0x58>
801053c4:	83 ec 0c             	sub    $0xc,%esp
801053c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053ca:	31 c9                	xor    %ecx,%ecx
801053cc:	ba 01 00 00 00       	mov    $0x1,%edx
801053d1:	6a 00                	push   $0x0
801053d3:	e8 78 f7 ff ff       	call   80104b50 <create>
801053d8:	83 c4 10             	add    $0x10,%esp
801053db:	85 c0                	test   %eax,%eax
801053dd:	74 19                	je     801053f8 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
801053df:	83 ec 0c             	sub    $0xc,%esp
801053e2:	50                   	push   %eax
801053e3:	e8 28 c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
801053e8:	e8 c3 d9 ff ff       	call   80102db0 <end_op>
  return 0;
801053ed:	83 c4 10             	add    $0x10,%esp
801053f0:	31 c0                	xor    %eax,%eax
}
801053f2:	c9                   	leave  
801053f3:	c3                   	ret    
801053f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801053f8:	e8 b3 d9 ff ff       	call   80102db0 <end_op>
    return -1;
801053fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105402:	c9                   	leave  
80105403:	c3                   	ret    
80105404:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010540b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010540f:	90                   	nop

80105410 <sys_mknod>:

int
sys_mknod(void)
{
80105410:	f3 0f 1e fb          	endbr32 
80105414:	55                   	push   %ebp
80105415:	89 e5                	mov    %esp,%ebp
80105417:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010541a:	e8 21 d9 ff ff       	call   80102d40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010541f:	83 ec 08             	sub    $0x8,%esp
80105422:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105425:	50                   	push   %eax
80105426:	6a 00                	push   $0x0
80105428:	e8 73 f6 ff ff       	call   80104aa0 <argstr>
8010542d:	83 c4 10             	add    $0x10,%esp
80105430:	85 c0                	test   %eax,%eax
80105432:	78 64                	js     80105498 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105434:	83 ec 08             	sub    $0x8,%esp
80105437:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010543a:	50                   	push   %eax
8010543b:	6a 01                	push   $0x1
8010543d:	e8 ae f5 ff ff       	call   801049f0 <argint>
  if((argstr(0, &path)) < 0 ||
80105442:	83 c4 10             	add    $0x10,%esp
80105445:	85 c0                	test   %eax,%eax
80105447:	78 4f                	js     80105498 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105449:	83 ec 08             	sub    $0x8,%esp
8010544c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010544f:	50                   	push   %eax
80105450:	6a 02                	push   $0x2
80105452:	e8 99 f5 ff ff       	call   801049f0 <argint>
     argint(1, &major) < 0 ||
80105457:	83 c4 10             	add    $0x10,%esp
8010545a:	85 c0                	test   %eax,%eax
8010545c:	78 3a                	js     80105498 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010545e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105462:	83 ec 0c             	sub    $0xc,%esp
80105465:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105469:	ba 03 00 00 00       	mov    $0x3,%edx
8010546e:	50                   	push   %eax
8010546f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105472:	e8 d9 f6 ff ff       	call   80104b50 <create>
     argint(2, &minor) < 0 ||
80105477:	83 c4 10             	add    $0x10,%esp
8010547a:	85 c0                	test   %eax,%eax
8010547c:	74 1a                	je     80105498 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010547e:	83 ec 0c             	sub    $0xc,%esp
80105481:	50                   	push   %eax
80105482:	e8 89 c5 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105487:	e8 24 d9 ff ff       	call   80102db0 <end_op>
  return 0;
8010548c:	83 c4 10             	add    $0x10,%esp
8010548f:	31 c0                	xor    %eax,%eax
}
80105491:	c9                   	leave  
80105492:	c3                   	ret    
80105493:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105497:	90                   	nop
    end_op();
80105498:	e8 13 d9 ff ff       	call   80102db0 <end_op>
    return -1;
8010549d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054a2:	c9                   	leave  
801054a3:	c3                   	ret    
801054a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054af:	90                   	nop

801054b0 <sys_chdir>:

int
sys_chdir(void)
{
801054b0:	f3 0f 1e fb          	endbr32 
801054b4:	55                   	push   %ebp
801054b5:	89 e5                	mov    %esp,%ebp
801054b7:	56                   	push   %esi
801054b8:	53                   	push   %ebx
801054b9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801054bc:	e8 bf e4 ff ff       	call   80103980 <myproc>
801054c1:	89 c6                	mov    %eax,%esi
  
  begin_op();
801054c3:	e8 78 d8 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801054c8:	83 ec 08             	sub    $0x8,%esp
801054cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054ce:	50                   	push   %eax
801054cf:	6a 00                	push   $0x0
801054d1:	e8 ca f5 ff ff       	call   80104aa0 <argstr>
801054d6:	83 c4 10             	add    $0x10,%esp
801054d9:	85 c0                	test   %eax,%eax
801054db:	78 73                	js     80105550 <sys_chdir+0xa0>
801054dd:	83 ec 0c             	sub    $0xc,%esp
801054e0:	ff 75 f4             	pushl  -0xc(%ebp)
801054e3:	e8 58 cb ff ff       	call   80102040 <namei>
801054e8:	83 c4 10             	add    $0x10,%esp
801054eb:	89 c3                	mov    %eax,%ebx
801054ed:	85 c0                	test   %eax,%eax
801054ef:	74 5f                	je     80105550 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801054f1:	83 ec 0c             	sub    $0xc,%esp
801054f4:	50                   	push   %eax
801054f5:	e8 76 c2 ff ff       	call   80101770 <ilock>
  if(ip->type != T_DIR){
801054fa:	83 c4 10             	add    $0x10,%esp
801054fd:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105502:	75 2c                	jne    80105530 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105504:	83 ec 0c             	sub    $0xc,%esp
80105507:	53                   	push   %ebx
80105508:	e8 43 c3 ff ff       	call   80101850 <iunlock>
  iput(curproc->cwd);
8010550d:	58                   	pop    %eax
8010550e:	ff 76 68             	pushl  0x68(%esi)
80105511:	e8 8a c3 ff ff       	call   801018a0 <iput>
  end_op();
80105516:	e8 95 d8 ff ff       	call   80102db0 <end_op>
  curproc->cwd = ip;
8010551b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010551e:	83 c4 10             	add    $0x10,%esp
80105521:	31 c0                	xor    %eax,%eax
}
80105523:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105526:	5b                   	pop    %ebx
80105527:	5e                   	pop    %esi
80105528:	5d                   	pop    %ebp
80105529:	c3                   	ret    
8010552a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105530:	83 ec 0c             	sub    $0xc,%esp
80105533:	53                   	push   %ebx
80105534:	e8 d7 c4 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105539:	e8 72 d8 ff ff       	call   80102db0 <end_op>
    return -1;
8010553e:	83 c4 10             	add    $0x10,%esp
80105541:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105546:	eb db                	jmp    80105523 <sys_chdir+0x73>
80105548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010554f:	90                   	nop
    end_op();
80105550:	e8 5b d8 ff ff       	call   80102db0 <end_op>
    return -1;
80105555:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010555a:	eb c7                	jmp    80105523 <sys_chdir+0x73>
8010555c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105560 <sys_exec>:

int
sys_exec(void)
{
80105560:	f3 0f 1e fb          	endbr32 
80105564:	55                   	push   %ebp
80105565:	89 e5                	mov    %esp,%ebp
80105567:	57                   	push   %edi
80105568:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105569:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010556f:	53                   	push   %ebx
80105570:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105576:	50                   	push   %eax
80105577:	6a 00                	push   $0x0
80105579:	e8 22 f5 ff ff       	call   80104aa0 <argstr>
8010557e:	83 c4 10             	add    $0x10,%esp
80105581:	85 c0                	test   %eax,%eax
80105583:	0f 88 8b 00 00 00    	js     80105614 <sys_exec+0xb4>
80105589:	83 ec 08             	sub    $0x8,%esp
8010558c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105592:	50                   	push   %eax
80105593:	6a 01                	push   $0x1
80105595:	e8 56 f4 ff ff       	call   801049f0 <argint>
8010559a:	83 c4 10             	add    $0x10,%esp
8010559d:	85 c0                	test   %eax,%eax
8010559f:	78 73                	js     80105614 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801055a1:	83 ec 04             	sub    $0x4,%esp
801055a4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801055aa:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801055ac:	68 80 00 00 00       	push   $0x80
801055b1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801055b7:	6a 00                	push   $0x0
801055b9:	50                   	push   %eax
801055ba:	e8 51 f1 ff ff       	call   80104710 <memset>
801055bf:	83 c4 10             	add    $0x10,%esp
801055c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801055c8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801055ce:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801055d5:	83 ec 08             	sub    $0x8,%esp
801055d8:	57                   	push   %edi
801055d9:	01 f0                	add    %esi,%eax
801055db:	50                   	push   %eax
801055dc:	e8 6f f3 ff ff       	call   80104950 <fetchint>
801055e1:	83 c4 10             	add    $0x10,%esp
801055e4:	85 c0                	test   %eax,%eax
801055e6:	78 2c                	js     80105614 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
801055e8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801055ee:	85 c0                	test   %eax,%eax
801055f0:	74 36                	je     80105628 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801055f2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801055f8:	83 ec 08             	sub    $0x8,%esp
801055fb:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801055fe:	52                   	push   %edx
801055ff:	50                   	push   %eax
80105600:	e8 8b f3 ff ff       	call   80104990 <fetchstr>
80105605:	83 c4 10             	add    $0x10,%esp
80105608:	85 c0                	test   %eax,%eax
8010560a:	78 08                	js     80105614 <sys_exec+0xb4>
  for(i=0;; i++){
8010560c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
8010560f:	83 fb 20             	cmp    $0x20,%ebx
80105612:	75 b4                	jne    801055c8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105614:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105617:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010561c:	5b                   	pop    %ebx
8010561d:	5e                   	pop    %esi
8010561e:	5f                   	pop    %edi
8010561f:	5d                   	pop    %ebp
80105620:	c3                   	ret    
80105621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105628:	83 ec 08             	sub    $0x8,%esp
8010562b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105631:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105638:	00 00 00 00 
  return exec(path, argv);
8010563c:	50                   	push   %eax
8010563d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105643:	e8 38 b4 ff ff       	call   80100a80 <exec>
80105648:	83 c4 10             	add    $0x10,%esp
}
8010564b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010564e:	5b                   	pop    %ebx
8010564f:	5e                   	pop    %esi
80105650:	5f                   	pop    %edi
80105651:	5d                   	pop    %ebp
80105652:	c3                   	ret    
80105653:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010565a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105660 <sys_pipe>:

int
sys_pipe(void)
{
80105660:	f3 0f 1e fb          	endbr32 
80105664:	55                   	push   %ebp
80105665:	89 e5                	mov    %esp,%ebp
80105667:	57                   	push   %edi
80105668:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105669:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010566c:	53                   	push   %ebx
8010566d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105670:	6a 08                	push   $0x8
80105672:	50                   	push   %eax
80105673:	6a 00                	push   $0x0
80105675:	e8 c6 f3 ff ff       	call   80104a40 <argptr>
8010567a:	83 c4 10             	add    $0x10,%esp
8010567d:	85 c0                	test   %eax,%eax
8010567f:	78 4e                	js     801056cf <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105681:	83 ec 08             	sub    $0x8,%esp
80105684:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105687:	50                   	push   %eax
80105688:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010568b:	50                   	push   %eax
8010568c:	e8 6f dd ff ff       	call   80103400 <pipealloc>
80105691:	83 c4 10             	add    $0x10,%esp
80105694:	85 c0                	test   %eax,%eax
80105696:	78 37                	js     801056cf <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105698:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010569b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010569d:	e8 de e2 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
801056a8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801056ac:	85 f6                	test   %esi,%esi
801056ae:	74 30                	je     801056e0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
801056b0:	83 c3 01             	add    $0x1,%ebx
801056b3:	83 fb 10             	cmp    $0x10,%ebx
801056b6:	75 f0                	jne    801056a8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801056b8:	83 ec 0c             	sub    $0xc,%esp
801056bb:	ff 75 e0             	pushl  -0x20(%ebp)
801056be:	e8 0d b8 ff ff       	call   80100ed0 <fileclose>
    fileclose(wf);
801056c3:	58                   	pop    %eax
801056c4:	ff 75 e4             	pushl  -0x1c(%ebp)
801056c7:	e8 04 b8 ff ff       	call   80100ed0 <fileclose>
    return -1;
801056cc:	83 c4 10             	add    $0x10,%esp
801056cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056d4:	eb 5b                	jmp    80105731 <sys_pipe+0xd1>
801056d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056dd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801056e0:	8d 73 08             	lea    0x8(%ebx),%esi
801056e3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801056ea:	e8 91 e2 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056ef:	31 d2                	xor    %edx,%edx
801056f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801056f8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801056fc:	85 c9                	test   %ecx,%ecx
801056fe:	74 20                	je     80105720 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105700:	83 c2 01             	add    $0x1,%edx
80105703:	83 fa 10             	cmp    $0x10,%edx
80105706:	75 f0                	jne    801056f8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105708:	e8 73 e2 ff ff       	call   80103980 <myproc>
8010570d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105714:	00 
80105715:	eb a1                	jmp    801056b8 <sys_pipe+0x58>
80105717:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010571e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105720:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105724:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105727:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105729:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010572c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010572f:	31 c0                	xor    %eax,%eax
}
80105731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105734:	5b                   	pop    %ebx
80105735:	5e                   	pop    %esi
80105736:	5f                   	pop    %edi
80105737:	5d                   	pop    %ebp
80105738:	c3                   	ret    
80105739:	66 90                	xchg   %ax,%ax
8010573b:	66 90                	xchg   %ax,%ax
8010573d:	66 90                	xchg   %ax,%ax
8010573f:	90                   	nop

80105740 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105740:	f3 0f 1e fb          	endbr32 
  return fork();
80105744:	e9 e7 e3 ff ff       	jmp    80103b30 <fork>
80105749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105750 <sys_exit>:
}

int
sys_exit(void)
{
80105750:	f3 0f 1e fb          	endbr32 
80105754:	55                   	push   %ebp
80105755:	89 e5                	mov    %esp,%ebp
80105757:	83 ec 08             	sub    $0x8,%esp
  exit();
8010575a:	e8 71 e6 ff ff       	call   80103dd0 <exit>
  return 0;  // not reached
}
8010575f:	31 c0                	xor    %eax,%eax
80105761:	c9                   	leave  
80105762:	c3                   	ret    
80105763:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010576a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105770 <sys_wait>:

int
sys_wait(void)
{
80105770:	f3 0f 1e fb          	endbr32 
  return wait();
80105774:	e9 a7 e8 ff ff       	jmp    80104020 <wait>
80105779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105780 <sys_kill>:
}

int
sys_kill(void)
{
80105780:	f3 0f 1e fb          	endbr32 
80105784:	55                   	push   %ebp
80105785:	89 e5                	mov    %esp,%ebp
80105787:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010578a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010578d:	50                   	push   %eax
8010578e:	6a 00                	push   $0x0
80105790:	e8 5b f2 ff ff       	call   801049f0 <argint>
80105795:	83 c4 10             	add    $0x10,%esp
80105798:	85 c0                	test   %eax,%eax
8010579a:	78 14                	js     801057b0 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010579c:	83 ec 0c             	sub    $0xc,%esp
8010579f:	ff 75 f4             	pushl  -0xc(%ebp)
801057a2:	e8 d9 e9 ff ff       	call   80104180 <kill>
801057a7:	83 c4 10             	add    $0x10,%esp
}
801057aa:	c9                   	leave  
801057ab:	c3                   	ret    
801057ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057b0:	c9                   	leave  
    return -1;
801057b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057b6:	c3                   	ret    
801057b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057be:	66 90                	xchg   %ax,%ax

801057c0 <sys_getpid>:

int
sys_getpid(void)
{
801057c0:	f3 0f 1e fb          	endbr32 
801057c4:	55                   	push   %ebp
801057c5:	89 e5                	mov    %esp,%ebp
801057c7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801057ca:	e8 b1 e1 ff ff       	call   80103980 <myproc>
801057cf:	8b 40 10             	mov    0x10(%eax),%eax
}
801057d2:	c9                   	leave  
801057d3:	c3                   	ret    
801057d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057df:	90                   	nop

801057e0 <sys_sbrk>:

int
sys_sbrk(void)
{
801057e0:	f3 0f 1e fb          	endbr32 
801057e4:	55                   	push   %ebp
801057e5:	89 e5                	mov    %esp,%ebp
801057e7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801057e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057eb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057ee:	50                   	push   %eax
801057ef:	6a 00                	push   $0x0
801057f1:	e8 fa f1 ff ff       	call   801049f0 <argint>
801057f6:	83 c4 10             	add    $0x10,%esp
801057f9:	85 c0                	test   %eax,%eax
801057fb:	78 23                	js     80105820 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801057fd:	e8 7e e1 ff ff       	call   80103980 <myproc>
  if(growproc(n) < 0)
80105802:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105805:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105807:	ff 75 f4             	pushl  -0xc(%ebp)
8010580a:	e8 a1 e2 ff ff       	call   80103ab0 <growproc>
8010580f:	83 c4 10             	add    $0x10,%esp
80105812:	85 c0                	test   %eax,%eax
80105814:	78 0a                	js     80105820 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105816:	89 d8                	mov    %ebx,%eax
80105818:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010581b:	c9                   	leave  
8010581c:	c3                   	ret    
8010581d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105820:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105825:	eb ef                	jmp    80105816 <sys_sbrk+0x36>
80105827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010582e:	66 90                	xchg   %ax,%ax

80105830 <sys_sleep>:

int
sys_sleep(void)
{
80105830:	f3 0f 1e fb          	endbr32 
80105834:	55                   	push   %ebp
80105835:	89 e5                	mov    %esp,%ebp
80105837:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105838:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010583b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010583e:	50                   	push   %eax
8010583f:	6a 00                	push   $0x0
80105841:	e8 aa f1 ff ff       	call   801049f0 <argint>
80105846:	83 c4 10             	add    $0x10,%esp
80105849:	85 c0                	test   %eax,%eax
8010584b:	0f 88 86 00 00 00    	js     801058d7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105851:	83 ec 0c             	sub    $0xc,%esp
80105854:	68 60 4d 11 80       	push   $0x80114d60
80105859:	e8 a2 ed ff ff       	call   80104600 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010585e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105861:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  while(ticks - ticks0 < n){
80105867:	83 c4 10             	add    $0x10,%esp
8010586a:	85 d2                	test   %edx,%edx
8010586c:	75 23                	jne    80105891 <sys_sleep+0x61>
8010586e:	eb 50                	jmp    801058c0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105870:	83 ec 08             	sub    $0x8,%esp
80105873:	68 60 4d 11 80       	push   $0x80114d60
80105878:	68 a0 55 11 80       	push   $0x801155a0
8010587d:	e8 de e6 ff ff       	call   80103f60 <sleep>
  while(ticks - ticks0 < n){
80105882:	a1 a0 55 11 80       	mov    0x801155a0,%eax
80105887:	83 c4 10             	add    $0x10,%esp
8010588a:	29 d8                	sub    %ebx,%eax
8010588c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010588f:	73 2f                	jae    801058c0 <sys_sleep+0x90>
    if(myproc()->killed){
80105891:	e8 ea e0 ff ff       	call   80103980 <myproc>
80105896:	8b 40 24             	mov    0x24(%eax),%eax
80105899:	85 c0                	test   %eax,%eax
8010589b:	74 d3                	je     80105870 <sys_sleep+0x40>
      release(&tickslock);
8010589d:	83 ec 0c             	sub    $0xc,%esp
801058a0:	68 60 4d 11 80       	push   $0x80114d60
801058a5:	e8 16 ee ff ff       	call   801046c0 <release>
  }
  release(&tickslock);
  return 0;
}
801058aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801058ad:	83 c4 10             	add    $0x10,%esp
801058b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058b5:	c9                   	leave  
801058b6:	c3                   	ret    
801058b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058be:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801058c0:	83 ec 0c             	sub    $0xc,%esp
801058c3:	68 60 4d 11 80       	push   $0x80114d60
801058c8:	e8 f3 ed ff ff       	call   801046c0 <release>
  return 0;
801058cd:	83 c4 10             	add    $0x10,%esp
801058d0:	31 c0                	xor    %eax,%eax
}
801058d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058d5:	c9                   	leave  
801058d6:	c3                   	ret    
    return -1;
801058d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058dc:	eb f4                	jmp    801058d2 <sys_sleep+0xa2>
801058de:	66 90                	xchg   %ax,%ax

801058e0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801058e0:	f3 0f 1e fb          	endbr32 
801058e4:	55                   	push   %ebp
801058e5:	89 e5                	mov    %esp,%ebp
801058e7:	53                   	push   %ebx
801058e8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801058eb:	68 60 4d 11 80       	push   $0x80114d60
801058f0:	e8 0b ed ff ff       	call   80104600 <acquire>
  xticks = ticks;
801058f5:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  release(&tickslock);
801058fb:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105902:	e8 b9 ed ff ff       	call   801046c0 <release>
  return xticks;
}
80105907:	89 d8                	mov    %ebx,%eax
80105909:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010590c:	c9                   	leave  
8010590d:	c3                   	ret    
8010590e:	66 90                	xchg   %ax,%ax

80105910 <sys_chpr>:
//calls chpr for change of process priority
int sys_chpr(void)
{
80105910:	f3 0f 1e fb          	endbr32 
80105914:	55                   	push   %ebp
80105915:	89 e5                	mov    %esp,%ebp
80105917:	83 ec 20             	sub    $0x20,%esp
	int pid, pr;
	if(argint(0, &pid) < 0)
8010591a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010591d:	50                   	push   %eax
8010591e:	6a 00                	push   $0x0
80105920:	e8 cb f0 ff ff       	call   801049f0 <argint>
80105925:	83 c4 10             	add    $0x10,%esp
80105928:	85 c0                	test   %eax,%eax
8010592a:	78 2c                	js     80105958 <sys_chpr+0x48>
		return -1;
	if(argint(1, &pr) < 0)
8010592c:	83 ec 08             	sub    $0x8,%esp
8010592f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105932:	50                   	push   %eax
80105933:	6a 01                	push   $0x1
80105935:	e8 b6 f0 ff ff       	call   801049f0 <argint>
8010593a:	83 c4 10             	add    $0x10,%esp
8010593d:	85 c0                	test   %eax,%eax
8010593f:	78 17                	js     80105958 <sys_chpr+0x48>
		return -1;
	return chpr(pid, pr);
80105941:	83 ec 08             	sub    $0x8,%esp
80105944:	ff 75 f4             	pushl  -0xc(%ebp)
80105947:	ff 75 f0             	pushl  -0x10(%ebp)
8010594a:	e8 91 e9 ff ff       	call   801042e0 <chpr>
8010594f:	83 c4 10             	add    $0x10,%esp
}
80105952:	c9                   	leave  
80105953:	c3                   	ret    
80105954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105958:	c9                   	leave  
		return -1;
80105959:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010595e:	c3                   	ret    

8010595f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010595f:	1e                   	push   %ds
  pushl %es
80105960:	06                   	push   %es
  pushl %fs
80105961:	0f a0                	push   %fs
  pushl %gs
80105963:	0f a8                	push   %gs
  pushal
80105965:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105966:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010596a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010596c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010596e:	54                   	push   %esp
  call trap
8010596f:	e8 cc 00 00 00       	call   80105a40 <trap>
  addl $4, %esp
80105974:	83 c4 04             	add    $0x4,%esp

80105977 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105977:	61                   	popa   
  popl %gs
80105978:	0f a9                	pop    %gs
  popl %fs
8010597a:	0f a1                	pop    %fs
  popl %es
8010597c:	07                   	pop    %es
  popl %ds
8010597d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010597e:	83 c4 08             	add    $0x8,%esp
  iret
80105981:	cf                   	iret   
80105982:	66 90                	xchg   %ax,%ax
80105984:	66 90                	xchg   %ax,%ax
80105986:	66 90                	xchg   %ax,%ax
80105988:	66 90                	xchg   %ax,%ax
8010598a:	66 90                	xchg   %ax,%ax
8010598c:	66 90                	xchg   %ax,%ax
8010598e:	66 90                	xchg   %ax,%ax

80105990 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105990:	f3 0f 1e fb          	endbr32 
80105994:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105995:	31 c0                	xor    %eax,%eax
{
80105997:	89 e5                	mov    %esp,%ebp
80105999:	83 ec 08             	sub    $0x8,%esp
8010599c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801059a0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801059a7:	c7 04 c5 a2 4d 11 80 	movl   $0x8e000008,-0x7feeb25e(,%eax,8)
801059ae:	08 00 00 8e 
801059b2:	66 89 14 c5 a0 4d 11 	mov    %dx,-0x7feeb260(,%eax,8)
801059b9:	80 
801059ba:	c1 ea 10             	shr    $0x10,%edx
801059bd:	66 89 14 c5 a6 4d 11 	mov    %dx,-0x7feeb25a(,%eax,8)
801059c4:	80 
  for(i = 0; i < 256; i++)
801059c5:	83 c0 01             	add    $0x1,%eax
801059c8:	3d 00 01 00 00       	cmp    $0x100,%eax
801059cd:	75 d1                	jne    801059a0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801059cf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801059d2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
801059d7:	c7 05 a2 4f 11 80 08 	movl   $0xef000008,0x80114fa2
801059de:	00 00 ef 
  initlock(&tickslock, "time");
801059e1:	68 61 79 10 80       	push   $0x80107961
801059e6:	68 60 4d 11 80       	push   $0x80114d60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801059eb:	66 a3 a0 4f 11 80    	mov    %ax,0x80114fa0
801059f1:	c1 e8 10             	shr    $0x10,%eax
801059f4:	66 a3 a6 4f 11 80    	mov    %ax,0x80114fa6
  initlock(&tickslock, "time");
801059fa:	e8 81 ea ff ff       	call   80104480 <initlock>
}
801059ff:	83 c4 10             	add    $0x10,%esp
80105a02:	c9                   	leave  
80105a03:	c3                   	ret    
80105a04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a0f:	90                   	nop

80105a10 <idtinit>:

void
idtinit(void)
{
80105a10:	f3 0f 1e fb          	endbr32 
80105a14:	55                   	push   %ebp
  pd[0] = size-1;
80105a15:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105a1a:	89 e5                	mov    %esp,%ebp
80105a1c:	83 ec 10             	sub    $0x10,%esp
80105a1f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105a23:	b8 a0 4d 11 80       	mov    $0x80114da0,%eax
80105a28:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105a2c:	c1 e8 10             	shr    $0x10,%eax
80105a2f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105a33:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105a36:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105a39:	c9                   	leave  
80105a3a:	c3                   	ret    
80105a3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a3f:	90                   	nop

80105a40 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105a40:	f3 0f 1e fb          	endbr32 
80105a44:	55                   	push   %ebp
80105a45:	89 e5                	mov    %esp,%ebp
80105a47:	57                   	push   %edi
80105a48:	56                   	push   %esi
80105a49:	53                   	push   %ebx
80105a4a:	83 ec 1c             	sub    $0x1c,%esp
80105a4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105a50:	8b 43 30             	mov    0x30(%ebx),%eax
80105a53:	83 f8 40             	cmp    $0x40,%eax
80105a56:	0f 84 bc 01 00 00    	je     80105c18 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105a5c:	83 e8 20             	sub    $0x20,%eax
80105a5f:	83 f8 1f             	cmp    $0x1f,%eax
80105a62:	77 08                	ja     80105a6c <trap+0x2c>
80105a64:	3e ff 24 85 08 7a 10 	notrack jmp *-0x7fef85f8(,%eax,4)
80105a6b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105a6c:	e8 0f df ff ff       	call   80103980 <myproc>
80105a71:	8b 7b 38             	mov    0x38(%ebx),%edi
80105a74:	85 c0                	test   %eax,%eax
80105a76:	0f 84 eb 01 00 00    	je     80105c67 <trap+0x227>
80105a7c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105a80:	0f 84 e1 01 00 00    	je     80105c67 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105a86:	0f 20 d1             	mov    %cr2,%ecx
80105a89:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a8c:	e8 cf de ff ff       	call   80103960 <cpuid>
80105a91:	8b 73 30             	mov    0x30(%ebx),%esi
80105a94:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105a97:	8b 43 34             	mov    0x34(%ebx),%eax
80105a9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105a9d:	e8 de de ff ff       	call   80103980 <myproc>
80105aa2:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105aa5:	e8 d6 de ff ff       	call   80103980 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105aaa:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105aad:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ab0:	51                   	push   %ecx
80105ab1:	57                   	push   %edi
80105ab2:	52                   	push   %edx
80105ab3:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ab6:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105ab7:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105aba:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105abd:	56                   	push   %esi
80105abe:	ff 70 10             	pushl  0x10(%eax)
80105ac1:	68 c4 79 10 80       	push   $0x801079c4
80105ac6:	e8 e5 ab ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105acb:	83 c4 20             	add    $0x20,%esp
80105ace:	e8 ad de ff ff       	call   80103980 <myproc>
80105ad3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ada:	e8 a1 de ff ff       	call   80103980 <myproc>
80105adf:	85 c0                	test   %eax,%eax
80105ae1:	74 1d                	je     80105b00 <trap+0xc0>
80105ae3:	e8 98 de ff ff       	call   80103980 <myproc>
80105ae8:	8b 50 24             	mov    0x24(%eax),%edx
80105aeb:	85 d2                	test   %edx,%edx
80105aed:	74 11                	je     80105b00 <trap+0xc0>
80105aef:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105af3:	83 e0 03             	and    $0x3,%eax
80105af6:	66 83 f8 03          	cmp    $0x3,%ax
80105afa:	0f 84 50 01 00 00    	je     80105c50 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105b00:	e8 7b de ff ff       	call   80103980 <myproc>
80105b05:	85 c0                	test   %eax,%eax
80105b07:	74 0f                	je     80105b18 <trap+0xd8>
80105b09:	e8 72 de ff ff       	call   80103980 <myproc>
80105b0e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105b12:	0f 84 e8 00 00 00    	je     80105c00 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b18:	e8 63 de ff ff       	call   80103980 <myproc>
80105b1d:	85 c0                	test   %eax,%eax
80105b1f:	74 1d                	je     80105b3e <trap+0xfe>
80105b21:	e8 5a de ff ff       	call   80103980 <myproc>
80105b26:	8b 40 24             	mov    0x24(%eax),%eax
80105b29:	85 c0                	test   %eax,%eax
80105b2b:	74 11                	je     80105b3e <trap+0xfe>
80105b2d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105b31:	83 e0 03             	and    $0x3,%eax
80105b34:	66 83 f8 03          	cmp    $0x3,%ax
80105b38:	0f 84 03 01 00 00    	je     80105c41 <trap+0x201>
    exit();
}
80105b3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b41:	5b                   	pop    %ebx
80105b42:	5e                   	pop    %esi
80105b43:	5f                   	pop    %edi
80105b44:	5d                   	pop    %ebp
80105b45:	c3                   	ret    
    ideintr();
80105b46:	e8 a5 c6 ff ff       	call   801021f0 <ideintr>
    lapiceoi();
80105b4b:	e8 80 cd ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b50:	e8 2b de ff ff       	call   80103980 <myproc>
80105b55:	85 c0                	test   %eax,%eax
80105b57:	75 8a                	jne    80105ae3 <trap+0xa3>
80105b59:	eb a5                	jmp    80105b00 <trap+0xc0>
    if(cpuid() == 0){
80105b5b:	e8 00 de ff ff       	call   80103960 <cpuid>
80105b60:	85 c0                	test   %eax,%eax
80105b62:	75 e7                	jne    80105b4b <trap+0x10b>
      acquire(&tickslock);
80105b64:	83 ec 0c             	sub    $0xc,%esp
80105b67:	68 60 4d 11 80       	push   $0x80114d60
80105b6c:	e8 8f ea ff ff       	call   80104600 <acquire>
      wakeup(&ticks);
80105b71:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
      ticks++;
80105b78:	83 05 a0 55 11 80 01 	addl   $0x1,0x801155a0
      wakeup(&ticks);
80105b7f:	e8 9c e5 ff ff       	call   80104120 <wakeup>
      release(&tickslock);
80105b84:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105b8b:	e8 30 eb ff ff       	call   801046c0 <release>
80105b90:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105b93:	eb b6                	jmp    80105b4b <trap+0x10b>
    kbdintr();
80105b95:	e8 f6 cb ff ff       	call   80102790 <kbdintr>
    lapiceoi();
80105b9a:	e8 31 cd ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b9f:	e8 dc dd ff ff       	call   80103980 <myproc>
80105ba4:	85 c0                	test   %eax,%eax
80105ba6:	0f 85 37 ff ff ff    	jne    80105ae3 <trap+0xa3>
80105bac:	e9 4f ff ff ff       	jmp    80105b00 <trap+0xc0>
    uartintr();
80105bb1:	e8 4a 02 00 00       	call   80105e00 <uartintr>
    lapiceoi();
80105bb6:	e8 15 cd ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bbb:	e8 c0 dd ff ff       	call   80103980 <myproc>
80105bc0:	85 c0                	test   %eax,%eax
80105bc2:	0f 85 1b ff ff ff    	jne    80105ae3 <trap+0xa3>
80105bc8:	e9 33 ff ff ff       	jmp    80105b00 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105bcd:	8b 7b 38             	mov    0x38(%ebx),%edi
80105bd0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105bd4:	e8 87 dd ff ff       	call   80103960 <cpuid>
80105bd9:	57                   	push   %edi
80105bda:	56                   	push   %esi
80105bdb:	50                   	push   %eax
80105bdc:	68 6c 79 10 80       	push   $0x8010796c
80105be1:	e8 ca aa ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105be6:	e8 e5 cc ff ff       	call   801028d0 <lapiceoi>
    break;
80105beb:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bee:	e8 8d dd ff ff       	call   80103980 <myproc>
80105bf3:	85 c0                	test   %eax,%eax
80105bf5:	0f 85 e8 fe ff ff    	jne    80105ae3 <trap+0xa3>
80105bfb:	e9 00 ff ff ff       	jmp    80105b00 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80105c00:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105c04:	0f 85 0e ff ff ff    	jne    80105b18 <trap+0xd8>
    yield();
80105c0a:	e8 01 e3 ff ff       	call   80103f10 <yield>
80105c0f:	e9 04 ff ff ff       	jmp    80105b18 <trap+0xd8>
80105c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105c18:	e8 63 dd ff ff       	call   80103980 <myproc>
80105c1d:	8b 70 24             	mov    0x24(%eax),%esi
80105c20:	85 f6                	test   %esi,%esi
80105c22:	75 3c                	jne    80105c60 <trap+0x220>
    myproc()->tf = tf;
80105c24:	e8 57 dd ff ff       	call   80103980 <myproc>
80105c29:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105c2c:	e8 af ee ff ff       	call   80104ae0 <syscall>
    if(myproc()->killed)
80105c31:	e8 4a dd ff ff       	call   80103980 <myproc>
80105c36:	8b 48 24             	mov    0x24(%eax),%ecx
80105c39:	85 c9                	test   %ecx,%ecx
80105c3b:	0f 84 fd fe ff ff    	je     80105b3e <trap+0xfe>
}
80105c41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c44:	5b                   	pop    %ebx
80105c45:	5e                   	pop    %esi
80105c46:	5f                   	pop    %edi
80105c47:	5d                   	pop    %ebp
      exit();
80105c48:	e9 83 e1 ff ff       	jmp    80103dd0 <exit>
80105c4d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105c50:	e8 7b e1 ff ff       	call   80103dd0 <exit>
80105c55:	e9 a6 fe ff ff       	jmp    80105b00 <trap+0xc0>
80105c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105c60:	e8 6b e1 ff ff       	call   80103dd0 <exit>
80105c65:	eb bd                	jmp    80105c24 <trap+0x1e4>
80105c67:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105c6a:	e8 f1 dc ff ff       	call   80103960 <cpuid>
80105c6f:	83 ec 0c             	sub    $0xc,%esp
80105c72:	56                   	push   %esi
80105c73:	57                   	push   %edi
80105c74:	50                   	push   %eax
80105c75:	ff 73 30             	pushl  0x30(%ebx)
80105c78:	68 90 79 10 80       	push   $0x80107990
80105c7d:	e8 2e aa ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105c82:	83 c4 14             	add    $0x14,%esp
80105c85:	68 66 79 10 80       	push   $0x80107966
80105c8a:	e8 01 a7 ff ff       	call   80100390 <panic>
80105c8f:	90                   	nop

80105c90 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105c90:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105c94:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105c99:	85 c0                	test   %eax,%eax
80105c9b:	74 1b                	je     80105cb8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c9d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ca2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105ca3:	a8 01                	test   $0x1,%al
80105ca5:	74 11                	je     80105cb8 <uartgetc+0x28>
80105ca7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cac:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105cad:	0f b6 c0             	movzbl %al,%eax
80105cb0:	c3                   	ret    
80105cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105cb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cbd:	c3                   	ret    
80105cbe:	66 90                	xchg   %ax,%ax

80105cc0 <uartputc.part.0>:
uartputc(int c)
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	57                   	push   %edi
80105cc4:	89 c7                	mov    %eax,%edi
80105cc6:	56                   	push   %esi
80105cc7:	be fd 03 00 00       	mov    $0x3fd,%esi
80105ccc:	53                   	push   %ebx
80105ccd:	bb 80 00 00 00       	mov    $0x80,%ebx
80105cd2:	83 ec 0c             	sub    $0xc,%esp
80105cd5:	eb 1b                	jmp    80105cf2 <uartputc.part.0+0x32>
80105cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cde:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105ce0:	83 ec 0c             	sub    $0xc,%esp
80105ce3:	6a 0a                	push   $0xa
80105ce5:	e8 06 cc ff ff       	call   801028f0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105cea:	83 c4 10             	add    $0x10,%esp
80105ced:	83 eb 01             	sub    $0x1,%ebx
80105cf0:	74 07                	je     80105cf9 <uartputc.part.0+0x39>
80105cf2:	89 f2                	mov    %esi,%edx
80105cf4:	ec                   	in     (%dx),%al
80105cf5:	a8 20                	test   $0x20,%al
80105cf7:	74 e7                	je     80105ce0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105cf9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cfe:	89 f8                	mov    %edi,%eax
80105d00:	ee                   	out    %al,(%dx)
}
80105d01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d04:	5b                   	pop    %ebx
80105d05:	5e                   	pop    %esi
80105d06:	5f                   	pop    %edi
80105d07:	5d                   	pop    %ebp
80105d08:	c3                   	ret    
80105d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d10 <uartinit>:
{
80105d10:	f3 0f 1e fb          	endbr32 
80105d14:	55                   	push   %ebp
80105d15:	31 c9                	xor    %ecx,%ecx
80105d17:	89 c8                	mov    %ecx,%eax
80105d19:	89 e5                	mov    %esp,%ebp
80105d1b:	57                   	push   %edi
80105d1c:	56                   	push   %esi
80105d1d:	53                   	push   %ebx
80105d1e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105d23:	89 da                	mov    %ebx,%edx
80105d25:	83 ec 0c             	sub    $0xc,%esp
80105d28:	ee                   	out    %al,(%dx)
80105d29:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105d2e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105d33:	89 fa                	mov    %edi,%edx
80105d35:	ee                   	out    %al,(%dx)
80105d36:	b8 0c 00 00 00       	mov    $0xc,%eax
80105d3b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d40:	ee                   	out    %al,(%dx)
80105d41:	be f9 03 00 00       	mov    $0x3f9,%esi
80105d46:	89 c8                	mov    %ecx,%eax
80105d48:	89 f2                	mov    %esi,%edx
80105d4a:	ee                   	out    %al,(%dx)
80105d4b:	b8 03 00 00 00       	mov    $0x3,%eax
80105d50:	89 fa                	mov    %edi,%edx
80105d52:	ee                   	out    %al,(%dx)
80105d53:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105d58:	89 c8                	mov    %ecx,%eax
80105d5a:	ee                   	out    %al,(%dx)
80105d5b:	b8 01 00 00 00       	mov    $0x1,%eax
80105d60:	89 f2                	mov    %esi,%edx
80105d62:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d63:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d68:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105d69:	3c ff                	cmp    $0xff,%al
80105d6b:	74 52                	je     80105dbf <uartinit+0xaf>
  uart = 1;
80105d6d:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105d74:	00 00 00 
80105d77:	89 da                	mov    %ebx,%edx
80105d79:	ec                   	in     (%dx),%al
80105d7a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d7f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105d80:	83 ec 08             	sub    $0x8,%esp
80105d83:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105d88:	bb 88 7a 10 80       	mov    $0x80107a88,%ebx
  ioapicenable(IRQ_COM1, 0);
80105d8d:	6a 00                	push   $0x0
80105d8f:	6a 04                	push   $0x4
80105d91:	e8 aa c6 ff ff       	call   80102440 <ioapicenable>
80105d96:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105d99:	b8 78 00 00 00       	mov    $0x78,%eax
80105d9e:	eb 04                	jmp    80105da4 <uartinit+0x94>
80105da0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105da4:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105daa:	85 d2                	test   %edx,%edx
80105dac:	74 08                	je     80105db6 <uartinit+0xa6>
    uartputc(*p);
80105dae:	0f be c0             	movsbl %al,%eax
80105db1:	e8 0a ff ff ff       	call   80105cc0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105db6:	89 f0                	mov    %esi,%eax
80105db8:	83 c3 01             	add    $0x1,%ebx
80105dbb:	84 c0                	test   %al,%al
80105dbd:	75 e1                	jne    80105da0 <uartinit+0x90>
}
80105dbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dc2:	5b                   	pop    %ebx
80105dc3:	5e                   	pop    %esi
80105dc4:	5f                   	pop    %edi
80105dc5:	5d                   	pop    %ebp
80105dc6:	c3                   	ret    
80105dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dce:	66 90                	xchg   %ax,%ax

80105dd0 <uartputc>:
{
80105dd0:	f3 0f 1e fb          	endbr32 
80105dd4:	55                   	push   %ebp
  if(!uart)
80105dd5:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105ddb:	89 e5                	mov    %esp,%ebp
80105ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105de0:	85 d2                	test   %edx,%edx
80105de2:	74 0c                	je     80105df0 <uartputc+0x20>
}
80105de4:	5d                   	pop    %ebp
80105de5:	e9 d6 fe ff ff       	jmp    80105cc0 <uartputc.part.0>
80105dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105df0:	5d                   	pop    %ebp
80105df1:	c3                   	ret    
80105df2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e00 <uartintr>:

void
uartintr(void)
{
80105e00:	f3 0f 1e fb          	endbr32 
80105e04:	55                   	push   %ebp
80105e05:	89 e5                	mov    %esp,%ebp
80105e07:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105e0a:	68 90 5c 10 80       	push   $0x80105c90
80105e0f:	e8 4c aa ff ff       	call   80100860 <consoleintr>
}
80105e14:	83 c4 10             	add    $0x10,%esp
80105e17:	c9                   	leave  
80105e18:	c3                   	ret    

80105e19 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105e19:	6a 00                	push   $0x0
  pushl $0
80105e1b:	6a 00                	push   $0x0
  jmp alltraps
80105e1d:	e9 3d fb ff ff       	jmp    8010595f <alltraps>

80105e22 <vector1>:
.globl vector1
vector1:
  pushl $0
80105e22:	6a 00                	push   $0x0
  pushl $1
80105e24:	6a 01                	push   $0x1
  jmp alltraps
80105e26:	e9 34 fb ff ff       	jmp    8010595f <alltraps>

80105e2b <vector2>:
.globl vector2
vector2:
  pushl $0
80105e2b:	6a 00                	push   $0x0
  pushl $2
80105e2d:	6a 02                	push   $0x2
  jmp alltraps
80105e2f:	e9 2b fb ff ff       	jmp    8010595f <alltraps>

80105e34 <vector3>:
.globl vector3
vector3:
  pushl $0
80105e34:	6a 00                	push   $0x0
  pushl $3
80105e36:	6a 03                	push   $0x3
  jmp alltraps
80105e38:	e9 22 fb ff ff       	jmp    8010595f <alltraps>

80105e3d <vector4>:
.globl vector4
vector4:
  pushl $0
80105e3d:	6a 00                	push   $0x0
  pushl $4
80105e3f:	6a 04                	push   $0x4
  jmp alltraps
80105e41:	e9 19 fb ff ff       	jmp    8010595f <alltraps>

80105e46 <vector5>:
.globl vector5
vector5:
  pushl $0
80105e46:	6a 00                	push   $0x0
  pushl $5
80105e48:	6a 05                	push   $0x5
  jmp alltraps
80105e4a:	e9 10 fb ff ff       	jmp    8010595f <alltraps>

80105e4f <vector6>:
.globl vector6
vector6:
  pushl $0
80105e4f:	6a 00                	push   $0x0
  pushl $6
80105e51:	6a 06                	push   $0x6
  jmp alltraps
80105e53:	e9 07 fb ff ff       	jmp    8010595f <alltraps>

80105e58 <vector7>:
.globl vector7
vector7:
  pushl $0
80105e58:	6a 00                	push   $0x0
  pushl $7
80105e5a:	6a 07                	push   $0x7
  jmp alltraps
80105e5c:	e9 fe fa ff ff       	jmp    8010595f <alltraps>

80105e61 <vector8>:
.globl vector8
vector8:
  pushl $8
80105e61:	6a 08                	push   $0x8
  jmp alltraps
80105e63:	e9 f7 fa ff ff       	jmp    8010595f <alltraps>

80105e68 <vector9>:
.globl vector9
vector9:
  pushl $0
80105e68:	6a 00                	push   $0x0
  pushl $9
80105e6a:	6a 09                	push   $0x9
  jmp alltraps
80105e6c:	e9 ee fa ff ff       	jmp    8010595f <alltraps>

80105e71 <vector10>:
.globl vector10
vector10:
  pushl $10
80105e71:	6a 0a                	push   $0xa
  jmp alltraps
80105e73:	e9 e7 fa ff ff       	jmp    8010595f <alltraps>

80105e78 <vector11>:
.globl vector11
vector11:
  pushl $11
80105e78:	6a 0b                	push   $0xb
  jmp alltraps
80105e7a:	e9 e0 fa ff ff       	jmp    8010595f <alltraps>

80105e7f <vector12>:
.globl vector12
vector12:
  pushl $12
80105e7f:	6a 0c                	push   $0xc
  jmp alltraps
80105e81:	e9 d9 fa ff ff       	jmp    8010595f <alltraps>

80105e86 <vector13>:
.globl vector13
vector13:
  pushl $13
80105e86:	6a 0d                	push   $0xd
  jmp alltraps
80105e88:	e9 d2 fa ff ff       	jmp    8010595f <alltraps>

80105e8d <vector14>:
.globl vector14
vector14:
  pushl $14
80105e8d:	6a 0e                	push   $0xe
  jmp alltraps
80105e8f:	e9 cb fa ff ff       	jmp    8010595f <alltraps>

80105e94 <vector15>:
.globl vector15
vector15:
  pushl $0
80105e94:	6a 00                	push   $0x0
  pushl $15
80105e96:	6a 0f                	push   $0xf
  jmp alltraps
80105e98:	e9 c2 fa ff ff       	jmp    8010595f <alltraps>

80105e9d <vector16>:
.globl vector16
vector16:
  pushl $0
80105e9d:	6a 00                	push   $0x0
  pushl $16
80105e9f:	6a 10                	push   $0x10
  jmp alltraps
80105ea1:	e9 b9 fa ff ff       	jmp    8010595f <alltraps>

80105ea6 <vector17>:
.globl vector17
vector17:
  pushl $17
80105ea6:	6a 11                	push   $0x11
  jmp alltraps
80105ea8:	e9 b2 fa ff ff       	jmp    8010595f <alltraps>

80105ead <vector18>:
.globl vector18
vector18:
  pushl $0
80105ead:	6a 00                	push   $0x0
  pushl $18
80105eaf:	6a 12                	push   $0x12
  jmp alltraps
80105eb1:	e9 a9 fa ff ff       	jmp    8010595f <alltraps>

80105eb6 <vector19>:
.globl vector19
vector19:
  pushl $0
80105eb6:	6a 00                	push   $0x0
  pushl $19
80105eb8:	6a 13                	push   $0x13
  jmp alltraps
80105eba:	e9 a0 fa ff ff       	jmp    8010595f <alltraps>

80105ebf <vector20>:
.globl vector20
vector20:
  pushl $0
80105ebf:	6a 00                	push   $0x0
  pushl $20
80105ec1:	6a 14                	push   $0x14
  jmp alltraps
80105ec3:	e9 97 fa ff ff       	jmp    8010595f <alltraps>

80105ec8 <vector21>:
.globl vector21
vector21:
  pushl $0
80105ec8:	6a 00                	push   $0x0
  pushl $21
80105eca:	6a 15                	push   $0x15
  jmp alltraps
80105ecc:	e9 8e fa ff ff       	jmp    8010595f <alltraps>

80105ed1 <vector22>:
.globl vector22
vector22:
  pushl $0
80105ed1:	6a 00                	push   $0x0
  pushl $22
80105ed3:	6a 16                	push   $0x16
  jmp alltraps
80105ed5:	e9 85 fa ff ff       	jmp    8010595f <alltraps>

80105eda <vector23>:
.globl vector23
vector23:
  pushl $0
80105eda:	6a 00                	push   $0x0
  pushl $23
80105edc:	6a 17                	push   $0x17
  jmp alltraps
80105ede:	e9 7c fa ff ff       	jmp    8010595f <alltraps>

80105ee3 <vector24>:
.globl vector24
vector24:
  pushl $0
80105ee3:	6a 00                	push   $0x0
  pushl $24
80105ee5:	6a 18                	push   $0x18
  jmp alltraps
80105ee7:	e9 73 fa ff ff       	jmp    8010595f <alltraps>

80105eec <vector25>:
.globl vector25
vector25:
  pushl $0
80105eec:	6a 00                	push   $0x0
  pushl $25
80105eee:	6a 19                	push   $0x19
  jmp alltraps
80105ef0:	e9 6a fa ff ff       	jmp    8010595f <alltraps>

80105ef5 <vector26>:
.globl vector26
vector26:
  pushl $0
80105ef5:	6a 00                	push   $0x0
  pushl $26
80105ef7:	6a 1a                	push   $0x1a
  jmp alltraps
80105ef9:	e9 61 fa ff ff       	jmp    8010595f <alltraps>

80105efe <vector27>:
.globl vector27
vector27:
  pushl $0
80105efe:	6a 00                	push   $0x0
  pushl $27
80105f00:	6a 1b                	push   $0x1b
  jmp alltraps
80105f02:	e9 58 fa ff ff       	jmp    8010595f <alltraps>

80105f07 <vector28>:
.globl vector28
vector28:
  pushl $0
80105f07:	6a 00                	push   $0x0
  pushl $28
80105f09:	6a 1c                	push   $0x1c
  jmp alltraps
80105f0b:	e9 4f fa ff ff       	jmp    8010595f <alltraps>

80105f10 <vector29>:
.globl vector29
vector29:
  pushl $0
80105f10:	6a 00                	push   $0x0
  pushl $29
80105f12:	6a 1d                	push   $0x1d
  jmp alltraps
80105f14:	e9 46 fa ff ff       	jmp    8010595f <alltraps>

80105f19 <vector30>:
.globl vector30
vector30:
  pushl $0
80105f19:	6a 00                	push   $0x0
  pushl $30
80105f1b:	6a 1e                	push   $0x1e
  jmp alltraps
80105f1d:	e9 3d fa ff ff       	jmp    8010595f <alltraps>

80105f22 <vector31>:
.globl vector31
vector31:
  pushl $0
80105f22:	6a 00                	push   $0x0
  pushl $31
80105f24:	6a 1f                	push   $0x1f
  jmp alltraps
80105f26:	e9 34 fa ff ff       	jmp    8010595f <alltraps>

80105f2b <vector32>:
.globl vector32
vector32:
  pushl $0
80105f2b:	6a 00                	push   $0x0
  pushl $32
80105f2d:	6a 20                	push   $0x20
  jmp alltraps
80105f2f:	e9 2b fa ff ff       	jmp    8010595f <alltraps>

80105f34 <vector33>:
.globl vector33
vector33:
  pushl $0
80105f34:	6a 00                	push   $0x0
  pushl $33
80105f36:	6a 21                	push   $0x21
  jmp alltraps
80105f38:	e9 22 fa ff ff       	jmp    8010595f <alltraps>

80105f3d <vector34>:
.globl vector34
vector34:
  pushl $0
80105f3d:	6a 00                	push   $0x0
  pushl $34
80105f3f:	6a 22                	push   $0x22
  jmp alltraps
80105f41:	e9 19 fa ff ff       	jmp    8010595f <alltraps>

80105f46 <vector35>:
.globl vector35
vector35:
  pushl $0
80105f46:	6a 00                	push   $0x0
  pushl $35
80105f48:	6a 23                	push   $0x23
  jmp alltraps
80105f4a:	e9 10 fa ff ff       	jmp    8010595f <alltraps>

80105f4f <vector36>:
.globl vector36
vector36:
  pushl $0
80105f4f:	6a 00                	push   $0x0
  pushl $36
80105f51:	6a 24                	push   $0x24
  jmp alltraps
80105f53:	e9 07 fa ff ff       	jmp    8010595f <alltraps>

80105f58 <vector37>:
.globl vector37
vector37:
  pushl $0
80105f58:	6a 00                	push   $0x0
  pushl $37
80105f5a:	6a 25                	push   $0x25
  jmp alltraps
80105f5c:	e9 fe f9 ff ff       	jmp    8010595f <alltraps>

80105f61 <vector38>:
.globl vector38
vector38:
  pushl $0
80105f61:	6a 00                	push   $0x0
  pushl $38
80105f63:	6a 26                	push   $0x26
  jmp alltraps
80105f65:	e9 f5 f9 ff ff       	jmp    8010595f <alltraps>

80105f6a <vector39>:
.globl vector39
vector39:
  pushl $0
80105f6a:	6a 00                	push   $0x0
  pushl $39
80105f6c:	6a 27                	push   $0x27
  jmp alltraps
80105f6e:	e9 ec f9 ff ff       	jmp    8010595f <alltraps>

80105f73 <vector40>:
.globl vector40
vector40:
  pushl $0
80105f73:	6a 00                	push   $0x0
  pushl $40
80105f75:	6a 28                	push   $0x28
  jmp alltraps
80105f77:	e9 e3 f9 ff ff       	jmp    8010595f <alltraps>

80105f7c <vector41>:
.globl vector41
vector41:
  pushl $0
80105f7c:	6a 00                	push   $0x0
  pushl $41
80105f7e:	6a 29                	push   $0x29
  jmp alltraps
80105f80:	e9 da f9 ff ff       	jmp    8010595f <alltraps>

80105f85 <vector42>:
.globl vector42
vector42:
  pushl $0
80105f85:	6a 00                	push   $0x0
  pushl $42
80105f87:	6a 2a                	push   $0x2a
  jmp alltraps
80105f89:	e9 d1 f9 ff ff       	jmp    8010595f <alltraps>

80105f8e <vector43>:
.globl vector43
vector43:
  pushl $0
80105f8e:	6a 00                	push   $0x0
  pushl $43
80105f90:	6a 2b                	push   $0x2b
  jmp alltraps
80105f92:	e9 c8 f9 ff ff       	jmp    8010595f <alltraps>

80105f97 <vector44>:
.globl vector44
vector44:
  pushl $0
80105f97:	6a 00                	push   $0x0
  pushl $44
80105f99:	6a 2c                	push   $0x2c
  jmp alltraps
80105f9b:	e9 bf f9 ff ff       	jmp    8010595f <alltraps>

80105fa0 <vector45>:
.globl vector45
vector45:
  pushl $0
80105fa0:	6a 00                	push   $0x0
  pushl $45
80105fa2:	6a 2d                	push   $0x2d
  jmp alltraps
80105fa4:	e9 b6 f9 ff ff       	jmp    8010595f <alltraps>

80105fa9 <vector46>:
.globl vector46
vector46:
  pushl $0
80105fa9:	6a 00                	push   $0x0
  pushl $46
80105fab:	6a 2e                	push   $0x2e
  jmp alltraps
80105fad:	e9 ad f9 ff ff       	jmp    8010595f <alltraps>

80105fb2 <vector47>:
.globl vector47
vector47:
  pushl $0
80105fb2:	6a 00                	push   $0x0
  pushl $47
80105fb4:	6a 2f                	push   $0x2f
  jmp alltraps
80105fb6:	e9 a4 f9 ff ff       	jmp    8010595f <alltraps>

80105fbb <vector48>:
.globl vector48
vector48:
  pushl $0
80105fbb:	6a 00                	push   $0x0
  pushl $48
80105fbd:	6a 30                	push   $0x30
  jmp alltraps
80105fbf:	e9 9b f9 ff ff       	jmp    8010595f <alltraps>

80105fc4 <vector49>:
.globl vector49
vector49:
  pushl $0
80105fc4:	6a 00                	push   $0x0
  pushl $49
80105fc6:	6a 31                	push   $0x31
  jmp alltraps
80105fc8:	e9 92 f9 ff ff       	jmp    8010595f <alltraps>

80105fcd <vector50>:
.globl vector50
vector50:
  pushl $0
80105fcd:	6a 00                	push   $0x0
  pushl $50
80105fcf:	6a 32                	push   $0x32
  jmp alltraps
80105fd1:	e9 89 f9 ff ff       	jmp    8010595f <alltraps>

80105fd6 <vector51>:
.globl vector51
vector51:
  pushl $0
80105fd6:	6a 00                	push   $0x0
  pushl $51
80105fd8:	6a 33                	push   $0x33
  jmp alltraps
80105fda:	e9 80 f9 ff ff       	jmp    8010595f <alltraps>

80105fdf <vector52>:
.globl vector52
vector52:
  pushl $0
80105fdf:	6a 00                	push   $0x0
  pushl $52
80105fe1:	6a 34                	push   $0x34
  jmp alltraps
80105fe3:	e9 77 f9 ff ff       	jmp    8010595f <alltraps>

80105fe8 <vector53>:
.globl vector53
vector53:
  pushl $0
80105fe8:	6a 00                	push   $0x0
  pushl $53
80105fea:	6a 35                	push   $0x35
  jmp alltraps
80105fec:	e9 6e f9 ff ff       	jmp    8010595f <alltraps>

80105ff1 <vector54>:
.globl vector54
vector54:
  pushl $0
80105ff1:	6a 00                	push   $0x0
  pushl $54
80105ff3:	6a 36                	push   $0x36
  jmp alltraps
80105ff5:	e9 65 f9 ff ff       	jmp    8010595f <alltraps>

80105ffa <vector55>:
.globl vector55
vector55:
  pushl $0
80105ffa:	6a 00                	push   $0x0
  pushl $55
80105ffc:	6a 37                	push   $0x37
  jmp alltraps
80105ffe:	e9 5c f9 ff ff       	jmp    8010595f <alltraps>

80106003 <vector56>:
.globl vector56
vector56:
  pushl $0
80106003:	6a 00                	push   $0x0
  pushl $56
80106005:	6a 38                	push   $0x38
  jmp alltraps
80106007:	e9 53 f9 ff ff       	jmp    8010595f <alltraps>

8010600c <vector57>:
.globl vector57
vector57:
  pushl $0
8010600c:	6a 00                	push   $0x0
  pushl $57
8010600e:	6a 39                	push   $0x39
  jmp alltraps
80106010:	e9 4a f9 ff ff       	jmp    8010595f <alltraps>

80106015 <vector58>:
.globl vector58
vector58:
  pushl $0
80106015:	6a 00                	push   $0x0
  pushl $58
80106017:	6a 3a                	push   $0x3a
  jmp alltraps
80106019:	e9 41 f9 ff ff       	jmp    8010595f <alltraps>

8010601e <vector59>:
.globl vector59
vector59:
  pushl $0
8010601e:	6a 00                	push   $0x0
  pushl $59
80106020:	6a 3b                	push   $0x3b
  jmp alltraps
80106022:	e9 38 f9 ff ff       	jmp    8010595f <alltraps>

80106027 <vector60>:
.globl vector60
vector60:
  pushl $0
80106027:	6a 00                	push   $0x0
  pushl $60
80106029:	6a 3c                	push   $0x3c
  jmp alltraps
8010602b:	e9 2f f9 ff ff       	jmp    8010595f <alltraps>

80106030 <vector61>:
.globl vector61
vector61:
  pushl $0
80106030:	6a 00                	push   $0x0
  pushl $61
80106032:	6a 3d                	push   $0x3d
  jmp alltraps
80106034:	e9 26 f9 ff ff       	jmp    8010595f <alltraps>

80106039 <vector62>:
.globl vector62
vector62:
  pushl $0
80106039:	6a 00                	push   $0x0
  pushl $62
8010603b:	6a 3e                	push   $0x3e
  jmp alltraps
8010603d:	e9 1d f9 ff ff       	jmp    8010595f <alltraps>

80106042 <vector63>:
.globl vector63
vector63:
  pushl $0
80106042:	6a 00                	push   $0x0
  pushl $63
80106044:	6a 3f                	push   $0x3f
  jmp alltraps
80106046:	e9 14 f9 ff ff       	jmp    8010595f <alltraps>

8010604b <vector64>:
.globl vector64
vector64:
  pushl $0
8010604b:	6a 00                	push   $0x0
  pushl $64
8010604d:	6a 40                	push   $0x40
  jmp alltraps
8010604f:	e9 0b f9 ff ff       	jmp    8010595f <alltraps>

80106054 <vector65>:
.globl vector65
vector65:
  pushl $0
80106054:	6a 00                	push   $0x0
  pushl $65
80106056:	6a 41                	push   $0x41
  jmp alltraps
80106058:	e9 02 f9 ff ff       	jmp    8010595f <alltraps>

8010605d <vector66>:
.globl vector66
vector66:
  pushl $0
8010605d:	6a 00                	push   $0x0
  pushl $66
8010605f:	6a 42                	push   $0x42
  jmp alltraps
80106061:	e9 f9 f8 ff ff       	jmp    8010595f <alltraps>

80106066 <vector67>:
.globl vector67
vector67:
  pushl $0
80106066:	6a 00                	push   $0x0
  pushl $67
80106068:	6a 43                	push   $0x43
  jmp alltraps
8010606a:	e9 f0 f8 ff ff       	jmp    8010595f <alltraps>

8010606f <vector68>:
.globl vector68
vector68:
  pushl $0
8010606f:	6a 00                	push   $0x0
  pushl $68
80106071:	6a 44                	push   $0x44
  jmp alltraps
80106073:	e9 e7 f8 ff ff       	jmp    8010595f <alltraps>

80106078 <vector69>:
.globl vector69
vector69:
  pushl $0
80106078:	6a 00                	push   $0x0
  pushl $69
8010607a:	6a 45                	push   $0x45
  jmp alltraps
8010607c:	e9 de f8 ff ff       	jmp    8010595f <alltraps>

80106081 <vector70>:
.globl vector70
vector70:
  pushl $0
80106081:	6a 00                	push   $0x0
  pushl $70
80106083:	6a 46                	push   $0x46
  jmp alltraps
80106085:	e9 d5 f8 ff ff       	jmp    8010595f <alltraps>

8010608a <vector71>:
.globl vector71
vector71:
  pushl $0
8010608a:	6a 00                	push   $0x0
  pushl $71
8010608c:	6a 47                	push   $0x47
  jmp alltraps
8010608e:	e9 cc f8 ff ff       	jmp    8010595f <alltraps>

80106093 <vector72>:
.globl vector72
vector72:
  pushl $0
80106093:	6a 00                	push   $0x0
  pushl $72
80106095:	6a 48                	push   $0x48
  jmp alltraps
80106097:	e9 c3 f8 ff ff       	jmp    8010595f <alltraps>

8010609c <vector73>:
.globl vector73
vector73:
  pushl $0
8010609c:	6a 00                	push   $0x0
  pushl $73
8010609e:	6a 49                	push   $0x49
  jmp alltraps
801060a0:	e9 ba f8 ff ff       	jmp    8010595f <alltraps>

801060a5 <vector74>:
.globl vector74
vector74:
  pushl $0
801060a5:	6a 00                	push   $0x0
  pushl $74
801060a7:	6a 4a                	push   $0x4a
  jmp alltraps
801060a9:	e9 b1 f8 ff ff       	jmp    8010595f <alltraps>

801060ae <vector75>:
.globl vector75
vector75:
  pushl $0
801060ae:	6a 00                	push   $0x0
  pushl $75
801060b0:	6a 4b                	push   $0x4b
  jmp alltraps
801060b2:	e9 a8 f8 ff ff       	jmp    8010595f <alltraps>

801060b7 <vector76>:
.globl vector76
vector76:
  pushl $0
801060b7:	6a 00                	push   $0x0
  pushl $76
801060b9:	6a 4c                	push   $0x4c
  jmp alltraps
801060bb:	e9 9f f8 ff ff       	jmp    8010595f <alltraps>

801060c0 <vector77>:
.globl vector77
vector77:
  pushl $0
801060c0:	6a 00                	push   $0x0
  pushl $77
801060c2:	6a 4d                	push   $0x4d
  jmp alltraps
801060c4:	e9 96 f8 ff ff       	jmp    8010595f <alltraps>

801060c9 <vector78>:
.globl vector78
vector78:
  pushl $0
801060c9:	6a 00                	push   $0x0
  pushl $78
801060cb:	6a 4e                	push   $0x4e
  jmp alltraps
801060cd:	e9 8d f8 ff ff       	jmp    8010595f <alltraps>

801060d2 <vector79>:
.globl vector79
vector79:
  pushl $0
801060d2:	6a 00                	push   $0x0
  pushl $79
801060d4:	6a 4f                	push   $0x4f
  jmp alltraps
801060d6:	e9 84 f8 ff ff       	jmp    8010595f <alltraps>

801060db <vector80>:
.globl vector80
vector80:
  pushl $0
801060db:	6a 00                	push   $0x0
  pushl $80
801060dd:	6a 50                	push   $0x50
  jmp alltraps
801060df:	e9 7b f8 ff ff       	jmp    8010595f <alltraps>

801060e4 <vector81>:
.globl vector81
vector81:
  pushl $0
801060e4:	6a 00                	push   $0x0
  pushl $81
801060e6:	6a 51                	push   $0x51
  jmp alltraps
801060e8:	e9 72 f8 ff ff       	jmp    8010595f <alltraps>

801060ed <vector82>:
.globl vector82
vector82:
  pushl $0
801060ed:	6a 00                	push   $0x0
  pushl $82
801060ef:	6a 52                	push   $0x52
  jmp alltraps
801060f1:	e9 69 f8 ff ff       	jmp    8010595f <alltraps>

801060f6 <vector83>:
.globl vector83
vector83:
  pushl $0
801060f6:	6a 00                	push   $0x0
  pushl $83
801060f8:	6a 53                	push   $0x53
  jmp alltraps
801060fa:	e9 60 f8 ff ff       	jmp    8010595f <alltraps>

801060ff <vector84>:
.globl vector84
vector84:
  pushl $0
801060ff:	6a 00                	push   $0x0
  pushl $84
80106101:	6a 54                	push   $0x54
  jmp alltraps
80106103:	e9 57 f8 ff ff       	jmp    8010595f <alltraps>

80106108 <vector85>:
.globl vector85
vector85:
  pushl $0
80106108:	6a 00                	push   $0x0
  pushl $85
8010610a:	6a 55                	push   $0x55
  jmp alltraps
8010610c:	e9 4e f8 ff ff       	jmp    8010595f <alltraps>

80106111 <vector86>:
.globl vector86
vector86:
  pushl $0
80106111:	6a 00                	push   $0x0
  pushl $86
80106113:	6a 56                	push   $0x56
  jmp alltraps
80106115:	e9 45 f8 ff ff       	jmp    8010595f <alltraps>

8010611a <vector87>:
.globl vector87
vector87:
  pushl $0
8010611a:	6a 00                	push   $0x0
  pushl $87
8010611c:	6a 57                	push   $0x57
  jmp alltraps
8010611e:	e9 3c f8 ff ff       	jmp    8010595f <alltraps>

80106123 <vector88>:
.globl vector88
vector88:
  pushl $0
80106123:	6a 00                	push   $0x0
  pushl $88
80106125:	6a 58                	push   $0x58
  jmp alltraps
80106127:	e9 33 f8 ff ff       	jmp    8010595f <alltraps>

8010612c <vector89>:
.globl vector89
vector89:
  pushl $0
8010612c:	6a 00                	push   $0x0
  pushl $89
8010612e:	6a 59                	push   $0x59
  jmp alltraps
80106130:	e9 2a f8 ff ff       	jmp    8010595f <alltraps>

80106135 <vector90>:
.globl vector90
vector90:
  pushl $0
80106135:	6a 00                	push   $0x0
  pushl $90
80106137:	6a 5a                	push   $0x5a
  jmp alltraps
80106139:	e9 21 f8 ff ff       	jmp    8010595f <alltraps>

8010613e <vector91>:
.globl vector91
vector91:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $91
80106140:	6a 5b                	push   $0x5b
  jmp alltraps
80106142:	e9 18 f8 ff ff       	jmp    8010595f <alltraps>

80106147 <vector92>:
.globl vector92
vector92:
  pushl $0
80106147:	6a 00                	push   $0x0
  pushl $92
80106149:	6a 5c                	push   $0x5c
  jmp alltraps
8010614b:	e9 0f f8 ff ff       	jmp    8010595f <alltraps>

80106150 <vector93>:
.globl vector93
vector93:
  pushl $0
80106150:	6a 00                	push   $0x0
  pushl $93
80106152:	6a 5d                	push   $0x5d
  jmp alltraps
80106154:	e9 06 f8 ff ff       	jmp    8010595f <alltraps>

80106159 <vector94>:
.globl vector94
vector94:
  pushl $0
80106159:	6a 00                	push   $0x0
  pushl $94
8010615b:	6a 5e                	push   $0x5e
  jmp alltraps
8010615d:	e9 fd f7 ff ff       	jmp    8010595f <alltraps>

80106162 <vector95>:
.globl vector95
vector95:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $95
80106164:	6a 5f                	push   $0x5f
  jmp alltraps
80106166:	e9 f4 f7 ff ff       	jmp    8010595f <alltraps>

8010616b <vector96>:
.globl vector96
vector96:
  pushl $0
8010616b:	6a 00                	push   $0x0
  pushl $96
8010616d:	6a 60                	push   $0x60
  jmp alltraps
8010616f:	e9 eb f7 ff ff       	jmp    8010595f <alltraps>

80106174 <vector97>:
.globl vector97
vector97:
  pushl $0
80106174:	6a 00                	push   $0x0
  pushl $97
80106176:	6a 61                	push   $0x61
  jmp alltraps
80106178:	e9 e2 f7 ff ff       	jmp    8010595f <alltraps>

8010617d <vector98>:
.globl vector98
vector98:
  pushl $0
8010617d:	6a 00                	push   $0x0
  pushl $98
8010617f:	6a 62                	push   $0x62
  jmp alltraps
80106181:	e9 d9 f7 ff ff       	jmp    8010595f <alltraps>

80106186 <vector99>:
.globl vector99
vector99:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $99
80106188:	6a 63                	push   $0x63
  jmp alltraps
8010618a:	e9 d0 f7 ff ff       	jmp    8010595f <alltraps>

8010618f <vector100>:
.globl vector100
vector100:
  pushl $0
8010618f:	6a 00                	push   $0x0
  pushl $100
80106191:	6a 64                	push   $0x64
  jmp alltraps
80106193:	e9 c7 f7 ff ff       	jmp    8010595f <alltraps>

80106198 <vector101>:
.globl vector101
vector101:
  pushl $0
80106198:	6a 00                	push   $0x0
  pushl $101
8010619a:	6a 65                	push   $0x65
  jmp alltraps
8010619c:	e9 be f7 ff ff       	jmp    8010595f <alltraps>

801061a1 <vector102>:
.globl vector102
vector102:
  pushl $0
801061a1:	6a 00                	push   $0x0
  pushl $102
801061a3:	6a 66                	push   $0x66
  jmp alltraps
801061a5:	e9 b5 f7 ff ff       	jmp    8010595f <alltraps>

801061aa <vector103>:
.globl vector103
vector103:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $103
801061ac:	6a 67                	push   $0x67
  jmp alltraps
801061ae:	e9 ac f7 ff ff       	jmp    8010595f <alltraps>

801061b3 <vector104>:
.globl vector104
vector104:
  pushl $0
801061b3:	6a 00                	push   $0x0
  pushl $104
801061b5:	6a 68                	push   $0x68
  jmp alltraps
801061b7:	e9 a3 f7 ff ff       	jmp    8010595f <alltraps>

801061bc <vector105>:
.globl vector105
vector105:
  pushl $0
801061bc:	6a 00                	push   $0x0
  pushl $105
801061be:	6a 69                	push   $0x69
  jmp alltraps
801061c0:	e9 9a f7 ff ff       	jmp    8010595f <alltraps>

801061c5 <vector106>:
.globl vector106
vector106:
  pushl $0
801061c5:	6a 00                	push   $0x0
  pushl $106
801061c7:	6a 6a                	push   $0x6a
  jmp alltraps
801061c9:	e9 91 f7 ff ff       	jmp    8010595f <alltraps>

801061ce <vector107>:
.globl vector107
vector107:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $107
801061d0:	6a 6b                	push   $0x6b
  jmp alltraps
801061d2:	e9 88 f7 ff ff       	jmp    8010595f <alltraps>

801061d7 <vector108>:
.globl vector108
vector108:
  pushl $0
801061d7:	6a 00                	push   $0x0
  pushl $108
801061d9:	6a 6c                	push   $0x6c
  jmp alltraps
801061db:	e9 7f f7 ff ff       	jmp    8010595f <alltraps>

801061e0 <vector109>:
.globl vector109
vector109:
  pushl $0
801061e0:	6a 00                	push   $0x0
  pushl $109
801061e2:	6a 6d                	push   $0x6d
  jmp alltraps
801061e4:	e9 76 f7 ff ff       	jmp    8010595f <alltraps>

801061e9 <vector110>:
.globl vector110
vector110:
  pushl $0
801061e9:	6a 00                	push   $0x0
  pushl $110
801061eb:	6a 6e                	push   $0x6e
  jmp alltraps
801061ed:	e9 6d f7 ff ff       	jmp    8010595f <alltraps>

801061f2 <vector111>:
.globl vector111
vector111:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $111
801061f4:	6a 6f                	push   $0x6f
  jmp alltraps
801061f6:	e9 64 f7 ff ff       	jmp    8010595f <alltraps>

801061fb <vector112>:
.globl vector112
vector112:
  pushl $0
801061fb:	6a 00                	push   $0x0
  pushl $112
801061fd:	6a 70                	push   $0x70
  jmp alltraps
801061ff:	e9 5b f7 ff ff       	jmp    8010595f <alltraps>

80106204 <vector113>:
.globl vector113
vector113:
  pushl $0
80106204:	6a 00                	push   $0x0
  pushl $113
80106206:	6a 71                	push   $0x71
  jmp alltraps
80106208:	e9 52 f7 ff ff       	jmp    8010595f <alltraps>

8010620d <vector114>:
.globl vector114
vector114:
  pushl $0
8010620d:	6a 00                	push   $0x0
  pushl $114
8010620f:	6a 72                	push   $0x72
  jmp alltraps
80106211:	e9 49 f7 ff ff       	jmp    8010595f <alltraps>

80106216 <vector115>:
.globl vector115
vector115:
  pushl $0
80106216:	6a 00                	push   $0x0
  pushl $115
80106218:	6a 73                	push   $0x73
  jmp alltraps
8010621a:	e9 40 f7 ff ff       	jmp    8010595f <alltraps>

8010621f <vector116>:
.globl vector116
vector116:
  pushl $0
8010621f:	6a 00                	push   $0x0
  pushl $116
80106221:	6a 74                	push   $0x74
  jmp alltraps
80106223:	e9 37 f7 ff ff       	jmp    8010595f <alltraps>

80106228 <vector117>:
.globl vector117
vector117:
  pushl $0
80106228:	6a 00                	push   $0x0
  pushl $117
8010622a:	6a 75                	push   $0x75
  jmp alltraps
8010622c:	e9 2e f7 ff ff       	jmp    8010595f <alltraps>

80106231 <vector118>:
.globl vector118
vector118:
  pushl $0
80106231:	6a 00                	push   $0x0
  pushl $118
80106233:	6a 76                	push   $0x76
  jmp alltraps
80106235:	e9 25 f7 ff ff       	jmp    8010595f <alltraps>

8010623a <vector119>:
.globl vector119
vector119:
  pushl $0
8010623a:	6a 00                	push   $0x0
  pushl $119
8010623c:	6a 77                	push   $0x77
  jmp alltraps
8010623e:	e9 1c f7 ff ff       	jmp    8010595f <alltraps>

80106243 <vector120>:
.globl vector120
vector120:
  pushl $0
80106243:	6a 00                	push   $0x0
  pushl $120
80106245:	6a 78                	push   $0x78
  jmp alltraps
80106247:	e9 13 f7 ff ff       	jmp    8010595f <alltraps>

8010624c <vector121>:
.globl vector121
vector121:
  pushl $0
8010624c:	6a 00                	push   $0x0
  pushl $121
8010624e:	6a 79                	push   $0x79
  jmp alltraps
80106250:	e9 0a f7 ff ff       	jmp    8010595f <alltraps>

80106255 <vector122>:
.globl vector122
vector122:
  pushl $0
80106255:	6a 00                	push   $0x0
  pushl $122
80106257:	6a 7a                	push   $0x7a
  jmp alltraps
80106259:	e9 01 f7 ff ff       	jmp    8010595f <alltraps>

8010625e <vector123>:
.globl vector123
vector123:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $123
80106260:	6a 7b                	push   $0x7b
  jmp alltraps
80106262:	e9 f8 f6 ff ff       	jmp    8010595f <alltraps>

80106267 <vector124>:
.globl vector124
vector124:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $124
80106269:	6a 7c                	push   $0x7c
  jmp alltraps
8010626b:	e9 ef f6 ff ff       	jmp    8010595f <alltraps>

80106270 <vector125>:
.globl vector125
vector125:
  pushl $0
80106270:	6a 00                	push   $0x0
  pushl $125
80106272:	6a 7d                	push   $0x7d
  jmp alltraps
80106274:	e9 e6 f6 ff ff       	jmp    8010595f <alltraps>

80106279 <vector126>:
.globl vector126
vector126:
  pushl $0
80106279:	6a 00                	push   $0x0
  pushl $126
8010627b:	6a 7e                	push   $0x7e
  jmp alltraps
8010627d:	e9 dd f6 ff ff       	jmp    8010595f <alltraps>

80106282 <vector127>:
.globl vector127
vector127:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $127
80106284:	6a 7f                	push   $0x7f
  jmp alltraps
80106286:	e9 d4 f6 ff ff       	jmp    8010595f <alltraps>

8010628b <vector128>:
.globl vector128
vector128:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $128
8010628d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106292:	e9 c8 f6 ff ff       	jmp    8010595f <alltraps>

80106297 <vector129>:
.globl vector129
vector129:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $129
80106299:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010629e:	e9 bc f6 ff ff       	jmp    8010595f <alltraps>

801062a3 <vector130>:
.globl vector130
vector130:
  pushl $0
801062a3:	6a 00                	push   $0x0
  pushl $130
801062a5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801062aa:	e9 b0 f6 ff ff       	jmp    8010595f <alltraps>

801062af <vector131>:
.globl vector131
vector131:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $131
801062b1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801062b6:	e9 a4 f6 ff ff       	jmp    8010595f <alltraps>

801062bb <vector132>:
.globl vector132
vector132:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $132
801062bd:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801062c2:	e9 98 f6 ff ff       	jmp    8010595f <alltraps>

801062c7 <vector133>:
.globl vector133
vector133:
  pushl $0
801062c7:	6a 00                	push   $0x0
  pushl $133
801062c9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801062ce:	e9 8c f6 ff ff       	jmp    8010595f <alltraps>

801062d3 <vector134>:
.globl vector134
vector134:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $134
801062d5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801062da:	e9 80 f6 ff ff       	jmp    8010595f <alltraps>

801062df <vector135>:
.globl vector135
vector135:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $135
801062e1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801062e6:	e9 74 f6 ff ff       	jmp    8010595f <alltraps>

801062eb <vector136>:
.globl vector136
vector136:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $136
801062ed:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801062f2:	e9 68 f6 ff ff       	jmp    8010595f <alltraps>

801062f7 <vector137>:
.globl vector137
vector137:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $137
801062f9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801062fe:	e9 5c f6 ff ff       	jmp    8010595f <alltraps>

80106303 <vector138>:
.globl vector138
vector138:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $138
80106305:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010630a:	e9 50 f6 ff ff       	jmp    8010595f <alltraps>

8010630f <vector139>:
.globl vector139
vector139:
  pushl $0
8010630f:	6a 00                	push   $0x0
  pushl $139
80106311:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106316:	e9 44 f6 ff ff       	jmp    8010595f <alltraps>

8010631b <vector140>:
.globl vector140
vector140:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $140
8010631d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106322:	e9 38 f6 ff ff       	jmp    8010595f <alltraps>

80106327 <vector141>:
.globl vector141
vector141:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $141
80106329:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010632e:	e9 2c f6 ff ff       	jmp    8010595f <alltraps>

80106333 <vector142>:
.globl vector142
vector142:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $142
80106335:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010633a:	e9 20 f6 ff ff       	jmp    8010595f <alltraps>

8010633f <vector143>:
.globl vector143
vector143:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $143
80106341:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106346:	e9 14 f6 ff ff       	jmp    8010595f <alltraps>

8010634b <vector144>:
.globl vector144
vector144:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $144
8010634d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106352:	e9 08 f6 ff ff       	jmp    8010595f <alltraps>

80106357 <vector145>:
.globl vector145
vector145:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $145
80106359:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010635e:	e9 fc f5 ff ff       	jmp    8010595f <alltraps>

80106363 <vector146>:
.globl vector146
vector146:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $146
80106365:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010636a:	e9 f0 f5 ff ff       	jmp    8010595f <alltraps>

8010636f <vector147>:
.globl vector147
vector147:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $147
80106371:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106376:	e9 e4 f5 ff ff       	jmp    8010595f <alltraps>

8010637b <vector148>:
.globl vector148
vector148:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $148
8010637d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106382:	e9 d8 f5 ff ff       	jmp    8010595f <alltraps>

80106387 <vector149>:
.globl vector149
vector149:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $149
80106389:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010638e:	e9 cc f5 ff ff       	jmp    8010595f <alltraps>

80106393 <vector150>:
.globl vector150
vector150:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $150
80106395:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010639a:	e9 c0 f5 ff ff       	jmp    8010595f <alltraps>

8010639f <vector151>:
.globl vector151
vector151:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $151
801063a1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801063a6:	e9 b4 f5 ff ff       	jmp    8010595f <alltraps>

801063ab <vector152>:
.globl vector152
vector152:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $152
801063ad:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801063b2:	e9 a8 f5 ff ff       	jmp    8010595f <alltraps>

801063b7 <vector153>:
.globl vector153
vector153:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $153
801063b9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801063be:	e9 9c f5 ff ff       	jmp    8010595f <alltraps>

801063c3 <vector154>:
.globl vector154
vector154:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $154
801063c5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801063ca:	e9 90 f5 ff ff       	jmp    8010595f <alltraps>

801063cf <vector155>:
.globl vector155
vector155:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $155
801063d1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801063d6:	e9 84 f5 ff ff       	jmp    8010595f <alltraps>

801063db <vector156>:
.globl vector156
vector156:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $156
801063dd:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801063e2:	e9 78 f5 ff ff       	jmp    8010595f <alltraps>

801063e7 <vector157>:
.globl vector157
vector157:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $157
801063e9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801063ee:	e9 6c f5 ff ff       	jmp    8010595f <alltraps>

801063f3 <vector158>:
.globl vector158
vector158:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $158
801063f5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801063fa:	e9 60 f5 ff ff       	jmp    8010595f <alltraps>

801063ff <vector159>:
.globl vector159
vector159:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $159
80106401:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106406:	e9 54 f5 ff ff       	jmp    8010595f <alltraps>

8010640b <vector160>:
.globl vector160
vector160:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $160
8010640d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106412:	e9 48 f5 ff ff       	jmp    8010595f <alltraps>

80106417 <vector161>:
.globl vector161
vector161:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $161
80106419:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010641e:	e9 3c f5 ff ff       	jmp    8010595f <alltraps>

80106423 <vector162>:
.globl vector162
vector162:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $162
80106425:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010642a:	e9 30 f5 ff ff       	jmp    8010595f <alltraps>

8010642f <vector163>:
.globl vector163
vector163:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $163
80106431:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106436:	e9 24 f5 ff ff       	jmp    8010595f <alltraps>

8010643b <vector164>:
.globl vector164
vector164:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $164
8010643d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106442:	e9 18 f5 ff ff       	jmp    8010595f <alltraps>

80106447 <vector165>:
.globl vector165
vector165:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $165
80106449:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010644e:	e9 0c f5 ff ff       	jmp    8010595f <alltraps>

80106453 <vector166>:
.globl vector166
vector166:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $166
80106455:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010645a:	e9 00 f5 ff ff       	jmp    8010595f <alltraps>

8010645f <vector167>:
.globl vector167
vector167:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $167
80106461:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106466:	e9 f4 f4 ff ff       	jmp    8010595f <alltraps>

8010646b <vector168>:
.globl vector168
vector168:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $168
8010646d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106472:	e9 e8 f4 ff ff       	jmp    8010595f <alltraps>

80106477 <vector169>:
.globl vector169
vector169:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $169
80106479:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010647e:	e9 dc f4 ff ff       	jmp    8010595f <alltraps>

80106483 <vector170>:
.globl vector170
vector170:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $170
80106485:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010648a:	e9 d0 f4 ff ff       	jmp    8010595f <alltraps>

8010648f <vector171>:
.globl vector171
vector171:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $171
80106491:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106496:	e9 c4 f4 ff ff       	jmp    8010595f <alltraps>

8010649b <vector172>:
.globl vector172
vector172:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $172
8010649d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801064a2:	e9 b8 f4 ff ff       	jmp    8010595f <alltraps>

801064a7 <vector173>:
.globl vector173
vector173:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $173
801064a9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801064ae:	e9 ac f4 ff ff       	jmp    8010595f <alltraps>

801064b3 <vector174>:
.globl vector174
vector174:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $174
801064b5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801064ba:	e9 a0 f4 ff ff       	jmp    8010595f <alltraps>

801064bf <vector175>:
.globl vector175
vector175:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $175
801064c1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801064c6:	e9 94 f4 ff ff       	jmp    8010595f <alltraps>

801064cb <vector176>:
.globl vector176
vector176:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $176
801064cd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801064d2:	e9 88 f4 ff ff       	jmp    8010595f <alltraps>

801064d7 <vector177>:
.globl vector177
vector177:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $177
801064d9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801064de:	e9 7c f4 ff ff       	jmp    8010595f <alltraps>

801064e3 <vector178>:
.globl vector178
vector178:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $178
801064e5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801064ea:	e9 70 f4 ff ff       	jmp    8010595f <alltraps>

801064ef <vector179>:
.globl vector179
vector179:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $179
801064f1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801064f6:	e9 64 f4 ff ff       	jmp    8010595f <alltraps>

801064fb <vector180>:
.globl vector180
vector180:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $180
801064fd:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106502:	e9 58 f4 ff ff       	jmp    8010595f <alltraps>

80106507 <vector181>:
.globl vector181
vector181:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $181
80106509:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010650e:	e9 4c f4 ff ff       	jmp    8010595f <alltraps>

80106513 <vector182>:
.globl vector182
vector182:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $182
80106515:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010651a:	e9 40 f4 ff ff       	jmp    8010595f <alltraps>

8010651f <vector183>:
.globl vector183
vector183:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $183
80106521:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106526:	e9 34 f4 ff ff       	jmp    8010595f <alltraps>

8010652b <vector184>:
.globl vector184
vector184:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $184
8010652d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106532:	e9 28 f4 ff ff       	jmp    8010595f <alltraps>

80106537 <vector185>:
.globl vector185
vector185:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $185
80106539:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010653e:	e9 1c f4 ff ff       	jmp    8010595f <alltraps>

80106543 <vector186>:
.globl vector186
vector186:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $186
80106545:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010654a:	e9 10 f4 ff ff       	jmp    8010595f <alltraps>

8010654f <vector187>:
.globl vector187
vector187:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $187
80106551:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106556:	e9 04 f4 ff ff       	jmp    8010595f <alltraps>

8010655b <vector188>:
.globl vector188
vector188:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $188
8010655d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106562:	e9 f8 f3 ff ff       	jmp    8010595f <alltraps>

80106567 <vector189>:
.globl vector189
vector189:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $189
80106569:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010656e:	e9 ec f3 ff ff       	jmp    8010595f <alltraps>

80106573 <vector190>:
.globl vector190
vector190:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $190
80106575:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010657a:	e9 e0 f3 ff ff       	jmp    8010595f <alltraps>

8010657f <vector191>:
.globl vector191
vector191:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $191
80106581:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106586:	e9 d4 f3 ff ff       	jmp    8010595f <alltraps>

8010658b <vector192>:
.globl vector192
vector192:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $192
8010658d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106592:	e9 c8 f3 ff ff       	jmp    8010595f <alltraps>

80106597 <vector193>:
.globl vector193
vector193:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $193
80106599:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010659e:	e9 bc f3 ff ff       	jmp    8010595f <alltraps>

801065a3 <vector194>:
.globl vector194
vector194:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $194
801065a5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801065aa:	e9 b0 f3 ff ff       	jmp    8010595f <alltraps>

801065af <vector195>:
.globl vector195
vector195:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $195
801065b1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801065b6:	e9 a4 f3 ff ff       	jmp    8010595f <alltraps>

801065bb <vector196>:
.globl vector196
vector196:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $196
801065bd:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801065c2:	e9 98 f3 ff ff       	jmp    8010595f <alltraps>

801065c7 <vector197>:
.globl vector197
vector197:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $197
801065c9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801065ce:	e9 8c f3 ff ff       	jmp    8010595f <alltraps>

801065d3 <vector198>:
.globl vector198
vector198:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $198
801065d5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801065da:	e9 80 f3 ff ff       	jmp    8010595f <alltraps>

801065df <vector199>:
.globl vector199
vector199:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $199
801065e1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801065e6:	e9 74 f3 ff ff       	jmp    8010595f <alltraps>

801065eb <vector200>:
.globl vector200
vector200:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $200
801065ed:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801065f2:	e9 68 f3 ff ff       	jmp    8010595f <alltraps>

801065f7 <vector201>:
.globl vector201
vector201:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $201
801065f9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801065fe:	e9 5c f3 ff ff       	jmp    8010595f <alltraps>

80106603 <vector202>:
.globl vector202
vector202:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $202
80106605:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010660a:	e9 50 f3 ff ff       	jmp    8010595f <alltraps>

8010660f <vector203>:
.globl vector203
vector203:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $203
80106611:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106616:	e9 44 f3 ff ff       	jmp    8010595f <alltraps>

8010661b <vector204>:
.globl vector204
vector204:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $204
8010661d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106622:	e9 38 f3 ff ff       	jmp    8010595f <alltraps>

80106627 <vector205>:
.globl vector205
vector205:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $205
80106629:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010662e:	e9 2c f3 ff ff       	jmp    8010595f <alltraps>

80106633 <vector206>:
.globl vector206
vector206:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $206
80106635:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010663a:	e9 20 f3 ff ff       	jmp    8010595f <alltraps>

8010663f <vector207>:
.globl vector207
vector207:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $207
80106641:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106646:	e9 14 f3 ff ff       	jmp    8010595f <alltraps>

8010664b <vector208>:
.globl vector208
vector208:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $208
8010664d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106652:	e9 08 f3 ff ff       	jmp    8010595f <alltraps>

80106657 <vector209>:
.globl vector209
vector209:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $209
80106659:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010665e:	e9 fc f2 ff ff       	jmp    8010595f <alltraps>

80106663 <vector210>:
.globl vector210
vector210:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $210
80106665:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010666a:	e9 f0 f2 ff ff       	jmp    8010595f <alltraps>

8010666f <vector211>:
.globl vector211
vector211:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $211
80106671:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106676:	e9 e4 f2 ff ff       	jmp    8010595f <alltraps>

8010667b <vector212>:
.globl vector212
vector212:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $212
8010667d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106682:	e9 d8 f2 ff ff       	jmp    8010595f <alltraps>

80106687 <vector213>:
.globl vector213
vector213:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $213
80106689:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010668e:	e9 cc f2 ff ff       	jmp    8010595f <alltraps>

80106693 <vector214>:
.globl vector214
vector214:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $214
80106695:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010669a:	e9 c0 f2 ff ff       	jmp    8010595f <alltraps>

8010669f <vector215>:
.globl vector215
vector215:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $215
801066a1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801066a6:	e9 b4 f2 ff ff       	jmp    8010595f <alltraps>

801066ab <vector216>:
.globl vector216
vector216:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $216
801066ad:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801066b2:	e9 a8 f2 ff ff       	jmp    8010595f <alltraps>

801066b7 <vector217>:
.globl vector217
vector217:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $217
801066b9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801066be:	e9 9c f2 ff ff       	jmp    8010595f <alltraps>

801066c3 <vector218>:
.globl vector218
vector218:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $218
801066c5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801066ca:	e9 90 f2 ff ff       	jmp    8010595f <alltraps>

801066cf <vector219>:
.globl vector219
vector219:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $219
801066d1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801066d6:	e9 84 f2 ff ff       	jmp    8010595f <alltraps>

801066db <vector220>:
.globl vector220
vector220:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $220
801066dd:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801066e2:	e9 78 f2 ff ff       	jmp    8010595f <alltraps>

801066e7 <vector221>:
.globl vector221
vector221:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $221
801066e9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801066ee:	e9 6c f2 ff ff       	jmp    8010595f <alltraps>

801066f3 <vector222>:
.globl vector222
vector222:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $222
801066f5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801066fa:	e9 60 f2 ff ff       	jmp    8010595f <alltraps>

801066ff <vector223>:
.globl vector223
vector223:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $223
80106701:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106706:	e9 54 f2 ff ff       	jmp    8010595f <alltraps>

8010670b <vector224>:
.globl vector224
vector224:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $224
8010670d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106712:	e9 48 f2 ff ff       	jmp    8010595f <alltraps>

80106717 <vector225>:
.globl vector225
vector225:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $225
80106719:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010671e:	e9 3c f2 ff ff       	jmp    8010595f <alltraps>

80106723 <vector226>:
.globl vector226
vector226:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $226
80106725:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010672a:	e9 30 f2 ff ff       	jmp    8010595f <alltraps>

8010672f <vector227>:
.globl vector227
vector227:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $227
80106731:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106736:	e9 24 f2 ff ff       	jmp    8010595f <alltraps>

8010673b <vector228>:
.globl vector228
vector228:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $228
8010673d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106742:	e9 18 f2 ff ff       	jmp    8010595f <alltraps>

80106747 <vector229>:
.globl vector229
vector229:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $229
80106749:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010674e:	e9 0c f2 ff ff       	jmp    8010595f <alltraps>

80106753 <vector230>:
.globl vector230
vector230:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $230
80106755:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010675a:	e9 00 f2 ff ff       	jmp    8010595f <alltraps>

8010675f <vector231>:
.globl vector231
vector231:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $231
80106761:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106766:	e9 f4 f1 ff ff       	jmp    8010595f <alltraps>

8010676b <vector232>:
.globl vector232
vector232:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $232
8010676d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106772:	e9 e8 f1 ff ff       	jmp    8010595f <alltraps>

80106777 <vector233>:
.globl vector233
vector233:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $233
80106779:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010677e:	e9 dc f1 ff ff       	jmp    8010595f <alltraps>

80106783 <vector234>:
.globl vector234
vector234:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $234
80106785:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010678a:	e9 d0 f1 ff ff       	jmp    8010595f <alltraps>

8010678f <vector235>:
.globl vector235
vector235:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $235
80106791:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106796:	e9 c4 f1 ff ff       	jmp    8010595f <alltraps>

8010679b <vector236>:
.globl vector236
vector236:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $236
8010679d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801067a2:	e9 b8 f1 ff ff       	jmp    8010595f <alltraps>

801067a7 <vector237>:
.globl vector237
vector237:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $237
801067a9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801067ae:	e9 ac f1 ff ff       	jmp    8010595f <alltraps>

801067b3 <vector238>:
.globl vector238
vector238:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $238
801067b5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801067ba:	e9 a0 f1 ff ff       	jmp    8010595f <alltraps>

801067bf <vector239>:
.globl vector239
vector239:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $239
801067c1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801067c6:	e9 94 f1 ff ff       	jmp    8010595f <alltraps>

801067cb <vector240>:
.globl vector240
vector240:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $240
801067cd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801067d2:	e9 88 f1 ff ff       	jmp    8010595f <alltraps>

801067d7 <vector241>:
.globl vector241
vector241:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $241
801067d9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801067de:	e9 7c f1 ff ff       	jmp    8010595f <alltraps>

801067e3 <vector242>:
.globl vector242
vector242:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $242
801067e5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801067ea:	e9 70 f1 ff ff       	jmp    8010595f <alltraps>

801067ef <vector243>:
.globl vector243
vector243:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $243
801067f1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801067f6:	e9 64 f1 ff ff       	jmp    8010595f <alltraps>

801067fb <vector244>:
.globl vector244
vector244:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $244
801067fd:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106802:	e9 58 f1 ff ff       	jmp    8010595f <alltraps>

80106807 <vector245>:
.globl vector245
vector245:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $245
80106809:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010680e:	e9 4c f1 ff ff       	jmp    8010595f <alltraps>

80106813 <vector246>:
.globl vector246
vector246:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $246
80106815:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010681a:	e9 40 f1 ff ff       	jmp    8010595f <alltraps>

8010681f <vector247>:
.globl vector247
vector247:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $247
80106821:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106826:	e9 34 f1 ff ff       	jmp    8010595f <alltraps>

8010682b <vector248>:
.globl vector248
vector248:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $248
8010682d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106832:	e9 28 f1 ff ff       	jmp    8010595f <alltraps>

80106837 <vector249>:
.globl vector249
vector249:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $249
80106839:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010683e:	e9 1c f1 ff ff       	jmp    8010595f <alltraps>

80106843 <vector250>:
.globl vector250
vector250:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $250
80106845:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010684a:	e9 10 f1 ff ff       	jmp    8010595f <alltraps>

8010684f <vector251>:
.globl vector251
vector251:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $251
80106851:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106856:	e9 04 f1 ff ff       	jmp    8010595f <alltraps>

8010685b <vector252>:
.globl vector252
vector252:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $252
8010685d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106862:	e9 f8 f0 ff ff       	jmp    8010595f <alltraps>

80106867 <vector253>:
.globl vector253
vector253:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $253
80106869:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010686e:	e9 ec f0 ff ff       	jmp    8010595f <alltraps>

80106873 <vector254>:
.globl vector254
vector254:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $254
80106875:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010687a:	e9 e0 f0 ff ff       	jmp    8010595f <alltraps>

8010687f <vector255>:
.globl vector255
vector255:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $255
80106881:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106886:	e9 d4 f0 ff ff       	jmp    8010595f <alltraps>
8010688b:	66 90                	xchg   %ax,%ax
8010688d:	66 90                	xchg   %ax,%ax
8010688f:	90                   	nop

80106890 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106890:	55                   	push   %ebp
80106891:	89 e5                	mov    %esp,%ebp
80106893:	57                   	push   %edi
80106894:	56                   	push   %esi
80106895:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106897:	c1 ea 16             	shr    $0x16,%edx
{
8010689a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010689b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010689e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801068a1:	8b 1f                	mov    (%edi),%ebx
801068a3:	f6 c3 01             	test   $0x1,%bl
801068a6:	74 28                	je     801068d0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801068a8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801068ae:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801068b4:	89 f0                	mov    %esi,%eax
}
801068b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801068b9:	c1 e8 0a             	shr    $0xa,%eax
801068bc:	25 fc 0f 00 00       	and    $0xffc,%eax
801068c1:	01 d8                	add    %ebx,%eax
}
801068c3:	5b                   	pop    %ebx
801068c4:	5e                   	pop    %esi
801068c5:	5f                   	pop    %edi
801068c6:	5d                   	pop    %ebp
801068c7:	c3                   	ret    
801068c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068cf:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801068d0:	85 c9                	test   %ecx,%ecx
801068d2:	74 2c                	je     80106900 <walkpgdir+0x70>
801068d4:	e8 67 bd ff ff       	call   80102640 <kalloc>
801068d9:	89 c3                	mov    %eax,%ebx
801068db:	85 c0                	test   %eax,%eax
801068dd:	74 21                	je     80106900 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801068df:	83 ec 04             	sub    $0x4,%esp
801068e2:	68 00 10 00 00       	push   $0x1000
801068e7:	6a 00                	push   $0x0
801068e9:	50                   	push   %eax
801068ea:	e8 21 de ff ff       	call   80104710 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801068ef:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801068f5:	83 c4 10             	add    $0x10,%esp
801068f8:	83 c8 07             	or     $0x7,%eax
801068fb:	89 07                	mov    %eax,(%edi)
801068fd:	eb b5                	jmp    801068b4 <walkpgdir+0x24>
801068ff:	90                   	nop
}
80106900:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106903:	31 c0                	xor    %eax,%eax
}
80106905:	5b                   	pop    %ebx
80106906:	5e                   	pop    %esi
80106907:	5f                   	pop    %edi
80106908:	5d                   	pop    %ebp
80106909:	c3                   	ret    
8010690a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106910 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	57                   	push   %edi
80106914:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106916:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010691a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010691b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106920:	89 d6                	mov    %edx,%esi
{
80106922:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106923:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106929:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010692c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010692f:	8b 45 08             	mov    0x8(%ebp),%eax
80106932:	29 f0                	sub    %esi,%eax
80106934:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106937:	eb 1f                	jmp    80106958 <mappages+0x48>
80106939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106940:	f6 00 01             	testb  $0x1,(%eax)
80106943:	75 45                	jne    8010698a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106945:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106948:	83 cb 01             	or     $0x1,%ebx
8010694b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010694d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106950:	74 2e                	je     80106980 <mappages+0x70>
      break;
    a += PGSIZE;
80106952:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80106958:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010695b:	b9 01 00 00 00       	mov    $0x1,%ecx
80106960:	89 f2                	mov    %esi,%edx
80106962:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106965:	89 f8                	mov    %edi,%eax
80106967:	e8 24 ff ff ff       	call   80106890 <walkpgdir>
8010696c:	85 c0                	test   %eax,%eax
8010696e:	75 d0                	jne    80106940 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106970:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106973:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106978:	5b                   	pop    %ebx
80106979:	5e                   	pop    %esi
8010697a:	5f                   	pop    %edi
8010697b:	5d                   	pop    %ebp
8010697c:	c3                   	ret    
8010697d:	8d 76 00             	lea    0x0(%esi),%esi
80106980:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106983:	31 c0                	xor    %eax,%eax
}
80106985:	5b                   	pop    %ebx
80106986:	5e                   	pop    %esi
80106987:	5f                   	pop    %edi
80106988:	5d                   	pop    %ebp
80106989:	c3                   	ret    
      panic("remap");
8010698a:	83 ec 0c             	sub    $0xc,%esp
8010698d:	68 90 7a 10 80       	push   $0x80107a90
80106992:	e8 f9 99 ff ff       	call   80100390 <panic>
80106997:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010699e:	66 90                	xchg   %ax,%ax

801069a0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069a0:	55                   	push   %ebp
801069a1:	89 e5                	mov    %esp,%ebp
801069a3:	57                   	push   %edi
801069a4:	56                   	push   %esi
801069a5:	89 c6                	mov    %eax,%esi
801069a7:	53                   	push   %ebx
801069a8:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801069aa:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
801069b0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069b6:	83 ec 1c             	sub    $0x1c,%esp
801069b9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801069bc:	39 da                	cmp    %ebx,%edx
801069be:	73 5b                	jae    80106a1b <deallocuvm.part.0+0x7b>
801069c0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801069c3:	89 d7                	mov    %edx,%edi
801069c5:	eb 14                	jmp    801069db <deallocuvm.part.0+0x3b>
801069c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069ce:	66 90                	xchg   %ax,%ax
801069d0:	81 c7 00 10 00 00    	add    $0x1000,%edi
801069d6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801069d9:	76 40                	jbe    80106a1b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
801069db:	31 c9                	xor    %ecx,%ecx
801069dd:	89 fa                	mov    %edi,%edx
801069df:	89 f0                	mov    %esi,%eax
801069e1:	e8 aa fe ff ff       	call   80106890 <walkpgdir>
801069e6:	89 c3                	mov    %eax,%ebx
    if(!pte)
801069e8:	85 c0                	test   %eax,%eax
801069ea:	74 44                	je     80106a30 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801069ec:	8b 00                	mov    (%eax),%eax
801069ee:	a8 01                	test   $0x1,%al
801069f0:	74 de                	je     801069d0 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801069f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801069f7:	74 47                	je     80106a40 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801069f9:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801069fc:	05 00 00 00 80       	add    $0x80000000,%eax
80106a01:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80106a07:	50                   	push   %eax
80106a08:	e8 73 ba ff ff       	call   80102480 <kfree>
      *pte = 0;
80106a0d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106a13:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80106a16:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106a19:	77 c0                	ja     801069db <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
80106a1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a21:	5b                   	pop    %ebx
80106a22:	5e                   	pop    %esi
80106a23:	5f                   	pop    %edi
80106a24:	5d                   	pop    %ebp
80106a25:	c3                   	ret    
80106a26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a2d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106a30:	89 fa                	mov    %edi,%edx
80106a32:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106a38:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
80106a3e:	eb 96                	jmp    801069d6 <deallocuvm.part.0+0x36>
        panic("kfree");
80106a40:	83 ec 0c             	sub    $0xc,%esp
80106a43:	68 46 74 10 80       	push   $0x80107446
80106a48:	e8 43 99 ff ff       	call   80100390 <panic>
80106a4d:	8d 76 00             	lea    0x0(%esi),%esi

80106a50 <seginit>:
{
80106a50:	f3 0f 1e fb          	endbr32 
80106a54:	55                   	push   %ebp
80106a55:	89 e5                	mov    %esp,%ebp
80106a57:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106a5a:	e8 01 cf ff ff       	call   80103960 <cpuid>
  pd[0] = size-1;
80106a5f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106a64:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106a6a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106a6e:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106a75:	ff 00 00 
80106a78:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
80106a7f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a82:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106a89:	ff 00 00 
80106a8c:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106a93:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a96:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106a9d:	ff 00 00 
80106aa0:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106aa7:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106aaa:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
80106ab1:	ff 00 00 
80106ab4:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106abb:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106abe:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106ac3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106ac7:	c1 e8 10             	shr    $0x10,%eax
80106aca:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106ace:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106ad1:	0f 01 10             	lgdtl  (%eax)
}
80106ad4:	c9                   	leave  
80106ad5:	c3                   	ret    
80106ad6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106add:	8d 76 00             	lea    0x0(%esi),%esi

80106ae0 <switchkvm>:
{
80106ae0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ae4:	a1 a4 55 11 80       	mov    0x801155a4,%eax
80106ae9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106aee:	0f 22 d8             	mov    %eax,%cr3
}
80106af1:	c3                   	ret    
80106af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b00 <switchuvm>:
{
80106b00:	f3 0f 1e fb          	endbr32 
80106b04:	55                   	push   %ebp
80106b05:	89 e5                	mov    %esp,%ebp
80106b07:	57                   	push   %edi
80106b08:	56                   	push   %esi
80106b09:	53                   	push   %ebx
80106b0a:	83 ec 1c             	sub    $0x1c,%esp
80106b0d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106b10:	85 f6                	test   %esi,%esi
80106b12:	0f 84 cb 00 00 00    	je     80106be3 <switchuvm+0xe3>
  if(p->kstack == 0)
80106b18:	8b 46 08             	mov    0x8(%esi),%eax
80106b1b:	85 c0                	test   %eax,%eax
80106b1d:	0f 84 da 00 00 00    	je     80106bfd <switchuvm+0xfd>
  if(p->pgdir == 0)
80106b23:	8b 46 04             	mov    0x4(%esi),%eax
80106b26:	85 c0                	test   %eax,%eax
80106b28:	0f 84 c2 00 00 00    	je     80106bf0 <switchuvm+0xf0>
  pushcli();
80106b2e:	e8 cd d9 ff ff       	call   80104500 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b33:	e8 b8 cd ff ff       	call   801038f0 <mycpu>
80106b38:	89 c3                	mov    %eax,%ebx
80106b3a:	e8 b1 cd ff ff       	call   801038f0 <mycpu>
80106b3f:	89 c7                	mov    %eax,%edi
80106b41:	e8 aa cd ff ff       	call   801038f0 <mycpu>
80106b46:	83 c7 08             	add    $0x8,%edi
80106b49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b4c:	e8 9f cd ff ff       	call   801038f0 <mycpu>
80106b51:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b54:	ba 67 00 00 00       	mov    $0x67,%edx
80106b59:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106b60:	83 c0 08             	add    $0x8,%eax
80106b63:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b6a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b6f:	83 c1 08             	add    $0x8,%ecx
80106b72:	c1 e8 18             	shr    $0x18,%eax
80106b75:	c1 e9 10             	shr    $0x10,%ecx
80106b78:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106b7e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106b84:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106b89:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b90:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106b95:	e8 56 cd ff ff       	call   801038f0 <mycpu>
80106b9a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106ba1:	e8 4a cd ff ff       	call   801038f0 <mycpu>
80106ba6:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106baa:	8b 5e 08             	mov    0x8(%esi),%ebx
80106bad:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bb3:	e8 38 cd ff ff       	call   801038f0 <mycpu>
80106bb8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106bbb:	e8 30 cd ff ff       	call   801038f0 <mycpu>
80106bc0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106bc4:	b8 28 00 00 00       	mov    $0x28,%eax
80106bc9:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106bcc:	8b 46 04             	mov    0x4(%esi),%eax
80106bcf:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106bd4:	0f 22 d8             	mov    %eax,%cr3
}
80106bd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bda:	5b                   	pop    %ebx
80106bdb:	5e                   	pop    %esi
80106bdc:	5f                   	pop    %edi
80106bdd:	5d                   	pop    %ebp
  popcli();
80106bde:	e9 6d d9 ff ff       	jmp    80104550 <popcli>
    panic("switchuvm: no process");
80106be3:	83 ec 0c             	sub    $0xc,%esp
80106be6:	68 96 7a 10 80       	push   $0x80107a96
80106beb:	e8 a0 97 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106bf0:	83 ec 0c             	sub    $0xc,%esp
80106bf3:	68 c1 7a 10 80       	push   $0x80107ac1
80106bf8:	e8 93 97 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106bfd:	83 ec 0c             	sub    $0xc,%esp
80106c00:	68 ac 7a 10 80       	push   $0x80107aac
80106c05:	e8 86 97 ff ff       	call   80100390 <panic>
80106c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c10 <inituvm>:
{
80106c10:	f3 0f 1e fb          	endbr32 
80106c14:	55                   	push   %ebp
80106c15:	89 e5                	mov    %esp,%ebp
80106c17:	57                   	push   %edi
80106c18:	56                   	push   %esi
80106c19:	53                   	push   %ebx
80106c1a:	83 ec 1c             	sub    $0x1c,%esp
80106c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c20:	8b 75 10             	mov    0x10(%ebp),%esi
80106c23:	8b 7d 08             	mov    0x8(%ebp),%edi
80106c26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106c29:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106c2f:	77 4b                	ja     80106c7c <inituvm+0x6c>
  mem = kalloc();
80106c31:	e8 0a ba ff ff       	call   80102640 <kalloc>
  memset(mem, 0, PGSIZE);
80106c36:	83 ec 04             	sub    $0x4,%esp
80106c39:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106c3e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106c40:	6a 00                	push   $0x0
80106c42:	50                   	push   %eax
80106c43:	e8 c8 da ff ff       	call   80104710 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106c48:	58                   	pop    %eax
80106c49:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c4f:	5a                   	pop    %edx
80106c50:	6a 06                	push   $0x6
80106c52:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c57:	31 d2                	xor    %edx,%edx
80106c59:	50                   	push   %eax
80106c5a:	89 f8                	mov    %edi,%eax
80106c5c:	e8 af fc ff ff       	call   80106910 <mappages>
  memmove(mem, init, sz);
80106c61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c64:	89 75 10             	mov    %esi,0x10(%ebp)
80106c67:	83 c4 10             	add    $0x10,%esp
80106c6a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106c6d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106c70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c73:	5b                   	pop    %ebx
80106c74:	5e                   	pop    %esi
80106c75:	5f                   	pop    %edi
80106c76:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106c77:	e9 34 db ff ff       	jmp    801047b0 <memmove>
    panic("inituvm: more than a page");
80106c7c:	83 ec 0c             	sub    $0xc,%esp
80106c7f:	68 d5 7a 10 80       	push   $0x80107ad5
80106c84:	e8 07 97 ff ff       	call   80100390 <panic>
80106c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c90 <loaduvm>:
{
80106c90:	f3 0f 1e fb          	endbr32 
80106c94:	55                   	push   %ebp
80106c95:	89 e5                	mov    %esp,%ebp
80106c97:	57                   	push   %edi
80106c98:	56                   	push   %esi
80106c99:	53                   	push   %ebx
80106c9a:	83 ec 1c             	sub    $0x1c,%esp
80106c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ca0:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106ca3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106ca8:	0f 85 99 00 00 00    	jne    80106d47 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
80106cae:	01 f0                	add    %esi,%eax
80106cb0:	89 f3                	mov    %esi,%ebx
80106cb2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106cb5:	8b 45 14             	mov    0x14(%ebp),%eax
80106cb8:	01 f0                	add    %esi,%eax
80106cba:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106cbd:	85 f6                	test   %esi,%esi
80106cbf:	75 15                	jne    80106cd6 <loaduvm+0x46>
80106cc1:	eb 6d                	jmp    80106d30 <loaduvm+0xa0>
80106cc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cc7:	90                   	nop
80106cc8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106cce:	89 f0                	mov    %esi,%eax
80106cd0:	29 d8                	sub    %ebx,%eax
80106cd2:	39 c6                	cmp    %eax,%esi
80106cd4:	76 5a                	jbe    80106d30 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106cd6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106cd9:	8b 45 08             	mov    0x8(%ebp),%eax
80106cdc:	31 c9                	xor    %ecx,%ecx
80106cde:	29 da                	sub    %ebx,%edx
80106ce0:	e8 ab fb ff ff       	call   80106890 <walkpgdir>
80106ce5:	85 c0                	test   %eax,%eax
80106ce7:	74 51                	je     80106d3a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80106ce9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ceb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106cee:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106cf3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106cf8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106cfe:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106d01:	29 d9                	sub    %ebx,%ecx
80106d03:	05 00 00 00 80       	add    $0x80000000,%eax
80106d08:	57                   	push   %edi
80106d09:	51                   	push   %ecx
80106d0a:	50                   	push   %eax
80106d0b:	ff 75 10             	pushl  0x10(%ebp)
80106d0e:	e8 5d ad ff ff       	call   80101a70 <readi>
80106d13:	83 c4 10             	add    $0x10,%esp
80106d16:	39 f8                	cmp    %edi,%eax
80106d18:	74 ae                	je     80106cc8 <loaduvm+0x38>
}
80106d1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d22:	5b                   	pop    %ebx
80106d23:	5e                   	pop    %esi
80106d24:	5f                   	pop    %edi
80106d25:	5d                   	pop    %ebp
80106d26:	c3                   	ret    
80106d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d2e:	66 90                	xchg   %ax,%ax
80106d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d33:	31 c0                	xor    %eax,%eax
}
80106d35:	5b                   	pop    %ebx
80106d36:	5e                   	pop    %esi
80106d37:	5f                   	pop    %edi
80106d38:	5d                   	pop    %ebp
80106d39:	c3                   	ret    
      panic("loaduvm: address should exist");
80106d3a:	83 ec 0c             	sub    $0xc,%esp
80106d3d:	68 ef 7a 10 80       	push   $0x80107aef
80106d42:	e8 49 96 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106d47:	83 ec 0c             	sub    $0xc,%esp
80106d4a:	68 90 7b 10 80       	push   $0x80107b90
80106d4f:	e8 3c 96 ff ff       	call   80100390 <panic>
80106d54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d5f:	90                   	nop

80106d60 <allocuvm>:
{
80106d60:	f3 0f 1e fb          	endbr32 
80106d64:	55                   	push   %ebp
80106d65:	89 e5                	mov    %esp,%ebp
80106d67:	57                   	push   %edi
80106d68:	56                   	push   %esi
80106d69:	53                   	push   %ebx
80106d6a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106d6d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106d70:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106d73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d76:	85 c0                	test   %eax,%eax
80106d78:	0f 88 b2 00 00 00    	js     80106e30 <allocuvm+0xd0>
  if(newsz < oldsz)
80106d7e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106d84:	0f 82 96 00 00 00    	jb     80106e20 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106d8a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106d90:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106d96:	39 75 10             	cmp    %esi,0x10(%ebp)
80106d99:	77 40                	ja     80106ddb <allocuvm+0x7b>
80106d9b:	e9 83 00 00 00       	jmp    80106e23 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80106da0:	83 ec 04             	sub    $0x4,%esp
80106da3:	68 00 10 00 00       	push   $0x1000
80106da8:	6a 00                	push   $0x0
80106daa:	50                   	push   %eax
80106dab:	e8 60 d9 ff ff       	call   80104710 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106db0:	58                   	pop    %eax
80106db1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106db7:	5a                   	pop    %edx
80106db8:	6a 06                	push   $0x6
80106dba:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106dbf:	89 f2                	mov    %esi,%edx
80106dc1:	50                   	push   %eax
80106dc2:	89 f8                	mov    %edi,%eax
80106dc4:	e8 47 fb ff ff       	call   80106910 <mappages>
80106dc9:	83 c4 10             	add    $0x10,%esp
80106dcc:	85 c0                	test   %eax,%eax
80106dce:	78 78                	js     80106e48 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106dd0:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106dd6:	39 75 10             	cmp    %esi,0x10(%ebp)
80106dd9:	76 48                	jbe    80106e23 <allocuvm+0xc3>
    mem = kalloc();
80106ddb:	e8 60 b8 ff ff       	call   80102640 <kalloc>
80106de0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106de2:	85 c0                	test   %eax,%eax
80106de4:	75 ba                	jne    80106da0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106de6:	83 ec 0c             	sub    $0xc,%esp
80106de9:	68 0d 7b 10 80       	push   $0x80107b0d
80106dee:	e8 bd 98 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106df3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106df6:	83 c4 10             	add    $0x10,%esp
80106df9:	39 45 10             	cmp    %eax,0x10(%ebp)
80106dfc:	74 32                	je     80106e30 <allocuvm+0xd0>
80106dfe:	8b 55 10             	mov    0x10(%ebp),%edx
80106e01:	89 c1                	mov    %eax,%ecx
80106e03:	89 f8                	mov    %edi,%eax
80106e05:	e8 96 fb ff ff       	call   801069a0 <deallocuvm.part.0>
      return 0;
80106e0a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106e11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e14:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e17:	5b                   	pop    %ebx
80106e18:	5e                   	pop    %esi
80106e19:	5f                   	pop    %edi
80106e1a:	5d                   	pop    %ebp
80106e1b:	c3                   	ret    
80106e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106e20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106e23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e29:	5b                   	pop    %ebx
80106e2a:	5e                   	pop    %esi
80106e2b:	5f                   	pop    %edi
80106e2c:	5d                   	pop    %ebp
80106e2d:	c3                   	ret    
80106e2e:	66 90                	xchg   %ax,%ax
    return 0;
80106e30:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106e37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e3d:	5b                   	pop    %ebx
80106e3e:	5e                   	pop    %esi
80106e3f:	5f                   	pop    %edi
80106e40:	5d                   	pop    %ebp
80106e41:	c3                   	ret    
80106e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106e48:	83 ec 0c             	sub    $0xc,%esp
80106e4b:	68 25 7b 10 80       	push   $0x80107b25
80106e50:	e8 5b 98 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106e55:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e58:	83 c4 10             	add    $0x10,%esp
80106e5b:	39 45 10             	cmp    %eax,0x10(%ebp)
80106e5e:	74 0c                	je     80106e6c <allocuvm+0x10c>
80106e60:	8b 55 10             	mov    0x10(%ebp),%edx
80106e63:	89 c1                	mov    %eax,%ecx
80106e65:	89 f8                	mov    %edi,%eax
80106e67:	e8 34 fb ff ff       	call   801069a0 <deallocuvm.part.0>
      kfree(mem);
80106e6c:	83 ec 0c             	sub    $0xc,%esp
80106e6f:	53                   	push   %ebx
80106e70:	e8 0b b6 ff ff       	call   80102480 <kfree>
      return 0;
80106e75:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106e7c:	83 c4 10             	add    $0x10,%esp
}
80106e7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e85:	5b                   	pop    %ebx
80106e86:	5e                   	pop    %esi
80106e87:	5f                   	pop    %edi
80106e88:	5d                   	pop    %ebp
80106e89:	c3                   	ret    
80106e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e90 <deallocuvm>:
{
80106e90:	f3 0f 1e fb          	endbr32 
80106e94:	55                   	push   %ebp
80106e95:	89 e5                	mov    %esp,%ebp
80106e97:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e9a:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106ea0:	39 d1                	cmp    %edx,%ecx
80106ea2:	73 0c                	jae    80106eb0 <deallocuvm+0x20>
}
80106ea4:	5d                   	pop    %ebp
80106ea5:	e9 f6 fa ff ff       	jmp    801069a0 <deallocuvm.part.0>
80106eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106eb0:	89 d0                	mov    %edx,%eax
80106eb2:	5d                   	pop    %ebp
80106eb3:	c3                   	ret    
80106eb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ebf:	90                   	nop

80106ec0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106ec0:	f3 0f 1e fb          	endbr32 
80106ec4:	55                   	push   %ebp
80106ec5:	89 e5                	mov    %esp,%ebp
80106ec7:	57                   	push   %edi
80106ec8:	56                   	push   %esi
80106ec9:	53                   	push   %ebx
80106eca:	83 ec 0c             	sub    $0xc,%esp
80106ecd:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106ed0:	85 f6                	test   %esi,%esi
80106ed2:	74 55                	je     80106f29 <freevm+0x69>
  if(newsz >= oldsz)
80106ed4:	31 c9                	xor    %ecx,%ecx
80106ed6:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106edb:	89 f0                	mov    %esi,%eax
80106edd:	89 f3                	mov    %esi,%ebx
80106edf:	e8 bc fa ff ff       	call   801069a0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ee4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106eea:	eb 0b                	jmp    80106ef7 <freevm+0x37>
80106eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ef0:	83 c3 04             	add    $0x4,%ebx
80106ef3:	39 df                	cmp    %ebx,%edi
80106ef5:	74 23                	je     80106f1a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106ef7:	8b 03                	mov    (%ebx),%eax
80106ef9:	a8 01                	test   $0x1,%al
80106efb:	74 f3                	je     80106ef0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106efd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106f02:	83 ec 0c             	sub    $0xc,%esp
80106f05:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f08:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106f0d:	50                   	push   %eax
80106f0e:	e8 6d b5 ff ff       	call   80102480 <kfree>
80106f13:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106f16:	39 df                	cmp    %ebx,%edi
80106f18:	75 dd                	jne    80106ef7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106f1a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106f1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f20:	5b                   	pop    %ebx
80106f21:	5e                   	pop    %esi
80106f22:	5f                   	pop    %edi
80106f23:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106f24:	e9 57 b5 ff ff       	jmp    80102480 <kfree>
    panic("freevm: no pgdir");
80106f29:	83 ec 0c             	sub    $0xc,%esp
80106f2c:	68 41 7b 10 80       	push   $0x80107b41
80106f31:	e8 5a 94 ff ff       	call   80100390 <panic>
80106f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f3d:	8d 76 00             	lea    0x0(%esi),%esi

80106f40 <setupkvm>:
{
80106f40:	f3 0f 1e fb          	endbr32 
80106f44:	55                   	push   %ebp
80106f45:	89 e5                	mov    %esp,%ebp
80106f47:	56                   	push   %esi
80106f48:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106f49:	e8 f2 b6 ff ff       	call   80102640 <kalloc>
80106f4e:	89 c6                	mov    %eax,%esi
80106f50:	85 c0                	test   %eax,%eax
80106f52:	74 42                	je     80106f96 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80106f54:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f57:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106f5c:	68 00 10 00 00       	push   $0x1000
80106f61:	6a 00                	push   $0x0
80106f63:	50                   	push   %eax
80106f64:	e8 a7 d7 ff ff       	call   80104710 <memset>
80106f69:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106f6c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106f6f:	83 ec 08             	sub    $0x8,%esp
80106f72:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106f75:	ff 73 0c             	pushl  0xc(%ebx)
80106f78:	8b 13                	mov    (%ebx),%edx
80106f7a:	50                   	push   %eax
80106f7b:	29 c1                	sub    %eax,%ecx
80106f7d:	89 f0                	mov    %esi,%eax
80106f7f:	e8 8c f9 ff ff       	call   80106910 <mappages>
80106f84:	83 c4 10             	add    $0x10,%esp
80106f87:	85 c0                	test   %eax,%eax
80106f89:	78 15                	js     80106fa0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f8b:	83 c3 10             	add    $0x10,%ebx
80106f8e:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106f94:	75 d6                	jne    80106f6c <setupkvm+0x2c>
}
80106f96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f99:	89 f0                	mov    %esi,%eax
80106f9b:	5b                   	pop    %ebx
80106f9c:	5e                   	pop    %esi
80106f9d:	5d                   	pop    %ebp
80106f9e:	c3                   	ret    
80106f9f:	90                   	nop
      freevm(pgdir);
80106fa0:	83 ec 0c             	sub    $0xc,%esp
80106fa3:	56                   	push   %esi
      return 0;
80106fa4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106fa6:	e8 15 ff ff ff       	call   80106ec0 <freevm>
      return 0;
80106fab:	83 c4 10             	add    $0x10,%esp
}
80106fae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106fb1:	89 f0                	mov    %esi,%eax
80106fb3:	5b                   	pop    %ebx
80106fb4:	5e                   	pop    %esi
80106fb5:	5d                   	pop    %ebp
80106fb6:	c3                   	ret    
80106fb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fbe:	66 90                	xchg   %ax,%ax

80106fc0 <kvmalloc>:
{
80106fc0:	f3 0f 1e fb          	endbr32 
80106fc4:	55                   	push   %ebp
80106fc5:	89 e5                	mov    %esp,%ebp
80106fc7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106fca:	e8 71 ff ff ff       	call   80106f40 <setupkvm>
80106fcf:	a3 a4 55 11 80       	mov    %eax,0x801155a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106fd4:	05 00 00 00 80       	add    $0x80000000,%eax
80106fd9:	0f 22 d8             	mov    %eax,%cr3
}
80106fdc:	c9                   	leave  
80106fdd:	c3                   	ret    
80106fde:	66 90                	xchg   %ax,%ax

80106fe0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106fe0:	f3 0f 1e fb          	endbr32 
80106fe4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106fe5:	31 c9                	xor    %ecx,%ecx
{
80106fe7:	89 e5                	mov    %esp,%ebp
80106fe9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106fec:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fef:	8b 45 08             	mov    0x8(%ebp),%eax
80106ff2:	e8 99 f8 ff ff       	call   80106890 <walkpgdir>
  if(pte == 0)
80106ff7:	85 c0                	test   %eax,%eax
80106ff9:	74 05                	je     80107000 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106ffb:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106ffe:	c9                   	leave  
80106fff:	c3                   	ret    
    panic("clearpteu");
80107000:	83 ec 0c             	sub    $0xc,%esp
80107003:	68 52 7b 10 80       	push   $0x80107b52
80107008:	e8 83 93 ff ff       	call   80100390 <panic>
8010700d:	8d 76 00             	lea    0x0(%esi),%esi

80107010 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107010:	f3 0f 1e fb          	endbr32 
80107014:	55                   	push   %ebp
80107015:	89 e5                	mov    %esp,%ebp
80107017:	57                   	push   %edi
80107018:	56                   	push   %esi
80107019:	53                   	push   %ebx
8010701a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010701d:	e8 1e ff ff ff       	call   80106f40 <setupkvm>
80107022:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107025:	85 c0                	test   %eax,%eax
80107027:	0f 84 9b 00 00 00    	je     801070c8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010702d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107030:	85 c9                	test   %ecx,%ecx
80107032:	0f 84 90 00 00 00    	je     801070c8 <copyuvm+0xb8>
80107038:	31 f6                	xor    %esi,%esi
8010703a:	eb 46                	jmp    80107082 <copyuvm+0x72>
8010703c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107040:	83 ec 04             	sub    $0x4,%esp
80107043:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107049:	68 00 10 00 00       	push   $0x1000
8010704e:	57                   	push   %edi
8010704f:	50                   	push   %eax
80107050:	e8 5b d7 ff ff       	call   801047b0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107055:	58                   	pop    %eax
80107056:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010705c:	5a                   	pop    %edx
8010705d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107060:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107065:	89 f2                	mov    %esi,%edx
80107067:	50                   	push   %eax
80107068:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010706b:	e8 a0 f8 ff ff       	call   80106910 <mappages>
80107070:	83 c4 10             	add    $0x10,%esp
80107073:	85 c0                	test   %eax,%eax
80107075:	78 61                	js     801070d8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107077:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010707d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107080:	76 46                	jbe    801070c8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107082:	8b 45 08             	mov    0x8(%ebp),%eax
80107085:	31 c9                	xor    %ecx,%ecx
80107087:	89 f2                	mov    %esi,%edx
80107089:	e8 02 f8 ff ff       	call   80106890 <walkpgdir>
8010708e:	85 c0                	test   %eax,%eax
80107090:	74 61                	je     801070f3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107092:	8b 00                	mov    (%eax),%eax
80107094:	a8 01                	test   $0x1,%al
80107096:	74 4e                	je     801070e6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107098:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010709a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010709f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801070a2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801070a8:	e8 93 b5 ff ff       	call   80102640 <kalloc>
801070ad:	89 c3                	mov    %eax,%ebx
801070af:	85 c0                	test   %eax,%eax
801070b1:	75 8d                	jne    80107040 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801070b3:	83 ec 0c             	sub    $0xc,%esp
801070b6:	ff 75 e0             	pushl  -0x20(%ebp)
801070b9:	e8 02 fe ff ff       	call   80106ec0 <freevm>
  return 0;
801070be:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801070c5:	83 c4 10             	add    $0x10,%esp
}
801070c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070ce:	5b                   	pop    %ebx
801070cf:	5e                   	pop    %esi
801070d0:	5f                   	pop    %edi
801070d1:	5d                   	pop    %ebp
801070d2:	c3                   	ret    
801070d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070d7:	90                   	nop
      kfree(mem);
801070d8:	83 ec 0c             	sub    $0xc,%esp
801070db:	53                   	push   %ebx
801070dc:	e8 9f b3 ff ff       	call   80102480 <kfree>
      goto bad;
801070e1:	83 c4 10             	add    $0x10,%esp
801070e4:	eb cd                	jmp    801070b3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801070e6:	83 ec 0c             	sub    $0xc,%esp
801070e9:	68 76 7b 10 80       	push   $0x80107b76
801070ee:	e8 9d 92 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801070f3:	83 ec 0c             	sub    $0xc,%esp
801070f6:	68 5c 7b 10 80       	push   $0x80107b5c
801070fb:	e8 90 92 ff ff       	call   80100390 <panic>

80107100 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107100:	f3 0f 1e fb          	endbr32 
80107104:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107105:	31 c9                	xor    %ecx,%ecx
{
80107107:	89 e5                	mov    %esp,%ebp
80107109:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010710c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010710f:	8b 45 08             	mov    0x8(%ebp),%eax
80107112:	e8 79 f7 ff ff       	call   80106890 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107117:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107119:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010711a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010711c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107121:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107124:	05 00 00 00 80       	add    $0x80000000,%eax
80107129:	83 fa 05             	cmp    $0x5,%edx
8010712c:	ba 00 00 00 00       	mov    $0x0,%edx
80107131:	0f 45 c2             	cmovne %edx,%eax
}
80107134:	c3                   	ret    
80107135:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010713c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107140 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107140:	f3 0f 1e fb          	endbr32 
80107144:	55                   	push   %ebp
80107145:	89 e5                	mov    %esp,%ebp
80107147:	57                   	push   %edi
80107148:	56                   	push   %esi
80107149:	53                   	push   %ebx
8010714a:	83 ec 0c             	sub    $0xc,%esp
8010714d:	8b 75 14             	mov    0x14(%ebp),%esi
80107150:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107153:	85 f6                	test   %esi,%esi
80107155:	75 3c                	jne    80107193 <copyout+0x53>
80107157:	eb 67                	jmp    801071c0 <copyout+0x80>
80107159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107160:	8b 55 0c             	mov    0xc(%ebp),%edx
80107163:	89 fb                	mov    %edi,%ebx
80107165:	29 d3                	sub    %edx,%ebx
80107167:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010716d:	39 f3                	cmp    %esi,%ebx
8010716f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107172:	29 fa                	sub    %edi,%edx
80107174:	83 ec 04             	sub    $0x4,%esp
80107177:	01 c2                	add    %eax,%edx
80107179:	53                   	push   %ebx
8010717a:	ff 75 10             	pushl  0x10(%ebp)
8010717d:	52                   	push   %edx
8010717e:	e8 2d d6 ff ff       	call   801047b0 <memmove>
    len -= n;
    buf += n;
80107183:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107186:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010718c:	83 c4 10             	add    $0x10,%esp
8010718f:	29 de                	sub    %ebx,%esi
80107191:	74 2d                	je     801071c0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107193:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107195:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107198:	89 55 0c             	mov    %edx,0xc(%ebp)
8010719b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801071a1:	57                   	push   %edi
801071a2:	ff 75 08             	pushl  0x8(%ebp)
801071a5:	e8 56 ff ff ff       	call   80107100 <uva2ka>
    if(pa0 == 0)
801071aa:	83 c4 10             	add    $0x10,%esp
801071ad:	85 c0                	test   %eax,%eax
801071af:	75 af                	jne    80107160 <copyout+0x20>
  }
  return 0;
}
801071b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801071b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071b9:	5b                   	pop    %ebx
801071ba:	5e                   	pop    %esi
801071bb:	5f                   	pop    %edi
801071bc:	5d                   	pop    %ebp
801071bd:	c3                   	ret    
801071be:	66 90                	xchg   %ax,%ax
801071c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801071c3:	31 c0                	xor    %eax,%eax
}
801071c5:	5b                   	pop    %ebx
801071c6:	5e                   	pop    %esi
801071c7:	5f                   	pop    %edi
801071c8:	5d                   	pop    %ebp
801071c9:	c3                   	ret    
