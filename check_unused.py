import os
import re
import sys

def check_file(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            lines = f.readlines()
    except:
        return []
    
    content = "".join(lines)
    unused = []
    
    
    for i, line in enumerate(lines):
        if line.strip().startswith('import ') and not line.strip().startswith('import static'):
            match = re.search(r'import\s+([\w\.]+);', line)
            if match:
                full_imp = match.group(1)
                class_name = full_imp.split('.')[-1]
                
                
                count = 0
                for j, l in enumerate(lines):
                    if i == j: continue
                    if re.search(r'\b' + re.escape(class_name) + r'\b', l):
                        count += 1
                
                if count == 0:
                    unused.append((i+1, "Unused import: " + full_imp))
                    
    
    for i, line in enumerate(lines):
        match = re.search(r'private\s+[\w<>]+\s+(\w+)\s*;', line)
        if match:
            field_name = match.group(1)
            count = 0
            for j, l in enumerate(lines):
                if i == j: continue
                if re.search(r'\b' + re.escape(field_name) + r'\b', l):
                    count += 1
            if count == 0:
                unused.append((i+1, "Unused private field: " + field_name))
                
    return unused

def main(target_dir):
    for r, d, files in os.walk(target_dir):
        if any(x in r for x in ['target', '.git', 'node_modules', '.idea']): continue
        for f in files:
            if f.endswith('.java'):
                path = os.path.join(r, f)
                probs = check_file(path)
                if probs:
                    print(f"FILE: {path} ({len(probs)} problems)")
                    for line, msg in probs:
                        print(f"  {line}: {msg}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        main(sys.argv[1])
    else:
        main(".")
