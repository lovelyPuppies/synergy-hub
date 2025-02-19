# %%

from IPython.core.interactiveshell import InteractiveShell

InteractiveShell.ast_node_interactivity = "all"


from collections.abc import MutableSequence, Sequence

print(f"Is List subclass of MutableSequence?: {issubclass(list, MutableSequence)}")
print(f"Is Tuple subclass of MutableSequence?: {issubclass(tuple, MutableSequence)}")
print(f"Is Tuple subclass of Sequence?: {issubclass(tuple, Sequence)}")


def foo() -> None:
    print("Hello")

    def bar() -> None:
        print("Bar")
