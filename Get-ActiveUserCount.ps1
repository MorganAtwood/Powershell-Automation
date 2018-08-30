$a = (get-date).AddDays(-7);(get-aduser -filter * -Properties LastLogonDate | Where-Object {$_.LastLogonDate -ge $a}).count
