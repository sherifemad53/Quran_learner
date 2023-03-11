class CircularQueue<T> {
  List<T?> _buffer = [];
  int _head = 0;
  int _tail = 0;
  int _count = 0;

  CircularQueue(int capacity) {
    _buffer = List<T?>.filled(capacity, null);
  }

  bool get isEmpty => _count == 0;

  bool get isFull => _count == _buffer.length;

  void enqueue(T item) {
    if (isFull) {
      throw Exception('Queue is full');
    }
    _buffer[_tail] = item;
    _tail = (_tail + 1) % _buffer.length;
    _count++;
  }

  T dequeue() {
    if (isEmpty) {
      throw Exception('Queue is empty');
    }
    final item = _buffer[_head];
    _buffer[_head] = null;
    _head = (_head + 1) % _buffer.length;
    _count--;
    return item!;
  }
}
