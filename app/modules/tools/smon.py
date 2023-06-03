import json

from jinja2 import Environment, FileSystemLoader

import modules.db.sql as sql
import modules.common.common as common
import modules.roxywi.common as roxywi_common

form = common.form


def create_smon() -> None:
    user_group = roxywi_common.get_user_group(id=1)
    name = common.checkAjaxInput(form.getvalue('newsmonname'))
    hostname = common.checkAjaxInput(form.getvalue('newsmon'))
    port = common.checkAjaxInput(form.getvalue('newsmonport'))
    enable = common.checkAjaxInput(form.getvalue('newsmonenable'))
    url = common.checkAjaxInput(form.getvalue('newsmonurl'))
    body = common.checkAjaxInput(form.getvalue('newsmonbody'))
    group = common.checkAjaxInput(form.getvalue('newsmongroup'))
    desc = common.checkAjaxInput(form.getvalue('newsmondescription'))
    telegram = common.checkAjaxInput(form.getvalue('newsmontelegram'))
    slack = common.checkAjaxInput(form.getvalue('newsmonslack'))
    pd = common.checkAjaxInput(form.getvalue('newsmonpd'))
    check_type = common.checkAjaxInput(form.getvalue('newsmonchecktype'))

    if check_type == 'tcp':
        try:
            port = int(port)
        except Exception:
            print('SMON error: port must number')
            return None
        if port > 65535 or port < 0:
            print('SMON error: port must be 0-65535')
            return None

    last_id = sql.insert_smon(name, enable, group, desc, telegram, slack, pd, user_group, check_type)

    if check_type == 'ping':
        sql.insert_smon_ping(last_id, hostname)
    elif check_type == 'tcp':
        sql.insert_smon_tcp(last_id, hostname, port)
    elif check_type == 'http':
        sql.insert_smon_http(last_id, url, body)

    if last_id:
        lang = roxywi_common.get_user_lang()
        smon = sql.select_smon_by_id(last_id)
        pds = sql.get_user_pd_by_group(user_group)
        slacks = sql.get_user_slack_by_group(user_group)
        telegrams = sql.get_user_telegram_by_group(user_group)
        smon_service = sql.select_smon_check_by_id(last_id, check_type)
        env = Environment(loader=FileSystemLoader('templates'), autoescape=True)
        template = env.get_template('ajax/show_new_smon.html')
        template = template.render(smon=smon, telegrams=telegrams, slacks=slacks, pds=pds, lang=lang, check_type=check_type,
                                   smon_service=smon_service)
        print(template)
        roxywi_common.logging('SMON', f' A new server {name} to SMON has been add ', roxywi=1, login=1)


def update_smon() -> None:
    smon_id = common.checkAjaxInput(form.getvalue('id'))
    name = common.checkAjaxInput(form.getvalue('updateSmonName'))
    ip = common.checkAjaxInput(form.getvalue('updateSmonIp'))
    port = common.checkAjaxInput(form.getvalue('updateSmonPort'))
    en = common.checkAjaxInput(form.getvalue('updateSmonEn'))
    url = common.checkAjaxInput(form.getvalue('updateSmonUrl'))
    body = common.checkAjaxInput(form.getvalue('updateSmonBody'))
    telegram = common.checkAjaxInput(form.getvalue('updateSmonTelegram'))
    slack = common.checkAjaxInput(form.getvalue('updateSmonSlack'))
    pd = common.checkAjaxInput(form.getvalue('updateSmonPD'))
    group = common.checkAjaxInput(form.getvalue('updateSmonGroup'))
    desc = common.checkAjaxInput(form.getvalue('updateSmonDesc'))
    check_type = common.checkAjaxInput(form.getvalue('check_type'))
    is_edited = False

    if check_type == 'tcp':
        try:
            port = int(port)
        except Exception:
            print('SMON error: port must number')
            return None
        if port > 65535 or port < 0:
            print('SMON error: port must be 0-65535')
            return None


    roxywi_common.check_user_group()
    try:
        if sql.update_smon(smon_id, name, telegram, slack, pd, group, desc, en):
            if check_type == 'http':
                is_edited = sql.update_smonHttp(smon_id, url, body)
            elif check_type == 'tcp':
                is_edited = sql.update_smonTcp(smon_id, ip, port)
            elif check_type == 'ping':
                is_edited = sql.update_smonTcp(smon_id, ip)

            if is_edited:
                print("Ok")
                roxywi_common.logging('SMON', f' The SMON server {name} has been update ', roxywi=1, login=1)
    except Exception as e:
        print(e)


def show_smon() -> None:
    user_group = roxywi_common.get_user_group(id=1)
    lang = roxywi_common.get_user_lang()
    sort = common.checkAjaxInput(form.getvalue('sort'))
    env = Environment(loader=FileSystemLoader('templates'), autoescape=True)
    template = env.get_template('ajax/smon_dashboard.html')
    template = template.render(smon=sql.smon_list(user_group), sort=sort, lang=lang, update=1)
    print(template)


def delete_smon() -> None:
    user_group = roxywi_common.get_user_group(id=1)
    smon_id = common.checkAjaxInput(form.getvalue('smondel'))

    if roxywi_common.check_user_group():
        try:
            if sql.delete_smon(smon_id, user_group):
                print('Ok')
                roxywi_common.logging('SMON', ' The server from SMON has been delete ', roxywi=1, login=1)
        except Exception as e:
            print(e)


def history_metrics(server_id: int, check_id: int) -> None:
    metric = sql.select_smon_history(server_id, check_id)

    metrics = {'chartData': {}}
    metrics['chartData']['labels'] = {}
    labels = ''
    curr_con = ''

    for i in reversed(metric):
        labels += f'{i.date.time()},'
        curr_con += f'{i.response_time},'

    metrics['chartData']['labels'] = labels
    metrics['chartData']['curr_con'] = curr_con

    print(json.dumps(metrics))
