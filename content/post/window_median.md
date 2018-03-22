---
title: "LeetCode 295. Find Median from Data Stream"
date: 2018-03-22T23:00:35+08:00
tags:
    - Heap
categories:
    - Leetcode
---

![295](/images/leetcode/295_1.png)

此题[295. Find Median from Data Stream
](https://leetcode.com/problems/find-median-from-data-stream/description/) 与[480. Sliding Window Median
](https://leetcode.com/problems/sliding-window-median/) 类似。都是在一个变化的序列中多次求中位数，而我们知道中位数与大小相关，所以很容易想到用堆来维护。

但对于堆来说，我们只能方便的取最大或最小，在这个问题中，我们可以用一个最小堆和一个最大堆来维护有序性，并且维持两个堆内元素个数之差始终在1以内。那么每次取中位数就只需要O(1)的时间，每次插入元素只需要O(n)的时间。具体如下：

* 初始化max_heap=[]用来保存小于中位数的数, min_heap=[]用来保存大于或等于中位数的数
* 插入一个元素时
	* 根据大小判断应该插入到max_heap还是min_heap中
	* 通过heappop和heappush保证len(max_heap)<=len(min_heap)<=len(max_heap)+1
* 取中位数时
	* 如果len(min_heap)==len(max_heap)+1, 取min_heap堆顶元素
	* 如果len(min_heap)==len(max_heap), 取两堆堆顶元素平均数

代码如下：

```
from heapq import *

class MedianFinder:

    def __init__(self):
        self.heaps = [], []

    def addNum(self, num):
        small, large = self.heaps
        heappush(small, -heappushpop(large, num))
        if len(large) < len(small):
            heappush(large, -heappop(small))

    def findMedian(self):
        small, large = self.heaps
        if len(large) > len(small):
            return float(large[0])
        return (large[0] - small[0]) / 2.0
```

![480](/images/leetcode/480_1.png)

如果是[480. Sliding Window Median
](https://leetcode.com/problems/sliding-window-median/) ，只需要在addNum时增加判断是否超出窗口大小，如果超过，就invalid离开窗口的元素，否则直接加入。

代码如下（有点啰嗦，没来得及优化）：

```
class Solution(object):
    def medianSlidingWindow(self, nums, k):
        """
        :type nums: List[int]
        :type k: int
        :rtype: List[float]
        """
        if k==1:
            return list(map(float, nums))
 
        def pop(heap):
            clean(heap)
            return heapq.heappop(heap)
        
        def top(heap):
            clean(heap)
            return heap[0]
        
        def clean(heap):
            while heap and not heap[0][1]:
                heapq.heappop(heap)

        def med(heap1, heap2):
            clean(heap1)
            clean(heap2)
            if k&1:
                return heap2[0][0]
            else:
                return (heap2[0][0]-heap1[0][0])/2

        N = len(nums)
        nums = [[nums[i], True, 1] for i in range(len(nums))]
        heap1 = []
        heap2 = []
        
        for i in range(k):
            nums[i][0] = -nums[i][0]
            heapq.heappush(heap1, nums[i])
            
        for i in range((k+1)//2):
            n = pop(heap1)
            n[0] = -n[0]
            n[2] = 2
            heapq.heappush(heap2, n)

        ret = [med(heap1, heap2)]
        for i in range(N-k):
            nums[i][1] = False
            if nums[i][2]==1:
                if nums[i+k][0]<=top(heap2)[0]:
                    nums[i+k][0] = -nums[i+k][0]
                    heapq.heappush(heap1, nums[i+k])
                    ret.append(med(heap1, heap2))
                else:
                    nums[i+k][2] = 2
                    heapq.heappush(heap2, nums[i+k])
                    n = pop(heap2)
                    n[2] = 1
                    n[0] = -n[0]
                    heapq.heappush(heap1, n)
                    ret.append(med(heap1, heap2))
            else:
                if nums[i+k][0]>=-top(heap1)[0]:
                    nums[i+k][2] = 2
                    heapq.heappush(heap2, nums[i+k])
                    ret.append(med(heap1, heap2))
                else:
                    nums[i+k][0] = -nums[i+k][0]
                    heapq.heappush(heap1, nums[i+k])
                    n = pop(heap1)
                    n[2] = 2
                    n[0] = -n[0]
                    heapq.heappush(heap2, n)
                    ret.append(med(heap1, heap2))
        
        return list(map(float, ret))
```