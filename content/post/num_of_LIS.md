---
title: "LeetCode 673. Number of Longest Increasing Subsequence"
date: 2018-03-26T18:42:05+08:00
tags:
- Dynamic Programming
categories:
- Leetcode
---

![desc](/images/leetcode/673_1.png)

这一题跟之前的LeetCode 300. Longest Increasing Subsequence和LeetCode 674. Longest Continuous Increasing Subsequence是一系列的题目，这两题的解法在之前发过[Longest Increasing Subsequence](/post/lis)。

回忆一下，674比较简单，300用了dp来记录长度为i的LIS(Longest Increasing Subsequence)最后一个元素的最小值。

这里我们要求的是LIS的个数，比如：

[1,3,5,4,7] 中最长递增子序列长度为4，总共有两个：[1,3,5,7]和[1,3,4,7]。

这里有两种动态规划解法：

# O(n^2)动态规划解法

我们用两个数组length和count来记录在每一个位置，LIS的长度与个数。如：nums[:i+1]中LIS的长度与个数分别为length[i]和count[i]

那么递推的公式就是：

i处LIS的长度取决于i之前比i小的元素的length
`length[i] = max(length[j]+1) for j in range(0, i) if nums[j]<nums[i]`

i处LIS的个数取决于i之前比i小的元素的长度为length[i]-1的LIS的个数
`count[i] = sum(count[j]) for j in range(0, i) if lenght[j]==length[i]-1`

代码如下：
```
class Solution:
def findNumberOfLIS(self, nums):
    N = len(nums)
    l, cnt = [0]*N, [0]*N
    max_l, ret = 0, 0
    
    for i in range(N):
        l[i], cnt[i] = 1, 1
        for j in range(i):
            if nums[j]<nums[i]:
                l[i] = max(l[j]+1, l[i])
                cnt[i] = 0
        for j in range(i):
            if nums[j]<nums[i] and l[j]==l[i]-1:
                cnt[i] += cnt[j]
        if l[i]==max_l:
            ret += cnt[i]
        if l[i]>max_l:
            max_l = l[i]
            ret = cnt[i]
    return ret
```

1400+ms，只击败了17%的Solution，那么在这个解法的基础上，其实还是可以改进的，我们对[0:i]进行了两次循环可以改成一次：

```
class Solution:
def findNumberOfLIS(self, nums):
    N = len(nums)
    l, cnt = [0]*N, [0]*N
    max_l, ret = 0, 0
    for i in range(N):
        l[i], cnt[i] = 1, 1
        # 改成一次循环，同时更新count和length：
        # 如果发现当前length[i]<length[j]+1，更新成大的即length[j]+1，count[i]初始化为count[j]
        # 如果发现length[j]+1==length[i]，发现新的构成length[i]的方式，count[i]+=count[j]
        for j in range(i):
            if nums[j]>=nums[i]:
                continue
            if l[i]==l[j]+1:
                cnt[i] += cnt[j]
            if l[i]<l[j]+1:
                l[i] = l[j]+1
                cnt[i] = cnt[j]
        if l[i]==max_l:
            ret += cnt[i]
        if l[i]>max_l:
            max_l = l[i]
            ret = cnt[i]
    return ret
```

700+ms, 击败70ms的Solution。

# O(n logn)动态规划解法

那么现在来看最快的解法。

从上面的O(n^2)的解法来看，也是可以计算出LIS的长度的，而在LeetCode 300. Longest Increasing Subsequence我们用另一个动态规划的方式，再加上二分查找，可以在O(n logn)的时间复杂度内得到LIS的长度。现在就是对这个解法进行扩充，让它能够同时保存LIS的个数。

LeetCode 300中，我们每一个dp[i]保存的是长度为i的LIS结尾元素的最小值。也就是说，之前的LIS结尾元素信息都被覆盖了，而统计LIS个数是需要这些信息的，那么就不能直接覆盖最小值，可以把dp[i]变成一个数组，发生更新时在数组末尾加上新值。那么每一个dp[i]中保存着一些nums中的数字，并且这些数字呈递减。现在我们在dp[i]为每一个数字再加上一个值，是这个数字作为长度为i的递增子序列最后一个元素的LIS的个数，所以dp[i]是一个数组，数组中每一个元素是[num, count(num)]。

有了这样的数据结构，对于nums中每一个num，我们先用二分查找找到它的位置idx，然后把idx-1中所有小于它的元素的count加到一起作为num的count值。那么这样做的复杂度是O(len(dp[i]))，即最坏情况是N，每一个元素进行O(N)的操作会导致复杂度还是O(N^2)。这里可以使用累积的方式来避免重复求和，即每一个[num, count]对中的count是它以及前面每个数的LIS数目之和。这样要计算idx-1中小于它元素的count之和只需要二分查找到小于num的元素x，用总count减去[x, count_x]中的count_x即得到num作为最后一个元素的LIS数目。

代码如下：

```
class Solution:
    def findNumberOfLIS(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        if not nums: return 0
        N = len(nums)
        l, dp = 0, [[] for _ in range(N)]
        for n in nums:
            idx1 = bisect.bisect_left([_[-1][0] if _ else sys.maxsize for _ in dp], n)
            if idx1==l:
                l += 1
            if idx1==0:
                dp[0].append([n, (dp[0][-1][1] if dp[0] else 0)+1])
            else:
                idx2 = bisect.bisect([-_[0] for _ in dp[idx1-1]], -n)
                dp[idx1].append([n, (dp[idx1][-1][1] if dp[idx1] else 0)+(dp[idx1-1][-1][1] if idx2==0 else (dp[idx1-1][-1][1]-dp[idx1-1][idx2-1][1]))])
        return dp[l-1][-1][1]
```

时间花了1100+ms，不符合复杂度，原因是用bisect来进行二分搜索的时候，每一次都新建了一个数组，而这个复杂度是O(N)的，所以时间并没有减少。而bisect的查找并不支持自定义key。所以只能自己写了：

```
def bs(arr, val, key=lambda x:x):
    l, r = 0, len(arr)-1
    if key(arr[l])>val:
        return l
    if key(arr[r])<=val:
        return r+1
    while l+1<r:
        m = (l+r)>>1
        v = key(arr[m])
        if v<=val:
            l = m
        else:
            r = m
    return r

def bs_left(arr, val, key=lambda x:x):
    l, r = 0, len(arr)-1
    if key(arr[l])>=val:
        return l
    if key(arr[r])<val:
        return r+1
    while l+1<r:
        m = (l+r)>>1
        v = key(arr[m])
        if v<val:
            l = m
        else:
            r = m
    return r
            

class Solution:
    def findNumberOfLIS(self, nums):
        if not nums: return 0
        N = len(nums)
        l, dp = 0, [[] for _ in range(N)]
        for n in nums:
            idx1 = bs_left(dp, n, lambda _:_[-1][0] if _ else sys.maxsize)
            if idx1==l:
                l += 1
            if idx1==0:
                dp[0].append([n, (dp[0][-1][1] if dp[0] else 0)+1])
            else:
                idx2 = bs(dp[idx1-1], -n, lambda _:-_[0])
                dp[idx1].append([n, (dp[idx1][-1][1] if dp[idx1] else 0)+(dp[idx1-1][-1][1] if idx2==0 else (dp[idx1-1][-1][1]-dp[idx1-1][idx2-1][1]))])
        return dp[l-1][-1][1]
```

只花了92ms,击败100%。

![beats](/images/leetcode/673_2.png)