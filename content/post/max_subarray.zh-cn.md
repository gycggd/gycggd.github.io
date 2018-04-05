---
title: "LeetCode 53. Maximum Subarray"
date: 2018-04-05T13:58:51+08:00
tags:
    - Dynamic Programming
    - Divide and Conquer
categories:
    - LeetCode
---

![desc](/images/leetcode/53_1.png)

这一题有O(N)的DP解法和O(NlogN)的DC解法

# 动态规划

dp[i]表示以i结尾的asubarray的最大和。

初始状态：

dp[0]=nums[0]

递推公式：

If dp[i-1]<0, dp[i]=nums[i]
Else dp[i]=dp[i-1]+nums[i]


```
class Solution:
    def maxSubArray(self, nums):
        if not nums: return 0
        dp = [0]*len(nums)
        for i in range(len(nums)):
            if i==0 or dp[i-1]<0: dp[i] = nums[i]
            else: dp[i] = dp[i-1]+nums[i]
        return max(dp)
```

```
class Solution:
    def maxSubArray(self, nums):
        s, ret = 0, -sys.maxsize
        for n in nums:
            if s<0: s = n
            else: s += n
            ret = max(ret, s)
        return ret
```

# 分而治之

三种情况：

* maxSubarray在左边(递归)
* maxSubarray在左边(递归)
* maxSubarray一半在左边一半在右边(cross)

```
class Solution:
    def maxSubArray(self, nums):
        def dc(nums, l, r):
            if l>=r: return 0 if l>r else nums[l]
            mid = (l+r)>>1
            return max(dc(nums, l, mid), dc(nums, mid+1, r), cross(nums, mid, l, r))

        def cross(nums, mid, l,r):
            left_sum, left_max = nums[mid], nums[mid]
            for _ in range(mid-1, l-1, -1):
                left_sum += nums[_]
                left_max = max(left_sum, left_max)
            right_sum, right_max = 0, 0
            for _ in range(mid+1, r+1):
                right_sum += nums[_]
                right_max = max(right_sum, right_max)
            return left_max+right_max
        return dc(nums, 0, len(nums)-1)             
```