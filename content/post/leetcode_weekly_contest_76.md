---
title: "Leetcode Weekly Contest 76"
date: 2018-03-25T12:53:17+08:00
tags:
    - Dynamic Programming
    - DFS
categories:
    - Leetcode
---

# 804. Unique Morse Code Words

![804 Description](/images/leetcode/804_1.png)

用一个set来保存转成摩斯码的结果然后返回set大小即可。

```
class Solution:
    def uniqueMorseRepresentations(self, words):
        trans = set()
        alp = [".-","-...","-.-.","-..",".","..-.","--.","....","..",".---","-.-",".-..","--","-.","---",".--.","--.-",".-.","...","-","..-","...-",".--","-..-","-.--","--.."]
        for w in words:
            trans.add(''.join(alp[ord(c)-ord('a')] for c in w))
        return len(trans)
```

# 807. Max Increase to Keep City Skyline

![807 Description](/images/leetcode/807_1.png)

计算每一列每一行的最大值col和row两个数组，然后保证这些值不变的情况下，对每一个building进行增高。所以对于每一个(i, j)来说，高度增加为min(row[i], col[j])

```
class Solution:
    def maxIncreaseKeepingSkyline(self, grid):
        row, col = map(max, grid), map(max, zip(*grid))
        return sum(min(i, j) for i in row for j in col) - sum(map(sum, grid))
```

# 806. Number of Lines To Write String

![806 Description](/images/leetcode/806_1.png)

这题只需要两个计数器，一个记行数，一个记当前行字符数。如果超出100，行数加一，字符数清零后继续加。

```
class Solution:
    def numberOfLines(self, widths, S):
        w = 0
        l = 1
        for c in S:
            i = ord(c)-ord('a')
            if w+widths[i]>100:
                l += 1
                w = 0
            w += widths[i]
        return l, w
```

# 805. Split Array With Same Average

![805 Description](/images/leetcode/805_1.png)

这道题目第一反应是DFS和DP的题目，因为每一个数的大小在10000以内，数组长度30以内，所以和最多为300000。

## DFS解法

第一种，直接DFS，TLE了

```
class Solution:
    def splitArraySameAverage(self, A):
        s = 0
        n = len(A)
        
        target = sum(A)/n
        
        def dfs(A, i, cur, target, l):
            if l>0 and l<len(A) and cur/l==target:
                return True
            if i==len(A):
                return False
            return dfs(A, i+1, cur+A[i], target, l+1) or dfs(A, i+1, cur, target, l)
        
        return dfs(A, 0, 0, target, 0)
```

第二种，考虑根据当前平均值选择下一个加大一点的数还是小一点的并且加了Memory。还是TLE了

```
class Solution:
    def splitArraySameAverage(self, A):
        s = 0
        n = len(A)
        
        target = sum(A)/n
        if target in A:
            return True
        A1 = list(sorted(filter(lambda x:x<target, A)))
        A2 = list(sorted(filter(lambda x:x>target, A)))[::-1]
        # print(A1, A2)
        memo = {}
        def dfs(A1, i1, A2, i2, cur, target, l):
            # print(i1, i2, cur, l)
            if l>0 and l<len(A) and cur/l==target:
                return True
            if i1==len(A1) and i2==len(A2):
                return False
            if (i1, i2, cur) in memo:
                return memo[(i1, i2, cur)]
            ret = False
            if i1==len(A1):
                ret |= (dfs(A1, i1, A2, i2+1, cur+A2[i2], target, l+1) or dfs(A1, i1, A2, i2+1, cur, target, l))
                memo[(i1, i2, cur)] = ret
                return ret
            if i2==len(A2):
                ret |= (dfs(A1, i1+1, A2, i2, cur+A1[i1], target, l+1) or dfs(A1, i1+1, A2, i2, cur, target, l))
                memo[(i1, i2, cur)] = ret
                return ret
            if cur<l*target:
                ret |= (dfs(A1, i1, A2, i2+1, cur+A2[i2], target, l+1) or dfs(A1, i1, A2, i2+1, cur, target, l))
                memo[(i1, i2, cur)] = ret
                return ret
            else:
                ret |= (dfs(A1, i1+1, A2, i2, cur+A1[i1], target, l+1) or dfs(A1, i1+1, A2, i2, cur, target, l))
                memo[(i1, i2, cur)] = ret
                return ret

        return dfs(A1, 0, A2, 0, 0, target, 0)
```

