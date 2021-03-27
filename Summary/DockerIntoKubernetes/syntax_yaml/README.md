# YAML入門
## Syntax - キー・バリュー
### yaml
```yaml 
key: value
```
### python
```python
data = dict()
data['key'] = 'value'
```
## Syntax - 階層構造
### yaml
```yaml
metadata:
  key: value
```
### python
```python
data = dict()
data['metadata'] = {'key':'value'}
```
## Syntax - 配列
### yaml
```yaml
animals:
  - dog
  - cat
  - bird
```
### python
```python
data = dict()
data['animals'] = ['dog', 'cat', 'bird']
```
