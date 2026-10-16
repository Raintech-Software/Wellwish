"""Every request/response schema has its own name.

The OpenAPI (and so the generated Dart and TypeScript clients) keys schemas by class name: two
classes called `DocumentOut` in different apps silently overwrite each other in the contract.
"""

from collections import defaultdict

from ninja import Schema

import config.api  # noqa: F401  (imports every API module, so every schema class exists)


def _subclasses(cls: type) -> set[type]:
    found = set()
    for sub in cls.__subclasses__():
        found.add(sub)
        found |= _subclasses(sub)
    return found


def test_schema_class_names_are_unique() -> None:
    by_name: dict[str, set[str]] = defaultdict(set)
    for cls in _subclasses(Schema):
        if cls.__module__.startswith(("apps.", "common.")):
            by_name[cls.__name__].add(cls.__module__)
    clashes = {name: sorted(mods) for name, mods in by_name.items() if len(mods) > 1}
    assert clashes == {}
