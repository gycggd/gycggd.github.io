---
title: "Leetcode 327: Count of Range Sum"
date: 2018-03-15T13:15:00+08:00
tags:
    - Divide and Conquer
categories:
    - Leetcode
comment: true
---

![Description](/images/leetcode/327_1.png)

This problem ask us to find the count of all range sums between [lower, upper] (inclusive) for an array. Numbers in the array can be either negative or positive, so we can't use two pointers to solve this problem.

An obvious solution is a O($N^2$) solution that calculate rangeSum(i, j) for all $i \in [0, N-1], j \in [i, N-1]$. But the problem says you __must__ do better than O($N^2$).

What is a familier time complexity that is better than O($N^2$)? O($N$) and O($N(logN)^m$).

Let's think of merge sort, in merge sort, we call merge $logN$ times and each merge cost O($N$) time. So if we can find a divide and conquer method and complete each merge process in O($N(logN)^m$), we can achieve a total time complexity better than O($N^2$).

# Divide and Conquer on original array

Let's try it on original array, $T(N)=2*T(\frac{N}{2})+T(merge)$.

When we divide an array arr[l:r] into arr[l:m] and arr[m+1:r], the merge process is to find count of (i, j) pairs such that $i\in[l:m]\wedge j\in[m+1:r]\wedge sum(arr[i:j]) \in [lower, upper]$.

We can finish this in O($N^2$), just try each i in the left part and each j in the right part and compute the range sum. 

But this leads exceeds our expected O($N(logN)^m$). We can do better. We can calculate the prefix sum array of the right part: $prefix[x]=sum(arr[m+1:x])$ and suffix sum array of the left part: $suffix[x]=sum(arr[x:m])$. Then for each $i \in [l:m]$, we want to find all j such that $prefix[j]+suffix[x] \in [lower, upper]$. This also costs O($N^2$), but if we sort the suffix array and use binary search for each i, search $lower-suffix[i]$ and $upper-suffix[i]$ to get count of valid j's, the time complexity becomes $O(NlogN)$.

So this method gives us a O($N(logN)^2$) solution.

# Divide and Conquer on prefix sum array

In the previous solution, we calculate prefix sum array and suffix sum array in each merge process, if we just calculate the prefix sum array before, can we save more time?

The answer is yes, just like [Leetcode 493. Reverse Pairs](https://leetcode.com/problems/reverse-pairs/description/) or [Count Inversions in an array](https://www.geeksforgeeks.org/counting-inversions/), we can guarantee at each merge process, both left and right part are sorted, and with this property the time we used on merge can be reduced.

Let's recall what we do in merge sort:

```
Initialize i=l, j=m+1
while i<=m or j<=r:
    if i<=m and j<=r:
        if a[i]<=a[j]:
            append a[i++] to sorted array
            i++
        else:
            append a[j++] to sorted array
    else if i<=m:
        append a[i++] to sorted array
    else:
        append a[j++] to sorted array
```

In merge sort, we compare a[i] with a[j], in this problem, we need to compare a[i]+lower and a[i]+upper with a[j]. 
Following is my code:
```
class Solution:
    def countRangeSum(self, nums, lower, upper):
        """
        :type nums: List[int]
        :type lower: int
        :type upper: int
        :rtype: int
        """
        sumarr = [0]
        for n in nums:
            sumarr.append(sumarr[-1]+n)
        
        def ms(arr, l, r):
            if l>=r:
                return 0
            m = (l+r)>>1
            return ms(arr, l, m)+ms(arr, m+1, r)+merge(arr, l, m, r)
        
        def merge(arr, l, m, r):
            ret = 0
            # lower_bound[x] means that for all j>=lower_bound[x], a[j]>=a[i]+lower. 
            # And the same for upper_bound
            lower_bound, upper_bound = {}, {} 
            i, j = l, m+1
            while i<=m:
                while j<=r and arr[j]<arr[i]+lower:
                    j += 1
                lower_bound[i] = j
                i += 1
            i, j = m, r
            while i>=l:
                while j>m and arr[j]>arr[i]+upper:
                    j -= 1
                upper_bound[i] = j
                i -= 1
            for i in range(l, m+1):
                ret += max(0, upper_bound[i]-lower_bound[i]+1)
            # Attention, I am lazy here, a standard way should use typical merge sort
            arr[l:r+1] = sorted(arr[l:r+1])
            return ret
                
        return ms(sumarr, 0, len(sumarr)-1)            
```

Last thing is that in this problem, why we can use this method is that **we don't care the order of the prefix sum array, we only need prefix sums are at the correct side when we do merge on that range**.