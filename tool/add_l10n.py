"""Adds strings to the English and Hindi ARB files.

Usage: from tool.add_l10n import add; add({key: (english, hindi)})
A {placeholder} in the English text gets its metadata automatically:
names in INT_NAMES are ints, all others strings.
"""
import json
import re

ROOT = 'lib/l10n'
INT_NAMES = {'count', 'n', 'days', 'total', 'done', 'present', 'absent', 'late', 'minutes', 'copied', 'skipped', 'waiting', 'percent', 'planned', 'want', 'have', 'units', 'pages', 'step', 'marks', 'same', 'onlyA', 'onlyB', 'diff', 'added', 'changed', 'removed'}


def add(entries):
    for fn, idx in (('app_en.arb', 0), ('app_hi.arb', 1)):
        path = f'{ROOT}/{fn}'
        data = json.load(open(path, encoding='utf-8'))
        for key, texts in entries.items():
            text = texts[idx]
            data[key] = text
            if idx == 0:
                names = re.findall(r'\{(\w+)\}', text)
                if names:
                    data['@' + key] = {
                        'placeholders': {
                            n: {'type': 'int' if n in INT_NAMES else 'String'}
                            for n in names
                        }
                    }
        with open(path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
            f.write('\n')
