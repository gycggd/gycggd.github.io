---
title: "LeetCode 322. Coin Change"
date: 2018-04-07T14:22:08+08:00
tags:
    - Dynamic Programming
    - DFS
    - BFS
categories:
    - LeetCode
---

![desc](/images/leetcode/322_1.png)

# 动态规划

dp[i]为构成i的最少硬币数目

初始状态：

`dp[0] = 0`
`dp[i] = sys.maxsize for i!=0`

递推公式：

`dp[i+c] = min(dp[i+c], dp[i]+1) for c in coins`

返回：

`dp[amount] if dp[amount]!=sys.maxsize else -1`

代码：

```
class Solution:
    def coinChange(self, coins, amount):
        dp = [sys.maxsize]*(amount+1)
        dp[0] = 0
        for i in range(amount):
            for c in coins:
                if i+c<=amount:
                    dp[i+c] = min(dp[i+c], dp[i]+1)
        return dp[amount] if dp[amount]!=sys.maxsize else -1
```

# 广度优先遍历

```
class Solution:
    ret = sys.maxsize
    def coinChange(self, coins, amount):
        if amount == 0: return 0
        q = [0]
        cnt =  0
        visited = {0}
        while q:
            cnt += 1
            new_q = []
            for v in q:
                for c in coins:
                    new_v = v + c
                    if new_v == amount: return cnt
                    elif new_v > amount: continue
                    elif new_v not in visited:
                        visited.add(new_v)
                        new_q.append(new_v)
            q = new_q
        return -1
```

# 深度优先遍历+剪枝

```
class Solution:
    ret = sys.maxsize
    def coinChange(self, coins, amount):
    	# 排序为了剪枝
        coins.sort()
        def dfs(target, i, cnt):
        	# 剪枝
            if i<0 or target<0 or cnt>=self.ret: return
            q = target//coins[i]
            # 剪枝：因为coins[i]为当前最大，尽量取coins[i]肯定最优，后面不用检查了
            if target%coins[i]==0:
                self.ret = min(self.ret, cnt+q)
                return
            # 剪枝：因为除不尽，至少还有一个
            if q+cnt+1>=self.ret: return
            # 取一个coins[i]
            dfs(target-coins[i], i, cnt+1)
            # 不取coins[i]了，往前取更小的面值
            dfs(target, i-1, cnt)
        dfs(amount, len(coins)-1, 0)
        return self.ret if self.ret<sys.maxsize else -1
```