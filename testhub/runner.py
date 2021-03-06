import unittest
import pytest
from test_demo import TestDemo

suite = unittest.TestSuite()
suite.addTests([TestDemo('test_a'), TestDemo('test_b')])

# 因为suite中可能会存在嵌套, 所以我们要迭代取出其中所有的用例:
def collect(suite): 
    cases = []  # 用于存放Pytest支持的用例路径字符串

    def _collect(tests):   # 递归，如果下级元素还是TestSuite则继续往下找
        if isinstance(tests, unittest.TestSuite):
            [_collect(i) for i in tests if tests.countTestCases() != 0] 
        else:
            _path = tests.id().split(".")  # case.id()可以获取用例路径(字符串)
            _path[0] += ".py"
            cases.append("::".join(_path))  # 如果下级元素是TestCase，则添加到TestSuite中

    _collect(suite)
    return cases

if __name__ == '__main__':
    cases = collect(suite)
    pytest.main([*cases, "-v"])
    # pytest.main(cases)  # 不加额外参数的化可直接执行cases
