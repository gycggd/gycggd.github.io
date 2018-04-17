---
title: "LeetCode 494. Target Sum"
date: 2018-04-17T14:36:05+08:00
tags:
    - Dynamic Programming
categories:
    - LeetCode
---

# Description

<div class="question-description"><div><p>
You are given a list of non-negative integers, a1, a2, ..., an, and a target, S. Now you have 2 symbols <code>+</code> and <code>-</code>. For each integer, you should choose one from <code>+</code> and <code>-</code> as its new symbol.
</p> 

<p>Find out how many ways to assign symbols to make sum of integers equal to target S.  
</p>

<p><b>Example 1:</b><br>
</p><pre><b>Input:</b> nums is [1, 1, 1, 1, 1], S is 3. 
<b>Output:</b> 5
<b>Explanation:</b> 

-1+1+1+1+1 = 3
+1-1+1+1+1 = 3
+1+1-1+1+1 = 3
+1+1+1-1+1 = 3
+1+1+1+1-1 = 3

There are 5 ways to assign symbols to make the sum of nums be target 3.
</pre>
<p></p>

<p><b>Note:</b><br>
</p><ol>
<li>The length of the given array is positive and will not exceed 20. </li>
<li>The sum of elements in the given array will not exceed 1000.</li>
<li>Your output answer is guaranteed to be fitted in a 32-bit integer.</li>
</ol>
<p></p></div></div>

# Solutions

## Plain DP

Python:

```
class Solution:
    def findTargetSumWays(self, nums, S):
        def dp(i, target):
            if i==-1: return 1 if target==0 else 0
            if (i, target) not in memo:
                memo[(i, target)] = dp(i-1, target-nums[i])+dp(i-1, target+nums[i])
            return memo[(i, target)]
        return dp(len(nums)-1, S)
```

Java：

```
class Solution {
    public int findTargetSumWays(int[] nums, int S) {
        return dp(nums, nums.length-1, S, new HashMap<>());
    }
    public int dp(int[] nums, int i, int target, Map<String, Integer> memo) {
        if (i==-1) {
            return target==0?1:0;
        }
        String key = String.valueOf(i)+','+String.valueOf(target);
        if (!memo.containsKey(key)) {
            memo.put(key, dp(nums, i-1, target+nums[i], memo)+dp(nums, i-1, target-nums[i], memo));
        }
        return memo.get(key);
    }
}
```

## DP with a trick

令plus为取+号元素之和，minus为取-号元素之和。

则:

```
plus+minus = sum(nums)
plus-minus = S
```

可以得到：`plus=(S+sum(nums))/2`

那么接下来就是一个背包问题了，nums中取若干个元素，和为plus

Python:

```
class Solution:
    def findTargetSumWays(self, nums, S):
        total = sum(nums)
        # total<S 或者 奇偶性不同
        if total<S or (total^S)&1: return 0
        plus = (S+total)>>1
        cnt = [0]*(plus+1)
        cnt[0] = 1
        for n in nums:
            for i in range(plus, -1, -1):
                if i-n<0: break
                cnt[i] += cnt[i-n]
        return cnt[plus]
```

Java:

```
class Solution {
    public int findTargetSumWays(int[] nums, int S) {
        int total = Arrays.stream(nums).sum();
        if (total<S || ((total^S)&1)==1) {
            return 0;
        }
        int plus = (total+S)>>1;
        int cnt[] = new int[plus+1];
        cnt[0] = 1;
        for (int n:nums) {
            for (int i=plus; i>=n; i--) {
                cnt[i] += cnt[i-n];
            }
        }
        return cnt[plus];
    }
}
```