结束之后看到Pass的DFS都是根据数组长度来的，下面是代码：

```
class Solution:
    def splitArraySameAverage(self, A):
        A, avg = sorted(A), total/len(A)
        # 考虑长度到一半即可，因为另一半是对应的
        for l in range(1, len(A) // 2 + 1):
            if not (l*avg).is_integer():
                continue
            if self.dfs(A, avg*l, l, 0, 0, 0): 
                return True
        return False
    # target：长度为l时，需要的总和
    # pos：当前位置
    # i：当前已选元素长度
    # cur：当前和
    def dfs(self, A, target, l, pos, i, cur):
        # 长度达到l，判断
        if i==l:
            return cur==target
        # 剩下元素不够
        if cur>target or len(A)-pos<l-i:
            return False
        return self.dfs(A, target, l, pos+1, i+1, cur+A[pos]) or self.dfs(A, target, l, pos+1, i, cur)
```

## DP解法

DP解法是一个二维dp数组，`dp[i][j]=True`表示可以从A中取到n个元素，和可以为j，如果为False则表示取不到。计算完后只需要对每一个i验证`dp[i][i*avg]`即可。

DP的Java和C++解法都可以轻松AC，如下面的Java版本：

```
class Solution {
    public boolean splitArraySameAverage(int[] A) {
        boolean dp[][] =  new boolean[30][300010];
        dp[0][0] = true;
        int s = 0;
        for (int i=0; i<A.length; i++) {
            for (int j=i; j>=0; j--) {
                for (int k=s; k>=0; k--) {
                    dp[j+1][k+A[i]] |= dp[j][k];
                }
            }
            s += A[i];
        }
        for (int i=1; i<A.length/2+1; i++) {
            if ((i*s)%A.length==0 && dp[i][i*s/A.length]) {
                return true;
            }
        }
        return false;
    }
}
```

Python版本在此，python自身的数组操作太过缓慢，果断TLE：

```
class Solution:
    def splitArraySameAverage(self, A):
        dp = [[False]*(30*10005) for _ in range(30)]
        dp[0][0] = True
        s = 0
        for i in range(len(A)):
            for j in range(i, -1, -1):
                for k in range(s, -1, -1):
                    dp[j+1][k+A[i]] |= dp[j][k]
            s += A[i]
        
        for i in range(1, len(A)):
            if (i*s)%len(A)==0 and dp[i][i*s//len(A)]:
                return True
        return False
```

Python的解法需要借助numpy才能通过，208ms。代码如下：

```
import numpy as np
class Solution:
    def splitArraySameAverage(self, A):
        N, S = len(A), sum(A)
        dp = np.zeros((N, S), dtype=bool)
        dp[0][0] = 1
        for n in A:
            dp[1:, n:] |= np.array(dp[:-1, :-n or None])
        return any(i*S%N==0 and dp[i][i*S/N] for i in range(1, N//2+1))
```

这里或操作的时候每次都新建一个array，因为两个数组相互覆盖。

但可以用reversed indexing的方法来避免新建array从而提高效率。用-1，-1表示0，0，依次类推。

代码如下，144ms：

```
import numpy as np
class Solution:
    def splitArraySameAverage(self, A):
        N, S = len(A), sum(A)
        dp = np.zeros((N, S), dtype=bool)
        dp[~0][~0] = 1
        for n in A:
            dp[:-1, :-n or None] |= dp[1:, n:]
        return any(i*S%N==0 and dp[~i][~(i*S//N)] for i in range(1, N//2+1))
```