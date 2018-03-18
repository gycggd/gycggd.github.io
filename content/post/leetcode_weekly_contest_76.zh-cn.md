---
title: "Leetcode Weekly Contest 76"
date: 2018-03-18T12:53:17+08:00
tags:
    - BFS
    - Dynamic Programming
categories:
    - Leetcode
---


# 801. Minimum Swaps To Make Sequences Increasing

![801 Description](/images/leetcode/801_1.png)

以`1, 2, 3, 8, 5`和`5, 6, 7, 4, 9`为例，只需要交换`8`和`4`即可。

这个问题可以用动态规划来解决，在每一个位置可以有两种选择，交换和不交换，但是由于要产生两个排好序的数组，在确定之前的交换情况后，我们并不能自由选择交换与否。所以可以形成一个递推的公式：

初始化用来递推的数组dp，dp[i][0]和dp[i][1]表示在A[:i+1]与B[:i+1]上交换至有序需要的最少操作，其中dp[i][0]表示在i处不进行交换的情况，dp[i][1]表示在i处进行交换的情况。为什么要分成两个？因为在对下一个位置进行推导的时候，需要知道上一个位置的交换情况。
```
N = len(A)
dp = [[maxint]\*2 for \_ in range(N)]
```

推导公式如下：

For $i \in [1, N]$:

If A[i]>A[i-1] and B[i]>B[i-1]（不交换就有序）:
$$dp[i][0]=min(dp[i][0], dp[i-1][0])$$（i处不交换即可）
$$dp[i][1]=min(dp[i][1], dp[i-1][1]+1)$$（i-1处进行了交换，i处交换才可以保持有序）

If A[i]>B[i-1] and B[i]>A[i-1]（交换后有序）:
$$dp[i][0]=min(dp[i][0], dp[i-1][1])$$（由于i-1处已交换，不交换即有序）
$$dp[i][1]=min(dp[i][1], dp[i-1][0]+1)$$（i-1处未交换，i处交换可以有序）

上面两种情况并不冲突，所以取较小者

最后的结果是$min(dp[N-1][0], dp[N-1][1])$.

因为每次递推只需要用到前一次的结果，所以需要的空间是$O(1)$，时间是$O(N)$。

20行Python版Solution：

```
class Solution:
    def minSwap(self, A, B):
        """
        :type A: List[int]
        :type B: List[int]
        :rtype: int
        """
        n = len(A)
        pre = [0, 1]
        for i in range(1, n):
            cur = [sys.maxsize, sys.maxsize]
            if A[i]>A[i-1] and B[i]>B[i-1]:
                cur[0] = min(cur[0], pre[0])
                cur[1] = min(cur[1], pre[1]+1)
            if A[i]>B[i-1] and B[i]>A[i-1]:
                cur[0] = min(cur[0], pre[1])
                cur[1] = min(cur[1], pre[0]+1)
            pre = cur
        return min(pre)
```

# 803. Bricks Falling When Hit
